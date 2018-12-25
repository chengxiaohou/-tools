//
//  MBProgressHUD+Add.m
//  视频客户端
//
//  Created by mj on 13-4-18.
//  Copyright (c) 2013年 itcast. All rights reserved.
//

#import "MBProgressHUD+Add.h"

@implementation MBProgressHUD (Add)

#pragma mark 橙晓侯自制MBProgressHUD方法
+ (MBProgressHUD *)showResult:(BOOL)result text:(NSString *)text delay:(double)delay
{
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:Window animated:YES];
    hud.alpha = 0.8;
    hud.labelText = text;
    // 设置图片
    hud.customView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:[NSString stringWithFormat:@"MBProgressHUD.bundle/%@", result ? @"icon_gg" : @"icon_xx"]]];
    // 再设置模式
    hud.mode = MBProgressHUDModeCustomView;
    
    // 隐藏时候从父控件中移除
    hud.removeFromSuperViewOnHide = YES;
    
    // n秒之后再消失
    [hud hide:YES afterDelay:delay];
    
    return hud;
}

#pragma mark 显示带副标题的延时信息
+ (MBProgressHUD *)showMessag:(NSString *)message detailMessage:(NSString *)detailMessage toView:(UIView *)view delay:(double)delay
{
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:Window animated:YES];
    hud.alpha = 0.8;
    hud.labelText = message;
    hud.detailsLabelText = detailMessage;
    // 再设置模式
    hud.mode = MBProgressHUDModeCustomView;
    
    // 隐藏时候从父控件中移除
    hud.removeFromSuperViewOnHide = YES;
    
    // n秒之后再消失
    [hud hide:YES afterDelay:delay];
    
    return hud;
}


// 带标题的动画
+ (MBProgressHUD *)beginAnimateHUDAddedTo:(UIView *)view text:(NSString *)text {
    
    return [MBProgressHUD beginAnimateHUDAddedTo:view text:text detailText:nil];
}

// 带标题+副标题的动画
+ (MBProgressHUD *)beginAnimateHUDAddedTo:(UIView *)view text:(NSString *)text detailText:(NSString *)detailText {
    
    MBProgressHUD *HUD = [[MBProgressHUD alloc] initWithView:view];
    
    if (text) HUD.label.text = text;
    
    if (detailText) HUD.detailsLabel.text = detailText;
    
    [view addSubview:HUD];
    [HUD showAnimated:YES];
    
    return HUD;
}

// 点击取消的操作
+ (void)removeHUD:(UITapGestureRecognizer *)tap
{
    [tap.view removeFromSuperview];
}

#pragma mark 显示信息
+ (MBProgressHUD *)show:(NSString *)text icon:(NSString *)icon view:(UIView *)view
{
    if (view == nil) view = [UIApplication sharedApplication].keyWindow;
    // 快速显示一个提示信息
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:view animated:YES];
    [hud setUserInteractionEnabled:NO];// 橙晓侯修改成可点击穿透
    hud.alpha = 0.8;
    hud.labelText = text;
    // 设置图片
    hud.customView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:[NSString stringWithFormat:@"MBProgressHUD.bundle/%@", icon]]];
    // 再设置模式
    hud.mode = MBProgressHUDModeCustomView;
    
    // 隐藏时候从父控件中移除
    hud.removeFromSuperViewOnHide = YES;
    
    // 1秒之后再消失
    [hud hide:YES afterDelay:0.7];
    
    return hud;
}

#pragma mark 显示错误信息
+ (MBProgressHUD *)showError:(NSString *)error toView:(UIView *)view{
    return [self show:error icon:@"icon_xx" view:view];
}

+ (MBProgressHUD *)showSuccess:(NSString *)success toView:(UIView *)view
{
    return [self show:success icon:@"icon_gg" view:view];
}

+ (MBProgressHUD *)showMessage:(NSString *)message toView:(UIView *)view
{
    NSLog(@"MB报幕：%@", message);
    return [self show:message icon:nil view:view];
}

#pragma mark 显示一些信息
+ (MBProgressHUD *)showMessag:(NSString *)message toView:(UIView *)view {
    if (view == nil) view = [UIApplication sharedApplication].keyWindow;
    // 快速显示一个提示信息
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:view animated:YES];
    hud.labelText = message;
    // 隐藏时候从父控件中移除
    hud.removeFromSuperViewOnHide = YES;
    // YES代表需要蒙版效果
    hud.dimBackground = NO;
    [hud hide:YES afterDelay:0.7];
    return hud;
}

#pragma mark 延时隐藏代码块
- (void)hideAfterDelay:(NSTimeInterval)delay handle:(void (^)(void))handle
{
    [self performSelector:@selector(hideHandle:) withObject:handle afterDelay:delay];
}

- (void)hideHandle:(void (^)(void))handle
{
    if (handle)
    {
        handle();
    }
    [self hide:YES];
}

@end
