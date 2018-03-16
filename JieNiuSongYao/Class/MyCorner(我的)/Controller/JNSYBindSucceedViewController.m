//
//  JNSYBindSucceedViewController.m
//  JieNiuSongYao
//
//  Created by rongfeng on 2017/5/18.
//  Copyright © 2017年 China Zhou. All rights reserved.
//

#import "JNSYBindSucceedViewController.h"
#import "Common.h"
#import "Masonry.h"

@interface JNSYBindSucceedViewController ()

@end

@implementation JNSYBindSucceedViewController

- (void)viewWillAppear:(BOOL)animated {
    
    [super viewWillAppear:animated];
    
    self.title = @"绑定会员卡";
    self.view.backgroundColor = [UIColor whiteColor];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //隐藏返回按钮
    self.navigationItem.hidesBackButton = YES;
    //设置导航栏右侧按钮
    UIBarButtonItem *keepBtn = [[UIBarButtonItem alloc] initWithTitle:@"完成" style:UIBarButtonItemStylePlain target:self action:@selector(KeepAction)];
    self.navigationItem.rightBarButtonItem = keepBtn;
    
    UIImageView *backImg = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, KscreenWidth, KscreenHeight)];
    backImg.backgroundColor = ColorTableBack;
    backImg.userInteractionEnabled = YES;
    
    UIImageView *LogoView = [[UIImageView alloc] initWithFrame:CGRectMake(100, 100, 120, 120)];
    LogoView.contentMode = UIViewContentModeScaleAspectFill;
    //LogoView.backgroundColor = [UIColor redColor];
    LogoView.image = [UIImage imageNamed:@"绑定成功"];
    LogoView.userInteractionEnabled = YES;
    [backImg addSubview:LogoView];
    
    UILabel *TipsLab = [[UILabel alloc] init];
    TipsLab.textAlignment = NSTextAlignmentCenter;
    TipsLab.font = [UIFont systemFontOfSize:14];
    TipsLab.text = @"您已成功绑定联名信用卡!";
    [backImg addSubview:TipsLab];
    
    [LogoView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(backImg);
        make.top.equalTo(backImg).offset(160);
        make.width.height.mas_equalTo(120);
    }];
    
    [TipsLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(LogoView.mas_bottom).offset(10);
        make.centerX.equalTo(LogoView);
        make.width.mas_equalTo(KscreenWidth);
    }];
    
    [self.view addSubview:backImg];
}


- (void)KeepAction {
    
    
    [self.navigationController popToRootViewControllerAnimated:YES];
    
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
