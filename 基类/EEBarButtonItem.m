//
//  EEBarButtonItem.m
//  QuanQiuBang
//
//  Created by 橙晓侯 on 16/1/25.
//  Copyright © 2016年 小马网络. All rights reserved.
//

#import "EEBarButtonItem.h"

@implementation EEBarButtonItem

// 修改文字大小
- (void)setTitleSizeEE:(CGFloat)titleSizeEE {
    
    [self setTitleTextAttributes:@{NSFontAttributeName:[UIFont boldSystemFontOfSize:titleSizeEE]} forState:UIControlStateNormal];
}
@end
