//
//  UITabBarItem+AYItem.m
//
//  Created by Zephyr on 14/6/28.
//  Copyright © 2014年 anye. All rights reserved.
//

#import "UIBarButtonItem+AYItem.h"

@implementation UIBarButtonItem (AYItem)

+ (instancetype)barButtonItemWithImageName:(NSString *)image highlightedImageName:(NSString *)hlImage target:(id)target selector:(SEL)selector controlEvents:(UIControlEvents)controlEvents {
    
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    [btn setImage:[UIImage imageNamed:image] forState:UIControlStateNormal];
    [btn setImage:[UIImage imageNamed:hlImage] forState:UIControlStateHighlighted];
    [btn sizeToFit];
    
    [btn addTarget:target action:selector forControlEvents:controlEvents];
    
    return [[UIBarButtonItem alloc] initWithCustomView:btn];
}

@end
