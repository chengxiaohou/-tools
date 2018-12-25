//
//  EELabel.m
//  QuanQiuBang
//
//  Created by 橙晓侯 on 16/1/27.
//  Copyright © 2016年 小马网络. All rights reserved.
//

#import "EELabel.h"

@implementation EELabel
{
    CGFloat originFontSize;
}

- (void)drawRect:(CGRect)rect
{
    [super drawRect:rect];
    // 边框
    if (_borderWidth > 0) {
        
        self.layer.borderWidth = _borderWidth;
        self.layer.borderColor = _borderColor.CGColor;
        
    }
}

- (void)awakeFromNib {
    
    [super awakeFromNib];
    //=========== 本地化 ===========
    if (self.text.length) {
        self.text = NSLocalizedString(self.text, nil);
    }
    //=========== 全局字体增量 ===========
    originFontSize = self.font.pointSize;
    [self refreshFontIncrement];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(refreshFontIncrement) name:NOTI_FontIncrementChenged object:nil];
}

#pragma mark 更新字体增量
- (void)refreshFontIncrement
{
    self.font = [UIFont fontWithName:self.font.fontName size:originFontSize + FontIncrement];
}


- (void)setCornerRadius:(CGFloat)cornerRadius {
    
    _cornerRadius = cornerRadius;
    self.layer.masksToBounds = YES;
    self.layer.cornerRadius = cornerRadius;
}

- (void)setBorderColor:(UIColor *)borderColor {
    
    _borderColor = borderColor;
    self.layer.masksToBounds = YES;
    self.layer.borderColor = borderColor.CGColor;
}

- (void)setBorderWidth:(CGFloat)borderWidth {
    
    _borderWidth = borderWidth;
    self.layer.masksToBounds = YES;
    self.layer.borderWidth = borderWidth;
}

#pragma mark 设置点击事件代码块
- (void)setClickEvent:(void (^)(void))clickEvent
{
    _clickEvent = clickEvent;
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(touchAction:)];
    [self addGestureRecognizer:tap];
    self.userInteractionEnabled = YES;
}

#pragma mark 触发代码块点击事件
- (void)touchAction:(UITapGestureRecognizer *)tap
{
    if (_clickEvent) _clickEvent();
}

//- (void)setGlobalFontEnable:(BOOL)globalFontEnable
//{
//    _globalFontEnable = globalFontEnable;
//
//    if (_globalFontEnable) {
//
//
//    }
//}

@end
