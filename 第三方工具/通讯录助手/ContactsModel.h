//
//  ContactsModel.h
//  MingPian
//
//  Created by 橙晓侯 on 2017/5/22.
//  Copyright © 2017年 橙晓侯. All rights reserved.
//

#import "BaseObj.h"

@interface ContactsModel : BaseObj

@property (nonatomic, copy) NSString *num;
@property (nonatomic, copy) NSString *name;

- (instancetype)initWithName:(NSString *)name num:(NSString *)num;

@end
