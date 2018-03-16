//
//  JNSYMainBarController.m
//  JieNiuSongYao
//
//  Created by rongfeng on 2017/7/27.
//  Copyright © 2017年 China Zhou. All rights reserved.
//

#import "JNSYMainBarController.h"
#import "Common.h"
#import "JNSYMainViewController.h"
#import "JNSYDrugStoreViewController.h"
#import "ShopCarViewController.h"
#import "JNSYMyCornerViewController.h"
@interface JNSYMainBarController ()

@end

@implementation JNSYMainBarController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    //首页
    JNSYMainViewController *MianCtr = [[JNSYMainViewController alloc] init];
    MianCtr.tabBarItem.image = [[UIImage imageNamed:@"首页.png"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    MianCtr.tabBarItem.selectedImage = [[UIImage imageNamed:@"首页-SEL.png"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    MianCtr.tabBarItem.title = @"首页";
    UINavigationController *MainNav = [[UINavigationController alloc] initWithRootViewController:MianCtr];
    
    //药店
    JNSYDrugStoreViewController *DrugStoreCtr = [[JNSYDrugStoreViewController alloc] init];
    DrugStoreCtr.tabBarItem.image = [[UIImage imageNamed:@"药店.png"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    DrugStoreCtr.tabBarItem.selectedImage = [[UIImage imageNamed:@"药店-SEL.png"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    DrugStoreCtr.tabBarItem.title = @"药店";
    UINavigationController *DrugStoreNav = [[UINavigationController alloc] initWithRootViewController:DrugStoreCtr];
    
    //设置导航栏背景色
    DrugStoreNav.navigationBar.barTintColor = ColorTabBarback;
    DrugStoreNav.tabBarController.tabBar.barTintColor = ColorTabBarback;
    //设置导航栏标题颜色
    [DrugStoreNav.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName:[UIColor whiteColor],NSFontAttributeName:[UIFont systemFontOfSize:18]}];
    
    
    //购物车
    ShopCarViewController *ShopCarCtr = [[ShopCarViewController alloc] init];
    ShopCarCtr.tabBarItem.image = [[UIImage imageNamed:@"购物车.png"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    ShopCarCtr.tabBarItem.selectedImage = [[UIImage imageNamed:@"购物车-SEL.png"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    ShopCarCtr.tabBarItem.title = @"购物车";
    UINavigationController *ShopCarNav = [[UINavigationController alloc] initWithRootViewController:ShopCarCtr];
    ShopCarNav.navigationBar.barTintColor = ColorTabBarback;
    ShopCarNav.tabBarController.tabBar.barTintColor = ColorTabBarback;
    [ShopCarNav.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName:[UIColor whiteColor],NSFontAttributeName:[UIFont systemFontOfSize:18]}];
    
    
    //我的
    JNSYMyCornerViewController *MeCtr = [[JNSYMyCornerViewController alloc] init];
    
    MeCtr.tabBarItem.image = [[UIImage imageNamed:@"我.png"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    MeCtr.tabBarItem.selectedImage = [[UIImage imageNamed:@"我-SEL.png"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    MeCtr.tabBarItem.title = @"我";
    UINavigationController *MeNav = [[UINavigationController alloc] initWithRootViewController:MeCtr];
    //设置导航栏背景色
    MeNav.tabBarController.tabBar.barTintColor = ColorTabBarback;
    //设置导航栏标题颜色
    [MeNav.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName:[UIColor whiteColor],NSFontAttributeName:[UIFont systemFontOfSize:18]}];
    MeNav.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"" style:UIBarButtonItemStylePlain target:self action:nil];
    MeNav.navigationController.navigationBar.tintColor = [UIColor whiteColor];
    
    
    self.viewControllers = @[MainNav,DrugStoreNav,ShopCarNav,MeNav];
    
    self.tabBar.tintColor = ColorTabBarback;
    
    
    
    
    
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
