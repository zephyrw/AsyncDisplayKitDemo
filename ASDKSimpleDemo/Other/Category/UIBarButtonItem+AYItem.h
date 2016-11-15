//
//  UITabBarItem+AYItem.h
//
//  Created by Zephyr on 14/6/28.
//  Copyright © 2014年 anye. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIBarButtonItem (AYItem)

+ (instancetype)barButtonItemWithImageName:(NSString *)image highlightedImageName:(NSString *)hlImage target:(id)target selector:(SEL)selector controlEvents:(UIControlEvents)controlEvents;

@end
