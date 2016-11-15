//
//  AppDelegate.m
//  ASDKSimpleDemo
//
//  Created by wpsd on 2016/11/11.
//  Copyright © 2016年 wpsd. All rights reserved.
//

#import "AppDelegate.h"
#import "AYWindowWithStatusBarUnderLay.h"
#import "AYTabBarController.h"

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
    _window = [[AYWindowWithStatusBarUnderLay alloc] initWithFrame:[UIScreen mainScreen].bounds];
    _window.backgroundColor = [UIColor whiteColor];
    _window.rootViewController = [AYTabBarController new];
    [_window makeKeyAndVisible];
    
    [UINavigationBar appearance].barTintColor = AYDarkBlueColor;
    [UINavigationBar appearance].tintColor = [UIColor whiteColor];
    [[UINavigationBar appearance] setTitleTextAttributes:@{NSForegroundColorAttributeName: [UIColor whiteColor]}];
    [[UINavigationBar appearance] setTranslucent:NO];
    
    [UITabBar appearance].tintColor = AYDarkBlueColor;
    
    return YES;
}

#pragma mark - UITabBarControllerDelegate

- (void)tabBarController:(UITabBarController *)tabBarController didSelectViewController:(UIViewController *)viewController
{
    if ([viewController isKindOfClass:[UINavigationController class]]) {
        NSArray *viewControllers = [(UINavigationController *)viewController viewControllers];
        UIViewController *rootViewController = viewControllers[0];
        if ([rootViewController conformsToProtocol:@protocol(PhotoFeedControllerProtocol)]) {
            // FIXME: 代理实现还是存在问题
//            [(id <PhotoFeedControllerProtocol>)rootViewController resetAllData];
        }
    }
}

@end
