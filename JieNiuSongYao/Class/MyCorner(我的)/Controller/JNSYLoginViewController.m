//
//  JNSYLoginViewController.m
//  JieNiuSongYao
//
//  Created by rongfeng on 2017/6/2.
//  Copyright © 2017年 China Zhou. All rights reserved.
//

#import "JNSYLoginViewController.h"
#import "Common.h"
#import "JNSYAutoSize.h"
#import "JNSYRushLoginViewController.h"
#import "JNSYCodeLoginViewController.h"
#import "JNSYRegisterViewController.h"
#import "MBProgressHUD.h"
@interface JNSYLoginViewController ()

@end

@implementation JNSYLoginViewController {
    
    MBProgressHUD *HUD;
    
    
}

- (void)viewWillAppear:(BOOL)animated {
    
    [super viewWillAppear:animated];
    
    self.title = @"登录";
    self.view.backgroundColor = [UIColor whiteColor];
    [self.navigationController setNavigationBarHidden:NO animated:YES];
    
}


- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    UIButton *RightBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    RightBtn.frame = CGRectMake(0, 0, 80, 30);
    RightBtn.titleLabel.font = [UIFont systemFontOfSize:14];
    [RightBtn setTitle:@"账户注册" forState:UIControlStateNormal];
    RightBtn.backgroundColor = [UIColor clearColor];
    [RightBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [RightBtn addTarget:self action:@selector(registerAction) forControlEvents:(UIControlEventTouchUpInside)];

    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:RightBtn];
    
    JNSYRushLoginViewController *RushLogin = [[JNSYRushLoginViewController alloc] init];
    RushLogin.title = @"快速登录";
    
    JNSYCodeLoginViewController *CodeLogin = [[JNSYCodeLoginViewController alloc] init];
    CodeLogin.title = @"密码登录";
    
    self.viewControllers = @[RushLogin,CodeLogin];
    self.scrollView.scrollEnabled = NO;
    
    
    //HUD = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    
    
    
    
    
}

- (void)registerAction {
    
    NSLog(@"注册");
    
    JNSYRegisterViewController *RegisterVc = [[JNSYRegisterViewController alloc] init];
    RegisterVc.hidesBottomBarWhenPushed =  YES;
    [self.navigationController pushViewController:RegisterVc animated:YES];
    
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
