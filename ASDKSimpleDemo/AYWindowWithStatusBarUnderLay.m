//
//  AYWindowWithStatusBarUnderLay.m
//  ASDKSimpleDemo
//
//  Created by wpsd on 2016/11/11.
//  Copyright © 2016年 wpsd. All rights reserved.
//

#import "AYWindowWithStatusBarUnderLay.h"

@implementation AYWindowWithStatusBarUnderLay
{
    UIView *_statusBarOpaqueUnderlayView;
}


- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        _statusBarOpaqueUnderlayView = [[UIView alloc] init];
        _statusBarOpaqueUnderlayView.backgroundColor = AYDarkBlueColor;
        [self addSubview:_statusBarOpaqueUnderlayView];
    }
    
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    [self bringSubviewToFront:_statusBarOpaqueUnderlayView];
    CGFloat statusBarH = [UIApplication sharedApplication].statusBarFrame.size.height;
    _statusBarOpaqueUnderlayView.frame = CGRectMake(0, 0, AYScreemWidth, statusBarH);
}

@end
