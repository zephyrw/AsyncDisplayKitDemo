//
//  UIImage+AYImage_Extension.h
//
//  Created by Zephyr on 14/6/28.
//  Copyright © 2014年 anye. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImage (Extension)

+ (instancetype)imageWithOriginalImageName:(NSString *)imageName;

+ (instancetype)imageWithStretchableImage:(UIImage *)image;

@end
