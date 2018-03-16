//
//  JNSYCodeLoginViewController.m
//  JieNiuSongYao
//
//  Created by rongfeng on 2017/6/2.
//  Copyright © 2017年 China Zhou. All rights reserved.
//

#import "JNSYCodeLoginViewController.h"
#import "Common.h"
#import "JNSYLabAndFldTableViewCell.h"
#import "Masonry.h"
#import "JNSYAutoSize.h"
#import "JNSYForgetCodeViewController.h"
#import "IBHttpTool.h"
#import <CommonCrypto/CommonDigest.h>
#import "SBJSON.h"
#import "JNSYUserInfo.h"
#import "MBProgressHUD.h"
#import <HyphenateLite/HyphenateLite.h>
@interface JNSYCodeLoginViewController ()<UITableViewDelegate,UITableViewDataSource>

@end

@implementation JNSYCodeLoginViewController {
    
    JNSYLabAndFldTableViewCell *PhoneCell;
    JNSYLabAndFldTableViewCell *PwdCell;
    MBProgressHUD *HUD;
}

- (void)viewWillAppear:(BOOL)animated {
    
    [super viewWillAppear:animated];
    
    self.title = @"密码登录";
    self.view.backgroundColor = [UIColor whiteColor];
    
    
}


- (void)viewDidLoad {
    [super viewDidLoad];
    
    //返回按钮
    self.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"" style:UIBarButtonItemStylePlain target:self action:nil];
    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
    
    
    UITableView *table = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, KscreenWidth, KscreenHeight) style:UITableViewStylePlain];
    table.delegate = self;
    table.dataSource = self;
    table.backgroundColor = ColorTableBack;
    table.separatorStyle = UITableViewCellSeparatorStyleNone;
    table.showsVerticalScrollIndicator = NO;
    table.scrollEnabled = NO;
    [self.view addSubview:table];
    
    UIImageView *tableFooterView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, KscreenWidth, 120)];
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
        make.height.mas_equalTo([JNSYAutoSize AutoHeight:38]);
    }];
    
    UIButton *ForgetBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [ForgetBtn setTitle:@"忘记密码?" forState:UIControlStateNormal];
    ForgetBtn.titleLabel.font = [UIFont systemFontOfSize:12];
    [ForgetBtn setBackgroundColor:[UIColor clearColor]];
    [ForgetBtn setTitleColor:[UIColor colorWithRed:126/255.0 green:126/255.0 blue:126/255.0 alpha:1] forState:UIControlStateNormal];
    [ForgetBtn addTarget:self action:@selector(ForgetBtnAction) forControlEvents:UIControlEventTouchUpInside];
    
    [tableFooterView addSubview:ForgetBtn];
    
    [ForgetBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(CommitBtn.mas_bottom).offset(2);
        make.right.equalTo(CommitBtn).offset(5);
        make.height.mas_equalTo([JNSYAutoSize AutoHeight:30]);
        make.width.mas_equalTo(80);
    }];
    
    table.tableFooterView = tableFooterView;
    
    
    
}

//登录请求
- (void)CommitAction {
    
    NSLog(@"登录");
    //空字符串判断
    if ([PhoneCell.RightFld.text isEqualToString:@""] || PhoneCell.RightFld.text == nil) {
        [self showMsg:@"手机号为空!"];
        return;
    }else if ([PwdCell.RightFld.text isEqualToString:@""] || PwdCell.RightFld.text == nil) {
        
        [self showMsg:@"密码为空!"];
        return;
        
    }

    //HUD
    HUD = [[MBProgressHUD alloc] initWithView:self.view];
    //HUD.mode = MBProgressHUDModeText;
    [self.view addSubview:HUD];
    HUD.labelText = @"登录中...";
    //[HUD showAnimated:YES];
    [HUD show:YES];
    NSDictionary *dic = @{
                          @"phone":PhoneCell.RightFld.text,
                          @"pass":PwdCell.RightFld.text,
                          @"os":@"IOS",
                          @"soft":@"JnsyApp",
                          @"version":BundleID,
                          @"imei":[JNSYAutoSize getDiviceIMEI]
                          };
    NSString *action = @"UserLoginState";
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
           
            [HUD hide:YES afterDelay:1.5];
            
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
            
            //获取广告图片
            [self getadvertiseImage];
            
            //登录环信
            
            [self loginHXIM];
            
            [self performSelector:@selector(BackToLogin) withObject:nil afterDelay:1.5];
            
        }else {
            //[HUD hideAnimated:YES];
            [HUD hide:YES];
            
            NSString *msg = resultdic[@"msg"];
            HUD.mode = MBProgressHUDModeText;
            HUD.labelText = msg;
            [HUD show:YES];
            [HUD hide:YES afterDelay:1.5];
            
        }
        
    } failure:^(NSError *error) {
        NSLog(@"%@",error);
    }];
}

//登录环信IM
- (void)loginHXIM {
    
    EMError *error = [[EMClient sharedClient] loginWithUsername:@"123" password:@"123"];
   
    if (error) {
        NSLog(@"环信IM登录失败:%@",error.errorDescription);
    }else {
        
        NSLog(@"环信登录成功!");
        
    }
    
}


//获取用户名和头像
- (void)getUserNameAndHeaderImg:(NSString *)userId {
    

    NSDictionary *dic = @{
                          @"ids":userId,
                          };
    NSString *action = @"SearchImAccountState";
    
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
            
            NSArray *array = [userId componentsSeparatedByString:@","];
            NSDictionary *infodic = resultdic[@"accountInfo"];
            for (NSInteger i = 0; i < array.count; i++) {
                NSDictionary *userDic = [infodic objectForKey:array[i]];
                NSString *userName = userDic[@"imNickname"];
                NSString *userImg = userDic[@"imHeadImg"];
                
                
                
                
            }
            
            
        }else {
            NSString *msg = resultdic[@"msg"];
            [JNSYAutoSize showMsg:msg];
        }
    } failure:^(NSError *error) {
        NSLog(@"%@",error);
    }];
    
}



//获取广告图片
- (void)getadvertiseImage {
    NSDictionary *dic = @{
                          @"adArea":@"A1001",
                          @"adSize":@"1"
                          };
    NSString *action = @"AdInfoState";
    
    NSDictionary *requestDic = @{
                                 @"action":action,
                                 @"token":[JNSYUserInfo getUserInfo].userToken,
                                 @"data":dic
                                 };
    NSString *params = [requestDic JSONFragment];
    [IBHttpTool postWithURL:JNSYTestUrl params:params success:^(id result) {
        NSDictionary *resultdic = [result JSONValue];
        NSString *code = resultdic[@"code"];
        NSLog(@"%@",resultdic);
        if([code isEqualToString:@"000000"]) {
            
            NSArray *picArray = resultdic[@"adinfoList"];
            
            if (picArray.count > 0) {
                
                //保存广告图片
                
            }
            
        }else {
            
            NSString *msg = resultdic[@"msg"];
            [JNSYAutoSize showMsg:msg];
        }
    } failure:^(NSError *error) {
        
        
    }];
}

//返回个人信息
- (void)BackToLogin {
    
    [self.navigationController popToRootViewControllerAnimated:YES];
    
}

//MD5加密
- (NSString *)md5HexDigest:(NSString*)password
{
    const char *original_str = [password UTF8String];
    unsigned char result[CC_MD5_DIGEST_LENGTH];
    CC_MD5(original_str, strlen(original_str), result);
    NSMutableString *hash = [NSMutableString string];
    for (int i = 0; i < 16; i++)
    {
        [hash appendFormat:@"%02X", result[i]];
    }
    NSString *mdfiveString = [hash lowercaseString];
    return mdfiveString;
}

- (void)ForgetBtnAction {
    
    NSLog(@"忘记密码");
    
    JNSYForgetCodeViewController *ForgetCodeVc = [[JNSYForgetCodeViewController alloc] init];
    ForgetCodeVc.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:ForgetCodeVc animated:YES];
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
            PhoneCell = [[JNSYLabAndFldTableViewCell alloc] init];
            PhoneCell.LeftLab.text = @"手机号";
            PhoneCell.RightFld.placeholder = @"请输入11位手机号码";
            PhoneCell.RightFld.keyboardType = UIKeyboardTypeNumberPad;
            //PhoneCell.RightFld.text = @"18868825142";
            cell = PhoneCell;
        }else if (indexPath.row == 2) {
            PwdCell = [[JNSYLabAndFldTableViewCell alloc] init];
            PwdCell.LeftLab.text = @"登录密码";
            PwdCell.RightFld.placeholder = @"请输入登录密码";
            PwdCell.RightFld.secureTextEntry = YES;
            //PwdCell.RightFld.text = @"123456";
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
