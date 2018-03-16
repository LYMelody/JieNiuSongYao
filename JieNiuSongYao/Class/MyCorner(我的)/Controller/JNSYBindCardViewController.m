//
//  JNSYBindCardViewController.m
//  JieNiuSongYao
//
//  Created by rongfeng on 2017/5/17.
//  Copyright © 2017年 China Zhou. All rights reserved.
//

#import "JNSYBindCardViewController.h"
#import "JNSYCreditCardViewController.h"
#import "JNSYDepositCardViewController.h"

@interface JNSYBindCardViewController ()

@end

@implementation JNSYBindCardViewController

- (void)viewWillAppear:(BOOL)animated {
    
    [super viewWillAppear:animated];
    self.title = @"绑定会员卡";
    self.view.backgroundColor = [UIColor whiteColor];
    
}


- (void)viewDidLoad {
    [super viewDidLoad];
    
    //返回按钮
    self.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"" style:UIBarButtonItemStylePlain target:self action:nil];
    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
    
    JNSYCreditCardViewController *VcOne = [[JNSYCreditCardViewController alloc] init];
    VcOne.title = @"联名信用卡";
    
    JNSYDepositCardViewController *VcTwo = [[JNSYDepositCardViewController alloc] init];
    VcTwo.title = @"联名储蓄卡";
    
    self.viewControllers = @[VcOne,VcTwo];
    
    
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
