//
//  EEButton.h
//  QuanQiuBang
//
//  Created by 橙晓侯 on 16/1/26.
//  Copyright © 2016年 小马网络. All rights reserved.
//

#import <UIKit/UIKit.h>

IB_DESIGNABLE

@interface EEButton : UIButton


//=========== 边框 ===========
@property (assign, nonatomic) IBInspectable CGFloat cornerRadius;
@property (assign, nonatomic) IBInspectable CGFloat borderWidth;    // 线宽
@property (strong, nonatomic) IBInspectable UIColor *borderColor;
/** 半圆角 */
@property (assign, nonatomic) IBInspectable BOOL halfRadius;
//=========== === ===========


/** 按钮图片填充模式 */
@property (assign, nonatomic) IBInspectable NSInteger imageMode;
/** 按钮北背景图片填充模式 */
@property (assign, nonatomic) IBInspectable NSInteger BGImageMode;

/**
 *  忽略点击到了透明区域
 */
@property (nonatomic, assign) IBInspectable BOOL isIgnoreTouchInTransparentPoint;

/** 文字使用主题色 */
@property (assign, nonatomic) IBInspectable BOOL titleThemeColor;
/** 背景使用主题色 */
@property (assign, nonatomic) IBInspectable BOOL bgThemeColor;

/** 点击事件 */
@property (strong, nonatomic) void (^clickEvent)(void);
@end
