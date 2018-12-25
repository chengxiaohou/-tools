//
//  NavView.m
//  QuanQiuBang
//
//  Created by 橙晓侯 on 16/1/6.
//  Copyright © 2016年 小马网络. All rights reserved.
//

#import "NavView.h"

@implementation NavView

- (void)onLeft:(UIButton *)sender
{
    [self.delegate left];
}

- (void)onRight:(UIButton *)sender
{
    [self.delegate right];
}

/*
 // Only override drawRect: if you perform custom drawing.
 // An empty implementation adversely affects performance during animation.
 - (void)drawRect:(CGRect)rect {
 // Drawing code
 }
 */

#pragma mark 设置左右中间（推荐使用）
-(void)setTitle:(NSString *)title leftText:(NSString *)leftText rightTitle:(id)right showBackImg:(BOOL)showBackImg
{
    dispatch_async(dispatch_get_main_queue(), ^{
        
        if (showBackImg)
        {
            // 返回按钮图片根据主题色变色
            self.backImg.image = [[UIImage imageNamed:@"Back_Icon_SystemType"] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
            self.backImg.tintColor = _navTintColor;
            // 用于重新显示出来
            [_backImg mas_updateConstraints:^(MASConstraintMaker *make) {
                
                make.width.offset(25);
            }];
        }
        else
        {
            self.backImg.image = nil;
            [_backImg mas_updateConstraints:^(MASConstraintMaker *make) {
                
                make.width.offset(0);
            }];
        }
        // 如果传入参数有长度 判定为需要创建
        if (title.length > 0) {
            
            if (!_titleLB) {
                NSLog(@"报幕员：当前VC的标题为「%@」；类型是「%@」", title, [[self.superview nextResponder] class]);
            }
            
            self.titleLB.text = title;
            [self.titleLB setTextColor:_navTintColor];
        }
        if (leftText) {
            [self.leftBtn setTitle:leftText forState:UIControlStateNormal];
            [self.leftBtn setTitleColor:_navTintColor forState:UIControlStateNormal];
        }
        
        // 右边可设置为文字或图片
        if ([right isKindOfClass:[NSString class]]) {
            
            NSString *rightTitle = (NSString *)right;
            if (rightTitle) {
                [self.rightTitleBtn setTitle:rightTitle forState:UIControlStateNormal];
                [self.rightTitleBtn setTitleColor:_navTintColor forState:UIControlStateNormal];
            }
        }
        else if ([right isKindOfClass:[UIImage class]])
        {
            UIImage *rightImage = (UIImage *)right;
            [self.rightImageBtn setImage:rightImage forState:UIControlStateNormal];
        }
        
        self.line.hidden = 0;// 懒加载分割线，和隐藏无关
    
        // 若有专门设置过背景颜色就...不然就用默认主题色...
        self.navColor = _navColor ? _navColor : ThemeColor;
        // 导航栏的文字颜色 (没有特殊要求的就用默认的白色)
        self.navTintColor = _navTintColor ? _navTintColor : [UIColor whiteColor];
    });
    
}


- (UIImageView *)backImg
{
    MJWeakSelf
    if (!_backImg) {
        _backImg = [UIImageView new];
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(onLeft:)];
        _backImg.contentMode = UIViewContentModeScaleAspectFit;
        [_backImg addGestureRecognizer:tap];
        _backImg.userInteractionEnabled = YES;
        
        [self addSubview:_backImg];
    
        [_backImg mas_remakeConstraints:^(MASConstraintMaker *make) {
            
            make.bottom.equalTo(weakSelf.mas_bottom).offset(3);
            make.left.equalTo(weakSelf.mas_left).offset(7);
            make.width.offset(25);
            make.height.offset(45);
        }];
    }
    
    return _backImg;
}

- (UIButton *)leftBtn
{
    if (!_leftBtn) {
        
        _leftBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _leftBtn.imageView.contentMode = UIViewContentModeScaleAspectFit;
        _leftBtn.titleLabel.font = [UIFont systemFontOfSize:Nav_Fond];
        // _leftBtn.titleLabel.textAlignment = NSTextAlignmentLeft;是无效的
        _leftBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
        [_leftBtn addTarget:self action:@selector(onLeft:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:_leftBtn];
        
        MJWeakSelf
        [_leftBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            
//            make.bottom.equalTo(weakSelf.mas_bottom).offset(-3);
            make.centerY.equalTo(weakSelf.backImg);
            make.left.equalTo(weakSelf.backImg.mas_right);
            
        }];
    }
    return _leftBtn;
}

- (UIButton *)rightImageBtn
{
    if (!_rightImageBtn) {
        _rightImageBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _rightImageBtn.imageView.contentMode = UIViewContentModeScaleAspectFit;
        _rightImageBtn.titleLabel.font = [UIFont systemFontOfSize:Nav_Fond];
        _rightImageBtn.titleLabel.textAlignment = NSTextAlignmentLeft;
        [_rightImageBtn addTarget:self action:@selector(onRight:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:_rightImageBtn];
        
        MJWeakSelf
        [_rightImageBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            
            make.centerY.equalTo(weakSelf.backImg);
            make.right.equalTo(weakSelf).offset(-10);
        }];
    }
    
    _rightTitleBtn.hidden = 1;
    _rightImageBtn.hidden = 0;
    return _rightImageBtn;
}

- (UIButton *)rightTitleBtn
{
    if (!_rightTitleBtn)
    {
        _rightTitleBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        
        [_rightTitleBtn addTarget:self action:@selector(onRight:) forControlEvents:UIControlEventTouchUpInside];
        _rightTitleBtn.titleLabel.font = [UIFont systemFontOfSize:Nav_Fond];
        [_rightTitleBtn setTitleColor:[UIColor lightGrayColor] forState:UIControlStateHighlighted];
        _rightTitleBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
        
        [self addSubview:_rightTitleBtn];
        
        MJWeakSelf
        [_rightTitleBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            
            make.centerY.equalTo(weakSelf.backImg);
            make.right.equalTo(weakSelf).offset(-7);
        }];
    }
    _rightTitleBtn.hidden = 0;
    _rightImageBtn.hidden = 1;
    
    return _rightTitleBtn;
}

- (UILabel *)titleLB
{
    
    if(!_titleLB){
        _titleLB = [UILabel new];
        _titleLB.textAlignment = NSTextAlignmentCenter;
        _titleLB.font = [UIFont systemFontOfSize:18];
        _titleLB.adjustsFontSizeToFitWidth = YES;
        _titleLB.textColor = [UIColor whiteColor];
        [self addSubview:_titleLB];

        MJWeakSelf
        [_titleLB mas_makeConstraints:^(MASConstraintMaker *make) {
            
            make.centerY.equalTo(weakSelf.backImg);
            make.centerX.equalTo(weakSelf);
            
        }];
    }
    return _titleLB;
}

- (UIView *)line
{
    if (!_line) {
        _line = [UIView new];
        _line.backgroundColor = HexColor(0xced0d2);
        [self addSubview:_line];
        
        [_line mas_makeConstraints:^(MASConstraintMaker *make) {
            
            make.height.offset(1);
            make.left.bottom.right.equalTo(self);
        }];
    }
    return _line;
}

- (void)setNavTintColor:(UIColor *)navTintColor
{
    _navTintColor = navTintColor;
    _backImg.tintColor = _navTintColor;
    [_titleLB setTextColor:_navTintColor];
    [_leftBtn setTitleColor:_navTintColor forState:UIControlStateNormal];
    [_rightTitleBtn setTitleColor:_navTintColor forState:UIControlStateNormal];
    [_rightImageBtn setTintColor:_navTintColor];
}

- (void)setNavColor:(UIColor *)navColor
{
    _navColor = navColor;
    self.backgroundColor = _navColor;
    
    if ([navColor isEqual:[UIColor clearColor]])
    {
        self.line.hidden = 1;
    }
    else
    {
        self.line.hidden = 0;
    }
}

@end
