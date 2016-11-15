//
//  AYTabBarController.m
//  ASDKSimpleDemo
//
//  Created by wpsd on 2016/11/11.
//  Copyright © 2016年 wpsd. All rights reserved.
//

#import "AYTabBarController.h"
#import "AYNavigationController.h"
#import "AYPhotoFeedNodeController.h"
#import "AYPhotoFeedViewController.h"

@interface AYTabBarController ()

@end

@implementation AYTabBarController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self addChildViewController:[AYPhotoFeedViewController new] Title:@"UIKit" imageName:@"home" selImageName:@"home"];
    [self addChildViewController:[AYPhotoFeedNodeController new] Title:@"ASDK" imageName:@"home" selImageName:@"home"];
    self.selectedIndex = 1;
}

- (void)addChildViewController:(UIViewController *)vc Title:(NSString *)title imageName:(NSString *)imageName selImageName:(NSString *)selImageName {
    vc.title  =title;
    vc.tabBarItem.image = [UIImage imageNamed:imageName];
    vc.tabBarItem.selectedImage = [UIImage imageNamed:selImageName];
    AYNavigationController *naviVC = [[AYNavigationController alloc] initWithRootViewController:vc];
    naviVC.hidesBarsOnSwipe = YES;
    [self addChildViewController:naviVC];
//    if ([vc isKindOfClass:[AYPhotoFeedNodeController class]]) {
//        self.selectedViewController = naviVC;
//    }
}

@end
