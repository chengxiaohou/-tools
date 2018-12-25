//
//  NavView.h
//  QuanQiuBang
//
//  Created by 橙晓侯 on 16/1/6.
//  Copyright © 2016年 小马网络. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol NavViewDelegate <NSObject>

@optional
- (void)left;
- (void)right;
@end


@interface NavView : UIView

@property (nonatomic, strong) UIButton * leftBtn;
@property (nonatomic, strong) UILabel * titleLB;
@property (nonatomic, strong) UIButton * rightImageBtn;
@property (nonatomic, strong) UIButton * rightTitleBtn;
@property (nonatomic, strong) UIImageView * backImg;
/** 分割线 */
@property (strong, nonatomic) UIView *line;
/** 文字颜色 */
@property (nonatomic, strong) UIColor *navTintColor;
/** 背景色 */
@property (strong, nonatomic) UIColor *navColor;

@property (nonatomic,weak) id <NavViewDelegate> delegate;

/** 唯一启动方法 */
- (void)setTitle:(NSString *)title leftText:(NSString *)leftText rightTitle:(id)right showBackImg:(BOOL)showBackImg;

@end
