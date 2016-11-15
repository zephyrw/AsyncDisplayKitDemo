//
//  AYPhotoFeedModel.h
//  ASDKSimpleDemo
//
//  Created by Zephyr on 2016/11/11.
//  Copyright © 2016年 wpsd. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AYPhotoModel.h"

typedef NS_ENUM(NSInteger, PhotoFeedModelType) {
    PhotoFeedModelTypePopular,
    PhotoFeedModelTypeLocation,
    PhotoFeedModelTypeUserPhotos
};

@interface AYPhotoFeedModel : NSObject

- (NSUInteger)totalNumberOfPhotos;
- (NSUInteger)numberOfItemsInFeed;
- (AYPhotoModel *)objectAtIndex:(NSUInteger)index;
- (NSInteger)indexOfPhotoModel:(AYPhotoModel *)photoModel;

- (instancetype)initWithPhotoFeedModelType:(PhotoFeedModelType)type imageSize:(CGSize)imageSize;
- (void)requestPageWithCompletionBlock:(void (^)(NSArray *))block numResultsToReturn:(NSUInteger)numResults;

- (void)clearFeed;

- (void)refreshFeedWithCompletionBlock:(void (^)(NSArray *))block numResultsToReturn:(NSUInteger)numResults;
- (void)fetchPageWithCompletionBlock:(void (^)(NSArray *))block numResultsToReturn:(NSUInteger)numResults replaceData:(BOOL)replaceData;

@end
