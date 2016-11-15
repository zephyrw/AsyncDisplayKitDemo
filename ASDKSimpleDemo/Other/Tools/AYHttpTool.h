//
//  AYHttpTool.h
//  ASDKSimpleDemo
//
//  Created by Zephyr on 2016/11/11.
//  Copyright © 2016年 wpsd. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Singleton.h"

@interface AYHttpTool : NSObject
singleton_interface(AYHttpTool)

- (void)GET:(NSString *)URLString
                            parameters:(id)parameters
                               success:(void (^)(id responseObject))success
                               failure:(void (^)(NSError *error))failure;

- (void)POST:(NSString *)URLString
      parameters:(id)parameters
        progress:(void (^)(NSProgress *))uploadProgress
         success:(void (^)(id))success
         failure:(void (^)(NSError * ))failure;

@end
