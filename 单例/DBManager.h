//
//  DBManager.h
//  9.2 SQLite FMDB
//
//  Created by 橙晓侯 on 15/9/6.
//  Copyright (c) 2015年 FengYi. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DBManager : NSObject

+ (id)sharedManager;
- (NSString *)getMyDateBasePath;
- (void)deleteDataWhereName:(NSString *)name orID:(int)ID;
- (void)setName:(NSString *)newName forName:(NSString *)name orID:(int)ID;
- (id)queryJsonDataSQL:(NSString *)sql;
- (void)createTableSQL:(NSString *)sql;
-(void)insertDataWithData:(NSData *)data SQL:(NSString *)sql;

- (NSArray *)getAllProviceData;
- (NSArray *)getCityDataWithIndex:(NSInteger)index;
- (NSArray *)getAreaDataWithCode:(NSString *)code;
@end
