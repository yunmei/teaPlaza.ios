//
//  User.m
//  teaPlaza
//
//  Created by bevin chen on 13-3-28.
//  Copyright (c) 2013年 maimaicha. All rights reserved.
//

#import "User.h"

@implementation User

+ (BOOL)checkLogin
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    if ([defaults objectForKey:@"session"] == nil || [[defaults objectForKey:@"session"] isEqualToString:@""]) {
        return NO;
    }
    return YES;
}

+ (BOOL)saveUserInfo:(NSMutableDictionary *)userDictionary
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setObject:[userDictionary objectForKey:@"session"] forKey:@"session"];
    [defaults setObject:[userDictionary objectForKey:@"username"] forKey:@"username"];
    [defaults setObject:[userDictionary objectForKey:@"userId"] forKey:@"userId"];
    [defaults synchronize];
    return YES;
}

+ (NSString *)getSession
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    return [defaults objectForKey:@"session"];
}

+ (NSString *)getUserId
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    return [defaults objectForKey:@"userId"];
}

+ (NSMutableDictionary *)getUsername
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    return [defaults objectForKey:@"username"];
}

+ (BOOL)clearUserInfo
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setObject:@"" forKey:@"session"];
    [defaults setObject:@"" forKey:@"username"];
    [defaults setObject:@"" forKey:@"userId"];
    [defaults synchronize];
    return YES;
}
@end
