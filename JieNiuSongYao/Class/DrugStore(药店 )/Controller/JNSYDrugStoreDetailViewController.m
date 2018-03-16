//
//  JNSYDrugStoreDetailViewController.m
//  JieNiuSongYao
//
//  Created by rongfeng on 2017/5/31.
//  Copyright © 2017年 China Zhou. All rights reserved.
//

#import "JNSYDrugStoreDetailViewController.h"
#import "JNSYDrugDiscountViewController.h"
#import "JNSYMedicineDisplayViewController.h"
#import "JNSYDrugDocersViewController.h"
#import "JNSYDrugStoreCerViewController.h"
#import "Common.h"
#import "JNSYAutoSize.h"
#import "JNSYUserInfo.h"
#import "SBJSON.h"
#import "IBHttpTool.h"
#import "MBProgressHUD.h"

@interface JNSYDrugStoreDetailViewController ()<UINavigationControllerDelegate>

@end

@implementation JNSYDrugStoreDetailViewController

- (void)viewWillAppear:(BOOL)animated {
    
    self.title = self.shopName;
    self.view.backgroundColor = ColorTabBarback;
    [self.navigationController setNavigationBarHidden:NO animated:YES];
    self.navigationController.navigationBar.barTintColor = ColorTabBarback;
    self.navigationController.navigationBar.translucent = YES;
    [super viewWillAppear:animated];
}

- (void)viewWillDisappear:(BOOL)animated {
    
    [super viewWillDisappear:animated];
    self.navigationController.navigationBar.translucent = NO;
    
}


- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    //返回按钮
    self.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"" style:UIBarButtonItemStylePlain target:self action:nil];
    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
    
//    for (NSInteger i = 0; i < 3; i++) {
//        UIImageView *LineImg = [[UIImageView alloc] init];
//        LineImg.backgroundColor = ColorTabBarback;
//        LineImg.frame = CGRectMake((KscreenWidth/4.0) *(i+1) , 10, 1, self.segmentControl.frame.size.height - 18);
//        
//        [self.segmentControl addSubview:LineImg];
//    }
    
    for (NSInteger i = 0; i < 2; i++) {
        UIImageView *LineImg = [[UIImageView alloc] init];
        LineImg.backgroundColor = ColorTabBarback;
        LineImg.frame = CGRectMake((KscreenWidth/3.0) *(i+1) , 10, 1, self.segmentControl.frame.size.height - 18);
        
        [self.segmentControl addSubview:LineImg];
    }
    
    
    
    JNSYMedicineDisplayViewController *MedicineVc = [[JNSYMedicineDisplayViewController alloc] init];
    MedicineVc.shopId = self.shopId;
    MedicineVc.title  = @"药品展示";
    
    JNSYDrugDiscountViewController *DrugDiscountVc = [[JNSYDrugDiscountViewController alloc] init];
    DrugDiscountVc.title = @"药店优惠";
    
    JNSYDrugDocersViewController *DrugDocersVc = [[JNSYDrugDocersViewController alloc] init];
    DrugDocersVc.shopId = self.shopId;
    DrugDocersVc.title = @"驻店药师";
    
    JNSYDrugStoreCerViewController *DrugStoreCer = [[JNSYDrugStoreCerViewController alloc] init];
    DrugStoreCer.shopId = self.shopId;
    DrugStoreCer.title = @"药店资质";
    
    
    self.viewControllers = @[MedicineVc,DrugDocersVc,DrugStoreCer];
    self.scrollView.scrollEnabled = NO;

    
    
}

- (void)viewDidAppear:(BOOL)animated {
    
    [super viewDidAppear:animated];
    
    
    
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
