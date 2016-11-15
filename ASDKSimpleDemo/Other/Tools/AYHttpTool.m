//
//  AYHttpTool.m
//  ASDKSimpleDemo
//
//  Created by Zephyr on 2016/11/11.
//  Copyright © 2016年 wpsd. All rights reserved.
//

#import "AYHttpTool.h"
#import "AFNetworking.h"

@implementation AYHttpTool
singleton_implementation(AYHttpTool)

- (void)GET:(NSString *)URLString parameters:(id)parameters success:(void (^)(id))success failure:(void (^)(NSError *))failure {
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    [manager GET:URLString parameters:parameters progress:^(NSProgress * _Nonnull downloadProgress) {
        AYLog(@"%@", downloadProgress);
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        if (success) {
            success(responseObject);
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        if (failure) {
            failure(error);
        }
    }];
}

- (void)POST:(NSString *)URLString parameters:(id)parameters progress:(void (^)(NSProgress *))uploadProgress success:(void (^)(id))success failure:(void (^)(NSError *))failure {
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    [manager GET:URLString parameters:parameters progress:^(NSProgress * _Nonnull downloadProgress) {
        AYLog(@"%@", downloadProgress);
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        if (success) {
            success(responseObject);
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        if (failure) {
            failure(error);
        }
    }];
}

@end
