//
//  EETextField.h
//  QuanQiuBang
//
//  Created by 橙晓侯 on 16/1/27.
//  Copyright © 2016年 小马网络. All rights reserved.
//

#import <UIKit/UIKit.h>
//IB_DESIGNABLE
@interface EETextField : UITextField
//=========== 边框 ===========
@property (assign, nonatomic) IBInspectable CGFloat cornerRadius;
@property (assign, nonatomic) IBInspectable CGFloat borderWidth;    // 线宽
@property (strong, nonatomic) IBInspectable UIColor *borderColor;
//=========== === ===========

/** 文字左边距 */
@property (assign, nonatomic) IBInspectable CGFloat leftSpace;
/** 左视图 */
@property (nonatomic, assign) CGRect leftViewFrame;
/** placeholder颜色 */
@property (nonatomic, strong) UILabel *placeholderLabel;

//=========== === ===========
/** 使用点击变灰效果 */
@property (assign, nonatomic) IBInspectable BOOL selection;
/** 点击事件 */
@property (strong, nonatomic) void (^clickEvent)(void);

@property (assign, nonatomic) BOOL fontIncrementForbident;
@end
