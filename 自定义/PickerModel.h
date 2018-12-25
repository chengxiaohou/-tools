//
//  PickerModel.h
//  MingPian
//
//  Created by 橙晓侯 on 2017/8/30.
//  Copyright © 2017年 橙晓侯. All rights reserved.
//

#import "BaseObj.h"

@interface PickerModel : BaseObj

@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) NSString *ID;
@property (nonatomic, assign) NSInteger index;
/** 下级数组 */
@property (strong, nonatomic) NSArray *subList;

@end
