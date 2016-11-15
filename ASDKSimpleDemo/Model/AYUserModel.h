//
//  AYUserModel.h
//  ASDKSimpleDemo
//
//  Created by Zephyr on 2016/11/11.
//  Copyright © 2016年 wpsd. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface AYUserModel : NSObject

@property (nonatomic, strong, readonly) NSDictionary *dictionaryRepresentation;
@property (nonatomic, assign, readonly) NSUInteger   userID;
@property (nonatomic, copy, readonly) NSString     *username;
@property (nonatomic, copy, readonly) NSString     *firstName;
@property (nonatomic, copy, readonly) NSString     *lastName;
@property (nonatomic, copy, readonly) NSString     *fullName;
@property (nonatomic, copy, readonly) NSString     *city;
@property (nonatomic, copy, readonly) NSString     *state;
@property (nonatomic, copy, readonly) NSString     *country;
@property (nonatomic, copy, readonly) NSString     *about;
@property (nonatomic, copy, readonly) NSString     *domain;
@property (nonatomic, strong) NSURL *userPicURL;
@property (nonatomic, copy, readonly) NSString     *urlString;
@property (nonatomic, assign, readonly) NSUInteger   photoCount;
@property (nonatomic, assign, readonly) NSUInteger   galleriesCount;
@property (nonatomic, assign, readonly) NSUInteger   affection;
@property (nonatomic, assign, readonly) NSUInteger   friendsCount;
@property (nonatomic, assign, readonly) NSUInteger   followersCount;
@property (nonatomic, assign, readonly) BOOL         following;

- (NSAttributedString *)usernameAttributedStringWithFontSize:(CGFloat)size;
- (NSAttributedString *)fullNameAttributedStringWithFontSize:(CGFloat)size;

@end
