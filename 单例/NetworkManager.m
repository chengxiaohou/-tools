//
//  NetworkManager.m
//  TianZiCai
//
//  Created by 橙晓侯 on 2017/3/9.
//  Copyright © 2017年 橙晓侯. All rights reserved.
//

#import "NetworkManager.h"

@implementation NetworkManager


+ (NetworkManager *)sharedManager
{
    static NetworkManager *this = nil;
    // 执行一次
    static dispatch_once_t predicate;
    dispatch_once(&predicate, ^
                  {
                      this = [[self alloc] init];
                  });
    return this;
}

#pragma mark - ......::::::: GET :::::::......

/**
 主get请求
 
 @param url 接口网址
 @param parameters 参数
 @param success 200回调
 @param elseAction 非200回调
 @param failure 网络失败回调
 @param animation 是否需要隐藏动画的处理
 @param showSuccess 200时是否显示提示
 @param isMJRefresh 是否有用到MJRefresh
 @param tabIndex 是否需要手动选择刷新
 @param page 是否用到TheTab分栏分页
 @param tableView 所在tableView
 */
- (void)getURL:(NSString *)url parameters:(NSDictionary *)parameters success:(void (^)(NSDictionary *dic))success elseAction:(void (^)(NSDictionary *dic))elseAction failure:(void (^)(NSError * error)) failure animation:(BOOL)animation showSuccess:(BOOL)showSuccess isMJRefresh:(BOOL)isMJRefresh withTabIndex:(NSInteger)tabIndex useTabPage:(NSInteger)page withTableView:(UIScrollView *)tableView
{
    // 动画开始
    if (animation){[MBProgressHUD showHUDAddedTo:Window animated:YES];}
    
    [self.session GET:url parameters:parameters progress:nil
     
              success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                  
                  // 动画隐藏
                  if (animation)
                  {
                      [MBProgressHUD hideAllHUDsForView:Window animated:YES];
                  }
                  
                  NSDictionary *dic = responseObject;
                  
                  if ([dic[ResponseCode] isEqual:SuccessCode]) {
                      
                      if (showSuccess) {[MBProgressHUD showSuccess:dic[Message] toView:Window];}
                      
                      // 分页页号处理
                      if (page != NSNotFound) {
                          
                      }
                      
                      if (isMJRefresh) {[tableView.mj_header endRefreshing]; [tableView.mj_footer endRefreshing];}
                      
                      if (success) {success(dic);}
                      
                  }
                  else {
                      
                      [MBProgressHUD showError:dic[Message] toView:Window];
                      
                      if (isMJRefresh) {[tableView.mj_header endRefreshing]; [tableView.mj_footer endRefreshingWithNoMoreData];}
                      
                      if (elseAction) {elseAction(dic);}
                      
                      [[NSNotificationCenter defaultCenter] postNotificationName:NOTI_RequestWarning object:dic];
                  }
                  
              } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                  
                  // 动画隐藏
                  if (animation){[MBProgressHUD hideAllHUDsForView:Window animated:YES];}
                  
                  if (isMJRefresh) {[tableView.mj_header endRefreshing]; [tableView.mj_footer endRefreshing];}
                  
                  // 非请求取消才显示报错
                  if (error.code != -999) [MBProgressHUD showError:ErrorMessage toView:Window];
                  
                  NSLog(@"报错：%@", [error localizedDescription]);
                  
                  if (failure) {failure(error);}
                  
                  [[NSNotificationCenter defaultCenter] postNotificationName:NOTI_RequestError object:error];
              }];
}

#pragma mark - ......::::::: POST :::::::......
/**
 主post请求
 
 @param url 接口网址
 @param parameters 参数
 @param success 200回调
 @param elseAction 非200回调
 @param failure 网络失败回调
 @param animation 是否需要隐藏动画的处理
 @param showSuccess 200时是否显示提示
 @param isMJRefresh 是否有用到MJRefresh
 @param page 是否要用到TheTab分栏分页，传NSNotFound表示不需要
 @param tableView 所在tableView
 */
- (void)postURL:(NSString *)url parameters:(NSDictionary *)parameters success:(void (^)(NSDictionary *dic))success elseAction:(void (^)(NSDictionary *dic))elseAction failure:(void (^)(NSError * error)) failure animation:(BOOL)animation showSuccess:(BOOL)showSuccess isMJRefresh:(BOOL)isMJRefresh withTabIndex:(NSInteger)tabIndex useTabPage:(NSInteger)page withTableView:(UIScrollView *)tableView
{
    // 动画开始
    if (animation){[MBProgressHUD showHUDAddedTo:Window animated:YES];}
    
    [self.session POST:url parameters:parameters progress:nil
     
               success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                   
                   // 动画隐藏
                   if (animation)
                   {
                       [MBProgressHUD hideAllHUDsForView:Window animated:YES];
                   }
                   
                   NSDictionary *dic = responseObject;
                   
                   
                   if ([dic[ResponseCode] isEqual:SuccessCode]) {
                       
                       if (showSuccess) {[MBProgressHUD showSuccess:dic[Message] toView:Window];}
                       
                       // 分页页号处理
                       if (page != NSNotFound) {
                           
                       }
                       
                       if (isMJRefresh) {[tableView.mj_header endRefreshing]; [tableView.mj_footer endRefreshing];}
                       
                       if (success) {success(dic);}
                       
                   }
                   else {
                       
                       [MBProgressHUD showError:dic[Message] toView:Window];
                       
                       if (isMJRefresh) {[tableView.mj_header endRefreshing]; [tableView.mj_footer endRefreshingWithNoMoreData];}
                       
                       if (elseAction) {elseAction(dic);}
                       
                       [[NSNotificationCenter defaultCenter] postNotificationName:NOTI_RequestWarning object:dic];
                   }
                   
               } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                   
                   // 动画隐藏
                   if (animation){[MBProgressHUD hideAllHUDsForView:Window animated:YES];}
                   
                   if (isMJRefresh) {[tableView.mj_header endRefreshing]; [tableView.mj_footer endRefreshing];}
                   
                   // 非请求取消才显示报错
                   if (error.code != -999) [MBProgressHUD showError:ErrorMessage toView:Window];
                   
                   NSLog(@"报错：%@", [error localizedDescription]);
                   
                   if (failure) {failure(error);}
                   
                   [[NSNotificationCenter defaultCenter] postNotificationName:NOTI_RequestError object:error];
               }];
}


//========================== 一大波请求即将到来。。。 ==========================

/** 缺省请求 带动画 无成功提示 */
- (void)get1_URL:(NSString *)url parameters:(NSDictionary *)parameters success:(void (^)(NSDictionary *dic))success elseAction:(void (^)(NSDictionary *dic))elseAction failure:(void (^)(NSError * error))failure
{
    [self getURL:url parameters:parameters success:success elseAction:elseAction failure:failure animation:YES showSuccess:NO isMJRefresh:NO withTabIndex:NSNotFound useTabPage:NSNotFound withTableView:nil];
}

- (void)post1_URL:(NSString *)url parameters:(NSDictionary *)parameters success:(void (^)(NSDictionary *dic))success elseAction:(void (^)(NSDictionary *dic))elseAction failure:(void (^)(NSError * error))failure
{
    [self postURL:url parameters:parameters success:success elseAction:elseAction failure:failure animation:YES showSuccess:NO isMJRefresh:NO withTabIndex:NSNotFound useTabPage:NSNotFound withTableView:nil];
}

- (void)get1_URL:(NSString *)url parameters:(NSDictionary *)parameters success:(void (^)(NSDictionary *dic))success
{
    [self getURL:url parameters:parameters success:success elseAction:nil failure:nil animation:YES showSuccess:NO isMJRefresh:NO withTabIndex:NSNotFound useTabPage:NSNotFound withTableView:nil];
}

- (void)post1_URL:(NSString *)url parameters:(NSDictionary *)parameters success:(void (^)(NSDictionary *dic))success
{
    [self postURL:url parameters:parameters success:success elseAction:nil failure:nil animation:YES showSuccess:NO isMJRefresh:NO withTabIndex:NSNotFound useTabPage:NSNotFound withTableView:nil];
}

/** 用户请求 带动画 有成功提示 */
- (void)get2_URL:(NSString *)url parameters:(NSDictionary *)parameters success:(void (^)(NSDictionary *dic))success elseAction:(void (^)(NSDictionary *dic))elseAction failure:(void (^)(NSError * error)) failure
{
    [self getURL:url parameters:parameters success:success elseAction:elseAction failure:failure animation:YES showSuccess:YES isMJRefresh:NO withTabIndex:NSNotFound useTabPage:NSNotFound withTableView:nil];
}

- (void)post2_URL:(NSString *)url parameters:(NSDictionary *)parameters success:(void (^)(NSDictionary *dic))success elseAction:(void (^)(NSDictionary *dic))elseAction failure:(void (^)(NSError * error)) failure
{
    [self postURL:url parameters:parameters success:success elseAction:elseAction failure:failure animation:YES showSuccess:YES isMJRefresh:NO withTabIndex:NSNotFound useTabPage:NSNotFound withTableView:nil];
}

- (void)get2_URL:(NSString *)url parameters:(NSDictionary *)parameters success:(void (^)(NSDictionary *dic))success
{
    [self getURL:url parameters:parameters success:success elseAction:nil failure:nil animation:YES showSuccess:YES isMJRefresh:NO withTabIndex:NSNotFound useTabPage:NSNotFound withTableView:nil];
}

- (void)post2_URL:(NSString *)url parameters:(NSDictionary *)parameters success:(void (^)(NSDictionary *dic))success
{
    [self postURL:url parameters:parameters success:success elseAction:nil failure:nil animation:YES showSuccess:YES isMJRefresh:NO withTabIndex:NSNotFound useTabPage:NSNotFound withTableView:nil];
}

/** 静默请求 无动画 无成功提示 */
- (void)get3_URL:(NSString *)url parameters:(NSDictionary *)parameters success:(void (^)(NSDictionary *dic))success elseAction:(void (^)(NSDictionary *dic))elseAction failure:(void (^)(NSError * error)) failure
{
    [self getURL:url parameters:parameters success:success elseAction:elseAction failure:failure animation:NO showSuccess:NO isMJRefresh:NO withTabIndex:NSNotFound useTabPage:NSNotFound withTableView:nil];
}

- (void)post3_URL:(NSString *)url parameters:(NSDictionary *)parameters success:(void (^)(NSDictionary *dic))success elseAction:(void (^)(NSDictionary *dic))elseAction failure:(void (^)(NSError * error)) failure
{
    [self postURL:url parameters:parameters success:success elseAction:elseAction failure:failure animation:NO showSuccess:NO isMJRefresh:NO withTabIndex:NSNotFound useTabPage:NSNotFound withTableView:nil];
}

- (void)get3_URL:(NSString *)url parameters:(NSDictionary *)parameters success:(void (^)(NSDictionary *dic))success
{
    [self getURL:url parameters:parameters success:success elseAction:nil failure:nil animation:NO showSuccess:NO isMJRefresh:NO withTabIndex:NSNotFound useTabPage:NSNotFound withTableView:nil];
}

- (void)post3_URL:(NSString *)url parameters:(NSDictionary *)parameters success:(void (^)(NSDictionary *dic))success
{
    [self postURL:url parameters:parameters success:success elseAction:nil failure:nil animation:NO showSuccess:NO isMJRefresh:NO withTabIndex:NSNotFound useTabPage:NSNotFound withTableView:nil];
}


#pragma mark - ......::::::: 懒加载 :::::::......

- (AFHTTPSessionManager *)session
{
    if (!_session)
    {
        _session = [AFHTTPSessionManager manager];
        _session.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/json", @"text/javascript", @"text/html",nil];
        
        [_session.requestSerializer willChangeValueForKey:@"timeoutInterval"];
        _session.requestSerializer.timeoutInterval = AFN_TimeOut;//设置请求超时时间
        [_session.requestSerializer didChangeValueForKey:@"timeoutInterval"];
        
        AFJSONResponseSerializer *responseSerializer = (AFJSONResponseSerializer *)_session.responseSerializer;
        [responseSerializer setRemovesKeysWithNullValues:YES];
        
    }
    return _session;
}

- (AFURLSessionManager *)URLManager
{
    if (!_URLManager) {
        NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
        _URLManager = [[AFURLSessionManager alloc] initWithSessionConfiguration:configuration];
    }
    return _URLManager;
}
@end
