//
//  JNSYSetPayPwdViewController.m
//  JieNiuSongYao
//
//  Created by rongfeng on 2017/6/30.
//  Copyright © 2017年 China Zhou. All rights reserved.
//

#import "JNSYSetPayPwdViewController.h"
#import "Common.h"
#import "JNSYUserInfo.h"
#import "JNSYAutoSize.h"
#import "IBHttpTool.h"
#import "SBJSON.h"
#import "Masonry.h"
#import "JNSYLabAndFldTableViewCell.h"
#import "MBProgressHUD.h"
@interface JNSYSetPayPwdViewController ()<UITableViewDelegate,UITableViewDataSource>

@end

@implementation JNSYSetPayPwdViewController {
    
    JNSYLabAndFldTableViewCell *CodeCell;
    JNSYLabAndFldTableViewCell *QueCell;
}

- (void)viewWillAppear:(BOOL)animated {
    
    
    [super viewWillAppear:animated];
    
    self.title = @"设置密码";
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
    [CommitBtn setTitle:@"提交" forState:UIControlStateNormal];
    CommitBtn.layer.cornerRadius = 5;
    CommitBtn.layer.masksToBounds = YES;
    [CommitBtn addTarget:self action:@selector(CommintAction) forControlEvents:UIControlEventTouchUpInside];
    [tableFooterView addSubview:CommitBtn];
    
    [CommitBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(tableFooterView).offset(30);
        make.right.equalTo(tableFooterView).offset(-30);
        make.top.equalTo(tableFooterView).offset(50);
        make.height.mas_equalTo(36);
    }];
    
    table.tableFooterView = tableFooterView;

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
            CodeCell = [[JNSYLabAndFldTableViewCell alloc] init];
            CodeCell.LeftLab.text = @"支付密码";
            CodeCell.RightFld.placeholder = @"请输入6位支付密码";
            CodeCell.RightFld.secureTextEntry = YES;
            cell = CodeCell;
            
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
    
    
    if(indexPath.row == 0) {
        return 6;
    }
    
    return 44;
    
}

//提交
- (void)CommintAction {
    
    if ([CodeCell.RightFld.text isEqualToString:@""] || CodeCell.RightFld.text == nil) {
        [JNSYAutoSize showMsg:@"密码为空！"];
        return;
    }else if ([QueCell.RightFld.text isEqualToString:@""] || QueCell.RightFld.text == nil) {
        [JNSYAutoSize showMsg:@"确认密码为空!"];
        return;
    }else if(CodeCell.RightFld.text != QueCell.RightFld.text){
        [JNSYAutoSize showMsg:@"两次输入的密码不一致!"];
        return;
    }
    
    MBProgressHUD *HUD = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    HUD.labelText = @"信息提交中";
    NSDictionary *dic = @{
                          @"newPass":CodeCell.RightFld.text,
                          
                          };
    NSString *action = @"UserPayPassStateNew";
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
            
            //[HUD hideAnimated:YES];
            [HUD hide:YES];
            
            HUD.mode = MBProgressHUDModeText;
            HUD.labelText = @"设置密码成功!";
//            [HUD showAnimated:YES];
//            [HUD hideAnimated:YES afterDelay:1.5];
            
            [HUD show:YES];
            [HUD hide:YES afterDelay:1.5];
            
            [self performSelector:@selector(BackToLogin) withObject:nil afterDelay:1.5];
            
            [JNSYUserInfo getUserInfo].isSetPayPwd = YES;
        }else {
            NSString *msg = resultdic[@"msg"];
            [JNSYAutoSize showMsg:msg];
            //[HUD hideAnimated:YES];
            [HUD hide:YES];
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
