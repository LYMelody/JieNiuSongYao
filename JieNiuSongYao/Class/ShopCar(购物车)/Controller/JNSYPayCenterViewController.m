//
//  JNSYPayCenterViewController.m
//  JieNiuSongYao
//
//  Created by rongfeng on 2017/6/20.
//  Copyright © 2017年 China Zhou. All rights reserved.
//

#import "JNSYPayCenterViewController.h"
#import "Common.h"
#import "Masonry.h"
#import "JNSYAutoSize.h"
#import "GRBkeyTextField.h"
#import "GRBsafeKeyBoard.h"
#import "UIColor+extention.h"
#import <IQKeyboardManager.h>
#import "JNSYPayResultViewController.h"

@interface JNSYPayCenterViewController ()<UIAlertViewDelegate,GRBTextFieldDelegate>

@property(nonatomic,strong)GRBkeyTextField *safeInputTextFiled;
@property(nonatomic,strong)GRBsafeKeyBoard *board;

@end

@implementation JNSYPayCenterViewController


- (void)viewWillAppear:(BOOL)animated {
    
    self.title = @"支付中心";
    self.view.backgroundColor = ColorTableBack;
    [IQKeyboardManager sharedManager].enable = NO;
    [IQKeyboardManager sharedManager].enableAutoToolbar = NO;
    
    [self.navigationController setNavigationBarHidden:YES animated:YES];
    
}

- (void)viewWillDisappear:(BOOL)animated {
    
    [super viewWillDisappear:animated];
    [IQKeyboardManager sharedManager].enable = YES;
    [IQKeyboardManager sharedManager].enableAutoToolbar = YES;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    //返回按钮
    self.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"" style:UIBarButtonItemStylePlain target:self action:nil];
    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
    
    [self CreateUI];
    
    
}

- (void)CreateUI {
    
    //导航栏
    UIImageView *NavBackImg = [[UIImageView alloc] init];
    NavBackImg.backgroundColor = ColorTabBarback;
    NavBackImg.userInteractionEnabled = YES;
    [self.view addSubview:NavBackImg];
    [NavBackImg mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.equalTo(self.view);
        make.height.mas_equalTo(64);
    }];
    
    UIButton *DisMissBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [DisMissBtn setImage:[UIImage imageNamed:@"×"] forState:UIControlStateNormal];
    [DisMissBtn addTarget:self action:@selector(DisMissBtnAction) forControlEvents:UIControlEventTouchUpInside];
    [NavBackImg addSubview:DisMissBtn];
    
    [DisMissBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view).offset(10);
        make.bottom.equalTo(NavBackImg).offset(-8);
        make.width.height.mas_equalTo(30);
    }];
    
    UILabel *titleLab = [[UILabel alloc] init];
    titleLab.text = @"支付中心";
    titleLab.textColor = [UIColor whiteColor];
    titleLab.font = [UIFont systemFontOfSize:18];
    titleLab.textAlignment = NSTextAlignmentCenter;
    [NavBackImg addSubview:titleLab];
    [titleLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(NavBackImg);
        make.bottom.equalTo(NavBackImg).offset(-8);
        make.width.mas_equalTo(120);
        make.height.mas_equalTo(30);
    }];
    
    //支付金额
    UIImageView *PayCashBackImg = [[UIImageView alloc] init];
    PayCashBackImg.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:PayCashBackImg];
    [PayCashBackImg mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(NavBackImg.mas_bottom);
        make.left.right.equalTo(self.view);
        make.height.mas_equalTo(KscreenHeight/4.0);
    }];
    
    UILabel *SubTitleLab = [[UILabel alloc] init];
    SubTitleLab.text = @"向葵花药业支付";
    SubTitleLab.textColor = [UIColor blackColor];
    SubTitleLab.font = [UIFont systemFontOfSize:16];
    SubTitleLab.textAlignment = NSTextAlignmentCenter;
    [PayCashBackImg addSubview:SubTitleLab];
    [SubTitleLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(PayCashBackImg).offset([JNSYAutoSize AutoHeight:40]);
        make.centerX.equalTo(PayCashBackImg);
        make.width.equalTo(PayCashBackImg);
        make.height.mas_equalTo([JNSYAutoSize AutoHeight:30]);
    }];
    
    UILabel *PriceLab = [[UILabel alloc] init];
    PriceLab.textAlignment = NSTextAlignmentCenter;
    PriceLab.text = @"￥100";
    PriceLab.textColor = [UIColor redColor];
    PriceLab.font = [UIFont systemFontOfSize:24];
    [PayCashBackImg addSubview:PriceLab];
    [PriceLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(PayCashBackImg);
        make.width.equalTo(PayCashBackImg);
        make.height.mas_equalTo(40);
        make.top.equalTo(SubTitleLab.mas_bottom).offset(10);
    }];
    
    UILabel *prePriceLab = [[UILabel alloc] init];
    prePriceLab.font = [UIFont systemFontOfSize:15];
    prePriceLab.textAlignment = NSTextAlignmentCenter;
    NSString *Str = @"￥120";
    NSMutableAttributedString *attributedStr = [[NSMutableAttributedString alloc] initWithString:Str];
    [attributedStr addAttributes:@{
                                  NSStrikethroughStyleAttributeName:[NSNumber numberWithInteger:NSUnderlineStyleSingle],NSBaselineOffsetAttributeName:@(NSUnderlineStyleSingle)
                                   }range:NSMakeRange(0, Str.length)];
    prePriceLab.attributedText = attributedStr;
    
    prePriceLab.textColor = ColorText;
    [PayCashBackImg addSubview:prePriceLab];
    [prePriceLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(PriceLab.mas_bottom).offset(0);
        make.centerX.equalTo(PayCashBackImg);
        make.height.mas_equalTo([JNSYAutoSize AutoHeight:20]);
        make.width.equalTo(PayCashBackImg);
    }];
    
    //支付信息
    
    UIImageView *PayInfoBackImg = [[UIImageView alloc] init];
    PayInfoBackImg.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:PayInfoBackImg];
    [PayInfoBackImg mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(PayCashBackImg.mas_bottom).offset(6);
        make.left.right.equalTo(self.view);
        make.height.mas_equalTo([JNSYAutoSize AutoHeight:80]);
    }];
    
    UILabel *PayMethodLab = [[UILabel alloc] init];
    PayMethodLab.text = @"支付方式：兴业葵花联名信用卡(9678)";
    PayMethodLab.textAlignment = NSTextAlignmentLeft;
    PayMethodLab.font = [UIFont systemFontOfSize:13];
    PayMethodLab.textColor = ColorText;
    [PayInfoBackImg addSubview:PayMethodLab];
    [PayMethodLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(PayInfoBackImg);
        make.left.equalTo(PayInfoBackImg).offset(16);
        make.height.mas_equalTo([JNSYAutoSize AutoHeight:40]);
        make.width.mas_equalTo(KscreenWidth - 20);
    }];
    
    UIImageView *LineView = [[UIImageView alloc] init];
    LineView.backgroundColor = ColorTableViewCellSeparate;
    [PayInfoBackImg addSubview:LineView];
    [LineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(PayMethodLab.mas_bottom);
        make.left.equalTo(PayMethodLab);
        make.right.equalTo(self.view);
        make.height.mas_equalTo([JNSYAutoSize AutoHeight:0.5]);
    }];
    
    UILabel *NameLab = [[UILabel alloc] init];
    NameLab.text = @"持卡人：*某某";
    NameLab.font = [UIFont systemFontOfSize:13];
    NameLab.textColor = ColorText;
    NameLab.textAlignment = NSTextAlignmentLeft;
    [PayInfoBackImg addSubview:NameLab];
    
    [NameLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(LineView.mas_bottom);
        make.left.equalTo(PayMethodLab);
        make.height.mas_equalTo([JNSYAutoSize AutoHeight:40]);
        make.width.mas_equalTo(KscreenWidth - 20);
    }];
    
    //支付按钮
    UIButton *PayBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    PayBtn.layer.cornerRadius = 5;
    PayBtn.layer.masksToBounds = YES;
    PayBtn.titleLabel.font = [UIFont systemFontOfSize:14];
    [PayBtn setBackgroundColor:ColorTabBarback];
    [PayBtn setTitle:@"立即支付" forState:UIControlStateNormal];
    [PayBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [PayBtn addTarget:self action:@selector(PayAction) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:PayBtn];
    [PayBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(PayInfoBackImg.mas_bottom).offset([JNSYAutoSize AutoHeight:20]);
        make.centerX.equalTo(self.view);
        make.height.mas_equalTo([JNSYAutoSize AutoHeight:36]);
        make.width.mas_equalTo(KscreenWidth - 80);
    }];
}

- (void)PayAction {
    
    NSLog(@"立即支付");
    
    
    self.board = [GRBsafeKeyBoard GRB_showSafeInputKeyBoard];
    __weak typeof(self)WS = self;
    self.board.GRBsafeKeyFinish=^(NSString * passWord){
        if (passWord.length==6) {
            
            [WS.board GRB_endKeyBoard];
            
            JNSYPayResultViewController *ResultVc = [[JNSYPayResultViewController alloc] init];
            ResultVc.hidesBottomBarWhenPushed = YES;
            [WS.navigationController pushViewController:ResultVc animated:YES];
            
            UIAlertController * alert = [UIAlertController alertControllerWithTitle:@"密码结果" message:passWord preferredStyle:UIAlertControllerStyleAlert];
            UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
            UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"好的" style:UIAlertActionStyleDefault handler:nil];
            [alert addAction:cancelAction];
            [alert addAction:okAction];
            [WS presentViewController:alert animated:YES completion:nil];
            
        }
        
    };
    self.board.GRBsafeKeyClose=^{
        
        [WS.board GRB_endKeyBoard];
    };
}

- (void)DisMissBtnAction {
    
    
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:@"放弃支付？" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确认", nil];
    [alert show];
    
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    
    if (buttonIndex == 0) {
        
    }else {
        [self dismissViewControllerAnimated:YES completion:nil];
    }
    
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
