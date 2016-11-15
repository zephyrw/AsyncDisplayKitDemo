//
//  AYUserModel.m
//  ASDKSimpleDemo
//
//  Created by Zephyr on 2016/11/11.
//  Copyright © 2016年 wpsd. All rights reserved.
//

#import "AYUserModel.h"
#import "MJExtension.h"

@implementation AYUserModel

+ (NSDictionary *)mj_replacedKeyFromPropertyName {
    return @{
                @"userID":@"id",
                @"photoCount":@"photos_count",
                @"galleriesCount":@"galleries_count",
                @"friendsCount":@"friends_count",
                @"followersCount":@"followers_count",
                @"urlString":@"userpic_url"
             };
}

- (void)setUrlString:(NSString *)urlString {
    _urlString = urlString;
    _userPicURL = [NSURL URLWithString:urlString];
}

- (NSAttributedString *)usernameAttributedStringWithFontSize:(CGFloat)size
{
    return [NSAttributedString attributedStringWithString:self.username fontSize:size color:AYDarkBlueColor firstWordColor:nil];
}

- (NSAttributedString *)fullNameAttributedStringWithFontSize:(CGFloat)size
{
    return [NSAttributedString attributedStringWithString:self.fullName fontSize:size color:[UIColor lightGrayColor] firstWordColor:nil];
}

@end
