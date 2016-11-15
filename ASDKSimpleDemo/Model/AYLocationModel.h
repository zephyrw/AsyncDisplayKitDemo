//
//  AYLocationModel.h
//  ASDKSimpleDemo
//
//  Created by Zephyr on 2016/11/11.
//  Copyright © 2016年 wpsd. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface AYLocationModel : NSObject

@property (nonatomic, assign, readonly) CLLocationCoordinate2D coordinates;
@property (nonatomic, strong, readonly) CLPlacemark            *placemark;
@property (nonatomic, strong, readonly) NSString               *locationString;

- (instancetype)init NS_UNAVAILABLE;
- (instancetype)initWith500pxPhoto:(NSDictionary *)dictionary NS_DESIGNATED_INITIALIZER;

- (void)reverseGeocodedLocationWithCompletionBlock:(void (^)(AYLocationModel *))blockName;

@end
