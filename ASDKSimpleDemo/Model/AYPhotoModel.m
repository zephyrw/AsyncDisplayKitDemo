//
//  AYPhotoModel.m
//  ASDKSimpleDemo
//
//  Created by Zephyr on 2016/11/11.
//  Copyright © 2016年 wpsd. All rights reserved.
//

#import "AYPhotoModel.h"
#import "MJExtension.h"

@implementation AYPhotoModel

+ (NSDictionary *)mj_replacedKeyFromPropertyName {
    return @{
                @"uploadDateString" : @"created_at",
                @"photoID" : @"id",
                @"descriptionText" : @"name",
                @"commentsCount" : @"comments_count",
                @"likesCount" : @"positive_votes_count",
                @"urlString" : @"image_url",
                @"ownerUserProfile" : @"user"
             };
}

#pragma mark - Properties

- (AYCommentFeedModel *)commentFeed
{
    if (!_commentFeed) {
        _commentFeed = [[AYCommentFeedModel alloc] initWithPhotoID:_photoID];
    }
    return _commentFeed;
}

- (void)setUrlString:(NSString *)urlString {
    _urlString = urlString;
    _URL = [NSURL URLWithString:urlString];
}

- (void)setUploadDateString:(NSString *)uploadDateString {
    _uploadDateString = [NSString elapsedTimeStringSinceDate:uploadDateString];
}

#pragma mark - 实例方法

- (NSAttributedString *)descriptionAttributedStringWithFontSize:(CGFloat)size
{
    NSString *string               = [NSString stringWithFormat:@"%@ %@", self.ownerUserProfile.username, self.descriptionText];
    NSAttributedString *attrString = [NSAttributedString attributedStringWithString:string
                                                                           fontSize:size
                                                                              color:[UIColor darkGrayColor]
                                                                     firstWordColor:AYDarkBlueColor];
    return attrString;
}

- (NSAttributedString *)uploadDateAttributedStringWithFontSize:(CGFloat)size
{
    return [NSAttributedString attributedStringWithString:self.uploadDateString fontSize:size color:[UIColor lightGrayColor] firstWordColor:nil];
}

@end
