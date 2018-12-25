/** 
 2017-03-09 11:37:06.246928
 添加基本网络请求，从BaseVC拷贝而来
 */
//
//  NetworkManager.h
//  TianZiCai
//
//  Created by 橙晓侯 on 2017/3/9.
//  Copyright © 2017年 橙晓侯. All rights reserved.
//

#import "BaseObj.h"

@interface NetworkManager : BaseObj

@property (nonatomic, strong) AFHTTPSessionManager *session;
@property (nonatomic, strong) AFURLSessionManager *URLManager;

+ (NetworkManager *)sharedManager;


/** 缺省请求 带动画 无成功提示 */
- (void)get1_URL:(NSString *)url parameters:(NSDictionary *)parameters success:(void (^)(NSDictionary *dic))success;
- (void)get1_URL:(NSString *)url parameters:(NSDictionary *)parameters success:(void (^)(NSDictionary *dic))success elseAction:(void (^)(NSDictionary *dic))elseAction failure:(void (^)(NSError * error))failure;

/** 缺省请求 带动画 无成功提示 */
- (void)post1_URL:(NSString *)url parameters:(NSDictionary *)parameters success:(void (^)(NSDictionary *dic))success;
- (void)post1_URL:(NSString *)url parameters:(NSDictionary *)parameters success:(void (^)(NSDictionary *dic))success elseAction:(void (^)(NSDictionary *dic))elseAction failure:(void (^)(NSError * error))failure;

/** 用户请求 带动画 有成功提示 */
- (void)get2_URL:(NSString *)url parameters:(NSDictionary *)parameters success:(void (^)(NSDictionary *dic))success;
- (void)get2_URL:(NSString *)url parameters:(NSDictionary *)parameters success:(void (^)(NSDictionary *dic))success elseAction:(void (^)(NSDictionary *dic))elseAction failure:(void (^)(NSError * error)) failure;

/** 用户请求 带动画 有成功提示 */
- (void)post2_URL:(NSString *)url parameters:(NSDictionary *)parameters success:(void (^)(NSDictionary *dic))success;
- (void)post2_URL:(NSString *)url parameters:(NSDictionary *)parameters success:(void (^)(NSDictionary *dic))success elseAction:(void (^)(NSDictionary *dic))elseAction failure:(void (^)(NSError * error)) failure;

/** 静默请求 无动画 无成功提示 */
- (void)get3_URL:(NSString *)url parameters:(NSDictionary *)parameters success:(void (^)(NSDictionary *dic))success;
- (void)get3_URL:(NSString *)url parameters:(NSDictionary *)parameters success:(void (^)(NSDictionary *dic))success elseAction:(void (^)(NSDictionary *dic))elseAction failure:(void (^)(NSError * error)) failure;

/** 静默请求 带动画 无成功提示 */
- (void)post3_URL:(NSString *)url parameters:(NSDictionary *)parameters success:(void (^)(NSDictionary *dic))success;
- (void)post3_URL:(NSString *)url parameters:(NSDictionary *)parameters success:(void (^)(NSDictionary *dic))success elseAction:(void (^)(NSDictionary *dic))elseAction failure:(void (^)(NSError * error)) failure;



@end
