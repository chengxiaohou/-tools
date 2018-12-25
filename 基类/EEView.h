//
//  EEView.h
//  QuanQiuBang
//
//  Created by 橙晓侯 on 16/1/26.
//  Copyright © 2016年 小马网络. All rights reserved.
//

#import <UIKit/UIKit.h>
IB_DESIGNABLE

@interface EEView : UIView<UIGestureRecognizerDelegate>

//=========== 边框 ===========
@property (assign, nonatomic) IBInspectable CGFloat cornerRadius;
@property (assign, nonatomic) IBInspectable CGFloat borderWidth;    // 线宽
@property (strong, nonatomic) IBInspectable UIColor *borderColor;
/** 半圆角 */
@property (assign, nonatomic) IBInspectable BOOL halfRadius;

//=========== === ===========
/** 使用点击变灰效果 */
@property (assign, nonatomic) IBInspectable BOOL selection;
/** 点击事件 */
@property (strong, nonatomic) void (^clickEvent)(void);

@end
