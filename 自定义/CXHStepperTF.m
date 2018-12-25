//
//  CXHStepperTF.m
//  自定义stepper
//
//  Created by 橙晓侯 on 16/6/25.
//  Copyright © 2016年 CC. All rights reserved.
//

#import "CXHStepperTF.h"


@interface CXHStepperTF ()<UITextFieldDelegate, CXHTFToolbarDelegate>

/** 上次生效的数量 */
@property (strong, nonatomic) NSString *beginEditingText;
@end


@implementation CXHStepperTF
/*
 // Only override drawRect: if you perform custom drawing.
 // An empty implementation adversely affects performance during animation.
 - (void)drawRect:(CGRect)rect {
 // Drawing code
 }
 */

#pragma mark 初始化
- (void)setEnableStepper:(BOOL)enableStepper
{
    if (enableStepper)
    {
        // 设置toolbar
        CXHTextFieldToolbar *toolbar = [[CXHTextFieldToolbar alloc] initWithStyle:CXHTextFieldToolbarStyleSingleDone AndTheTF:self];
        toolbar.delegate = self;
        self.inputAccessoryView = toolbar;
        
        _minNum = 1;
        _maxNum = 10000;
        
        self.text = @"1";
        self.textAlignment = NSTextAlignmentCenter;
        self.returnKeyType = UIReturnKeyDone;
        self.keyboardType = UIKeyboardTypeNumberPad;
        self.delegate = self;
        
        _leftBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _rightBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        
        _leftBtn.frame = CGRectMake(0, 0, 30, self.frame.size.height);
        _rightBtn.frame = CGRectMake(0, 0, 30, self.frame.size.height);
        
        [_leftBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [_rightBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        
        [_leftBtn setTitle:@"＋" forState:UIControlStateNormal];
        [_rightBtn setTitle:@"－" forState:UIControlStateNormal];
        
        [_leftBtn addTarget:self action:@selector(addAction:) forControlEvents:UIControlEventTouchUpInside];
        [_rightBtn addTarget:self action:@selector(deleteAction:) forControlEvents:UIControlEventTouchUpInside];
        
        self.leftView = _rightBtn;
        self.rightView = _leftBtn;
        self.leftViewMode = UITextFieldViewModeAlways;
        self.rightViewMode = UITextFieldViewModeAlways;
        
    }
}

// 只能输入数字
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    BOOL shouldReturn = [Worker inputMathsString:string inRange:range ofText:textField.text withDotLength:0];
    
    return shouldReturn;
}

#pragma mark 点击加
-(void)addAction:(UIButton *)sender
{
    
    NSInteger value = self.text.integerValue;
    if (value + 1 <= _maxNum)
    {
        self.text = [NSString stringWithFormat:@"%ld",(long)value+1];
        [self handleVolume];
    }
}

#pragma mark 点击减
-(void)deleteAction:(UIButton *)sender
{
    NSInteger value = self.text.integerValue;
    if (value - 1 >= _minNum)
    {
        self.text = [NSString stringWithFormat:@"%ld",(long)value-1];
        [self handleVolume];
    }
}

- (BOOL)textFieldShouldReturn:(UIView *)textField
{
    [textField resignFirstResponder];
    return 1;
}

/** 开始编辑时记录数量 */
- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    _beginEditingText = textField.text;
    return 1;
}

- (BOOL)textFieldShouldEndEditing:(UITextField *)textField
{
    [self handleVolume];
    return 1;
}

#pragma mark 处理数值
- (void)handleVolume
{
    // 此时如果没有内容 则显示开始编辑时记录的数量
    if (!self.hasText) {
        self.text = _beginEditingText;
    }
    NSInteger value = [self.text integerValue];
    
    // 过高
    if (value > _maxNum)
    {
        self.text = [NSString stringWithFormat:@"%ld",(long)_maxNum];
    }
    // 过低
    if (value < _minNum)
    {
        self.text = [NSString stringWithFormat:@"%ld",(long)_minNum];
    }
    //    // 内容无变动 好像不需要这个
    //    if ([self.text isEqualToString:_beginEditingText])
    //    {
    //        return;// 拦截 ---------------------------------------
    //    }
    self.volumeChangeBlock([self.text integerValue]);
    _beginEditingText = self.text;// 更新上次生效的值
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}



@end

