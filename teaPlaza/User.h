//
//  User.h
//  teaPlaza
//
//  Created by bevin chen on 13-3-28.
//  Copyright (c) 2013年 maimaicha. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface User : NSObject

// 检查是否登陆，已登陆返回YES
+ (BOOL)checkLogin;

// 保存用户信息
+ (BOOL)saveUserInfo:(NSMutableDictionary *)userDictionary;

// 获取Session
+ (NSString *)getSession;

// 获取用户Id
+ (NSString *)getUserId;

// 获取用户名
+ (NSMutableDictionary *)getUsername;

// 清除用户信息
+ (BOOL)clearUserInfo;
@end
