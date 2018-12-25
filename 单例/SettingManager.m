//
//  SettingManager.m
//  BAM
//
//  Created by 橙晓侯 on 2017/12/15.
//  Copyright © 2017年 橙晓侯. All rights reserved.
//

#import "SettingManager.h"

@implementation SettingManager

/** UDKey：字体增量 */
static NSString *const UDKey_FontIncrement = @"FontIncrementKey";

+ (SettingManager *)manager
{
    static SettingManager *this = nil;
    // 执行一次
    static dispatch_once_t predicate;
    dispatch_once(&predicate, ^{
        
        this = [[self alloc] init];
        // 读取全局字体增量
        this.fontIncrement = [[UD objectForKey:UDKey_FontIncrement] floatValue];
    });
    return this;
}

- (void)setFontIncrement:(CGFloat)fontIncrement
{
    _fontIncrement = fontIncrement;
    [UD setObject:@(_fontIncrement) forKey:UDKey_FontIncrement];
    [UD synchronize];
    // fontIncrement变动后必定发出通知
    [[NSNotificationCenter defaultCenter] postNotificationName:NOTI_FontIncrementChenged object:nil];
}


@end


