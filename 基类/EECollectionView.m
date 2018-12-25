//
//  EECollectionView.m
//  xmaMall
//
//  Created by 橙晓侯 on 16/6/24.
//  Copyright © 2016年 橙晓侯. All rights reserved.
//

#import "EECollectionView.h"

@implementation EECollectionView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/


#pragma mark 点击消键盘
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [super touchesBegan:touches withEvent:event];

    [TopVC.view endEditing:YES];
}

@end
