//
//  DBManager.m
//  9.2 SQLite FMDB
//
//  Created by 橙晓侯 on 15/9/6.
//  Copyright (c) 2015年 FengYi. All rights reserved.
//
#import <UIKit/UIKit.h>
#import "DBManager.h"
#import "FMDB.h"

@interface DBManager ()
@property (nonatomic,strong)FMDatabaseQueue *queue;
@property(nonatomic,strong)FMDatabase *db;
@end

@implementation DBManager

- (instancetype)init
{
    self = [super init];
    if (self) {
        //只创建一个队列和一个单例
        _queue = [[FMDatabaseQueue alloc] init];
        _db = [[FMDatabase alloc] init];
        // 2.获得数据库
        //通过指定SQLite数据库文件路径来创建FMDatabase对象
        _db = [FMDatabase databaseWithPath:[self getMyDateBasePath]];
        // 3.队列创建的方法
        _queue = [FMDatabaseQueue databaseQueueWithPath:[self getMyDateBasePath]];

        NSLog(@"=====================\n%@\n=====================", [self getMyDateBasePath]);
    }
    return self;
}

+ (id)sharedManager {
    static dispatch_once_t once;
    static id instance;
    dispatch_once(&once, ^{
        instance = [[self alloc] init];
    });
    return instance;
}

//----------- 数据库存放路径 -----------
- (NSString *)getMyDateBasePath
{

/* 沙盒路径
 //1.获得数据库文件的路径
 NSString *docPath = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)[0];
 NSString *databasePath = [docPath stringByAppendingPathComponent:@"dataBase.sqlite"];
 return databasePath;
*/
    
    // bundle路径
    return [[NSBundle mainBundle] pathForResource:@"dataBase" ofType:@"sqlite"];
    
}
//----------- 创表 -----------
- (void)createTableSQL:(NSString *)sql
{
    [_queue inDatabase:^(FMDatabase *db) {
        [db executeUpdate:sql];
    }];
}

//----------- 插入数据 -----------
-(void)insertDataWithData:(NSData *)data SQL:(NSString *)sql
{
    [_queue inDatabase:^(FMDatabase *db) {
        [db executeUpdateWithFormat:sql,data];
    }];
}

//----------- 删除数据 -----------
- (void)deleteDataWhereName:(NSString *)name orID:(int)ID
{
    [_queue inDatabase:^(FMDatabase *db) {
        [db executeUpdateWithFormat:@"delete from t_student where name = %@ or id = %d;", name, ID];
    }];
    
}

//----------- 修改数据 -----------
- (void)setName:(NSString *)newName forName:(NSString *)name orID:(int)ID
{
    [_queue inDatabase:^(FMDatabase *db) {
        [db executeUpdateWithFormat:@"update t_student set name = %@ where name = %@ or id = %d;",newName, name, ID];
    }];
    
    
}

//----------- 查询数据 -----------
- (id)queryJsonDataSQL:(NSString *)sql
{
    __block NSData *data = [[NSData alloc] init];
    [_queue inDatabase:^(FMDatabase *db) {
        // 1.执行查询语句
        FMResultSet *resultSet = [db executeQuery:sql];
        // 2.遍历结果
        while ([resultSet next]) {
            data = [resultSet dataForColumn:@"JsonData"];
        }
    }];
    return data;
}


#pragma mark - 城市Demo
//========================== 城市Demo ==========================

- (NSArray *)execute:(NSString *)query forResult:(NSString *)result
{
    [_db open];
    NSMutableArray *arr = [NSMutableArray new];
    FMResultSet *resultSet =  [_db executeQuery:query];
    
    while ([resultSet next])
    {
        [arr addObject:[resultSet stringForColumn:result]];
    }
    
    [_db close];
    return arr;
}

#pragma mark 省份
- (NSArray *)getAllProviceData
{
    [_db open];
    NSMutableArray *arr = [NSMutableArray new];
    FMResultSet *resultSet =  [_db executeQuery:@"select * from province"];
    
    while ([resultSet next])
    {
        City *c = [City new];
        c.name = [resultSet stringForColumn:@"province_name"];
        c.index = [[resultSet stringForColumn:@"id"] integerValue];
        [arr addObject:c];
    }
    
    [_db close];
    return arr;
}

#pragma mark 城市
- (NSArray *)getCityDataWithIndex:(NSInteger)index
{
//    NSLog(@"省份index：%ld", (long)index+1);
    [_db open];
    NSMutableArray *arr = [NSMutableArray new];
    FMResultSet *resultSet =  [_db executeQuery:[NSString stringWithFormat:@"select * from city where ids = %ld",(long)index+1]];
    
    while ([resultSet next])
    {
        City *c = [City new];
        c.name = [resultSet stringForColumn:@"city_name"];
        c.ids = [resultSet stringForColumn:@"ids"];
        c.code = [resultSet stringForColumn:@"code"];
        [arr addObject:c];
    }
    
    [_db close];
    return arr;
}


#pragma mark 区域
- (NSArray *)getAreaDataWithCode:(NSString *)code
{
//    NSLog(@"城市区域code：%@", code);
    [_db open];
    NSMutableArray *arr = [NSMutableArray new];
    FMResultSet *resultSet =  [_db executeQuery:[NSString stringWithFormat:@"select * from area where code = %@",code]];
    
    while ([resultSet next])
    {
        City *c = [City new];
        c.name = [resultSet stringForColumn:@"name"];
        c.code = [resultSet stringForColumn:@"code"];
        [arr addObject:c];
    }
    
    [_db close];
    
    // 如果没有区域也不要返回空的数组
    if (arr.count == 0)
    {
        City *c = [City new];
        c.name = @"";
        return @[c];
    }
    else
    {
        return arr;
    }
}
@end
