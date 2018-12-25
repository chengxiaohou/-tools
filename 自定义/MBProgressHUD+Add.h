//
//  MBProgressHUD+Add.h
//  视频客户端
//
//  Created by mj on 13-4-18.
//  Copyright (c) 2013年 itcast. All rights reserved.
//

#import "MBProgressHUD.h"

@interface MBProgressHUD (Add)

+ (MBProgressHUD *)showError:(NSString *)error toView:(UIView *)view;
+ (MBProgressHUD *)showSuccess:(NSString *)success toView:(UIView *)view;
/** 简短提示 */
+ (MBProgressHUD *)showMessage:(NSString *)message toView:(UIView *)view;
+ (MBProgressHUD *)showMessag:(NSString *)message toView:(UIView *)view;
+ (MBProgressHUD *)showResult:(BOOL)result text:(NSString *)text delay:(double)delay;

/** 显示带副标题的延时信息 */
+ (MBProgressHUD *)showMessag:(NSString *)message detailMessage:(NSString *)detailMessage toView:(UIView *)view delay:(double)delay;
/** 带标题的动画 */
+ (MBProgressHUD *)beginAnimateHUDAddedTo:(UIView *)view text:(NSString *)text;
/** 带标题+副标题的动画 */
+ (MBProgressHUD *)beginAnimateHUDAddedTo:(UIView *)view text:(NSString *)text detailText:(NSString *)detailText;
/** 延时隐藏handle */
- (void)hideAfterDelay:(NSTimeInterval)delay handle:(void (^)(void))handle;

@end
