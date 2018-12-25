//
//  CDManager.h
//  GoldenB
//
//  Created by 橙晓侯 on 16/4/18.
//  Copyright © 2016年 橙晓侯. All rights reserved.
//

#import "BaseObj.h"

@interface CDManager : BaseObj

@property (nonatomic, assign) NSInteger SMS_CD;
@property (nonatomic, strong) NSTimer *SMS_timer;
@property (nonatomic, strong) NSString *SMS_code;
/** 进入后台时间记录 */
@property (nonatomic, strong) NSDate *goBackgroundDate;

+ (CDManager *)sharedManager;

/** 开始计时 */
- (void)startCountDown;

/** 发出验证码（带CD判断） */
//- (void)sendSMSCodeToPhone:(NSString *)phone handle:(void (^)(void))handle;
/** 对比校验 */
//- (void)CDManager:(NSString *)code handle:(void (^)(void))handle;

@end

