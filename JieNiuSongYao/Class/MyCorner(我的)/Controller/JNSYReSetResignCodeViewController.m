//
//  JNSYReSetResignCodeViewController.m
//  JieNiuSongYao
//
//  Created by rongfeng on 2017/5/17.
//  Copyright © 2017年 China Zhou. All rights reserved.
//

#import "JNSYReSetResignCodeViewController.h"
#import "Common.h"
#import "Masonry.h"
#import "JNSYGetCodeTableViewCell.h"
#import "JNSYLabAndFldTableViewCell.h"
#import "JNSYAutoSize.h"
#import "JNSYUserInfo.h"
#import "IBHttpTool.h"
#import "SBJSON.h"
#import "MBProgressHUD.h"
@interface JNSYReSetResignCodeViewController ()<UITableViewDelegate,UITableViewDataSource>

@end

@implementation JNSYReSetResignCodeViewController {
    
    JNSYGetCodeTableViewCell *PhoneCell;
    JNSYLabAndFldTableViewCell *CodeCell;
    JNSYLabAndFldTableViewCell *PwdCell;
    NSTimer *_timer;
    NSInteger _index;
}

- (void)viewWillAppear:(BOOL)animated {
    
    [super viewWillAppear:animated];
    
    self.title = @"修改登录密码";
    
    self.view.backgroundColor = [UIColor whiteColor];
    
}


- (void)viewDidLoad {
    [super viewDidLoad];
    
    UITableView *table = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, KscreenWidth, KscreenHeight) style:UITableViewStylePlain];
    table.delegate = self;
    table.dataSource = self;
    table.separatorStyle = UITableViewCellSeparatorStyleNone;
    table.showsVerticalScrollIndicator = NO;
    table.backgroundColor = ColorTableBack;
    table.tableFooterView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 0, CGFLOAT_MIN)];
    table.scrollEnabled = NO;
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
    
    return 3;
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *identy = @"identy";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identy];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] init];
        if (indexPath.row == 0) {
            PhoneCell = [[JNSYGetCodeTableViewCell alloc] init];
            PhoneCell.rightFld.text = [[JNSYUserInfo getUserInfo].userPhone stringByReplacingCharactersInRange:NSMakeRange(3, ([JNSYUserInfo getUserInfo].userPhone.length - 7)) withString:@"****"];
            PhoneCell.LeftLab.text = @"当前账户为";
            PhoneCell.rightFld.enabled = NO;
            __weak typeof(self) weakSelf = self;
            PhoneCell.btnActionBlock = ^(NSString *phoneStr) {
                __strong typeof(self) strongSelf = weakSelf;
                [strongSelf getCode:phoneStr];
            };
            cell = PhoneCell;
        }else if (indexPath.row == 1) {
            CodeCell = [[JNSYLabAndFldTableViewCell alloc] init];
            CodeCell.LeftLab.text = @"验证码";
            CodeCell.RightFld.placeholder = @"请输入验证码";
            CodeCell.RightFld.keyboardType = UIKeyboardTypeNumberPad;
            cell = CodeCell;
        }else if (indexPath.row == 2) {
            PwdCell = [[JNSYLabAndFldTableViewCell alloc] init];
            PwdCell.LeftLab.text = @"新密码";
            PwdCell.RightFld.placeholder = @"6-12位数字、字母组合密码";
            PwdCell.RightFld.secureTextEntry = YES;
            cell = PwdCell;
        }
        
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
    
}

- (void)getCode:(NSString *)phoneStr {
    
    if([phoneStr isEqualToString:@""] || phoneStr == nil) {
        
        [JNSYAutoSize showMsg:@"手机号为空!"];
        return;
    }
    
    NSDictionary *dic = @{
                          @"timestamp":[JNSYAutoSize getTimeNow]
                          };
    
    NSString *action = @"UserLoginPassStateSms";
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

//
- (void)CommitAction {
    
    
    if([PwdCell.RightFld.text isEqualToString:@""] || PwdCell.RightFld.text == nil) {
        
        [JNSYAutoSize showMsg:@"密码为空!"];
        return;
    }else if ([CodeCell.RightFld.text isEqualToString:@""] || CodeCell.RightFld.text == nil) {
        
        [JNSYAutoSize showMsg:@"验证码为空!"];
        return;
    }
    
    NSDictionary *dic = @{
                          
                          @"code":CodeCell.RightFld.text,
                          @"pass":PwdCell.RightFld.text
                          };
    NSString *action = @"UserLoginPassState";
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
            
            
            MBProgressHUD *HUD = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
            HUD.mode = MBProgressHUDModeText;
            HUD.labelText = @"修改密码成功!";
           // [HUD hideAnimated:YES afterDelay:1.5];
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
