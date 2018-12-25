//
//  EEStackView.m
//  MingPian
//
//  Created by 橙晓侯 on 2017/9/13.
//  Copyright © 2017年 橙晓侯. All rights reserved.
//

#import "EEStackView.h"

@implementation EEStackView

- (void)setCornerRadius:(CGFloat)cornerRadius {
    
    _cornerRadius = cornerRadius;
    [self updateBorderView];
}

- (void)setBorderColor:(UIColor *)borderColor {
    
    _borderColor = borderColor;
    [self updateBorderView];
}

- (void)setBorderWidth:(CGFloat)borderWidth {
    
    _borderWidth = borderWidth;
    [self updateBorderView];
}


#pragma mark 刷新borderView
- (void)updateBorderView
{
    MJWeakSelf
    [self bringSubviewToFront:self.borderView];
    _borderView.backgroundColor = [UIColor clearColor];
    _borderView.borderColor = _borderColor;
    _borderView.borderWidth = _borderWidth;
    _borderView.cornerRadius = _cornerRadius;
    _borderView.clipsToBounds = 1;
    _borderView.userInteractionEnabled = 0;
    
    [_borderView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(weakSelf).insets(UIEdgeInsetsMake(0, 0, 0, 0));
    }];
}


- (EEView *)borderView
{
    if (!_borderView) {
        _borderView = [EEView new];
        [self addSubview:_borderView];
    }
    return _borderView;
}

/*
 // Only override drawRect: if you perform custom drawing.
 // An empty implementation adversely affects performance during animation.
 - (void)drawRect:(CGRect)rect {
 // Drawing code
 }
 */

@end

