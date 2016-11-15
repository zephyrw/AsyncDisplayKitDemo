//
//  AppDelegate.h
//  ASDKSimpleDemo
//
//  Created by wpsd on 2016/11/11.
//  Copyright © 2016年 wpsd. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol PhotoFeedControllerProtocol <NSObject>
- (void)resetAllData;
@end

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;


@end

