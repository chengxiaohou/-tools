//
//  CXHStepperTF.h
//  自定义stepper
//
//  Created by 橙晓侯 on 16/6/25.
//  Copyright © 2016年 CC. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CXHStepperTF : UITextField

typedef void(^VolumeChangeBlock)(NSInteger volume);
@property (nonatomic, copy) VolumeChangeBlock volumeChangeBlock;
@property(nonatomic,strong)UIButton * leftBtn;
@property(nonatomic,strong)UIButton * rightBtn;
@property (nonatomic, assign) NSInteger minNum;
@property (nonatomic, assign) NSInteger maxNum;

@property (nonatomic, assign) IBInspectable BOOL enableStepper;

@end
