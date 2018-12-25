/*
 2016-07-11 11:20:10.304 网络请求这一块调整
 1、重新封装所有请求，AFHTTPSessionManager现做为全局变量
 2、加入退出页面取消请求
 3、修改动画所在视图为self.view
 
 2017-02-27 14:29:00.305 分栏分页请求
 
 */

//
//  BaseVC.h
//
//  Created by 橙晓侯 on 16/1/6.
//

#import <UIKit/UIKit.h>
#import "NavView.h"

#define TAB self.tab
#define Datas TAB.datas

@class Order;
@class TheTab;
IB_DESIGNABLE
@interface BaseVC : UIViewController<NavViewDelegate>

typedef void (^KeyboardWillShowBlock)(NSDictionary *info);
typedef void (^KeyBoardWillHideBlock)(NSDictionary *info);

@property (nonatomic, copy) KeyboardWillShowBlock keyboardWillShow;
@property (nonatomic, copy) KeyBoardWillHideBlock keyBoardWillHide;

/** 分栏数据 */
@property (strong, nonatomic) NSMutableArray *tabDatas;
/** 分栏的当前Index */
@property (assign, nonatomic) NSInteger tabIndex;
/** 当前的tab，用宏TAB来使用 */
@property (strong, nonatomic) TheTab *tab;

/** 用于隐藏原生导航栏 */
@property (assign, nonatomic) IBInspectable BOOL hideNavBarOnPush;
/** UIStatusBarStyle */
@property (assign, nonatomic) IBInspectable BOOL lightContentBarStyle;


/** 导航栏标题 */
@property (strong, nonatomic) NSString *navTitle;
/** 导航栏颜色 */
@property (strong, nonatomic) UIColor *navColor;
/** 导航栏主题色 */
@property (strong, nonatomic) UIColor *navTintColor;
/** 返回箭头 */
@property (nonatomic,assign)  BOOL back;
@property (strong, nonatomic) NSString *leftText;
@property (strong, nonatomic) NSString *rightText;
/** 自动处理键盘事件防止遮挡 */
@property (nonatomic,assign)  IBInspectable BOOL autoKBEvent;


// 用户信息
//@property (strong, nonatomic) TheUser* user;
/**
 *  空页面
 */
@property (nonatomic, strong) UIImageView *coverView;
@property (nonatomic, strong) NavView *nav;

@property (nonatomic, strong) AFHTTPSessionManager *session;
/** 界面跳转后是否保留通知 */
@property (assign, nonatomic) BOOL removeNotificationWhenDisappear;
/** 是否是第二次viewWillAppear */
@property (assign, nonatomic) BOOL isSecondAppear;
/** 是否是第二次viewDidAppear */
@property (assign, nonatomic) BOOL isSecondDidAppear;
/** 为0时表示：使用与NET相同的Request配置
    为1时表示：使用独立的Request配置
    默认为0 */
@property (assign, nonatomic) BOOL independentNetConfig;
/** 滚动自动隐藏键盘 */
@property (assign, nonatomic) IBInspectable BOOL autoHideKB;

/** 登录才进入（storyboardID必须和类名一致） */
+ (void)gotoVCIfLogin:(BaseVC *)oldVC;

// 功能型警告视图
- (void)showFunctionAlertWithTitle:(NSString *)title message:(NSString *)str functionName:(NSString *)functionName Handler:(void (^)())handler;

/** 普通alert */
- (void)showNormalAlertWithTitle:(NSString *)title message:(NSString *)str;
/** 普通alert + handler */
- (void)showNormalAlertWithTitle:(NSString *)title message:(NSString *)str handler:(void (^)())handler;


// 空页面相关方法
- (void)showCoverViewOn:(UIView *)view;
- (void)removeCoverView;
- (UIImageView *)coverView;

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



/**
 MJ请求 无动画 无成功提示

 @param url 接口网址
 @param parameters 参数
 @param success 200回调
 @param elseAction 非200回调
 @param failure 网络失败回调
 @param tableView 所在tableView
 */
- (void)getMJ_URL:(NSString *)url parameters:(NSDictionary *)parameters success:(void (^)(NSDictionary *dic))success elseAction:(void (^)(NSDictionary *dic))elseAction failure:(void (^)(NSError * error)) failure tableView:(UIScrollView *)tableView;

- (void)postMJ_URL:(NSString *)url parameters:(NSDictionary *)parameters success:(void (^)(NSDictionary *dic))success elseAction:(void (^)(NSDictionary *dic))elseAction failure:(void (^)(NSError * error)) failure tableView:(UIScrollView *)tableView;



/**
 分栏TabMJ请求 无动画 无成功提示

 @param url 接口网址
 @param parameters 参数
 @param success 200回调
 @param elseAction 非200回调
 @param failure 网络失败回调
 @param page 分页的页数
 @param tableView 所在tableView
 */
- (void)getTabMJ_URL:(NSString *)url parameters:(NSDictionary *)parameters success:(void (^)(NSDictionary *dic))success elseAction:(void (^)(NSDictionary *dic))elseAction failure:(void (^)(NSError * error)) failure useTabPage:(NSInteger)page tableView:(UIScrollView *)tableView;
/**
 分栏TabMJ请求 无动画 无成功提示
 */
- (void)postTabMJ_URL:(NSString *)url parameters:(NSDictionary *)parameters success:(void (^)(NSDictionary *dic))success elseAction:(void (^)(NSDictionary *dic))elseAction failure:(void (^)(NSError * error)) failure useTabPage:(NSInteger)page tableView:(UIScrollView *)tableView;

/**
 分栏TabMJ1请求 指定tabIndex 无动画 无成功提示
 
 @param url 接口网址
 @param parameters 参数
 @param success 200回调
 @param elseAction 非200回调
 @param failure 网络失败回调
 @param tabIndex 指定的TabIndex
 @param page 分页的页数
 @param tableView 所在tableView
 */
- (void)getTabMJ1_URL:(NSString *)url parameters:(NSDictionary *)parameters success:(void (^)(NSDictionary *))success elseAction:(void (^)(NSDictionary *))elseAction failure:(void (^)(NSError *))failure withTabIndex:(NSInteger)tabIndex useTabPage:(NSInteger)page tableView:(UIScrollView *)tableView;

/**
 分栏TabMJ1请求 指定tabIndex 无动画 无成功提示
 */
- (void)postTabMJ1_URL:(NSString *)url parameters:(NSDictionary *)parameters success:(void (^)(NSDictionary *))success elseAction:(void (^)(NSDictionary *))elseAction failure:(void (^)(NSError *))failure withTabIndex:(NSInteger)tabIndex useTabPage:(NSInteger)page tableView:(UIScrollView *)tableView;


/** 刷新用户信息 */
- (void)requestUserInfo:(void (^)(void))handle failure:(void (^)(void))failure;

/** 弹出输入框 1.0 */
- (void)showTFAlertTitle:(NSString *)title message:(NSString *)message placeHolder:(NSString *)placeHolder handle:(void (^)(NSString *text))handle;
/** 弹出输入框 1.1 text */
- (void)showTFAlertTitle:(NSString *)title message:(NSString *)message placeHolder:(NSString *)placeHolder textFieldText:(NSString *)text handle:(void (^)(NSString *text))handle;

//#pragma mark 调支付视图
//- (NSString *)showPayAlertWithOrder:(Order *)order;
//
//#pragma mark 调支付宝
//- (NSString *)gotoAliPay:(Order *)order orderID:(NSString *)orderId;
//#pragma mark 调微信支付
//- (NSString *)gotoWXPay:(Order *)order orderID:(NSString *)orderId;
//
//#pragma mark 支付结果处理（子类重写前需调用一遍父类方法）
//- (void)payResultHandle:(NSNotification *)notification;

/** 智能VC跳转 */
- (void)showVC:(UIViewController *)vc;

@end
