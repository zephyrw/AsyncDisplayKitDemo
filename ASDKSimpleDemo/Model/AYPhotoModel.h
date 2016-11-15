//
//  AYPhotoModel.h
//  ASDKSimpleDemo
//
//  Created by Zephyr on 2016/11/11.
//  Copyright © 2016年 wpsd. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AYLocationModel.h"
#import "AYUserModel.h"
#import "AYCommentFeedModel.h"

@interface AYPhotoModel : NSObject

@property (nonatomic, strong) NSURL  *URL;
@property (nonatomic, copy, readonly) NSString *urlString;
@property (nonatomic, copy, readonly) NSString  *photoID;
@property (nonatomic, copy, readonly) NSString  *uploadDateString;
@property (nonatomic, copy, readonly) NSString  *title;
@property (nonatomic, copy, readonly) NSString  *descriptionText;
@property (nonatomic, assign, readonly) NSUInteger  commentsCount;
@property (nonatomic, assign, readonly) NSUInteger  likesCount;
@property (nonatomic, strong, readonly) AYLocationModel  *location;
@property (nonatomic, strong, readonly) AYUserModel   *ownerUserProfile;
@property (nonatomic, strong) AYCommentFeedModel  *commentFeed;

- (NSAttributedString *)uploadDateAttributedStringWithFontSize:(CGFloat)size;

@end
