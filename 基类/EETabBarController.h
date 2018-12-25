//
//  EETabBarController.h
//  GoldenB
//
//  Created by 小熊 on 16/4/12.
//  Copyright © 2016年 橙晓侯. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface EETabBarController : UITabBarController

@property (nonatomic,assign) NSInteger lastIndex;
/** 使用SB中设置的tintColor */
@property (strong, nonatomic) IBInspectable UIColor *tintColor;
/** 是否使用项目主题色 */
@property (assign, nonatomic) IBInspectable BOOL useThemeTintColor;

@end
