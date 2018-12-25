//
//  EETabBarController.m
//  GoldenB
//
//  Created by 小熊 on 16/4/12.
//  Copyright © 2016年 橙晓侯. All rights reserved.
//

#import "EETabBarController.h"

@interface EETabBarController ()<UITabBarDelegate,UITabBarControllerDelegate>

@end

@implementation EETabBarController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.delegate = self;
    
    // Do any additional setup after loading the view.
}

- (void)setTintColor:(UIColor *)tintColor
{
    _tintColor = tintColor;
    self.tabBar.tintColor = _tintColor;
}

- (void)setUseThemeTintColor:(BOOL)useThemeTintColor
{
    if (useThemeTintColor) {
        
        _tintColor = ThemeColor;
        self.tabBar.tintColor = _tintColor;
    }
}

- (BOOL)tabBarController:(UITabBarController *)tabBarController shouldSelectViewController:(UIViewController *)viewController{
    //判断用户是否登陆
    if (!USER.isLogin) {
        //这里拿到你想要的tabBarItem,这里的方法有很多,还有通过tag值,这里看你的需要了
        if ([viewController.tabBarItem.title isEqualToString:@"个人"])
        {
            UINavigationController *navc = [Worker MainSB:SBLoginName];
            [self presentViewController:navc animated:YES completion:nil];
            //这里的NO是关键,如果是这个tabBarItem,就不要让他点击进去
            return NO;
        }
    }
    //当然其余的还是要点击进去的
    return YES;
}

- (void)tabBar:(UITabBar *)tabBar didSelectItem:(UITabBarItem *)item
{
    #pragma mark 获取上次选中的Index
    _lastIndex = self.selectedIndex;
//    NSLog(@"%lu -> %lu", self.selectedIndex,[self.tabBar.items indexOfObject:item]);
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
