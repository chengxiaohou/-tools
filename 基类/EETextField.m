//
//  EETextField.m
//  QuanQiuBang
//
//  Created by 橙晓侯 on 16/1/27.
//  Copyright © 2016年 小马网络. All rights reserved.
//

#import "EETextField.h"

@implementation EETextField
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
    if (self.placeholder.length) {
        self.placeholder = NSLocalizedString(self.placeholder, nil);
    }
    
    //=========== 全局字体增量 ===========
    originFontSize = self.placeholderLabel.font.pointSize;
    [self refreshFontIncrement];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(refreshFontIncrement) name:NOTI_FontIncrementChenged object:nil];
}

#pragma mark 更新字体增量
- (void)refreshFontIncrement
{
    self.font = [UIFont fontWithName:self.font.fontName size:originFontSize + FontIncrement];
    
    self.placeholderLabel.font = [UIFont fontWithName:self.placeholderLabel.font.fontName size:originFontSize + FontIncrement];
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

- (CGRect)leftViewRectForBounds:(CGRect)bounds {

    if (_leftViewFrame.origin.x != 0)
    {
        return _leftViewFrame;
    }
    return [super leftViewRectForBounds:bounds];
}

- (UILabel *)placeholderLabel
{
    return [self valueForKey:@"_placeholderLabel"];
}

- (void)setLeftSpace:(CGFloat)leftSpace
{
    if (leftSpace > 0) {

        _leftSpace = leftSpace;
        CGRect frame = [self frame];
        frame.size.width = leftSpace;
        UIImageView *leftview = [[UIImageView alloc] initWithFrame:frame];
        self.leftViewMode = UITextFieldViewModeAlways;
        self.leftView = leftview;
    }
}

/** 防止UITextBorderStyleNone编辑文字时偏移 */
- (CGRect)editingRectForBounds:(CGRect)bounds {
    if (self.borderStyle == UITextBorderStyleNone)
        return CGRectInset( bounds , 1 , 0 );
    else
        return [super editingRectForBounds:bounds];
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

#pragma mark - ......::::::: 点击变灰的设置 :::::::......
- (void)setSelection:(BOOL)selection
{
    _selection = selection;
    UILongPressGestureRecognizer *tapRecognizer = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(changeColor:)];
    tapRecognizer.minimumPressDuration = 0;//Up to you;
    tapRecognizer.cancelsTouchesInView = NO;
    tapRecognizer.delegate = self;
    [self addGestureRecognizer:tapRecognizer];
}
@end
