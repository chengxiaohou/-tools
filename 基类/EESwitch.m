//
//  EESwitch.m
//  MingPian
//
//  Created by 橙晓侯 on 2017/6/5.
//  Copyright © 2017年 橙晓侯. All rights reserved.
//

#import "EESwitch.h"

@implementation EESwitch

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/
- (void)setOnThemeColor:(BOOL)onThemeColor
{
    _onThemeColor = onThemeColor;
    self.onTintColor = ThemeColor;
}
@end
