//
//  EELabel.h
//  QuanQiuBang
//
//  Created by 橙晓侯 on 16/1/27.
//  Copyright © 2016年 小马网络. All rights reserved.
//

#import <UIKit/UIKit.h>
IB_DESIGNABLE
@interface EELabel : UILabel

//=========== 边框 ===========
@property (assign, nonatomic) IBInspectable CGFloat cornerRadius;
@property (assign, nonatomic) IBInspectable CGFloat borderWidth;    // 线宽
@property (strong, nonatomic) IBInspectable UIColor *borderColor;
//=========== === ===========

/** 点击事件 */
@property (strong, nonatomic) void (^clickEvent)(void);

///** 字体大小全局控制 */
//@property (assign, nonatomic) BOOL globalFontEnable;


@end
