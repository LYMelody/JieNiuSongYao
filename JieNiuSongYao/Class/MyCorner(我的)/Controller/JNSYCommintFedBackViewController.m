//
//  JNSYCommintFedBackViewController.m
//  JieNiuSongYao
//
//  Created by rongfeng on 2017/7/6.
//  Copyright © 2017年 China Zhou. All rights reserved.
//

#import "JNSYCommintFedBackViewController.h"
#import "Common.h"
#import "JNSYAutoSize.h"
#import "JNSYUserInfo.h"
#import "Masonry.h"

@interface JNSYCommintFedBackViewController ()

@end

@implementation JNSYCommintFedBackViewController

- (void)viewWillAppear:(BOOL)animated {
    
    self.title = @"提交反馈";
    
    self.view.backgroundColor = ColorTabBarback;
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
    LogoView.image = [UIImage imageNamed:@"已提交"];
    LogoView.userInteractionEnabled = YES;
    [backImg addSubview:LogoView];
    
    UILabel *TipsLab = [[UILabel alloc] init];
    TipsLab.textAlignment = NSTextAlignmentCenter;
    TipsLab.font = [UIFont systemFontOfSize:14];
    TipsLab.text = @"药店信息已提交，请您耐心等待\n我们会在1~3个工作日给您反馈!";
    TipsLab.numberOfLines = 0;
    [backImg addSubview:TipsLab];
    
    [LogoView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(backImg);
        make.top.equalTo(backImg).offset(160);
        make.width.height.mas_equalTo(120);
    }];
    
    [TipsLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(LogoView.mas_bottom).offset(20);
        make.centerX.equalTo(LogoView);
        make.width.mas_equalTo(KscreenWidth);
        make.height.mas_equalTo(50);
    }];
    
    [self.view addSubview:backImg];
    
    
}

//点击“完成”返回主页面
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
