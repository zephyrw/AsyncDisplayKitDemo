//
//  AYPhotoTableViewCell.h
//  ASDKSimpleDemo
//
//  Created by Zephyr on 2016/11/13.
//  Copyright © 2016年 wpsd. All rights reserved.
//

#import "AYPhotoModel.h"

@interface AYPhotoTableViewCell : UITableViewCell

+ (CGFloat)heightForPhotoModel:(AYPhotoModel *)photo withWidth:(CGFloat)width;

- (void)updateCellWithPhotoObject:(AYPhotoModel *)photo;
- (void)loadCommentsForPhoto:(AYPhotoModel *)photo;

@end
