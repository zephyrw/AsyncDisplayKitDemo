//
//  AYPhotoCellNode.h
//  ASDKSimpleDemo
//
//  Created by Zephyr on 2016/11/11.
//  Copyright © 2016年 wpsd. All rights reserved.
//

#import <AsyncDisplayKit/AsyncDisplayKit.h>

@class AYPhotoModel;

@interface AYPhotoCellNode : ASCellNode

- (instancetype)initWithPhotoObject:(AYPhotoModel *)photo;

@end
