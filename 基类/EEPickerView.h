//
//  EEPickerView.h
//  MingPian
//
//  Created by 橙晓侯 on 2017/6/22.
//  Copyright © 2017年 橙晓侯. All rights reserved.
//

#import <UIKit/UIKit.h>
@class PickerModel;

typedef void(^EEPickerSelectCallback)(NSString *string, NSInteger row, NSInteger component);
typedef void(^EEPickerMultiSelectCallback)(NSArray *selectedMods, NSInteger row, NSInteger component);

@interface EEPickerView : UIPickerView 

/** 暂时没用到，给未来开发自定义对象数据源扩展 */
@property (strong, nonatomic) NSMutableArray *datas;
/** 列 */
@property (assign, nonatomic) NSInteger componentsCount;

/** 单列滚动选择回调 */
@property (copy, nonatomic) EEPickerSelectCallback callback;
/** 多列末级滚动选择回调 */
@property (nonatomic, copy) EEPickerMultiSelectCallback selectCallBack;


/** 字符串数据源 */
@property (strong, nonatomic) NSMutableArray *strArr;
/** 当前选中的数据 */
@property (strong, nonatomic) NSString *currentStr;
/** 单列 */
+ (EEPickerView *)singlePickerViewWithStrArr:(NSArray *)strArr;
/** 多列 */ // 铭片项目搜【1/3 企业地区】 第一个使用案例
+ (EEPickerView *)multiPickerViewWithDatas:(NSArray *)datas componentsCount:(NSInteger)componentsCount;

/** 用字符串组合名字 */
- (NSString *)combineNameWithString:(NSString *)str;
@end
