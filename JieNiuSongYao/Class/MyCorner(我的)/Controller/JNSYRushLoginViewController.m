//
//  JNSYRushLoginViewController.m
//  JieNiuSongYao
//
//  Created by rongfeng on 2017/6/2.
//  Copyright © 2017年 China Zhou. All rights reserved.
//

#import "JNSYRushLoginViewController.h"
#import "Common.h"
#import "Masonry.h"
#import "JNSYGetCodeTableViewCell.h"
#import "JNSYLabAndFldTableViewCell.h"
#import "JNSYAutoSize.h"
#import "IBHttpTool.h"
#import <CommonCrypto/CommonDigest.h>
#import "SBJSON.h"
#import "JNSYUserInfo.h"
@interface JNSYRushLoginViewController ()<UITableViewDelegate,UITableViewDataSource>

@end

@implementation JNSYRushLoginViewController {
    
    JNSYGetCodeTableViewCell *PhoneCell;
    JNSYLabAndFldTableViewCell *CodeCell;
    NSTimer *_timer;
    NSInteger _index;
}

- (void)viewWillAppear:(BOOL)animated {
    
    [super viewWillAppear:animated];
    
    self.title = @"快速登录";
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
    [CommitBtn setTitle:@"登录" forState:UIControlStateNormal];
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


//登录请求
- (void)CommitAction {
    
    NSLog(@"登录");
    
    if([PhoneCell.rightFld.text isEqualToString:@""] || PhoneCell.rightFld.text == nil) {
        
        [self showMsg:@"手机号不能为空！"];
        return;
    }else if ([CodeCell.RightFld.text isEqualToString:@""] || CodeCell.RightFld.text == nil) {
        
        [self showMsg:@"验证码为空!"];
        return;
    }
    
    //版本号
    //NSString  *version = [[[NSBundle mainBundle] infoDictionary] objectForKey:(NSString *)kCFBundleVersionKey];
    //imei
    //获取UUID
//    NSString *imsi = [[[UIDevice currentDevice] identifierForVendor] UUIDString];
//    NSString *UUID = [JNSYAutoSize md5HexDigest:imsi];
//    NSString *UUID16 = [[UUID substringFromIndex:8] substringToIndex:16];
    
    NSDictionary *dic = @{
                          @"phone":PhoneCell.rightFld.text,
                          @"smsCode":CodeCell.RightFld.text,
                          @"os":@"IOS",
                          @"soft":@"JnsyApp",
                          @"version":BundleID,
                          @"imei":[JNSYAutoSize getDiviceIMEI]
                          };
    NSString *action = @"UserVerifyLoginState";
    NSDictionary *requestDic = @{
                                 @"action":action,
                                 @"token":TOKEN,
                                 @"data":dic
                                 };
    NSString *params = [requestDic JSONFragment];
    [IBHttpTool postWithURL:JNSYTestUrl params:params success:^(id result) {
        
        NSLog(@"%@",result);
        
        NSDictionary *resultdic = [result JSONValue];
        NSString *code = resultdic[@"code"];
        
        NSLog(@"%@,%@",resultdic,code);
        if([code isEqualToString:@"000000"]) {
            
            [self showMsg:@"短信登录成功!"];
            [JNSYUserInfo getUserInfo].isLoggedIn = YES;
            [JNSYUserInfo getUserInfo].userCode = resultdic[@"userCode"];
            [JNSYUserInfo getUserInfo].userPhone = resultdic[@"userPhone"];
            [JNSYUserInfo getUserInfo].userName = resultdic[@"userName"];
            [JNSYUserInfo getUserInfo].shopStates = resultdic[@"shopStates"];
            [JNSYUserInfo getUserInfo].userToken = resultdic[@"userToken"];
            [JNSYUserInfo getUserInfo].userKey = resultdic[@"userKey"];
            [JNSYUserInfo getUserInfo].noticeFlg = resultdic[@"noticeFlg"];
            [JNSYUserInfo getUserInfo].noticeTitle = resultdic[@"noticeTitle"];
            [JNSYUserInfo getUserInfo].noticeText = resultdic[@"noticeText"];
            
            
            [self performSelector:@selector(BackToLogin) withObject:nil afterDelay:2];
            
        }else {
            NSString *msg = resultdic[@"msg"];
            [self showMsg:msg];
        }
        
    } failure:^(NSError *error) {
        NSLog(@"%@",error);
    }];
    
    
}

//获取验证码
- (void)getCode:(NSString *)phoneStr {
    
    if([phoneStr isEqualToString:@""] || phoneStr == nil) {
        
        [self showMsg:@"手机号不能为空！"];
        return;
    }
    
    NSDictionary *dic = @{
                          @"phone":phoneStr
                          };
    
    NSString *action = @"UserVerifyLoginStateSms";
    NSDictionary *RequestDic = @{
                                 @"action":action,
                                 @"token":TOKEN,
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
            
            [self showMsg:msg];
            
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

//返回个人信息
- (void)BackToLogin {
    
    [self.navigationController popViewControllerAnimated:YES];
    
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return 3;
    
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
            PhoneCell.rightFld.placeholder = @"请输入11位手机号码";
            PhoneCell.rightFld.keyboardType = UIKeyboardTypeNumberPad;
            __weak typeof(self) weakSelf = self;
            PhoneCell.btnActionBlock = ^(NSString *phoneStr) {
                NSLog(@"获取验证码");
                __strong typeof(self) StrongSelf = weakSelf;
                //获取验证码
                [StrongSelf getCode:phoneStr];
                
            };
            cell = PhoneCell;
        }else if(indexPath.row == 2){
            CodeCell = [[JNSYLabAndFldTableViewCell alloc] init];
            CodeCell.LeftLab.text = @"验证码";
            CodeCell.RightFld.placeholder = @"请输入6位验证码";
            CodeCell.RightFld.keyboardType = UIKeyboardTypeNumberPad;
            cell = CodeCell;
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


- (void)showMsg:(NSString *)msg {
    
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:msg delegate:self cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
    [alert show];
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
