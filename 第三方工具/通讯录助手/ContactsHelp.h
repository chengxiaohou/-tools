//
//  ContactsHelp.h
//  MingPian
//
//  Created by 橙晓侯 on 2017/5/22.
//  Copyright © 2017年 橙晓侯. All rights reserved.
//

#import "BaseObj.h"
#import <UIKit/UIKit.h>
#import "ContactsModel.h"

typedef void(^ContactBlock)(ContactsModel *contactsModel);

@interface ContactsHelp : BaseObj

+ (NSMutableArray *)getAllPhoneInfo;

- (void)getOnePhoneInfoWithUI:(UIViewController *)target callBack:(ContactBlock)block;

@end
