//
//  CDManager.m
//  GoldenB
//
//  Created by 橙晓侯 on 16/4/18.
//  Copyright © 2016年 橙晓侯. All rights reserved.
//

#import "CDManager.h"

@implementation CDManager

+ (CDManager *)sharedManager
{
    static CDManager *this = nil;
    // 执行一次
    static dispatch_once_t predicate;
    dispatch_once(&predicate, ^
                  {
                      this = [[self alloc] init];
                  });
    return this;
}

#pragma mark 开始计时
- (void)startCountDown
{
    _SMS_CD = 60;
    if (!_SMS_timer)
    {
        // 初次开始倒计时
        _SMS_timer = [NSTimer timerWithTimeInterval:1 target:self selector:@selector(countDown) userInfo:nil repeats:YES];
        [[NSRunLoop currentRunLoop] addTimer:_SMS_timer forMode:NSRunLoopCommonModes];
    }
    else
    {
        // 再次开始倒计时
        [_SMS_timer setFireDate:[NSDate date]];
    }
}

#pragma mark 倒计时方法
- (void)countDown
{
    // 发通知
    [[NSNotificationCenter defaultCenter] postNotificationName:NOTI_SMSCountDown object:@(_SMS_CD)];
    if (_SMS_CD <= 0)
    {
        // 暂停定时器
        [_SMS_timer setFireDate:[NSDate distantFuture]];
        _SMS_CD = 0;
    }
    else
    {
        --_SMS_CD;// 继续计时
    }
    NSLog(@"报幕员：短信CD %ld", _SMS_CD);
//    [MBProgressHUD showMessage:[NSString stringWithFormat:@"%ld",(long)_SMS_CD] toView:Window];
}

@end
