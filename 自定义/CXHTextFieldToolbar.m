//
//  CXHTextFieldToolbar.m
//  TianZiCai
//
//  Created by 橙晓侯 on 2017/3/13.
//  Copyright © 2017年 橙晓侯. All rights reserved.
//

#import "CXHTextFieldToolbar.h"



@implementation CXHTextFieldToolbar

- (id)initWithStyle:(CXHTextFieldToolbarStyle)style AndTheTF:(UIView *)theTF
{
    switch (style)
    {
        case CXHTextFieldToolbarStyleSingleDone:
        {
            return [self initWithFrame:CGRectMake(0, 0, Width, 44) rightText:@"完成" theTF:theTF];
        }
            break;
        case CXHTextFieldToolbarStyleSingleNext:
        {
            return [self initWithFrame:CGRectMake(0, 0, Width, 44) rightText:@"下一个" theTF:theTF];
        }
            break;
        case CXHTextFieldToolbarStyleSingleReturn:
        {
            return [self initWithFrame:CGRectMake(0, 0, Width, 44) rightText:@"换行" theTF:theTF];
        }
            break;
        default:
            return nil;
            break;
    }
}

- (id)initWithFrame:(CGRect)frame rightText:(NSString *)rightText theTF:(UIView *)theTF
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        _theTF = theTF;
        UIToolbar *toolbar = [[UIToolbar alloc] initWithFrame:frame];
        [toolbar setBarStyle:UIBarStyleDefault];
        toolbar.backgroundColor = [UIColor whiteColor];
//        _previousButton =[[UIBarButtonItem alloc] initWithTitle:@"上一个" style:UIBarButtonItemStylePlain target:self action:@selector(previous:)];
//        _nextButton =[[UIBarButtonItem alloc] initWithTitle:@"下一个" style:UIBarButtonItemStylePlain target:self action:@selector(next:)];
        UIBarButtonItem *flexibleSpace = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
        _doneButton = [[UIBarButtonItem alloc] initWithTitle:rightText style:UIBarButtonItemStylePlain target:self action:@selector(done:)];
        
        
        NSArray *itemsArray = [NSArray arrayWithObjects:flexibleSpace, _doneButton, nil];
        [toolbar setItems:itemsArray];
        
        [self addSubview:toolbar];
    }
    
    return self;
}

- (void)previous:(id)sender {
    if (_delegate) {
        [_delegate inputPreviousPressed];
    }
}

- (void)next:(id)sender {
    if (_delegate) {
        [_delegate inputNextPressed];
    }
}

- (void)done:(id)sender {
    if (_delegate) {
        [_delegate textFieldShouldReturn:_theTF];
    }
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
