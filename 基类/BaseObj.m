//
//  BaseObjct.m
//  QuanQiuBang
//
//  Created by 橙晓侯 on 16/3/4.
//  Copyright © 2016年 小马网络. All rights reserved.
//

#import "BaseObj.h"

@implementation BaseObj

MJExtensionLogAllProperties

+ (NSDictionary *)mj_replacedKeyFromPropertyName
{
    return @{
             @"ID" : @"id"
             };
}

// 用于对某个属性做额外处理
- (id)mj_newValueFromOldValue:(id)oldValue property:(MJProperty *)property
{
    // 替换 NSNull => nil
    if ([oldValue isKindOfClass:[NSNull class]]) {
        return nil;
    }
    
    if ([property.name isEqualToString:@"picPath"] ||
        [property.name isEqualToString:@"goodThumb"] ||
        [property.name isEqualToString:@"picurl"] ||
        [property.name isEqualToString:@"commodityPath"] ||
        [property.name isEqualToString:@"pic"] ||
        [property.name isEqualToString:@"path"] ||
        [property.name isEqualToString:@"<##>"] ||
        [property.name isEqualToString:@"<##>"] ||
        [property.name isEqualToString:@"<##>"])
    {
        if (!oldValue)
        {
            return nil;
        }
        else
        {
            NSString *newValue = [SYSURL stringByAppendingString:oldValue];
            
            return newValue;
        }
    }
    
    return oldValue;
}


#pragma mark 属于BaseObj的对象会被此方法处理，而不再是mj对NSObject的处理
+ (instancetype)mj_objectWithKeyValues:(NSDictionary *)keyValues
{
    NSDictionary *newKeyValues = [self handleReplacedListDic:keyValues];
    return [super mj_objectWithKeyValues:newKeyValues context:nil];
}

+ (instancetype)mj_objectWithKeyValues:(id)keyValues context:(NSManagedObjectContext *)context
{
    NSDictionary *newKeyValues = [self handleReplacedListDic:keyValues];
    return [super mj_objectWithKeyValues:newKeyValues context:context];
}

- (instancetype)mj_setKeyValues:(id)keyValues
{
    NSDictionary *newKeyValues = [[self class] handleReplacedListDic:keyValues];
    return [super mj_setKeyValues:newKeyValues];
}

- (instancetype)mj_setKeyValues:(id)keyValues context:(NSManagedObjectContext *)context
{
    NSDictionary *newKeyValues = [[self class] handleReplacedListDic:keyValues];
    return [super mj_setKeyValues:newKeyValues context:context];
}
#pragma mark 用于将多字段指向同一属性，在子类下覆写
+ (NSDictionary *)replacedListDic
{
    return nil;
}

#pragma mark 处理replacedListDic的名单
+ (NSDictionary *)handleReplacedListDic:(NSDictionary *)keyValues
{
    NSMutableDictionary *newDic = [NSMutableDictionary dictionaryWithDictionary:keyValues];
    NSDictionary *replacedListDic = [self replacedListDic];
    // 遍历分身名单
    for (NSString *subkey in [replacedListDic allKeys]) {
        // 见一个分身替换一个
        if ([[newDic allKeys] containsObject:subkey]) {
            
            id value = newDic[subkey];
            id mainKey = replacedListDic[subkey];
            // 将分身key「增减替换」成本体key
            [newDic setValue:value forKey:mainKey];
            [newDic removeObjectForKey:subkey];
        }
    }
    return newDic;
}

@end
