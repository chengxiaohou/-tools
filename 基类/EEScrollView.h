//
//  EEScrollView.h
//  QuanQiuBang
//
//  Created by 橙晓侯 on 16/1/28.
//  Copyright © 2016年 小马网络. All rights reserved.
//

#import <UIKit/UIKit.h>
//IB_DESIGNABLE
@interface EEScrollView : UIScrollView<UIScrollViewDelegate>

/** 滚动自动隐藏键盘 */
@property (assign, nonatomic) IBInspectable BOOL autoHideKB;
/** iOS11 替代[self setAutomaticallyAdjustsScrollViewInsets:NO]的作用 */
@property (assign, nonatomic) IBInspectable BOOL neverAdjustmentContentInset;
/** 键盘正在显示 */
@property (assign, nonatomic) BOOL isKBShowing;
















/** 预备删除 */
//@property (nonatomic,assign) CGSize originCS;
/** 预备删除 */
@property (assign, nonatomic) BOOL autoChangeCS;
/** 预备删除 */
@property (assign, nonatomic)  NSInteger adjust;// 微调
@end

