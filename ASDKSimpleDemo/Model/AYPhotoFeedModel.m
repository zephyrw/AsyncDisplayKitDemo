//
//  AYPhotoFeedModel.m
//  ASDKSimpleDemo
//
//  Created by Zephyr on 2016/11/11.
//  Copyright © 2016年 wpsd. All rights reserved.
//

#import "AYPhotoFeedModel.h"
#import "AYImageURLModel.h"
#import "AYHttpTool.h"
#import "MJExtension.h"

#define fiveHundredPX_host      @"https://api.500px.com/v1/"
#define fiveHundredPX_popular   @"photos?feature=popular&exclude=Nude,People,Fashion&sort=rating&image_size=3&include_store=store_download&include_states=voted"
#define fiveHundredPX_search    @"photos/search?geo="    //latitude,longitude,radius<units>
#define fiveHundredPX_user      @"photos?user_id="
#define fiveHundredPX_consumer_key_param @"&consumer_key=Fi13GVb8g53sGvHICzlram7QkKOlSDmAmp9s9aqC"   // 500px注册的app key

@implementation AYPhotoFeedModel
{
    PhotoFeedModelType _feedType;
    
    NSMutableArray *_photos;
    NSMutableArray *_ids;
    
    CGSize         _imageSize;
    NSString       *_urlString;
    NSUInteger     _currentPage;
    NSInteger      _nextPage;
    NSUInteger     _totalPages;
    NSUInteger     _totalItems;
    BOOL           _fetchPageInProgress;
    BOOL           _refreshFeedInProgress;
    NSURLSessionDataTask *_task;
    
    CLLocationCoordinate2D _location;
    NSUInteger    _locationRadius;
    NSUInteger    _userID;
}

- (instancetype)initWithPhotoFeedModelType:(PhotoFeedModelType)type imageSize:(CGSize)imageSize {
    if (self = [super init]) {
        _feedType = type;
        _imageSize = imageSize;
        _photos = [NSMutableArray array];
        _ids = [NSMutableArray array];
        _currentPage = 0;
        _nextPage = 1;
        AYLog(@"");
        NSString *apiEndPointString;
        switch (type) {
            case PhotoFeedModelTypePopular:
                apiEndPointString = fiveHundredPX_popular;
                break;
            case PhotoFeedModelTypeLocation:
                apiEndPointString = fiveHundredPX_search;
                break;
            case PhotoFeedModelTypeUserPhotos:
                apiEndPointString = fiveHundredPX_user;
                break;
                
            default:
                break;
        }
        _urlString = [[fiveHundredPX_host stringByAppendingString:apiEndPointString] stringByAppendingString:fiveHundredPX_consumer_key_param];
    }
    return self;
}

#pragma mark - Instance Methods

- (NSUInteger)totalNumberOfPhotos
{
    return _totalItems;
}

- (NSUInteger)numberOfItemsInFeed
{
    return [_photos count];
}

- (AYPhotoModel *)objectAtIndex:(NSUInteger)index
{
    return [_photos objectAtIndex:index];
}

- (NSInteger)indexOfPhotoModel:(AYPhotoModel *)photoModel
{
    return [_photos indexOfObjectIdenticalTo:photoModel];
}

- (void)updatePhotoFeedModelTypeLocationCoordinates:(CLLocationCoordinate2D)coordinate radiusInMiles:(NSUInteger)radius;
{
    _location = coordinate;
    _locationRadius = radius;
    NSString *locationString = [NSString stringWithFormat:@"%f,%f,%lumi", coordinate.latitude, coordinate.longitude, (unsigned long)radius];
    
    _urlString = [fiveHundredPX_host stringByAppendingString:fiveHundredPX_search];
    _urlString = [[_urlString stringByAppendingString:locationString] stringByAppendingString:fiveHundredPX_consumer_key_param];
}

- (void)updatePhotoFeedModelTypeUserId:(NSUInteger)userID
{
    _userID = userID;
    
    NSString *userString = [NSString stringWithFormat:@"%lu", (long)userID];
    _urlString = [fiveHundredPX_host stringByAppendingString:fiveHundredPX_user];
    _urlString = [[_urlString stringByAppendingString:userString] stringByAppendingString:@"&sort=created_at&image_size=3&include_store=store_download&include_states=voted"];
    _urlString = [_urlString stringByAppendingString:fiveHundredPX_consumer_key_param];
}

- (void)clearFeed
{
    _photos = [[NSMutableArray alloc] init];
    _ids = [[NSMutableArray alloc] init];
    _currentPage = 0;
    _fetchPageInProgress = NO;
    _refreshFeedInProgress = NO;
    [_task cancel];
    _task = nil;
}

- (void)requestPageWithCompletionBlock:(void (^)(NSArray *))block numResultsToReturn:(NSUInteger)numResults
{
    // only one fetch at a time
    if (_fetchPageInProgress) {
        return;
    } else {
        _fetchPageInProgress = YES;
        [self fetchPageWithCompletionBlock:block numResultsToReturn:numResults replaceData:NO];
    }
}

- (void)refreshFeedWithCompletionBlock:(void (^)(NSArray *))block numResultsToReturn:(NSUInteger)numResults
{
    // only one fetch at a time
    if (_refreshFeedInProgress) {
        return;
        
    } else {
        _refreshFeedInProgress = YES;
        _currentPage = 0;
        
        // FIXME: blow away any other requests in progress
        [self fetchPageWithCompletionBlock:^(NSArray *newPhotos) {
            if (block) {
                block(newPhotos);
            }
            _refreshFeedInProgress = NO;
        } numResultsToReturn:numResults replaceData:YES];
    }
}

#pragma mark - 请求数据

- (void)fetchPageWithCompletionBlock:(void (^)(NSArray *))block numResultsToReturn:(NSUInteger)numResults replaceData:(BOOL)replaceData {
    if (_totalPages) {
        if (_currentPage == _totalPages) {
            return;
        }
    }
    NSInteger numPhotos = numResults < 100 ? numResults : 100;
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        NSMutableArray *newPhotos = [NSMutableArray array];
        NSMutableArray *newIDs = [NSMutableArray array];
        @synchronized (self) {
            NSString *imageSizeParam = [AYImageURLModel imageParameterForClosestImageSize:_imageSize];
            NSString *urlAdditions   = [NSString stringWithFormat:@"&page=%lu&rpp=%lu%@", (unsigned long)_currentPage, (long)numPhotos, imageSizeParam];
            NSString *url = [_urlString stringByAppendingString:urlAdditions];
            [[AYHttpTool sharedAYHttpTool] GET:url parameters:@"" success:^(id responseObject) {
                NSDictionary *dataDict = (NSDictionary *)responseObject;
                _totalPages = [[dataDict valueForKeyPath:@"total_pages"] integerValue];
                _totalItems = [[dataDict valueForKeyPath:@"total_items"] integerValue];
                NSArray *photos = [AYPhotoModel mj_objectArrayWithKeyValuesArray:[dataDict objectForKey:@"photos"]];
                for (AYPhotoModel *photo in photos) {
                    if (replaceData || ![_ids containsObject:photo.photoID]) {
                        [newPhotos addObject:photo];
                        [newIDs addObject:photo.photoID];
                    }
                }
                dispatch_async(dispatch_get_main_queue(), ^{
                    if (replaceData) {
                        _photos = [newPhotos mutableCopy];
                        _ids = [newIDs mutableCopy];
                    }else {
                        [_photos addObjectsFromArray:newPhotos];
                        [_ids addObjectsFromArray:newIDs];
                    }
                    if (block) {
                        block(newPhotos);
                    }
                    _fetchPageInProgress = NO;
                });
            } failure:^(NSError *error) {
                AYLog(@"%@",error);
            }];
        }
        _currentPage += 1;
    });
}

@end
