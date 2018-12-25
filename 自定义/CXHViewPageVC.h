//
//  CXHViewPagerVC.h
//  CXHViewPagerVC
//
//  Created by okwei on 15/10/9.
//  Copyright © 2015年 okwei. All rights reserved.
//

#import <UIKit/UIKit.h>
@class CXHViewPageVC;
#pragma mark View Pager Delegate
@protocol  CXHViewPageVCDelegate <NSObject>
@optional
/**
 控制器结束滑动时调用该方法，返回当前显示的视图控制器
 */
-(void)viewPagerViewController:(CXHViewPageVC *)viewPager didFinishScrollWithCurrentViewController:(UIViewController *)viewController;
/**
 控制器将要开始滑动时调用该方法，返回当前将要滑动的视图控制器
 */
-(void)viewPagerViewController:(CXHViewPageVC *)viewPager willScrollerWithCurrentViewController:(UIViewController *)ViewController;

@end

#pragma mark View Pager DataSource
@protocol CXHViewPageVCDataSource <NSObject>

@required
/**
 设置返回需要滑动的控制器数量
 */
-(NSInteger)numberOfViewControllersInViewPager:(CXHViewPageVC *)viewPager;
/**
 用来设置当前索引下返回的控制器
 */
-(UIViewController *)viewPager:(CXHViewPageVC *)viewPager indexOfViewControllers:(NSInteger)index;
/**
 给每一个控制器设置一个标题
 */
-(NSString *)viewPager:(CXHViewPageVC *)viewPager titleWithIndexOfViewControllers:(NSInteger)index;

@optional
/**
 设置控制器标题按钮的样式，如果不设置将使用默认的样式，选择为红色，不选中为黑色带有选中下划线
 */
-(UIButton *)viewPager:(CXHViewPageVC *)viewPager titleButtonStyle:(NSInteger)index;
/**
 设置控制器上面标题的高度
 */
-(CGFloat)heightForTitleOfViewPager:(CXHViewPageVC *)viewPager;
/**
 如果有需要还要在控制器标题顶上添加视图。用来设置控制器标题上面的头部视图
 */
-(UIView *)headerViewForInViewPager:(CXHViewPageVC *)viewPager;
/**
 设置头部视图的高度
 */
-(CGFloat)heightForHeaderOfViewPager:(CXHViewPageVC *)viewPager;
@end

@interface CXHViewPageVC : BaseVC
@property (nonatomic,weak) id<CXHViewPageVCDataSource>dataSource;
@property (nonatomic,weak) id<CXHViewPageVCDelegate>delegate;
/** 从其他VC传入的view 用来添加pageViewController.view */
@property (strong, nonatomic) UIView *backgroundView;
/** 是否是PageVC的subVC */
@property (assign, nonatomic) BOOL isSubPageVC;
/** 总的PageVC 【weak】 */
@property (weak, nonatomic) CXHViewPageVC *superPageVC;
@property (nonatomic,strong) UIPageViewController *pageViewController;
@property (strong, nonatomic)  HMSegmentedControl *segment;
/** SubPageVC数组 */
@property (strong, nonatomic) NSArray *subPageViewControlls;


/** SubVC的creat方法 */
- (CXHViewPageVC *)creatWithTab:(TheTab *)tab storyboardID:(NSString *)SBID;
/** 本体 配置PageView【子类调用】 */
- (void)configPageViewOnBackgroundView:(UIView *)backgroundView;

/** 配置Segment */
- (void)configSegment;
/** Segment index切换 */
//- (void)segmentedControlChangedValue:(HMSegmentedControl *)segmentedControl;
/** 切换【API】 */
- (void)changeSegmentAndTabIndex:(NSInteger)index;
@end


#pragma mark View Controller Title Button

@interface CXHViewPagerTitleButton : UIButton

@end
