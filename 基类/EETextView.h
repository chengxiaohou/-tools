//
//  EETextView.h
//  xmaMall
//
//  Created by 橙晓侯 on 16/6/29.
//  Copyright © 2016年 橙晓侯. All rights reserved.
//

#import <UIKit/UIKit.h>

IB_DESIGNABLE

@interface EETextView : UITextView

typedef void (^TextChangeBlock)(NSString *text);
@property (nonatomic, copy) TextChangeBlock textChangeBlock;

/** 自动适配高度 */
@property (assign, nonatomic) IBInspectable BOOL autoHeight;

/** 文字距离上下左右边距 */
@property (assign, nonatomic) IBInspectable CGFloat insetTop;
@property (assign, nonatomic) IBInspectable CGFloat insetLeft;
@property (assign, nonatomic) IBInspectable CGFloat insetRight;
@property (assign, nonatomic) IBInspectable CGFloat insetBottom;

/** placeholderLB */
@property (nonatomic, strong) UILabel *lb;
@property (nonatomic, strong) IBInspectable NSString *placeholder;

//=========== 边框 ===========
@property (assign, nonatomic) IBInspectable CGFloat cornerRadius;
@property (assign, nonatomic) IBInspectable CGFloat borderWidth;    // 线宽
@property (strong, nonatomic) IBInspectable UIColor *borderColor;
//=========== === ===========

/** 初始设置的高度约束 (要求:有且仅有一个高度类型的约束，优先级不可设置为1000) */
@property (strong, nonatomic) NSLayoutConstraint *heightConstrain;
@end
