//
//  TheUser.m
//  QuanQiuBang
//
//  Created by 橙晓侯 on 16/1/6.
//  Copyright © 2016年 小马网络. All rights reserved.
//

#import "UDManager.h"
#define UD [NSUserDefaults standardUserDefaults]

@implementation UDManager


+ (void)setLoginName:(NSString *)name password:(NSString *)password
{
    if (name) {
        [UD setObject:name forKey:@"name"];// name是手机号
    }
    if (password) {
        [UD setObject:password forKey:@"password"];
    }
    
    [UD synchronize];
}

+ (void)setLoginPassword:(NSString *)password
{
    if (password)
    {
        [UD setObject:password forKey:@"password"];
    }
}

+ (void)cleanUserData
{
    [UD setObject:nil forKey:@"name"];// name是手机号
    [UD setObject:nil forKey:@"password"];
    [UD synchronize];
}

+ (void)cleanTheLoginData
{
    [UD setObject:nil forKey:@"name"];// name是手机号
    [UD setObject:nil forKey:@"password"];
    [UD synchronize];
}

+ (NSString *)getUserName
{
    NSString * name = [UD objectForKey:@"name"];
    return name;
}

+ (NSString *)getUserPassword
{
    NSString * password = [UD objectForKey:@"password"];
    return password;
}

#pragma mark 第一次运行 （UUID保存）
+ (void)didFirstLaunch
{
    [UD setBool:YES forKey:@"isSecondLunch"];
    [self setUDID:[[NSUUID UUID] UUIDString]];
}

+ (BOOL)isSecondLaunch
{
    return [UD boolForKey:@"isSecondLunch"];
}

+ (void)setUDID:(NSString *)UDID
{
    [UD setValue:UDID forKey:@"UDID"];
}

+ (NSString *)getUDID
{
    return [UD valueForKey:@"UDID"];
}

+ (BOOL)GetLogin
{
    return [UD boolForKey:@"isLogin"];
}

@end
