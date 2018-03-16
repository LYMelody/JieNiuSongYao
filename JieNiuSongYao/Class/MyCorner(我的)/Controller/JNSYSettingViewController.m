//
//  JNSYSettingViewController.m
//  JieNiuSongYao
//
//  Created by rongfeng on 2017/5/16.
//  Copyright © 2017年 China Zhou. All rights reserved.
//

#import "JNSYSettingViewController.h"
#import "Common.h"
#import "Masonry.h"
#import "JNSYMeCommonCell.h"
#import "JNSYReceivePlaceViewController.h"
#import "JNSYReSetResignCodeViewController.h"
#import "JNSYReSetPayCodeViewController.h"
#import "JNSYLoginViewController.h"
#import "JNSYAutoSize.h"
#import "JNSYUserInfo.h"
#import "JNSYSetPayPwdViewController.h"
@interface JNSYSettingViewController ()<UITableViewDelegate,UITableViewDataSource>

@end

@implementation JNSYSettingViewController {
    
    NSString *appCurVersion;
    
    
}

- (void)viewWillAppear:(BOOL)animated {
    
    [super viewWillAppear:animated];
    
    self.title = @" 设置";
    self.view.backgroundColor = [UIColor whiteColor];
    
    //返回按钮
    self.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"" style:UIBarButtonItemStylePlain target:self action:nil];
    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
    
    [self.navigationController setNavigationBarHidden:NO animated:YES];
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    UITableView *table = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, KscreenWidth, KscreenHeight) style:UITableViewStylePlain];
    table.delegate = self;
    table.dataSource = self;
    table.tableFooterView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 0, CGFLOAT_MIN)];
    table.separatorStyle = UITableViewCellSeparatorStyleNone;
    table.showsVerticalScrollIndicator = NO;
    table.backgroundColor = ColorTableBack;
    
    UIImageView *tablefootView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, KscreenWidth, 200)];
    tablefootView.backgroundColor = ColorTableBack;
    tablefootView.userInteractionEnabled = YES;
    
    UIButton *QuitBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [QuitBtn setTitle:@"退出登录" forState:UIControlStateNormal];
    [QuitBtn setBackgroundColor:[UIColor redColor]];
    QuitBtn.layer.cornerRadius = 5;
    QuitBtn.layer.masksToBounds = YES;
    QuitBtn.titleLabel.font = [UIFont systemFontOfSize:14];
    [QuitBtn addTarget:self action:@selector(Quit) forControlEvents:UIControlEventTouchUpInside];
    
    [tablefootView addSubview:QuitBtn];
    
    if ([JNSYUserInfo getUserInfo].isLoggedIn) {
        QuitBtn.hidden = NO;
    }else {
        QuitBtn.hidden = YES;
    }
    
    [QuitBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(tablefootView).offset(30);
        make.left.equalTo(tablefootView).offset(30);
        make.right.equalTo(tablefootView).offset(-30);
        make.height.mas_equalTo(35);
    }];
    
    table.tableFooterView = tablefootView;
    
    [self.view addSubview:table];
    
    //版本号
    NSDictionary *infoDic = [[NSBundle mainBundle] infoDictionary];
    appCurVersion = [infoDic objectForKey:@"CFBundleShortVersionString"];
    
}

- (void)Quit {
    
    NSLog(@"退出登录");
    
    [JNSYUserInfo getUserInfo].isLoggedIn = NO;
    [JNSYUserInfo getUserInfo].userKey = KEY;
    [JNSYUserInfo getUserInfo].userToken = TOKEN;
    [JNSYUserInfo getUserInfo].picHeader = nil;
    [self.navigationController popViewControllerAnimated:YES];
    
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return 7;
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *identy = @"identy";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identy];
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc] init];
        if (indexPath.row == 0) {
            cell.backgroundColor = ColorTableBack;
        }else if (indexPath.row == 1) {
            JNSYMeCommonCell *Cell = [[JNSYMeCommonCell alloc] init];
            Cell.leftLab.text = @"收货地址";
            cell = Cell;
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
            
        }else if (indexPath.row == 2) {
            JNSYMeCommonCell *Cell = [[JNSYMeCommonCell alloc] init];
            Cell.leftLab.text = @"登录密码";
            cell = Cell;
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
            
        }else if (indexPath.row == 3) {
            JNSYMeCommonCell *Cell = [[JNSYMeCommonCell alloc] init];
            Cell.leftLab.text = @"支付密码";
            cell = Cell;
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
            
        }else if (indexPath.row == 4) {
            cell.backgroundColor = ColorTableBack;
        }else if (indexPath.row == 5) {
            JNSYMeCommonCell *Cell = [[JNSYMeCommonCell alloc] init];
            Cell.leftLab.text = @"意见反馈";
            cell = Cell;
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
            
        }else if (indexPath.row == 6) {
            JNSYMeCommonCell *Cell = [[JNSYMeCommonCell alloc] init];
            Cell.leftLab.text = @"当前版本";
            Cell.rightLab.text = appCurVersion;
            cell = Cell;
        }
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.row == 0 || indexPath.row == 4) {
        return 10;
    }else {
        return 44;
    }
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    //判断是否登录
    if ([JNSYUserInfo getUserInfo].isLoggedIn) {
    
    }else {
        
        JNSYLoginViewController *LoginVc = [[JNSYLoginViewController alloc] init];
        LoginVc.LogIntag = 2;
        LoginVc.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:LoginVc animated:YES];
        
        return;
    }
    
    if (indexPath.row == 1) {   //收货地址
        JNSYReceivePlaceViewController *ReceiveVc = [[JNSYReceivePlaceViewController alloc] init];
        
        ReceiveVc.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:ReceiveVc animated:YES];
    }else if (indexPath.row == 2) {   //修改登录密码
        JNSYReSetResignCodeViewController *ReSetCode = [[JNSYReSetResignCodeViewController alloc] init];
        ReSetCode.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:ReSetCode animated:YES];
    }else if (indexPath.row == 3) {   //设置、修改支付密码
        
        JNSYSetPayPwdViewController *SetPayPwdVc = [[JNSYSetPayPwdViewController alloc] init];
        SetPayPwdVc.hidesBottomBarWhenPushed = YES;
        
        JNSYReSetPayCodeViewController *ReSetPayVc = [[JNSYReSetPayCodeViewController alloc] init];
        ReSetPayVc.hidesBottomBarWhenPushed = YES;
        
        [JNSYUserInfo getUserInfo].isSetPayPwd = YES;
        
        if ([JNSYUserInfo getUserInfo].isSetPayPwd) {
            [self.navigationController pushViewController:ReSetPayVc animated:YES];
        }else {
            [self.navigationController pushViewController:SetPayPwdVc animated:YES];
        }
        
        
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
