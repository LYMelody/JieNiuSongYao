//
//  JNSYReSetPayCodeViewController.m
//  
//
//  Created by rongfeng on 2017/5/17.
//
//

#import "JNSYReSetPayCodeViewController.h"
#import "Common.h"
#import "Masonry.h"
#import "JNSYGetCodeTableViewCell.h"
#import "JNSYLabAndFldTableViewCell.h"
#import "JNSYForgetPwdViewController.h"
#import "JNSYAutoSize.h"
#import "JNSYUserInfo.h"
#import "IBHttpTool.h"
#import "SBJSON.h"
#import "MBProgressHUD.h"
@interface JNSYReSetPayCodeViewController ()<UITableViewDelegate,UITableViewDataSource>

@end

@implementation JNSYReSetPayCodeViewController {
    
    JNSYGetCodeTableViewCell *OldPwdCell;
    JNSYLabAndFldTableViewCell *NewPwdCell;
    JNSYLabAndFldTableViewCell *QueCell;
}

- (void)viewWillAppear:(BOOL)animated {
    
    [super viewWillAppear:animated];
    
    self.title = @"修改支付密码";
    self.view.backgroundColor = ColorTableBack;
    
    
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
    
    
    UIImageView *tableFooterView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, KscreenWidth, 100)];
    tableFooterView.backgroundColor = ColorTableBack;
    tableFooterView.userInteractionEnabled = YES;
    
    UIButton *CommitBtn = [[UIButton alloc] init];
    CommitBtn.backgroundColor = ColorTabBarback;
    [CommitBtn setTitle:@"确认" forState:UIControlStateNormal];
    CommitBtn.layer.cornerRadius = 5;
    CommitBtn.layer.masksToBounds = YES;
    [CommitBtn addTarget:self action:@selector(KeppAction) forControlEvents:UIControlEventTouchUpInside];
    [tableFooterView addSubview:CommitBtn];
    
    [CommitBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(tableFooterView).offset(30);
        make.right.equalTo(tableFooterView).offset(-30);
        make.top.equalTo(tableFooterView).offset(50);
        make.height.mas_equalTo(36);
    }];
    
    table.tableFooterView = tableFooterView;
    
}

//保存按钮方法
- (void)KeppAction {
    
    
    if ([OldPwdCell.rightFld.text isEqualToString:@""] || OldPwdCell.rightFld.text == nil) {
        [JNSYAutoSize showMsg:@"旧密码为空!"];
        return;
    }else if ([NewPwdCell.RightFld.text isEqualToString:@""] || NewPwdCell.RightFld.text == nil) {
        [JNSYAutoSize showMsg:@"新密码为空!"];
        return;
    }else if ([QueCell.RightFld.text isEqualToString:@""] || QueCell.RightFld.text == nil ) {
        [JNSYAutoSize showMsg:@"确认密码为空!"];
        return;
    }else if ( NewPwdCell.RightFld.text != QueCell.RightFld.text) {
        [JNSYAutoSize showMsg:@"两次输入的密码不一致!"];
        return;
    }
    
    NSDictionary *dic = @{
                          
                          @"oldPass":OldPwdCell.rightFld.text,
                          @"newPass":NewPwdCell.RightFld.text
                          };
    NSString *action = @"UserPayPassStateChg";
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
    
    NSLog(@"保存");
    
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
            OldPwdCell = [[JNSYGetCodeTableViewCell alloc] init];
            OldPwdCell.LeftLab.text = @"旧密码";
            OldPwdCell.rightFld.placeholder = @"请输入原6位支付密码";
            OldPwdCell.rightFld.secureTextEntry = YES;
            [OldPwdCell.GetCodeBtn setTitle:@"忘记密码" forState:UIControlStateNormal];
            __weak typeof(self) weakSelf = self;
            
            OldPwdCell.btnActionBlock = ^(NSString *phoneStr) {
                JNSYForgetPwdViewController *ForgetPwd = [[JNSYForgetPwdViewController alloc] init];
                ForgetPwd.hidesBottomBarWhenPushed = YES;
                __strong typeof(self) strongSelf = weakSelf;
                [strongSelf.navigationController pushViewController:ForgetPwd animated:YES];
                NSLog(@"忘记密码");
            };
            cell = OldPwdCell;
        }else if (indexPath.row == 1) {
            NewPwdCell = [[JNSYLabAndFldTableViewCell alloc] init];
            NewPwdCell.LeftLab.text = @"新密码";
            NewPwdCell.RightFld.placeholder = @"请输入6位支付密码";
            NewPwdCell.RightFld.secureTextEntry = YES;
            cell = NewPwdCell;
            
        }else if (indexPath.row == 2) {
            
            QueCell = [[JNSYLabAndFldTableViewCell alloc] init];
            QueCell.LeftLab.text = @"确认密码";
            QueCell.RightFld.placeholder = @"请再次输入6位支付密码";
            QueCell.RightFld.secureTextEntry = YES;
            cell = QueCell;
        }
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    return 44;
    
}

//返回上一级
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
