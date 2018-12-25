//
//  EETextView.m
//  xmaMall
//
//  Created by 橙晓侯 on 16/6/29.
//  Copyright © 2016年 橙晓侯. All rights reserved.
//

#import "EETextView.h"

@implementation EETextView

- (void)drawRect:(CGRect)rect
{
    [super drawRect:rect];
    // 边框
    if (_borderWidth > 0) {
    
        self.layer.borderWidth = _borderWidth;
        self.layer.borderColor = _borderColor.CGColor;
        
    }
    
    // 校准子控件的frame以及约束数据，写在这里能确保拿到layoutifneed后的准确数据
    [self layoutPlaceholderLB];// 要提前调用一次
    [self performSelector:@selector(layoutPlaceholderLB) withObject:nil afterDelay:0.1];
    
    
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

#pragma mark 固化+自动增高
- (void)setAutoHeight:(BOOL)autoHeight
{
    _autoHeight = autoHeight;
    
    if (_autoHeight)
    {
        self.scrollEnabled = 0;
        
        NSString *str = self.lb.text;// 此处的self.lb非常重要，详见lb的懒加载。
        if (str == nil) {
            _lb.text = @" ";
        }
        
        [self refreshAutoHeight];
    }
    
}

- (void)setPlaceholder:(NSString *)placeholder
{
    self.lb.text = placeholder;
}

#pragma mark 核心控件 懒加载
- (UILabel *)lb
{
    // 靠这个LB支撑起了TV的高度，没有LB的情况下TV的高度是0，导致用不了。
    // 解决方案：setAutoHeight时用self.lb触发懒加载，确保有lb
    if (!_lb)
    {
        _lb = [[UILabel alloc] init];
        _lb.textColor = HexColor(0xB5B5B5);
        _lb.font = self.font;
        _lb.numberOfLines = 0;
        _lb.textAlignment = NSTextAlignmentLeft;
        [self addSubview:_lb];
        [self layoutPlaceholderLB];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textViewChanged:) name:UITextViewTextDidChangeNotification object:self];
    }
    return _lb;
}


- (void)layoutPlaceholderLB
{
    [_lb mas_remakeConstraints:^(MASConstraintMaker *make) {
        
        make.top.equalTo(self.mas_top).offset(_insetTop);
        make.left.equalTo(self.mas_left).offset(_insetLeft + 5);
//        make.right.equalTo(self.mas_right).offset(-(_insetRight - 5));
        make.width.offset(self.width -10);
    }];
    
    [self refreshAutoHeight];
}

#pragma mark 计算并刷新自动高度
- (void)refreshAutoHeight
{
    
    if (_autoHeight)
    {
        float insetHeight = _insetBottom + _insetTop;
//        float insetWidth = _insetLeft + _insetRight;
        float textHeight =  [self sizeThatFits:CGSizeMake(self.frame.size.width , MAXFLOAT)].height ;
        float placeholderHeight = [_lb sizeThatFits:CGSizeMake(_lb.frame.size.width , MAXFLOAT)].height + insetHeight;
        float originHeight = self.heightConstrain.constant;// 设置的约束高度
        float maxHeight = MAX(originHeight, MAX(textHeight, placeholderHeight));
        
        // 三个高度优先级平等，谁最高用谁的高度
        if (originHeight == maxHeight)
        {
            [self mas_remakeConstraints:^(MASConstraintMaker *make) {}];
        }
        else if (placeholderHeight == maxHeight)
        {
            [self mas_remakeConstraints:^(MASConstraintMaker *make) {
                
                make.height.offset(placeholderHeight);
            }];
        }
        else
        {
            [self mas_remakeConstraints:^(MASConstraintMaker *make) {
                
                make.height.offset(textHeight);
            }];
        }
    }
}


- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];   
}

- (void)setInsetTop:(CGFloat)insetTop
{
    _insetTop = insetTop;
    self.textContainerInset = UIEdgeInsetsMake(_insetTop, _insetLeft, _insetBottom, _insetRight);
}

- (void)setInsetLeft:(CGFloat)insetLeft
{
    _insetLeft = insetLeft;
    self.textContainerInset = UIEdgeInsetsMake(_insetTop, _insetLeft, _insetBottom, _insetRight);
}

- (void)setInsetRight:(CGFloat)insetRight
{
    _insetRight = insetRight;
    self.textContainerInset = UIEdgeInsetsMake(_insetTop, _insetLeft, _insetBottom, _insetRight);
}

- (void)setInsetBottom:(CGFloat)insetBottom
{
    _insetBottom = insetBottom;
    self.textContainerInset = UIEdgeInsetsMake(_insetTop, _insetLeft, _insetBottom, _insetRight);
}

#pragma mark 文字变化回调（备用）
- (void)textViewChanged:(NSNotification *)info
{
    _lb.hidden = self.hasText;
}

#pragma mark 文字变化回调（主力）
- (void)setText:(NSString *)text
{
    [super setText:text];
    
    _lb.hidden = self.hasText;
    [self refreshAutoHeight];
    
    // 触发回调
    if (_textChangeBlock) {
        self.textChangeBlock(text);
    }
    
}

- (NSLayoutConstraint *)heightConstrain
{
    if (!_heightConstrain) {
    
        for (NSLayoutConstraint *c in self.constraints) {
            if (c.firstAttribute == NSLayoutAttributeHeight) {
                _heightConstrain = c;
                break;
            }
        }
    }
    return _heightConstrain;
}
@end
