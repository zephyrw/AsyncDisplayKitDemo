//
//  AYCommentView.h
//  ASDKSimpleDemo
//
//  Created by Zephyr on 2016/11/13.
//  Copyright © 2016年 wpsd. All rights reserved.
//

#import "AYCommentFeedModel.h"

@interface AYCommentView : UIView

@property (strong, nonatomic) UIImageView *commentImageView;

+ (CGFloat)heightForCommentFeedModel:(AYCommentFeedModel *)feed withWidth:(CGFloat)width;

- (void)updateWithCommentFeedModel:(AYCommentFeedModel *)feed;

@end
