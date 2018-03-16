//
//  JNSYSearchDetailViewController.m
//  JieNiuSongYao
//
//  Created by rongfeng on 2017/5/25.
//  Copyright © 2017年 China Zhou. All rights reserved.
//

#import "JNSYSearchDetailViewController.h"
#import "Common.h"
#import "Masonry.h"

@interface JNSYSearchDetailViewController ()

@end

@implementation JNSYSearchDetailViewController

- (void)viewWillAppear:(BOOL)animated {
    
    [super viewWillAppear:animated];
    
    self.title = @"药品、药店详情";
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    self.navigationController.navigationBar.hidden = NO;
    self.navigationController.navigationBar.barTintColor = ColorTabBarback;
    
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
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
