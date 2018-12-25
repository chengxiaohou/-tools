//
//  CXHViewPagerVC.m
//  CXHViewPagerVC
//
//  Created by okwei on 15/10/9.
//  Copyright © 2015年 okwei. All rights reserved.
//

#import "CXHViewPageVC.h"

@interface CXHViewPageVC ()<UIPageViewControllerDelegate,UIPageViewControllerDataSource>
{
    NSInteger numberOfViewController;   //VC的总数量
    
    NSArray *arrayOfViewControllerButton;    //存放VC Button的数组
    UIView *headerView;     //头部视图
    CGRect oldRect;   //用来保存title布局的Rect
    CXHViewPagerTitleButton *oldButton;
    NSInteger pendingVCIndex;   //将要显示的View Controller 索引
    
}

@property (nonatomic,strong) UIScrollView *titleBackground;
@end

@implementation CXHViewPageVC

#pragma mark SubVC的creat方法
- (CXHViewPageVC *)creatWithTab:(TheTab *)tab storyboardID:(NSString *)SBID
{
    CXHViewPageVC *vc = [Worker MainSB:SBID];
    vc.superPageVC = self;// 设置总的pageVC，以便上下级沟通

    vc.isSubPageVC = 1;
    vc.tabDatas = (NSMutableArray *)@[tab];// 传递数据源
    
    return vc;
}

- (void)viewDidLoad {
    [super viewDidLoad];

    // 非本体
    if (_isSubPageVC) {
        
    }
    // 是本体
    else
    {
        [self addChildViewController:self.pageViewController];
    }
}

#pragma mark 配置PageView【子类调用】
- (void)configPageViewOnBackgroundView:(UIView *)backgroundView
{
    MJWeakSelf
    self.backgroundView = backgroundView;
    [self configSegment];
    
    UIStackView *stackView = [[UIStackView alloc] initWithArrangedSubviews:@[_segment, self.pageViewController.view]];
    stackView.axis = UILayoutConstraintAxisVertical;
    [_backgroundView addSubview:stackView];
    
    
    [stackView mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.leading.equalTo(weakSelf.backgroundView).offset(0);
        make.trailing.equalTo(weakSelf.backgroundView).offset(0);
        make.top.equalTo(weakSelf.backgroundView).offset(0);
        make.bottom.equalTo(weakSelf.backgroundView).offset(0);
    }];
}

#pragma mark 配置Segment
- (void)configSegment
{
    NSMutableArray *temps = [NSMutableArray new];
    for (TheTab *tab in self.tabDatas) {
        
        [temps addObject:tab.title];
    }
    _segment = [HMSegmentedControl new];
    
    [_segment mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.height.offset(44);
    }];
    
    _segment.sectionTitles = temps;
    
    _segment.autoresizingMask = UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleWidth;
    _segment.segmentEdgeInset = UIEdgeInsetsMake(0, 10, 0, 10);
    _segment.selectionStyle = HMSegmentedControlSelectionStyleTextWidthStripe;
    _segment.selectionIndicatorLocation = HMSegmentedControlSelectionIndicatorLocationDown;
    
    // 类型宽度
    _segment.segmentWidthStyle = HMSegmentedControlSegmentWidthStyleFixed;
    
    // 边框
    _segment.borderType = HMSegmentedControlBorderTypeBottom;
    _segment.borderWidth = 1;
    _segment.borderColor = BGGreyColor;
    
    // 分割线
    _segment.verticalDividerEnabled = YES;
    _segment.verticalDividerColor = BGGreyColor;
    _segment.verticalDividerWidth = 1.0f;
    
    // 选择指示器
    _segment.selectionIndicatorHeight = 4.0f;
    _segment.selectionIndicatorColor = ThemeColor;
    
    // 文字
    _segment.titleTextAttributes = @{
                                     NSForegroundColorAttributeName : [UIColor blackColor],
                                     NSFontAttributeName : [UIFont systemFontOfSize:13.0f]
                                     };
    _segment.selectedTitleTextAttributes = @{
                                             NSForegroundColorAttributeName : ThemeColor,
                                             NSFontAttributeName : [UIFont systemFontOfSize:13.0f]
                                             };
    
    [_segment addTarget:self action:@selector(segmentedControlChangedValue:) forControlEvents:UIControlEventValueChanged];
}

- (void)segmentedControlChangedValue:(HMSegmentedControl *)segmentedControl
{
    [self changeSegmentAndTabIndex:segmentedControl.selectedSegmentIndex];
}

#pragma mark 切换【API】
- (void)changeSegmentAndTabIndex:(NSInteger)index
{
    NSLog(@"CXHViewPagerVC报幕：Selected index %ld", (long)index);
    
    [_segment setSelectedSegmentIndex:index animated:1];
    
    // 方向
    NSInteger direction = self.tabIndex > index;
    self.tabIndex = index;
    [_pageViewController setViewControllers:@[_subPageViewControlls[self.tabIndex]] direction:direction animated:1 completion:nil];
}

-(UIPageViewController *)pageViewController
{
    if (!_pageViewController) {
        _pageViewController = [[UIPageViewController alloc] initWithTransitionStyle:UIPageViewControllerTransitionStyleScroll navigationOrientation:UIPageViewControllerNavigationOrientationHorizontal options:nil];
        _pageViewController.delegate = self;
        _pageViewController.dataSource = self;

    }
    return _pageViewController;
}


-(void)setDataSource:(id<CXHViewPageVCDataSource>)dataSource
{
    _dataSource = dataSource;
    [self p_reload];
    
}
-(void)p_reload
{
    if ([self.dataSource respondsToSelector:@selector(numberOfViewControllersInViewPager:)]) {
        oldRect = CGRectZero;
        if (![self.dataSource numberOfViewControllersInViewPager:self]) {
             @throw [NSException exceptionWithName:@"viewControllerException" reason:@"设置要返回的控制器数量" userInfo:nil];
        }
        numberOfViewController = [self.dataSource numberOfViewControllersInViewPager:self];
        NSMutableArray *mutableArrayOfVC = [NSMutableArray array];
        NSMutableArray *mutableArrayOfBtn = [NSMutableArray array];
        for (int i = 0; i<numberOfViewController; i++) {
            
            if ([self.dataSource respondsToSelector:@selector(viewPager:indexOfViewControllers:)])
            {
                if (![[self.dataSource viewPager:self indexOfViewControllers:i] isKindOfClass:[UIViewController class]])
                {
                    @throw [NSException exceptionWithName:@"viewControllerException" reason:[NSString stringWithFormat:@"第%d个分类下的控制器必须是UIViewController类型或者其子类",i+1] userInfo:nil];
                }
                else
                {
                    [mutableArrayOfVC addObject:[self.dataSource viewPager:self indexOfViewControllers:i]];
                }

            }
            else{
                @throw [NSException exceptionWithName:@"viewControllerException" reason:@"设置要显示的控制器" userInfo:nil];
            }
            if ([self.dataSource respondsToSelector:@selector(viewPager:titleWithIndexOfViewControllers:)]) {
                NSString *buttonTitle = [self.dataSource viewPager:self titleWithIndexOfViewControllers:i];
                if (arrayOfViewControllerButton.count > i) {
                    [[arrayOfViewControllerButton objectAtIndex:i] removeFromSuperview];
                }
                UIButton *button;
                if ([self.dataSource respondsToSelector:@selector(viewPager:titleButtonStyle:)]) {
                    if (![[self.dataSource viewPager:self titleButtonStyle:i] isKindOfClass:[UIButton class]]) {
                         @throw [NSException exceptionWithName:@"titleException" reason:[NSString stringWithFormat:@"第%d的标题类型必须为UIButton或者其子类",i+1] userInfo:nil];
                    }
                    button = [self.dataSource viewPager:self titleButtonStyle:i];
                }
                else
                {
                    button = [[CXHViewPagerTitleButton alloc] init];
                }
                [button addTarget:self action:@selector(p_titleButtonClick:) forControlEvents:UIControlEventTouchUpInside];


                button.frame = CGRectMake(oldRect.origin.x+oldRect.size.width, 0, [self p_fontText:buttonTitle withFontHeight:20], [self.dataSource respondsToSelector:@selector(heightForTitleOfViewPager:)]?[self.dataSource heightForTitleOfViewPager:self]:0);
                oldRect = button.frame;
                [button setTitle:buttonTitle forState:UIControlStateNormal];
                [mutableArrayOfBtn addObject:button];
                [_titleBackground addSubview:button];
                if (i == 0) {
                    oldButton = [mutableArrayOfBtn objectAtIndex:0];
                    oldButton.selected = YES;
                }

            }
            else
            {
                @throw [NSException exceptionWithName:@"titleException" reason:@"每个控制器必须设置一个标题" userInfo:nil];
            }
        }
        if (mutableArrayOfBtn.count && ((UIButton *)mutableArrayOfBtn.lastObject).frame.origin.x + ((UIButton *)mutableArrayOfBtn.lastObject).frame.size.width<self.view.frame.size.width) //当所有按钮尺寸小于屏幕宽度的时候要重新布局
        {
            oldRect = CGRectZero;
            CGFloat padding = self.view.frame.size.width-(((UIButton *)mutableArrayOfBtn.lastObject).frame.origin.x + ((UIButton *)mutableArrayOfBtn.lastObject).frame.size.width);
            for (CXHViewPagerTitleButton *button in mutableArrayOfBtn) {
                button.frame = CGRectMake(oldRect.origin.x+oldRect.size.width, 0,button.frame.size.width+padding/mutableArrayOfBtn.count, [self.dataSource respondsToSelector:@selector(heightForTitleOfViewPager:)]?[self.dataSource heightForTitleOfViewPager:self]:0);
                oldRect = button.frame;
            }
        }
        arrayOfViewControllerButton = [mutableArrayOfBtn copy];
        _subPageViewControlls = [mutableArrayOfVC copy];
        NSLog(@"MyLog:%@", mutableArrayOfVC);
        NSLog(@"MyLog:%@", _subPageViewControlls);
        NSLog(@"123");
    }
    if ([self.dataSource respondsToSelector:@selector(headerViewForInViewPager:)]) {
        [headerView removeFromSuperview];
        headerView = [self.dataSource headerViewForInViewPager:self];
        [self.view addSubview:headerView];
    }
    if (_subPageViewControlls.count) {
        [_pageViewController setViewControllers:@[_subPageViewControlls.firstObject] direction:UIPageViewControllerNavigationDirectionForward animated:YES completion:nil];
    }
}

#pragma mark -UIPageViewControllerDelegate
- (void)pageViewController:(UIPageViewController *)pageViewController didFinishAnimating:(BOOL)finished previousViewControllers:(NSArray<UIViewController *> *)previousViewControllers transitionCompleted:(BOOL)completed
{
    if (completed) {
        if (pendingVCIndex == NSNotFound) {
            return;
        }
        if (pendingVCIndex != [_subPageViewControlls indexOfObject:previousViewControllers[0]]) {
            
            [_segment setSelectedSegmentIndex:pendingVCIndex animated:0];// segment跟踪
            
            if ([self.delegate respondsToSelector:@selector(viewPagerViewController:didFinishScrollWithCurrentViewController:)]) {
                [self.delegate viewPagerViewController:self didFinishScrollWithCurrentViewController:[_subPageViewControlls objectAtIndex:pendingVCIndex]];
            }
        }
        
    }
}

- (void)pageViewController:(UIPageViewController *)pageViewController willTransitionToViewControllers:(NSArray<UIViewController *> *)pendingViewControllers
{
    pendingVCIndex = [_subPageViewControlls indexOfObject:pendingViewControllers[0]];
    if ([self.delegate respondsToSelector:@selector(viewPagerViewController:willScrollerWithCurrentViewController:)]) {
        [self.delegate viewPagerViewController:self willScrollerWithCurrentViewController:pageViewController.viewControllers[0]];
    }
}
#pragma mark -UIPageViewControllerDataSource
- (nullable UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerBeforeViewController:(UIViewController *)viewController
{
    NSInteger index = [_subPageViewControlls indexOfObject:viewController];
    if (index == 0 || index == NSNotFound) {
        return nil;
    }
    else{
        
        return _subPageViewControlls[--index];
        
    }
}
- (nullable UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerAfterViewController:(UIViewController *)viewController
{
    NSInteger index = [_subPageViewControlls indexOfObject:viewController];
    if (index == _subPageViewControlls.count-1 || index == NSNotFound) {
        return nil;
    }
    else{
        
        return _subPageViewControlls[++index];
    }
}


//{
//    headerView.frame = CGRectMake(0, self.topLayoutGuide.length, self.view.frame.size.width,[self.dataSource respondsToSelector:@selector(heightForHeaderOfViewPager:)]?[self.dataSource heightForHeaderOfViewPager:self]:0);
//    _titleBackground.frame = CGRectMake(0, (headerView.frame.size.height)?headerView.frame.origin.y+headerView.frame.size.height:self.topLayoutGuide.length, self.view.frame.size.width,[self.dataSource respondsToSelector:@selector(heightForTitleOfViewPager:)]?[self.dataSource heightForTitleOfViewPager:self]:0);
//    if (arrayOfViewControllerButton.count) {
//        
//        _titleBackground.contentSize = CGSizeMake(((UIButton *)arrayOfViewControllerButton.lastObject).frame.size.width+((UIButton *)arrayOfViewControllerButton.lastObject).frame.origin.x, _titleBackground.frame.size.height);
//    }
//    _pageViewController.view.frame = CGRectMake(0, _titleBackground.frame.origin.y+_titleBackground.frame.size.height, self.view.frame.size.width, self.view.frame.size.height-(_titleBackground.frame.origin.y+_titleBackground.frame.size.height));
//}
#pragma maek 计算字体宽度
-(CGFloat)p_fontText:(NSString *)text withFontHeight:(CGFloat)height
{
    CGFloat padding = 20;
    NSDictionary *fontAttribute = @{NSFontAttributeName : [UIFont systemFontOfSize:14]};
    CGSize fontSize = [text boundingRectWithSize:CGSizeMake(MAXFLOAT, height) options:NSStringDrawingUsesLineFragmentOrigin|NSStringDrawingUsesFontLeading attributes:fontAttribute context:nil].size;
    return fontSize.width+padding;
}

@end

#pragma -mark View Controller Title Button

@implementation CXHViewPagerTitleButton
- (instancetype)init
{
    self = [super init];
    if (self) {
        [self.titleLabel setFont:[UIFont systemFontOfSize:14]];
        [self setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [self setTitleColor:[UIColor redColor] forState:UIControlStateSelected];
    }
    return self;
}
-(void)drawRect:(CGRect)rect
{
    if (self.selected) {
        CGFloat lineWidth = 2.5;
        CGColorRef color = self.titleLabel.textColor.CGColor;
        CGContextRef ctx = UIGraphicsGetCurrentContext();
        CGContextSetStrokeColorWithColor(ctx, color);
        CGContextSetLineWidth(ctx, lineWidth);
        CGContextMoveToPoint(ctx, 0, self.frame.size.height-lineWidth);
        CGContextAddLineToPoint(ctx, self.frame.size.width, self.frame.size.height-lineWidth);
        CGContextStrokePath(ctx);
    }
}
@end
