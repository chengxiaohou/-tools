//
//  BaseVC.m
//
//  Created by 橙晓侯 on 16/1/6.
//  Copyright (c) 2015年 田隆真. All rights reserved.
//

#import "BaseVC.h"
// 设备
#import "sys/sysctl.h"
#import "AppDelegate.h"


@interface BaseVC ()<UITextFieldDelegate>


@end

@implementation BaseVC


#pragma mark 登录才能进入（storyboardID必须和类名一致）
+ (void)gotoVCIfLogin:(BaseVC *)oldVC
{
    if (USER.isLogin)
    {
        [oldVC.navigationController pushViewController:[Worker MainSB:NSStringFromClass([self class])] animated:YES];
    }
    else
    {
//        [MBProgressHUD showMessage:@"请先登录" toView:Window];
        [oldVC presentViewController:[Worker MainSB:SBLoginName] animated:YES completion:nil];
    }
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    _isSecondDidAppear = YES;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    _isSecondAppear = YES;
    
    if (_hideNavBarOnPush) {
        [self.navigationController setNavigationBarHidden:1 animated:1];
    }
    // 解决对bottom layout guide设置约束导致底部跳一下的问题（设置了hidesBottomBarWhenPushed的前提下）
    if (self.hidesBottomBarWhenPushed) {
        self.tabBarController.tabBar.hidden = 1;
    }
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [self.view endEditing:1];// 收起键盘
    
    if (_hideNavBarOnPush) {
        [self.navigationController setNavigationBarHidden:0 animated:1];
    }
}

- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
    [self.session.tasks makeObjectsPerformSelector:@selector(cancel)];// 完全离开页面后取消当前全部请求
    
    // 跳转界面后如果不需要保留通知，则移除
    if (_removeNotificationWhenDisappear) {
        
        [[NSNotificationCenter defaultCenter] removeObserver:self];
    }
    [MBProgressHUD hideAllHUDsForView:self.view animated:YES];// 动画隐藏
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self setAutomaticallyAdjustsScrollViewInsets:NO];
    // 如果在SB有写名字就自动创建nav，否则不执行
    if (_navTitle) {
        
        [self.nav setTitle:_navTitle leftText:_leftText rightTitle:_rightText showBackImg:_back];
    }
}

- (void)viewDidLayoutSubviews
{
    MJWeakSelf
    CGFloat h = self.topLayoutGuide.length;

    [_nav mas_remakeConstraints:^(MASConstraintMaker *make) {
        
        make.top.and.left.and.right.equalTo(weakSelf.view);
        make.height.offset(44+h);
    }];

}

#pragma mark nav的初始化看这里
- (NavView *)nav
{
    if (!_nav) {
        _nav = [[NavView alloc]init];
        
        _nav.delegate = self;
        [self.view addSubview:_nav];
    }
    return _nav;
}

- (void)setNavColor:(UIColor *)navColor
{
    _navColor = navColor;
    _nav.navColor = _navColor;
}

- (void)setNavTintColor:(UIColor *)navTintColor
{
    _navTintColor = navTintColor;
    _nav.navTintColor = _navTintColor;
}

- (UIImageView *)coverView
{
    if (!_coverView) {
        _coverView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"Default"]];
        _coverView.frame = CGRectMake(0, 0, Width, Height - 64);
        _coverView.contentMode = UIViewContentModeScaleAspectFill;
    }
    return _coverView;
}



#pragma mark 普通alert
- (void)showNormalAlertWithTitle:(NSString *)title message:(NSString *)str
{
    [self showNormalAlertWithTitle:title message:str handler:nil];
}

#pragma mark 普通alert + handler
- (void)showNormalAlertWithTitle:(NSString *)title message:(NSString *)str handler:(void (^)())handler
{
    UIAlertController *alertCtl = [UIAlertController alertControllerWithTitle:title message:str preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleCancel handler:handler];
    [alertCtl addAction:cancelAction];
    [self presentViewController:alertCtl animated:YES completion:nil];
}

/**
 *  功能型警告视图
 */
- (void)showFunctionAlertWithTitle:(NSString *)title message:(NSString *)str functionName:(NSString *)functionName Handler:(void (^)())handler
{
    UIAlertController *alertCtl = [UIAlertController alertControllerWithTitle:title message:str preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
    UIAlertAction *handleAction = [UIAlertAction actionWithTitle:functionName style:UIAlertActionStyleDefault handler:handler];
    [alertCtl addAction:cancelAction];
    [alertCtl addAction:handleAction];
    [self presentViewController:alertCtl animated:YES completion:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self.view endEditing:YES];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    return [textField resignFirstResponder];
}

- (void)showCoverViewOn:(UIView *)view
{
    [view addSubview:self.coverView];
    [view bringSubviewToFront:self.coverView];
}

- (void)removeCoverView
{
    [self.coverView removeFromSuperview];
}



// 如需自定义，重写覆盖即可
- (void)left
{
    // 默认返回
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)right
{
    [MBProgressHUD showMessage:@"无操作" toView:Window];
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
    if (animation){[MBProgressHUD showHUDAddedTo:self.view animated:YES];}
    
    // 使用与NET相同的Request配置
    if (!_independentNetConfig) {
        [self.session setValue:NET.session.requestSerializer forKey:@"requestSerializer"];
        [self.session setValue:NET.session.responseSerializer forKey:@"responseSerializer"];
    }
    
    [self.session GET:url parameters:parameters progress:nil
     
              success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                  
                  // 动画隐藏
                  if (animation)
                  {
                      [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
                  }
                  
                  NSDictionary *dic = responseObject;
                  
                  // 分页页号处理
                  if (page != NSNotFound) {
                      
                      TheTab *theTab = nil;
                      // 如果传入TabIndex，则手动选择tabIndex
                      if (tabIndex != NSNotFound)
                      {
                          theTab = _tabDatas[tabIndex];
                      }
                      // 未传入TabIndex，则智能选择tabIndex
                      else
                      {
                          theTab = _tabDatas[_tabIndex];
                      }
                      
                      // 如果是请求第一页，则页码置为1，清空原有数据
                      if (page == FirstPage)
                      {
                          theTab.pageNo = FirstPage;
                          [theTab.datas removeAllObjects];
                          if ([tableView isKindOfClass:[UITableView class]]) [(UITableView *)tableView reloadData];
                      }
                      // 非第一页，则记录页码加1
                      else
                      {
                          theTab.pageNo += 1;
                      }
                  }
                  
                  if ([dic[ResponseCode] isEqual:SuccessCode]) {
                      
                      if (showSuccess) {[MBProgressHUD showSuccess:dic[Message] toView:Window];}
                      
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
                  if (animation){[MBProgressHUD hideAllHUDsForView:self.view animated:YES];}
                  
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
    if (animation){[MBProgressHUD showHUDAddedTo:self.view animated:YES];}
    // 使用与NET相同的Request配置
    if (!_independentNetConfig)
    {
        [self.session setValue:NET.session.requestSerializer forKey:@"requestSerializer"];
        [self.session setValue:NET.session.responseSerializer forKey:@"responseSerializer"];
    }
    
    [self.session POST:url parameters:parameters progress:nil
     
               success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                   
                   // 动画隐藏
                   if (animation)
                   {
                       [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
                   }
                   
                   NSDictionary *dic = responseObject;
                   
                   // 分页页号处理
                   if (page != NSNotFound) {
                       
                       TheTab *theTab = nil;
                       // 如果传入TabIndex，则手动选择tabIndex
                       if (tabIndex != NSNotFound)
                       {
                           theTab = _tabDatas[tabIndex];
                       }
                       // 未传入TabIndex，则智能选择tabIndex
                       else
                       {
                           theTab = _tabDatas[_tabIndex];
                       }
                       
                       // 如果是请求第一页，则页码置为1，清空原有数据
                       if (page == FirstPage)
                       {
                           theTab.pageNo = FirstPage;
                           [theTab.datas removeAllObjects];
                           if ([tableView isKindOfClass:[UITableView class]]) [(UITableView *)tableView reloadData];
                       }
                       // 非第一页，则记录页码加1
                       else
                       {
                           theTab.pageNo += 1;
                       }
                   }
                   
                   if ([dic[ResponseCode] isEqual:SuccessCode]) {
                       
                       if (showSuccess) {[MBProgressHUD showSuccess:dic[Message] toView:Window];}
                       
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
                   if (animation){[MBProgressHUD hideAllHUDsForView:self.view animated:YES];}
                   
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

/** MJ请求 无动画 无成功提示 */
- (void)getMJ_URL:(NSString *)url parameters:(NSDictionary *)parameters success:(void (^)(NSDictionary *dic))success elseAction:(void (^)(NSDictionary *dic))elseAction failure:(void (^)(NSError * error)) failure tableView:(UIScrollView *)tableView
{
    [self getURL:url parameters:parameters success:success elseAction:elseAction failure:failure animation:NO showSuccess:NO isMJRefresh:YES withTabIndex:NSNotFound useTabPage:NSNotFound withTableView:tableView];
}

- (void)postMJ_URL:(NSString *)url parameters:(NSDictionary *)parameters success:(void (^)(NSDictionary *dic))success elseAction:(void (^)(NSDictionary *dic))elseAction failure:(void (^)(NSError * error)) failure tableView:(UIScrollView *)tableView
{
    [self postURL:url parameters:parameters success:success elseAction:elseAction failure:failure animation:NO showSuccess:NO isMJRefresh:YES withTabIndex:NSNotFound useTabPage:NSNotFound withTableView:tableView];
}

/** 分栏TabMJ请求 无动画 无成功提示 */
- (void)getTabMJ_URL:(NSString *)url parameters:(NSDictionary *)parameters success:(void (^)(NSDictionary *))success elseAction:(void (^)(NSDictionary *))elseAction failure:(void (^)(NSError *))failure useTabPage:(NSInteger)page tableView:(UIScrollView *)tableView
{
    [self getURL:url parameters:parameters success:success elseAction:elseAction failure:failure animation:NO showSuccess:NO isMJRefresh:YES withTabIndex:NSNotFound useTabPage:page withTableView:tableView];
}

- (void)postTabMJ_URL:(NSString *)url parameters:(NSDictionary *)parameters success:(void (^)(NSDictionary *))success elseAction:(void (^)(NSDictionary *))elseAction failure:(void (^)(NSError *))failure useTabPage:(NSInteger)page tableView:(UIScrollView *)tableView
{
    [self postURL:url parameters:parameters success:success elseAction:elseAction failure:failure animation:NO showSuccess:NO isMJRefresh:YES withTabIndex:NSNotFound useTabPage:page withTableView:tableView];
}

/** 分栏TabMJ1请求 指定tabIndex 无动画 无成功提示 */
- (void)getTabMJ1_URL:(NSString *)url parameters:(NSDictionary *)parameters success:(void (^)(NSDictionary *))success elseAction:(void (^)(NSDictionary *))elseAction failure:(void (^)(NSError *))failure withTabIndex:(NSInteger)tabIndex useTabPage:(NSInteger)page tableView:(UIScrollView *)tableView
{
    [self getURL:url parameters:parameters success:success elseAction:elseAction failure:failure animation:NO showSuccess:NO isMJRefresh:YES withTabIndex:tabIndex useTabPage:page withTableView:tableView];
}

- (void)postTabMJ1_URL:(NSString *)url parameters:(NSDictionary *)parameters success:(void (^)(NSDictionary *))success elseAction:(void (^)(NSDictionary *))elseAction failure:(void (^)(NSError *))failure withTabIndex:(NSInteger)tabIndex useTabPage:(NSInteger)page tableView:(UIScrollView *)tableView
{
    [self postURL:url parameters:parameters success:success elseAction:elseAction failure:failure animation:NO showSuccess:NO isMJRefresh:YES withTabIndex:tabIndex useTabPage:page withTableView:tableView];
}
//========================== 衍生请求 ==========================
#pragma mark 刷新用户信息
- (void)requestUserInfo:(void (^)(void))handle failure:(void (^)(void))failure
{
    if (USER.isLogin) {
        
        [self get1_URL:BaseURL@"member/users"
            parameters:@{
                         @"userId":USER.ID
                         }
               success:^(NSDictionary *dic) {
                   
                   [USER mj_setKeyValues:dic[@"data"]];
                   NSLog(@"用户数据刷新成功");
                   if (handle) {handle();}
                   
               } elseAction:^(NSDictionary *dic) {
                   
                   if (failure){failure();}
                   [[NSNotificationCenter defaultCenter] postNotificationName:NOTI_RequestWarning object:dic];
                   
               } failure:^(NSError *error) {
                   
                   if (failure){failure();}
                   [[NSNotificationCenter defaultCenter] postNotificationName:NOTI_RequestError object:error];
                   
               }];
    }
}

#pragma mark 弹出输入框
- (void)showTFAlertTitle:(NSString *)title message:(NSString *)message placeHolder:(NSString *)placeHolder handle:(void (^)(NSString *text))handle
{
    [self showTFAlertTitle:title message:message placeHolder:placeHolder textFieldText:nil handle:handle];
}

- (void)showTFAlertTitle:(NSString *)title message:(NSString *)message placeHolder:(NSString *)placeHolder textFieldText:(NSString *)text handle:(void (^)(NSString *text))handle
{
    // 带TF的
    __block UITextField *inputTF;
    
    UIAlertController *ac = [UIAlertController alertControllerWithTitle:title message:message preferredStyle:UIAlertControllerStyleAlert];
    
    [ac addTextFieldWithConfigurationHandler:^(UITextField * textField) {
        
        inputTF = textField;
        textField.placeholder = placeHolder;
        if (text)
        {
            textField.text = text;
        }
    }];
    [ac addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil]];
    [ac addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        
        if (handle) {handle(inputTF.text);}
        
    }]];
    
    [self presentViewController:ac animated:YES completion:nil];
}

#pragma mark 智能VC跳转
- (void)showVC:(UIViewController *)vc
{
    // 如果是导航C 则直接push
    if ([self isKindOfClass:[UINavigationController class]])
    {
        UINavigationController *nav = (UINavigationController *)self;
        [nav pushViewController:vc animated:YES];
    }
    // 是带导航C的VC 则智能push
    else if (self.navigationController)
    {
        [self.navigationController pushViewController:vc animated:YES];
    }
    // 如果是不带导航C的VC 则present
    else if (!self.navigationController)
    {
        [self presentViewController:vc animated:YES completion:nil];
    }
}

- (void)dealloc
{
    NSLog(@"%@释放了===================", self);
    [[NSNotificationCenter defaultCenter] removeObserver:self];
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

- (TheTab *)tab
{
    return self.tabDatas[self.tabIndex];// 当前选中的tab
}

#pragma mark 防止键盘遮挡策略
- (void)handleKeyboardEvent:(NSNotification *)notification
{
    static BOOL willShowing;
    static BOOL isShowing;
    
    willShowing = [notification.name isEqualToString:UIKeyboardWillShowNotification] ? 1 : 0;
    
    NSDictionary *info = [notification userInfo];
    CGFloat duration = [notification.userInfo[UIKeyboardAnimationDurationUserInfoKey] doubleValue];
    CGRect keyboardRect = [[info objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue];
    
    // 键盘弹出或高度变化
    if (willShowing)
    {
        // 解决高度变化时可能露出Window的部分。。。懒得描述了
        dispatch_async(dispatch_get_main_queue(), ^{
            
            if (!isShowing)
            {
                [UIView animateWithDuration:duration animations:^{
                    self.view.superview.height = Height - keyboardRect.size.height;
                    [self.view.superview layoutIfNeeded];
                }];
            }
            else
            {
                [UIView animateWithDuration:duration animations:^{
                    self.view.superview.height = Height - keyboardRect.size.height;
                    [self.view.superview layoutIfNeeded];
                }];
            }
            isShowing = 1;
        });

        if (_keyboardWillShow) _keyboardWillShow(info);
    }
    // 键盘收起
    else
    {
        dispatch_async(dispatch_get_main_queue(), ^{
            
            [UIView animateWithDuration:duration animations:^{
                
                self.view.superview.height = Height;
                [self.view.superview layoutIfNeeded];
            }];
            isShowing = 0;
        });
        
        if (_keyBoardWillHide) _keyBoardWillHide(info);
    }
}

- (void)setAutoKBEvent:(BOOL)autoKBEvent
{
    _autoKBEvent = autoKBEvent;
    // 自动处理键盘事件
    if (_autoKBEvent && IS_IPHONE)
    {
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(handleKeyboardEvent:) name:UIKeyboardWillShowNotification object:nil];
//        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(handleKeyboardEvent:) name:UIKeyboardWillChangeFrameNotification object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(handleKeyboardEvent:) name:UIKeyboardWillHideNotification object:nil];
    }
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    if (_autoHideKB) {
        [self.view endEditing:1];
    }
}

- (UIStatusBarStyle)preferredStatusBarStyle
{
    return _lightContentBarStyle;
}

@end
