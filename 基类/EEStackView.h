//
//  EEStackView.h
//  MingPian
//
//  Created by 橙晓侯 on 2017/9/13.
//  Copyright © 2017年 橙晓侯. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface EEStackView : UIStackView

//=========== 边框 ===========
/** 边框view */
@property (strong, nonatomic) EEView *borderView;
@property (assign, nonatomic) IBInspectable CGFloat cornerRadius;
@property (assign, nonatomic) IBInspectable CGFloat borderWidth;    // 线宽
@property (strong, nonatomic) IBInspectable UIColor *borderColor;

@end

