//
//  CXHTextFieldToolbar.h
//  TianZiCai
//
//  Created by 橙晓侯 on 2017/3/13.
//  Copyright © 2017年 橙晓侯. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM (NSUInteger, CXHTextFieldToolbarStyle) {
    
    CXHTextFieldToolbarStyleDefault,
    CXHTextFieldToolbarStyleSingleDone,
    CXHTextFieldToolbarStyleSingleNext,
    CXHTextFieldToolbarStyleSingleReturn,
};


@protocol CXHTFToolbarDelegate <NSObject>
@optional
- (void)inputPreviousPressed;
- (void)inputNextPressed;
- (void)inputDonePressed;
- (BOOL)textFieldShouldReturn:(UIView *)textField;
@end


@interface CXHTextFieldToolbar : UIView

@property (weak, nonatomic) id <CXHTFToolbarDelegate> delegate;
/** 与该AccessoryView绑定的TF 但不一定是TF */
@property (strong, nonatomic) UIView *theTF;
@property (strong, nonatomic) UIBarButtonItem *previousButton;
@property (strong, nonatomic) UIBarButtonItem *nextButton;
@property (strong, nonatomic) UIBarButtonItem *doneButton;

- (void)previous:(id)sender;
- (void)next:(id)sender;
- (void)done:(id)sender;

/** 推荐初始化方法 */
- (id)initWithStyle:(CXHTextFieldToolbarStyle)style AndTheTF:(UIView *)theTF;

@end
