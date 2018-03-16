//
//  JNSYRegisterViewController.m
//  JieNiuSongYao
//
//  Created by rongfeng on 2017/6/2.
//  Copyright © 2017年 China Zhou. All rights reserved.
//

#import "JNSYRegisterViewController.h"
#import "Common.h"
#import "Masonry.h"
#import "JNSYAutoSize.h"
#import "JNSYGetCodeTableViewCell.h"
#import "JNSYLabAndFldTableViewCell.h"
#import "JNSYUserProtrolViewController.h"
#import "IBHttpTool.h"
#import <CommonCrypto/CommonDigest.h>
#import "SBJSON.h"
#import "MBProgressHUD.h"
@interface JNSYRegisterViewController ()<UITableViewDelegate,UITableViewDataSource,UITextFieldDelegate>

@end

@implementation JNSYRegisterViewController {
    
    
    NSTimer *_timer;
    NSInteger _index;
    UITableView *table;
    JNSYGetCodeTableViewCell *PhoneCell;
    JNSYLabAndFldTableViewCell *PwdCell;
    JNSYLabAndFldTableViewCell *CodeCell;
    JNSYLabAndFldTableViewCell *InviteCell;
}

- (void)viewWillAppear:(BOOL)animated {
    
    [super viewWillAppear:animated];
    
    self.title = @"账户注册";
    self.view.backgroundColor = [UIColor whiteColor];
    
}


- (void)viewDidLoad {
    [super viewDidLoad];
    
    //返回按钮
    self.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"" style:UIBarButtonItemStylePlain target:self action:nil];
    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
    
    
    table = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, KscreenWidth, KscreenHeight) style:UITableViewStylePlain];
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
    [CommitBtn setTitle:@"注册" forState:UIControlStateNormal];
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
    
    UILabel *TipsLab = [[UILabel alloc] init];
    TipsLab.text = @"*邀请码可为空";
    TipsLab.textColor = ColorTabBarback;
    TipsLab.font = [UIFont systemFontOfSize:12];
    TipsLab.textAlignment = NSTextAlignmentLeft;
    
    [tableFooterView addSubview:TipsLab];
    
    [TipsLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(tableFooterView).offset(4);
        make.left.equalTo(tableFooterView).offset(20);
        make.height.mas_equalTo([JNSYAutoSize AutoHeight:10]);
        make.width.mas_equalTo(80);
    }];
    
    
    //注册协议
    UIButton *PropolBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [PropolBtn setTitle:@"《捷牛送药用户协议》" forState:UIControlStateNormal];
    [PropolBtn setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
    PropolBtn.titleLabel.font = [UIFont systemFontOfSize:13];
    [PropolBtn addTarget:self action:@selector(PropolBtnAction) forControlEvents:UIControlEventTouchUpInside];
    [tableFooterView addSubview:PropolBtn];
    
    CGFloat width = [JNSYRegisterViewController caculateTextWidth:@"《捷牛送药用户协议》" withFont:[UIFont systemFontOfSize:13]];
    
    
    [PropolBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(CommitBtn.mas_bottom).offset(10);
        make.centerX.equalTo(CommitBtn);
        make.width.mas_equalTo(width);
        make.height.mas_equalTo([JNSYAutoSize AutoHeight:15]);
    }];
    
    
    UIButton *SelectBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [SelectBtn setImage:[UIImage imageNamed:@"未选"] forState:UIControlStateNormal];
    [SelectBtn setImage:[UIImage imageNamed:@"选中"] forState:UIControlStateSelected];
    [SelectBtn addTarget:self action:@selector(SelectBtnAction:) forControlEvents:UIControlEventTouchUpInside];
    [tableFooterView addSubview:SelectBtn];
    
    [SelectBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(PropolBtn);
        make.right.equalTo(PropolBtn.mas_left).offset(-6);
        make.width.height.mas_equalTo(15);
    }];
    
    table.tableFooterView = tableFooterView;
    
    _index = 60;
    
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return 7;
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *identy = @"identy";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identy];
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc] init];
        if (indexPath.row == 0 || indexPath.row == 3 || indexPath.row == 5) {
            cell.backgroundColor = ColorTableBack;
        }
        if (indexPath.row == 1) {
            PhoneCell = [[JNSYGetCodeTableViewCell alloc] init];
            PhoneCell.LeftLab.text = @"手机号";
            PhoneCell.rightFld.placeholder = @"请输入11位手机号码";
            __weak typeof(self) weakSelf = self;
            PhoneCell.btnActionBlock = ^(NSString *phoneStr) {
                __strong typeof(self) StrongSelf = weakSelf;
                [StrongSelf GetCode:phoneStr];
            };
            cell = PhoneCell;
        }else if (indexPath.row == 2) {
            PwdCell = [[JNSYLabAndFldTableViewCell alloc] init];
            PwdCell.LeftLab.text = @"密码";
            PwdCell.RightFld.placeholder = @"请输入6-12位数字、字母组合密码";
            PwdCell.RightFld.secureTextEntry = YES;
            PwdCell.RightFld.delegate = self;
            cell = PwdCell;
        }else if (indexPath.row == 4) {
            CodeCell = [[JNSYLabAndFldTableViewCell alloc] init];
            CodeCell.LeftLab.text = @"验证码";
            CodeCell.RightFld.placeholder = @"请输入6位验证码";
            CodeCell.RightFld.keyboardType = UIKeyboardTypeNumberPad;
            cell = CodeCell;
        }else if (indexPath.row == 6) {
            InviteCell = [[JNSYLabAndFldTableViewCell alloc] init];
            InviteCell.LeftLab.text = @"邀请码";
            InviteCell.RightFld.placeholder = @"请输入邀请码";
            InviteCell.RightFld.keyboardType = UIKeyboardTypeNumberPad;
            cell = InviteCell;
        }
        
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    return cell;
    
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.row == 0 || indexPath.row == 3 || indexPath.row == 5) {
        return 6;
    }else {
        return 40;
    }
    
}

#define mark GetNetWorkMethods
//获取验证码
- (void)GetCode:(NSString *)phoneStr {
    
    PhoneCell.GetCodeBtn.enabled = NO;
    
    if([phoneStr isEqualToString:@""] || phoneStr == nil) {
        
        [self showMsg:@"手机号不能为空！"];
        PhoneCell.GetCodeBtn.enabled = YES;
        return;
    }
    
    NSDictionary *dic = @{
                          @"phone":phoneStr
                          };
    
    NSString *action = @"UserRegisterStateSms";
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

//注册方法
- (void)CommitAction {
    
    NSLog(@"注册");
    //验证密码位数
    if(PwdCell.RightFld.text.length <= 12 && PwdCell.RightFld.text.length >= 6) {
        
    }else {
        [self showMsg:@"请输入6-12位密码!"];
        return;
    }
    //验证验证码
    if (CodeCell.RightFld.text == nil || [CodeCell.RightFld.text isEqualToString:@""]) {
        [self showMsg:@"验证码为空!"];
        return;
    }
    //验证手机号
    if ([PhoneCell.rightFld.text isEqualToString:@""] || PhoneCell.rightFld.text == nil) {
        [self showMsg:@"手机号为空!"];
        return;
    }
    //邀请码
    NSString *org = @"";
    if ([InviteCell.RightFld.text isEqualToString:@""] || InviteCell.RightFld.text == nil) {
        org = @"";
    }else {
        org = InviteCell.RightFld.text;
    }
    //版本号
    NSString  *version = [[[NSBundle mainBundle] infoDictionary] objectForKey:(NSString *)kCFBundleVersionKey];
    //imei
    //获取UUID
    NSString *imsi = [[[UIDevice currentDevice] identifierForVendor] UUIDString];
    NSString *UUID = [self md5HexDigest:imsi];
    NSString *UUID16 = [[UUID substringFromIndex:8] substringToIndex:16];
    
    //发送注册请求
    
    NSDictionary *dic = @{
                          @"phone":PhoneCell.rightFld.text,
                          @"code":CodeCell.RightFld.text,
                          @"pass":PwdCell.RightFld.text,
                          @"org":org,
                          @"os":@"IOS",
                          @"soft":@"JnsyApp",
                          @"version":version,
                          @"imei":UUID16
                          };
    NSString *action = @"UserRegisterState";
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
            
            [self showMsg:@"注册成功!"];
            
            [self performSelector:@selector(BackToLogin) withObject:nil afterDelay:2];
            
        }else {
            NSString *msg = resultdic[@"msg"];
            [self showMsg:msg];
        }
        
    } failure:^(NSError *error) {
        NSLog(@"%@",error);
    }];
    
}

#define OtherMethods

//返回登录
- (void)BackToLogin {
    
    [self.navigationController popViewControllerAnimated:YES];
    
}

//计算字符串的宽度
+ (CGFloat)caculateTextWidth:(NSString *)text withFont:(UIFont *)font
{
    text = [text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    
    //    if ([XHSegmentItem isStringEmpty:text]) {
    //        return 0;
    //    }
    
    NSDictionary *attribute = @{NSFontAttributeName:font};
    
    CGRect newRect = [text boundingRectWithSize:CGSizeMake(CGFLOAT_MAX, font.pointSize) options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading attributes:attribute context:nil];
    
    text = nil;
    return newRect.size.width;
}

//点击注册协议
- (void)PropolBtnAction {
    
    NSLog(@"注册协议");
    
    JNSYUserProtrolViewController *UserProtrolVc = [[JNSYUserProtrolViewController alloc] init];
    UserProtrolVc.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:UserProtrolVc animated:YES];
    
}


//勾选注册协议
- (void)SelectBtnAction:(UIButton *)sender {
    
    sender.selected = !sender.selected;
    NSLog(@"同意");
    
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
