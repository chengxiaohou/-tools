//
//  ContactsModel.m
//  MingPian
//
//  Created by 橙晓侯 on 2017/5/22.
//  Copyright © 2017年 橙晓侯. All rights reserved.
//

#import "ContactsModel.h"

@implementation ContactsModel

- (instancetype)initWithName:(NSString *)name num:(NSString *)num {
    if (self = [super init]) {
        self.name = name;
        self.num = num;
    }
    return self;
}

@end
