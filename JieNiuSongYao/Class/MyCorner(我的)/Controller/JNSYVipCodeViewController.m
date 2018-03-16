//
//  JNSYVipCodeViewController.m
//  JieNiuSongYao
//
//  Created by rongfeng on 2017/5/18.
//  Copyright © 2017年 China Zhou. All rights reserved.
//

#import "JNSYVipCodeViewController.h"
#import "Common.h"
#import "Masonry.h"
#import "JNSYListHeaderTableViewCell.h"
#import "JNSYLabAndFldTableViewCell.h"
#import "JNSYBindSucceedViewController.h"
#import "JNSYAutoSize.h"
#import "JNSYUserInfo.h"
#import "IBHttpTool.h"
#import "SBJSON.h"
#import "MBProgressHUD.h"

@interface JNSYVipCodeViewController ()<UITableViewDelegate,UITableViewDataSource>

@end

@implementation JNSYVipCodeViewController {
    
    JNSYLabAndFldTableViewCell *CodeCell;
    
}

- (void)viewWillAppear:(BOOL)animated {
    
    [super viewWillAppear:animated];
    
    self.title = @"绑定会员卡";
    
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
    
    
    UIImageView *tableFooterView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, KscreenWidth, 100)];
    tableFooterView.backgroundColor = ColorTableBack;
    tableFooterView.userInteractionEnabled = YES;
    
    UIButton *CommitBtn = [[UIButton alloc] init];
    CommitBtn.backgroundColor = ColorTabBarback;
    [CommitBtn setTitle:@"绑定" forState:UIControlStateNormal];
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
    
    [self.view addSubview:table];

    
}

- (void)CommitAction {
    
    
    if ([CodeCell.RightFld.text isEqualToString:@""] || CodeCell.RightFld.text == nil) {
        [JNSYAutoSize showMsg:@"验证码为空!"];
        return;
    }
    
    
    
    NSDictionary *dic = @{
                          @"smsCode":CodeCell.RightFld.text,
                          @"cardNo":self.CardNUm,
                          @"cardYxq":self.YXQ,
                          @"cardCvv":self.SafeCode,
                          @"cardAccount":self.Name,
                          @"cardPhone":self.PhoneNum,
                          @"cardCert":self.CertNum
                          };
    NSString *action = @"UserCardBindState";
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
            
            JNSYBindSucceedViewController *BingSucceed = [[JNSYBindSucceedViewController alloc] init];
            BingSucceed.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:BingSucceed animated:YES];
            
        }else {
            NSString *msg = resultdic[@"msg"];
            [JNSYAutoSize showMsg:msg];
        }
        
    } failure:^(NSError *error) {
        NSLog(@"%@",error);
    }];
    
    
    NSLog(@"绑定");
    
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return 2;
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *identy = @"identy";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identy];
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc] init];
        if (indexPath.row == 0) {
            
            JNSYListHeaderTableViewCell *Cell = [[JNSYListHeaderTableViewCell alloc] init];
            Cell.leftLab.text = [NSString stringWithFormat:@"验证码已发送至预留手机(尾号%@)",[self.PhoneNum substringFromIndex:7]];
            cell = Cell;
        }else if (indexPath.row == 1) {
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
