//
//  JNSYForgetPwdViewController.m
//  JieNiuSongYao
//
//  Created by rongfeng on 2017/5/17.
//  Copyright © 2017年 China Zhou. All rights reserved.
//

#import "JNSYForgetPwdViewController.h"
#import "Common.h"
#import "Masonry.h"
#import "JNSYLabAndFldTableViewCell.h"
#import "JNSYGetCodeTableViewCell.h"
#import "JNSYAutoSize.h"
#import "JNSYUserInfo.h"
#import "IBHttpTool.h"
#import "SBJSON.h"
#import "JNSYSetPayPwdViewController.h"
#import "MBProgressHUD.h"

@interface JNSYForgetPwdViewController ()<UITableViewDelegate,UITableViewDataSource>

@end

@implementation JNSYForgetPwdViewController {
    
    NSTimer *_timer;
    NSInteger _index;
    JNSYGetCodeTableViewCell *PhoneCell;
    JNSYLabAndFldTableViewCell *NameCell;
    JNSYLabAndFldTableViewCell *CertCell;
    JNSYLabAndFldTableViewCell *CodeCell;
    JNSYLabAndFldTableViewCell *PwdCell;
}

- (void)viewWillAppear:(BOOL)animated {
    
    [super viewWillAppear:animated];
    
    self.title = @"忘记密码";
    
    self.view.backgroundColor = [UIColor whiteColor];
    
}


- (void)viewDidLoad {
    [super viewDidLoad];
    
    UITableView *table = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, KscreenWidth, KscreenHeight) style:UITableViewStylePlain];
    table.delegate = self;
    table.dataSource = self;
    table.backgroundColor = ColorTableBack;
    table.separatorStyle = UITableViewCellSeparatorStyleNone;
    table.scrollEnabled = NO;
    table.showsVerticalScrollIndicator = NO;
    [self.view addSubview:table];
    
    UIImageView *tableFooterView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, KscreenWidth, 100)];
    tableFooterView.backgroundColor = ColorTableBack;
    tableFooterView.userInteractionEnabled = YES;
    
    UIButton *CommitBtn = [[UIButton alloc] init];
    CommitBtn.backgroundColor = ColorTabBarback;
    [CommitBtn setTitle:@"提交" forState:UIControlStateNormal];
    CommitBtn.layer.cornerRadius = 5;
    CommitBtn.layer.masksToBounds = YES;
    [CommitBtn addTarget:self action:@selector(CommitAction) forControlEvents:UIControlEventTouchUpInside];
    [tableFooterView addSubview:CommitBtn];
    
    [CommitBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(tableFooterView).offset(30);
        make.right.equalTo(tableFooterView).offset(-30);
        make.top.equalTo(tableFooterView).offset(50);
        make.height.mas_equalTo(36);
    }];
    
    table.tableFooterView = tableFooterView;
    
    
    _index = 60;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return 10;
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *identy = @"identy";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identy];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] init];
        if (indexPath.row == 0 || indexPath.row == 2 || indexPath.row == 5) {
            cell.backgroundColor = ColorTableBack;
        }else if (indexPath.row == 1) {
            cell.textLabel.text = @"请输入实名认证信息";
            cell.textLabel.font = [UIFont systemFontOfSize:14];
        }else if (indexPath.row == 3) {
            NameCell = [[JNSYLabAndFldTableViewCell alloc] init];
            NameCell.LeftLab.text = @"姓名";
            NameCell.RightFld.placeholder = @"请输入姓名";
            cell = NameCell;
        }else if (indexPath.row == 4) {
            CertCell = [[JNSYLabAndFldTableViewCell alloc] init];
            CertCell.LeftLab.text = @"身份证号";
            CertCell.RightFld.placeholder = @"请输入身份证";
            cell = CertCell;
        }else if (indexPath.row == 6) {
            PhoneCell = [[JNSYGetCodeTableViewCell alloc] init];
            PhoneCell.LeftLab.text = @"当前账号为";
            PhoneCell.rightFld.enabled = NO;
            PhoneCell.rightFld.text = [[JNSYUserInfo getUserInfo].userPhone stringByReplacingCharactersInRange:NSMakeRange(3, ([JNSYUserInfo getUserInfo].userPhone.length - 7)) withString:@"****"] ;
            __weak typeof(self) weakSelf = self;
            PhoneCell.btnActionBlock = ^(NSString *phoneStr) {
                __strong typeof(self) strongSelf = weakSelf;
                [strongSelf getCode:phoneStr];
                
            };
            cell = PhoneCell;
        }else if (indexPath.row == 7) {
            CodeCell = [[JNSYLabAndFldTableViewCell alloc] init];
            CodeCell.LeftLab.text = @"验证码";
            CodeCell.RightFld.placeholder = @"请输入验证码";
            cell = CodeCell;
            
        }else if (indexPath.row == 8) {
            
            cell.backgroundColor = ColorTableBack;
            
        }
        else if (indexPath.row == 9) {
            
            PwdCell = [[JNSYLabAndFldTableViewCell alloc] init];
            PwdCell.LeftLab.text = @"支付密码";
            PwdCell.RightFld.placeholder = @"请输入6位支付密码";
            PwdCell.RightFld.secureTextEntry = YES;
            cell = PwdCell;
            
        }
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.row == 0 || indexPath.row == 2 || indexPath.row == 5 || indexPath.row == 8) {
        return 5;
    }else {
        return 40;
    }
    
}

- (void)getCode:(NSString *)phoneStr {
    
    if([phoneStr isEqualToString:@""] || phoneStr == nil) {
        
        [JNSYAutoSize showMsg:@"手机号为空!"];
        return;
    }
    
    NSDictionary *dic = @{
                          @"timestamp":[JNSYAutoSize getTimeNow]
                          };
    
    NSString *action = @"UserPayPassStateSms";
    NSDictionary *RequestDic = @{
                                 @"action":action,
                                 @"token":[JNSYUserInfo getUserInfo].userToken,
                                 @"data":dic,
                                 };
    NSString *params = [RequestDic JSONFragment];
    [IBHttpTool postWithURL:JNSYTestUrl params:params success:^(id result) {
        NSLog(@"%@",result);
        
        NSDictionary *resultDic = [result JSONValue];
        NSString *code = resultDic[@"code"];
        NSString *msg = resultDic[@"msg"];
        if ([code isEqualToString:@"000000"]) {
            
            //开启定时器
            _timer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(TimeDecrease) userInfo:nil repeats:YES];
            
        }else {
            
            [JNSYAutoSize showMsg:msg];
            
        }
        
    } failure:^(NSError *error) {
        NSLog(@"%@",error);
    }];
}

//定时器倒计时方法
- (void)TimeDecrease {
    
    _index--;
    [PhoneCell.GetCodeBtn setTitle:[NSString stringWithFormat:@"重新获取(%ld)",(long)_index] forState:UIControlStateNormal];
    PhoneCell.GetCodeBtn.enabled = NO;
    PhoneCell.GetCodeBtn.backgroundColor = [UIColor grayColor];
    
    if (_index == 0) {
        [_timer invalidate];
        PhoneCell.GetCodeBtn.enabled = YES;
        [PhoneCell.GetCodeBtn setTitle:@"获取验证码" forState:UIControlStateNormal];
        [PhoneCell.GetCodeBtn setBackgroundColor:ColorTabBarback];
        _index = 60;
    }
}

//登录请求
- (void)CommitAction {
    
    MBProgressHUD *HUD = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    //HUD.label.text = @"信息提交中";
    HUD.labelText = @"信息提交中";
    if([NameCell.RightFld.text isEqualToString:@""] || NameCell.RightFld.text == nil) {
        
        [JNSYAutoSize showMsg:@"姓名为空!"];
        [HUD hide:YES];
        return;
    }else if ([CodeCell.RightFld.text isEqualToString:@""] || CodeCell.RightFld.text == nil) {
        
        [JNSYAutoSize showMsg:@"验证码为空!"];
         [HUD hide:YES];
        return;
    }else if ([CertCell.RightFld.text isEqualToString:@""] || CertCell.RightFld.text == nil) {
        [JNSYAutoSize showMsg:@"身份证为空!"];
         [HUD hide:YES];
        return;
    }else if ([PwdCell.RightFld.text isEqualToString:@""] || PwdCell.RightFld.text== nil) {
        [JNSYAutoSize showMsg:@"支付密码为空!"];
         [HUD hide:YES];
        return;
    }
    
    NSDictionary *dic = @{
                          @"code":CodeCell.RightFld.text,
                          @"userAccount":NameCell.RightFld.text,
                          @"userCert":CertCell.RightFld.text,
                          @"pass":PwdCell.RightFld.text
                          };
    NSString *action = @"UserPayPassState";
    NSDictionary *requestDic = @{
                                 @"action":action,
                                 @"token":[JNSYUserInfo getUserInfo].userToken,
                                 @"data":dic
                                 };
    NSString *params = [requestDic JSONFragment];
    
    [IBHttpTool postWithURL:JNSYTestUrl params:params success:^(id result) {
        
        NSLog(@"%@",result);
        
        NSDictionary *resultdic = [result JSONValue];
        NSString *code = resultdic[@"code"];
        
        NSLog(@"%@,%@",resultdic,code);
        if([code isEqualToString:@"000000"]) {
            
            [HUD hide:YES];
            HUD.mode = MBProgressHUDModeText;
            HUD.labelText = @"设置密码成功!";
//            [HUD showAnimated:YES];
//            [HUD hideAnimated:YES afterDelay:1.5];
            
            [HUD show:YES];
            [HUD hide:YES afterDelay:1.5];
            
            [self performSelector:@selector(BackToLogin) withObject:nil afterDelay:1.5];

        
        }else {
            [HUD hide:YES];
            NSString *msg = resultdic[@"msg"];
            [JNSYAutoSize showMsg:msg];
        }
        
    } failure:^(NSError *error) {
        NSLog(@"%@",error);
    }];
    
}


- (void)BackToLogin {
    
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
