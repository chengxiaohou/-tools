//  用于多个分页
//  TheTab.h
//  TianZiCai
//
//  Created by 橙晓侯 on 2017/2/27.
//  Copyright © 2017年 橙晓侯. All rights reserved.
//

#import "BaseObj.h"

@interface TheTab : BaseObj

/** 栏目标题，用于界面展示*/
@property (nonatomic, strong) NSString *title;
/** 栏目类型名，可用于cell reuseid */
@property (nonatomic, strong) NSString *typeName;
/** 栏目数据源 */
@property (strong, nonatomic) NSMutableArray *datas;
/** 栏目是第几栏 */
@property (assign, nonatomic) NSInteger index;
/** 分页页码 */
@property (nonatomic, assign) NSInteger pageNo;
/** 分页大小 */
@property (nonatomic, assign) NSInteger pageSize;
/** 当前选中栏 */
@property (nonatomic, assign) BOOL isSelected;
/** 接口的部分url */
@property (strong, nonatomic) NSString *url;
/** 栏目的类型 可作为接口的类型参数 */
@property (retain, nonatomic) id type;
//@property (strong, nonatomic) NSNumber *type;
//@property (nonatomic, assign) NSInteger type;

@end
