//
//  AYCommentFeedModel.h
//  ASDKSimpleDemo
//
//  Created by Zephyr on 2016/11/11.
//  Copyright © 2016年 wpsd. All rights reserved.
//

#import "AYCommentModel.h"

@interface AYCommentFeedModel : NSObject

- (instancetype)init NS_UNAVAILABLE;
- (instancetype)initWithPhotoID:(NSString *)photoID NS_DESIGNATED_INITIALIZER;

- (NSUInteger)numberOfItemsInFeed;
- (AYCommentModel *)objectAtIndex:(NSUInteger)index;

- (NSUInteger)numberOfCommentsForPhoto;
- (BOOL)numberOfCommentsForPhotoExceedsInteger:(NSUInteger)number;
- (NSAttributedString *)viewAllCommentsAttributedString;

- (void)requestPageWithCompletionBlock:(void (^)(NSArray *))block;
- (void)refreshFeedWithCompletionBlock:(void (^)(NSArray *))block;

@end
