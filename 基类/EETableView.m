//
//  EETableView.m
//  QuanQiuBang
//
//  Created by 橙晓侯 on 16/2/17.
//  Copyright © 2016年 小马网络. All rights reserved.
//

#import "EETableView.h"

@implementation EETableView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (void)drawRect:(CGRect)rect
{
    [super drawRect:rect];
}

// 响应滑动返回
- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer
{
    if ([gestureRecognizer isKindOfClass:[UIPanGestureRecognizer class]]) {
        //直接允许了
        return YES;
    }
    return [super gestureRecognizerShouldBegin:gestureRecognizer];
}

#pragma mark 点击消键盘
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [super touchesBegan:touches withEvent:event];
    [TopVC.view endEditing:YES];
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)setERH:(NSInteger)ERH
{
    self.estimatedRowHeight = ERH;
    // 使cell高度自适应，测试发现iOS10 、iOS11 同样需要这个设置
    self.rowHeight = UITableViewAutomaticDimension;
    
    // 为iOS11 做适配
    if (@available(iOS 11.0, *))
    {
        // 在iOS11中VC的 automaticallyAdjustsScrollViewInsets 属性被废弃，以下为替代方案
        self.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
    }
    

}

- (void)reloadDataWithHandle:(void (^)(void))handle
{
    [self reloadData];
    if (handle)
    {
        handle();
    }
}

#pragma mark 隐藏空的cell
- (void)setEmptyFooter:(BOOL)emptyFooter
{
    _emptyFooter = emptyFooter;
    if (_emptyFooter) {
        
        self.tableFooterView = [UIView new];
    }
}

- (UILabel *)msgLabel
{
    if (!_msgLabel)
    {
        _msgLabel = [UILabel new];
        _msgLabel.textColor = [UIColor lightGrayColor];
        [self addSubview:_msgLabel];
        
        [_msgLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            
            make.center.equalTo(self);
        }];
    }
    _msgLabel.hidden = NO;
    return _msgLabel;
}

- (void)setMsg:(NSString *)msg
{
    _msg = msg;
    self.msgLabel.text = _msg;
}

@end
