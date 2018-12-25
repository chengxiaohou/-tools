//
//  UDManager
//  
//
//  Created by 橙晓侯 on 16/1/6.
//  Copyright © 2016年 小马网络. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface UDManager : NSObject

+ (void)setLoginName:(NSString *)name password:(NSString *)password;
+ (void)setLoginPassword:(NSString *)password;
/** 清空账号密码 */
+ (void)cleanUserData __attribute__((deprecated("Use cleanTheLoginData instead.")));
+ (void)cleanTheLoginData;
+ (void)didFirstLaunch;
+ (BOOL)isSecondLaunch;

+ (NSString *)getUserName;
+ (NSString *)getUserPassword;

/** 保存某种唯一标识符 */
+ (void)setUDID:(NSString *)UDID;
/** 读取某种唯一标识符 */
+ (NSString *)getUDID;
+ (BOOL)GetLogin;
@end
