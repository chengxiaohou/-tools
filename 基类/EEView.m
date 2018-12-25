//
//  EEView.m
//  QuanQiuBang
//
//  Created by 橙晓侯 on 16/1/26.
//  Copyright © 2016年 小马网络. All rights reserved.
//

#import "EEView.h"

@implementation EEView
{
    
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

-(void)changeColor:(UIGestureRecognizer *)gestureRecognizer{
    
    static CGPoint firstPoint;
    static UIColor * bgColor;
    // 接触时变灰
    if (gestureRecognizer.state == UIGestureRecognizerStateBegan)
    {
        bgColor = self.backgroundColor;
        self.backgroundColor = EEViewGreyColor;
        firstPoint = [gestureRecognizer locationInView:self.superview];
    }
    // 离开时变回去
    else if (gestureRecognizer.state == UIGestureRecognizerStateEnded)
    {
        self.backgroundColor = bgColor;
    }
    // 移动时变回去
    else
    {
        CGPoint newPoint = [gestureRecognizer locationInView:self.superview];
        if (fabs(newPoint.x - firstPoint.x) > 10 ||
            fabs(newPoint.y - firstPoint.y) > 10)
        {
            self.backgroundColor = bgColor;
        }
    }
}

//下面三个函数用于多个GestureRecognizer 协同作业，避免按下的手势影响了而别的手势不响应
- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer
{
    return YES;
}

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer
{
    return YES;
}

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch
{
    return YES;
}

@end
