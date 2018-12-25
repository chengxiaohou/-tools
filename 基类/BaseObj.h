//
//  BaseObjct.h
//  QuanQiuBang
//
//  Created by 橙晓侯 on 16/3/4.
//  Copyright © 2016年 小马网络. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BaseObj : NSObject
/** 用于将多字段指向同一属性，在子类下覆写 */
+ (NSDictionary *)replacedListDic;

@end
