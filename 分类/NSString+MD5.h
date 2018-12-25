//
//  NSString+MD5.h
//  xmaMall
//
//  Created by 橙晓侯 on 16/7/11.
//  Copyright © 2016年 橙晓侯. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (MD5)

- (NSString *)MD5;
/** 判断字符串是否为整型 */
- (BOOL)isPureInt;

/** 判断字符串是否为浮点型 */
- (BOOL)isPureFloat;

@end
