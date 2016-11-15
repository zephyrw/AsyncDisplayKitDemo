//
//  AYCommentModel.h
//  ASDKSimpleDemo
//
//  Created by Zephyr on 2016/11/11.
//  Copyright © 2016年 wpsd. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface AYCommentModel : NSObject

@property (nonatomic, assign, readonly) NSUInteger ID;
@property (nonatomic, assign, readonly) NSUInteger commenterID;
@property (nonatomic, copy, readonly) NSString *commenterUsername;
@property (nonatomic, copy, readonly) NSString *commenterAvatarURL;
@property (nonatomic, copy, readonly) NSString *body;
@property (nonatomic, copy, readonly) NSString *uploadDateString;

- (NSAttributedString *)commentAttributedString;
- (NSAttributedString *)uploadDateAttributedStringWithFontSize:(CGFloat)size;

@end
