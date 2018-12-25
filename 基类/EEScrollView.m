//  2016-07-09 17:21:32.327 更新了［subTF］弹键盘的滚动，没做更多测试。
//  EEScrollView.m
//  QuanQiuBang
//
//  Created by 橙晓侯 on 16/1/28.
//  Copyright © 2016年 小马网络. All rights reserved.
//

#import "EEScrollView.h"

@implementation EEScrollView
{
    /** 第一响应的TF */
    UITextField *_firstRespondTF;

    /** offset变化前记录的offset */
    CGPoint _oldOffset;

}
- (void)drawRect:(CGRect)rect
{
    [super drawRect:rect];
}

// 响应滑动返回(仅在第一页)
- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer
{
    if ([gestureRecognizer isKindOfClass:[UIPanGestureRecognizer class]]) {

        UIPanGestureRecognizer *pan = (UIPanGestureRecognizer *)gestureRecognizer;

        if ([pan translationInView:self].x > 0.0f && self.contentOffset.x == 0) {

            return YES;
        }
    }
    return [super gestureRecognizerShouldBegin:gestureRecognizer];
}

//重写touchesBegin方法
-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{

    [self endEditing:YES];
}

// 是否自动加长
- (void)setAutoChangeCS:(BOOL)autoChangeCS
{
    if (autoChangeCS) {

        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(TFDidBeginEditing:) name:UITextFieldTextDidBeginEditingNotification object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(TFDidBeginEditing:) name:UITextViewTextDidBeginEditingNotification object:nil];

        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyBoardWillWillHide:) name:UIKeyboardWillHideNotification object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    }
}

#pragma mark <##>
- (void)keyBoardWillWillHide:(NSNotification *)info
{
    if (_isKBShowing)
    {
        NSDictionary *dic = info.userInfo;
        CGRect rect = [dic[@"UIKeyboardBoundsUserInfoKey"] CGRectValue];
        CGSize temp = self.contentSize;
        temp.height -= rect.size.height;
        self.contentSize = temp;

        //        NSLog(@"要隐藏%f", self.contentSize.height);
    }
    _isKBShowing = 0;
}

#pragma mark <##>
- (void)keyboardWillShow:(NSNotification *)info
{
    if (!_isKBShowing) {
        NSDictionary *dic = info.userInfo;
        CGRect rect = [dic[@"UIKeyboardBoundsUserInfoKey"] CGRectValue];
        CGSize temp = self.contentSize;
        temp.height += rect.size.height;
        self.contentSize = temp;

        //        NSLog(@"要显示%f", self.contentSize.height);
    }
    _isKBShowing = 1;
}

- (void)TFDidBeginEditing:(NSNotification *)note
{
    // 获取当前TF
    _firstRespondTF = note.object;
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

#pragma mark 设置自动隐藏键盘
- (void)setAutoHideKB:(BOOL)autoHideKB
{
    _autoHideKB = autoHideKB;
    self.delegate = self;
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    if (_autoHideKB) {
        [self endEditing:1];
    }
}

/** iOS11 替代[self setAutomaticallyAdjustsScrollViewInsets:NO]的作用 */
- (void)setNeverAdjustmentContentInset:(BOOL)neverAdjustmentContentInset
{
    if (@available(iOS 11.0, *)) {
        _neverAdjustmentContentInset = neverAdjustmentContentInset;
        if (_neverAdjustmentContentInset) {
            self.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
        }
    }
}
@end

