//
//  JNSYPayResultViewController.m
//  JieNiuSongYao
//
//  Created by rongfeng on 2017/6/21.
//  Copyright © 2017年 China Zhou. All rights reserved.
//

#import "JNSYPayResultViewController.h"
#import "Common.h"
#import "Masonry.h"

@interface JNSYPayResultViewController ()

@end

@implementation JNSYPayResultViewController

- (void)viewWillAppear:(BOOL)animated {
    
    [super viewWillAppear:animated];
    self.title =@"支付结果";
    self.view.backgroundColor = ColorTableBack;
    self.navigationController.navigationBar.barTintColor = ColorTabBarback;
    [self.navigationController.navigationBar setTitleTextAttributes:@{
                                                                      NSForegroundColorAttributeName:[UIColor whiteColor],
                                                                      NSFontAttributeName:[UIFont systemFontOfSize:18]
                                                                      }];
    [self.navigationController setNavigationBarHidden:NO animated:YES];
    
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
