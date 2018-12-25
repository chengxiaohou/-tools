//
//  EETableView.h
//  QuanQiuBang
//
//  Created by 橙晓侯 on 16/2/17.
//  Copyright © 2016年 小马网络. All rights reserved.
//

#import <UIKit/UIKit.h>
//IB_DESIGNABLE
@interface EETableView : UITableView<UIScrollViewDelegate>


/** 方便plain类型的TV隐藏空的cell */
@property (assign, nonatomic) IBInspectable BOOL emptyFooter;
@property (assign, nonatomic) IBInspectable NSInteger adjust;// 微调
@property (assign, nonatomic) IBInspectable NSInteger ERH;// estimatedRowHeight

/** 中央文字LB */
@property (strong, nonatomic) UILabel *msgLabel;

/** 中央文字 */
@property (strong, nonatomic) IBInspectable NSString *msg;

- (void)reloadDataWithHandle:(void (^)(void))handle;
@end
