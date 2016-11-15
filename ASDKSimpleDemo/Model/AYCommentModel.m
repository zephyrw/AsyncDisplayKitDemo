//
//  AYCommentModel.m
//  ASDKSimpleDemo
//
//  Created by Zephyr on 2016/11/11.
//  Copyright © 2016年 wpsd. All rights reserved.
//

#import "AYCommentModel.h"
#import "MJExtension.h"

@implementation AYCommentModel

+ (NSDictionary *)mj_replacedKeyFromPropertyName {
    return @{
                @"ID":@"id",
                @"commenterID":@"user_id",
                @"commenterUsername":@"user.username",
                @"commenterAvatarURL":@"user.userpic_url",
                @"uploadDateString":@"created_at"
             };
}

- (void)setUploadDateString:(NSString *)uploadDateString {
    _uploadDateString = [NSString elapsedTimeStringSinceDate:uploadDateString];
}


#pragma mark - Instance Methods

- (NSAttributedString *)commentAttributedString
{
    NSString *commentString = [NSString stringWithFormat:@"%@ %@",[_commenterUsername lowercaseString], _body];
    return [NSAttributedString attributedStringWithString:commentString fontSize:14 color:[UIColor darkGrayColor] firstWordColor:AYDarkBlueColor];
}

- (NSAttributedString *)uploadDateAttributedStringWithFontSize:(CGFloat)size;
{
    return [NSAttributedString attributedStringWithString:self.uploadDateString fontSize:size color:[UIColor lightGrayColor] firstWordColor:nil];
}

@end
