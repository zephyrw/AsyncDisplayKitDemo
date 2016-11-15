//
//  AYCommentFeedModel.m
//  ASDKSimpleDemo
//
//  Created by Zephyr on 2016/11/11.
//  Copyright © 2016年 wpsd. All rights reserved.
//

#import "AYCommentFeedModel.h"
#import "AYHttpTool.h"
#import "MJExtension.h"

#define num_comments_to_show 3

#define fiveHundredPX_host      @"https://api.500px.com/v1/"
#define fiveHundredPX_popular   @"photos?feature=popular&exclude=Nude,People,Fashion&sort=rating&image_size=3&include_store=store_download&include_states=voted"
#define fiveHundredPX_search    @"photos/search?geo="    //latitude,longitude,radius<units>
#define fiveHundredPX_user      @"photos?user_id="
#define fiveHundredPX_consumer_key_param @"&consumer_key=Fi13GVb8g53sGvHICzlram7QkKOlSDmAmp9s9aqC"   // 500px注册的app key

@implementation AYCommentFeedModel
{
    NSMutableArray *_comments;    // CommentModel 模型数组
    
    NSString       *_photoID;
    NSString       *_urlString;
    NSUInteger     _currentPage;
    NSUInteger     _totalPages;
    NSUInteger     _totalItems;
    
    BOOL           _fetchPageInProgress;
    BOOL           _refreshFeedInProgress;
}

- (instancetype)initWithPhotoID:(NSString *)photoID
{
    self = [super init];
    
    if (self) {
        _photoID     = photoID;
        _currentPage = 0;
        _totalPages  = 0;
        _totalItems  = 0;
        _comments    = [[NSMutableArray alloc] init];
        _urlString   = [NSString stringWithFormat:@"https://api.500px.com/v1/photos/%@/comments?",photoID];
    }
    
    return self;
}

#pragma mark - Instance Methods

- (NSUInteger)numberOfItemsInFeed
{
    return [_comments count];
}

- (AYCommentModel *)objectAtIndex:(NSUInteger)index
{
    return [_comments objectAtIndex:index];
}

- (NSUInteger)numberOfCommentsForPhoto
{
    return _totalItems;
}

- (BOOL)numberOfCommentsForPhotoExceedsInteger:(NSUInteger)number
{
    return (_totalItems > number);
}

- (NSAttributedString *)viewAllCommentsAttributedString
{
    NSString *string               = [NSString stringWithFormat:@"查看全部%@条评论", [NSNumber numberWithUnsignedInteger:_totalItems]];
    NSAttributedString *attrString = [NSAttributedString attributedStringWithString:string fontSize:14 color:[UIColor lightGrayColor] firstWordColor:nil];
    return attrString;
}

- (void)requestPageWithCompletionBlock:(void (^)(NSArray *))block
{
    // only one fetch at a time
    if (_fetchPageInProgress) {
        return;
    } else {
        _fetchPageInProgress = YES;
        [self fetchPageWithCompletionBlock:block replaceData:NO];
    }
}

- (void)refreshFeedWithCompletionBlock:(void (^)(NSArray *))block
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
        } replaceData:YES];
    }
}

#pragma mark - Helper Methods

- (void)fetchPageWithCompletionBlock:(void (^)(NSArray *))block replaceData:(BOOL)replaceData
{
    // early return if reached end of pages
    if (_totalPages) {
        if (_currentPage == _totalPages) {
            return;
        }
    }
    _currentPage += 1;
    
    NSMutableArray *newComments = [NSMutableArray array];
    
    NSString *urlAdditions = [NSString stringWithFormat:@"page=%lu", (unsigned long)_currentPage];
    NSString *URLStr = [_urlString stringByAppendingString:urlAdditions];
    [[AYHttpTool sharedAYHttpTool] GET:URLStr parameters:nil success:^(id responseObject) {
        
        NSDictionary *dataDict = (NSDictionary *)responseObject;
        _totalPages  = [[dataDict valueForKeyPath:@"total_pages"] integerValue];
        _totalItems  = [[dataDict valueForKeyPath:@"total_items"] integerValue];
        NSArray *comments = [NSDictionary mj_objectArrayWithKeyValuesArray:dataDict[@"comments"]];
        NSUInteger commentsCount = comments.count;
        if (commentsCount > num_comments_to_show) {
            comments = [comments subarrayWithRange:(NSRange){commentsCount - num_comments_to_show, num_comments_to_show}];
        }
        for (NSDictionary *dict in comments) {
            AYCommentModel *comment = [AYCommentModel mj_objectWithKeyValues:dict];
            [newComments addObject:comment];
        }
        _fetchPageInProgress = NO;
        if (replaceData) {
            _comments = [newComments mutableCopy];
        } else {
            [_comments addObjectsFromArray:newComments];
        }
        if (block) {
            block(newComments);
        }
    } failure:^(NSError *error) {
        AYLog(@"%@", error);
    }];

}


@end
