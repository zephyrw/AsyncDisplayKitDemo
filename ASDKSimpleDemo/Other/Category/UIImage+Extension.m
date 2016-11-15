//
//  UIImage+AYImage_Extension.m
//
//  Created by Zephyr on 14/6/28.
//  Copyright © 2014年 anye. All rights reserved.
//

#import "UIImage+Extension.h"

@implementation UIImage (Extension)

+ (instancetype)imageWithOriginalImageName:(NSString *)imageName{

    UIImage *image = [UIImage imageNamed:imageName];
    return [image imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
}

+ (instancetype)imageWithStretchableImage:(UIImage *)image{
    return [image stretchableImageWithLeftCapWidth:image.size.width *0.5 topCapHeight:image.size.height * 0.5];
}


@end
