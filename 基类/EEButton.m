//
//  EEButton.m
//  QuanQiuBang
//
//  Created by 橙晓侯 on 16/1/26.
//  Copyright © 2016年 小马网络. All rights reserved.
//

#import "EEButton.h"
#import "UIView+ColorPointAndMask.h"

@implementation EEButton
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
    // 设置半圆角
    if (_halfRadius) {
        self.layer.masksToBounds = YES;
        self.layer.cornerRadius = self.width/2;
    }
}



- (void)awakeFromNib {
    
    [super awakeFromNib];
    
    //=========== 本地化 ===========
    NSArray *stateArray = @[@(UIControlStateNormal), @(UIControlStateSelected), @(UIControlStateHighlighted), @(UIControlStateDisabled)];
    for (NSNumber *stateNum in stateArray) {
        UIControlState state = [stateNum unsignedIntegerValue];
        NSString *title = [self titleForState:state];
        if (title.length) {
            [self setTitle:NSLocalizedString(title, nil) forState:state];
        }
    }
    //=========== 全局字体增量 ===========
    originFontSize = self.titleLabel.font.pointSize;
    [self refreshFontIncrement];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(refreshFontIncrement) name:NOTI_FontIncrementChenged object:nil];
}

#pragma mark 更新字体增量
- (void)refreshFontIncrement
{
    self.titleLabel.font = [UIFont fontWithName:self.titleLabel.font.fontName size:originFontSize + FontIncrement];
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

- (BOOL)pointInside:(CGPoint)point withEvent:(UIEvent *)event {
    
    BOOL result = [super pointInside:point withEvent:event];
    
    if (!self.isIgnoreTouchInTransparentPoint) {
        
        return result; // 正常流程
    }
    
    if (result)
    {
        // 判断alpha
        return ![self isTansparentOfPoint:point];
        
    }
    return NO;
}




- (void)setImageMode:(NSInteger)imageMode
{
    _imageMode = imageMode;
    self.imageView.contentMode = _imageMode;
}

- (void)setBGImageMode:(NSInteger)BGImageMode
{
    // 1、确保不会替换掉真正需要使用的背景图
    UIImage *backgroundImage = self.currentBackgroundImage ? self.currentBackgroundImage : [UIImage new];
    
    // 2、给普通模式设置背景图，之后才能找到背景View。可能还是会导致bug，待测试
    [self setBackgroundImage:backgroundImage forState:UIControlStateNormal];
    
    // 3、需要触发self.imageView，不然self.subviews里面没内容
    self.imageView.contentMode = self.imageView.contentMode;
    _BGImageMode = BGImageMode;
    
    // 4、取出BGView
    UIImageView *imageView = (UIImageView *)[self.subviews firstObject];
    [imageView setContentMode:_BGImageMode];
}

#pragma mark 设置点击事件代码块
- (void)setClickEvent:(void (^)(void))clickEvent
{
    _clickEvent = clickEvent;
    [self addTarget:self action:@selector(touchAction:) forControlEvents:UIControlEventTouchUpInside];
}

#pragma mark 触发代码块点击事件
- (void)touchAction:(id)sender
{
    _clickEvent();
}

#pragma mark 文字使用主题色
- (void)setTitleThemeColor:(BOOL)titleThemeColor
{
    _titleThemeColor = titleThemeColor;
    [self setTitleColor:ThemeColor forState:UIControlStateNormal];
}
#pragma mark 背景使用主题色
- (void)setBgThemeColor:(BOOL)bgThemeColor
{
    _bgThemeColor = bgThemeColor;
    [self setBackgroundColor:ThemeColor];
}

@end
