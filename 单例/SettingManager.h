//
//  SettingManager.h
//  BAM
//
//  Created by 橙晓侯 on 2017/12/15.
//  Copyright © 2017年 橙晓侯. All rights reserved.
//

#import <Foundation/Foundation.h>

#define NOTI_FontIncrementChenged @"全局字体增量变化"
#define FontIncrement [SettingManager manager].fontIncrement

@interface SettingManager : NSObject

/** 全局字体增量  */
@property (assign, nonatomic) CGFloat fontIncrement;

+ (SettingManager *)manager;
@end
