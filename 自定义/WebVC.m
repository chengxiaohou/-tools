//
//  WebVC.m
//  GoldenB
//
//  Created by 橙晓侯 on 16/5/12.
//  Copyright © 2016年 橙晓侯. All rights reserved.
//

#import "WebVC.h"


@interface WebVC ()<IMYWebViewDelegate>

@property (nonatomic, strong) UIProgressView *progressView;

@end

@implementation WebVC
{
    
}

+ (WebVC *)gotoWebWithUrl:(NSString *)url vc:(UIViewController *)oldVC
{
    WebVC *vc = [[WebVC alloc] init];
    vc.url = url;
    [oldVC.navigationController pushViewController:vc animated:YES];
    return vc;
}

#pragma mark show方法1
+ (WebVC *)showWithUrl:(NSString *)url
{
    WebVC *vc = [[WebVC alloc] init];
    vc.url = url;
    [Worker showVC:vc];
    return vc;
}

#pragma mark show方法2
+ (WebVC *)showWithHTMLString:(NSString *)HTMLString
{
    WebVC *vc = [[WebVC alloc] init];
    vc.HTMLString = HTMLString;
    [Worker showVC:vc];
    return vc;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.hidesBottomBarWhenPushed = YES;
    [self.nav setTitle:@"" leftText:nil rightTitle:nil showBackImg:YES];
    [self loadWebView];
}


#pragma mark - 加载子控件
- (void)loadWebView{
    
    //创建webview
    _webView = [[IMYWebView alloc] initWithFrame:CGRectMake(0, 64, Width, Height-64)];
    _webView.backgroundColor = [UIColor colorWithRed:0.9373 green:0.9373 blue:0.9569 alpha:1.0];
    [self.view addSubview: _webView];
    
    
    if (_url)
    {
        //网页类型
        [_webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:_url]]];
    }
    else if (_HTMLString)
    {    
        // 本地代码类型
        [_webView loadHTMLString:_HTMLString baseURL:nil];
    }
    
    
    _webView.delegate = self;
    
    //添加进度条
    _progressView = [[UIProgressView alloc] initWithFrame:CGRectMake(0, 0, Width, 2)];
    //    _webViewProgress.progressDelegate = self;
    [_progressView setTrackTintColor:[UIColor clearColor]];
    [_progressView setProgressTintColor:[UIColor colorWithRed:0.133 green:0.612 blue:0.875 alpha:1.0]];
    [_webView addSubview:_progressView];
    
}


#pragma mark - 代理<IMYWebViewDelegate>
#pragma mark 标题改变
- (void)webView:(IMYWebView *)webView titleChange:(NSString *)title{
    
    self.nav.titleLB.text = title;
}

#pragma mark 进度条改变
- (void)webView:(IMYWebView *)webView progressChange:(CGFloat)progress{
    
    [self.progressView setProgress:self.webView.estimatedProgress animated:YES];
    
    if (self.webView.estimatedProgress >= 1.0) {
        
        [UIView animateWithDuration:0.3 delay:0.3 options:UIViewAnimationOptionCurveEaseOut animations:^{
            [self.progressView setAlpha:0.0f];
        } completion:^(BOOL finished) {
            [self.progressView setProgress:0.0f animated:NO];
        }];
    }
}

//- (BOOL)webView:(IMYWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType
//{
//    NSLog(@"%@", request);
//    
//    return YES;
//}

@end
