//
//  JNSYForgetCodeViewController.m
//  JieNiuSongYao
//
//  Created by rongfeng on 2017/6/2.
//  Copyright © 2017年 China Zhou. All rights reserved.
//

#import "JNSYForgetCodeViewController.h"
#import "Common.h"
#import "JNSYGetCodeTableViewCell.h"
#import "JNSYLabAndFldTableViewCell.h"
#import "Masonry.h"
#import "JNSYAutoSize.h"
#import "JNSYUserInfo.h"
#import "IBHttpTool.h"
#import "SBJSON.h"
#import "MBProgressHUD.h"

@interface JNSYForgetCodeViewController ()<UITableViewDelegate,UITableViewDataSource>

@end

@implementation JNSYForgetCodeViewController {
    
    JNSYGetCodeTableViewCell *PhoneCell;
    JNSYLabAndFldTableViewCell *CodeCell;
    JNSYLabAndFldTableViewCell *PwdCell;
    NSTimer *_timer;
    NSInteger _index;
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
    table.showsVerticalScrollIndicator = NO;
    table.scrollEnabled = NO;
    [self.view addSubview:table];
    
    
    UIImageView *tableFooterView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, KscreenWidth, 100)];
    tableFooterView.backgroundColor = ColorTableBack;
    tableFooterView.userInteractionEnabled = YES;
    
    UIButton *CommitBtn = [[UIButton alloc] init];
    CommitBtn.backgroundColor = ColorTabBarback;
    [CommitBtn setTitle:@"保存" forState:UIControlStateNormal];
    CommitBtn.layer.cornerRadius = 5;
    CommitBtn.layer.masksToBounds = YES;
    [CommitBtn addTarget:self action:@selector(CommitAction) forControlEvents:UIControlEventTouchUpInside];
    [tableFooterView addSubview:CommitBtn];
    
    [CommitBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(tableFooterView).offset(30);
        make.right.equalTo(tableFooterView).offset(-30);
        make.top.equalTo(tableFooterView).offset(50);
        make.height.mas_equalTo([JNSYAutoSize AutoHeight:34]);
    }];
    
    table.tableFooterView = tableFooterView;
    
    _index = 60;
}



- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return 4;
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *identy = @"identy";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identy];
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc] init];
        if (indexPath.row == 0) {
            cell.backgroundColor = ColorTableBack;
        }else if (indexPath.row == 1) {
            
            PhoneCell = [[JNSYGetCodeTableViewCell alloc] init];
            PhoneCell.LeftLab.text = @"手机号";
            PhoneCell.rightFld.placeholder = @"请输入11位手机号";
            PhoneCell.rightFld.keyboardType = UIKeyboardTypeNumberPad;
            
            __weak typeof(self) weakSelf = self;
            PhoneCell.btnActionBlock = ^(NSString *phoneStr) {
                __strong typeof(self) strongSelf = weakSelf;
                [strongSelf getCode:phoneStr];
            };
            cell = PhoneCell;
            
        }else if (indexPath.row == 2) {
            CodeCell = [[JNSYLabAndFldTableViewCell alloc] init];
            CodeCell.LeftLab.text = @"验证码";
            CodeCell.RightFld.placeholder = @"请输入6位验证码";
            CodeCell.RightFld.keyboardType = UIKeyboardTypeNumberPad;
            cell = CodeCell;
        }else if (indexPath.row == 3) {
            PwdCell = [[JNSYLabAndFldTableViewCell alloc] init];
            PwdCell.LeftLab.text = @"设置密码";
            PwdCell.RightFld.placeholder = @"请输入6~12位数字、字母组合";
            PwdCell.RightFld.secureTextEntry = YES;
            cell = PwdCell;
        }
    }
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    return cell;
    
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.row == 0) {
        return 6;
    }else {
        return 40;
    }
    
}

//获取验证码
- (void)getCode:(NSString *)phoneStr {
    
    if([phoneStr isEqualToString:@""] || phoneStr == nil) {
        
        [JNSYAutoSize showMsg:@"手机号为空!"];
        return;
    }
    
    NSDictionary *dic = @{
                          @"phone":phoneStr
                          };
    
    NSString *action = @"UserFindPassStateSms";
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
            
            
            
            
        }else {
            
            [JNSYAutoSize showMsg:msg];
            
        }
        
    } failure:^(NSError *error) {
        NSLog(@"%@",error);
    }];
    
    _timer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(TimeDecrease) userInfo:nil repeats:YES];
    
    
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


- (void)CommitAction {
    
    //验证密码位数
    if(PwdCell.RightFld.text.length <= 12 && PwdCell.RightFld.text.length >= 6) {
        
    }else {
        [JNSYAutoSize showMsg:@"请输入6~12位密码!"];
        return;
    }
    //验证验证码
    if (CodeCell.RightFld.text == nil || [CodeCell.RightFld.text isEqualToString:@""]) {
        [JNSYAutoSize showMsg:@"密码为空!"];
        return;
    }
    //验证手机号
    if ([PhoneCell.rightFld.text isEqualToString:@""] || PhoneCell.rightFld.text == nil) {
        [JNSYAutoSize showMsg:@"手机号为空!"];
        return;
    }
    
    //发送请求
    NSDictionary *dic = @{
                          @"phone":PhoneCell.rightFld.text,
                          @"code":CodeCell.RightFld.text,
                          @"pass":PwdCell.RightFld.text
                          };
    NSString *action = @"UserFindPassState";
    NSDictionary *requestDic = @{
                                 @"action":action,
                                 @"token":[JNSYUserInfo getUserInfo].userToken,
                                 @"data":dic
                                 };
    NSString *params = [requestDic JSONFragment];
    [IBHttpTool postWithURL:JNSYTestUrl params:params success:^(id result) {
        
        NSDictionary *resultdic = [result JSONValue];
        NSString *code = resultdic[@"code"];
        
        NSLog(@"%@,%@",resultdic,code);
        if([code isEqualToString:@"000000"]) {
            
            MBProgressHUD *HUD = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
            HUD.mode = MBProgressHUDModeText;
            HUD.labelText = @"修改密码成功!";
            
            //[HUD hideAnimated:YES afterDelay:1.5];
            [HUD hide:YES afterDelay:1.5];
            [self performSelector:@selector(BackToLogin) withObject:nil afterDelay:1.5];
            
        }else {
            NSString *msg = resultdic[@"msg"];
            [JNSYAutoSize showMsg:msg];
        }
        
    } failure:^(NSError *error) {
        NSLog(@"%@",error);
    }];
    
}

- (void)BackToLogin {
    
    [self.navigationController popViewControllerAnimated:YES];
    
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
