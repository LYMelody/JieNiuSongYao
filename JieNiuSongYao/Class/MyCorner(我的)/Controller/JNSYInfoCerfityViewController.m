//
//  JNSYInfoCerfityViewController.m
//  JieNiuSongYao
//
//  Created by rongfeng on 2017/5/17.
//  Copyright © 2017年 China Zhou. All rights reserved.
//

#import "JNSYInfoCerfityViewController.h"
#import "Common.h"
#import "Masonry.h"
#import "JNSYLabAndFldTableViewCell.h"
#import "JNSYAutoSize.h"
#import "JNSYUserInfo.h"
#import "IBHttpTool.h"
#import "SBJSON.h"
#import "MBProgressHUD.h"

@interface JNSYInfoCerfityViewController ()<UITableViewDelegate,UITableViewDataSource>

@end

@implementation JNSYInfoCerfityViewController {
    
    JNSYLabAndFldTableViewCell *NameCell;
    JNSYLabAndFldTableViewCell *CertCell;
    
}

- (void)viewWillAppear:(BOOL)animated {
    
    [super viewWillAppear:animated];
    
    self.title = @"实名认证";
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    [self.navigationController setNavigationBarHidden:NO animated:YES];
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
    UIImageView *tableFooterView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, KscreenWidth, 100)];
    tableFooterView.backgroundColor = ColorTableBack;
    tableFooterView.userInteractionEnabled = YES;
    
    UILabel *TipsLab = [[UILabel alloc] init];
    TipsLab.text = @"认证信息将用于支付密码找回。";
    TipsLab.textColor = [UIColor redColor];
    TipsLab.font = [UIFont systemFontOfSize:12];
    TipsLab.textAlignment = NSTextAlignmentLeft;
    [tableFooterView addSubview:TipsLab];
    [TipsLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(tableFooterView).offset(5);
        make.left.equalTo(tableFooterView).offset(20);
        make.width.mas_equalTo(200);
        make.height.mas_equalTo(15);
    }];
    
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
    
    if (self.isCertify) {
        table.tableFooterView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 0, CGFLOAT_MIN)];
    }
    
    
    [self.view addSubview:table];
    
    
    
}

//提交认证
- (void)CommitAction {
    
    
    MBProgressHUD *HUD = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    
    
    if ([NameCell.RightFld.text isEqualToString:@""] || NameCell.RightFld.text == nil) {
        [JNSYAutoSize showMsg:@"姓名为空!"];
        [HUD hide:YES];
        return;
    }else if ([CertCell.RightFld.text isEqualToString:@""] || CertCell.RightFld.text == nil) {
        [JNSYAutoSize showMsg:@"身份证为空!"];
        [HUD hide:YES];
        return;
    }
    
    NSDictionary *dic = @{
                          @"userAccount":NameCell.RightFld.text,
                          @"userCert":CertCell.RightFld.text
                          };
    
    NSString *action = @"UserRealInfoAddState";
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
            
            [HUD hide:YES];
            HUD.labelText = @"认证成功!";
            HUD.mode = MBProgressHUDModeText;
//            [HUD showAnimated:YES];
//            [HUD hideAnimated:YES afterDelay:1.5];
            
            [HUD show:YES];
            [HUD hide:YES afterDelay:1.5];
            
            [self performSelector:@selector(backToBeforeVc) withObject:nil afterDelay:1.5];
            
        }else {
            
            [JNSYAutoSize showMsg:msg];
            [HUD hide:YES];
        }
        
    } failure:^(NSError *error) {
        NSLog(@"%@",error);
        [HUD hide:YES];
    }];
    
    NSLog(@"提交");
    
}


- (void)backToBeforeVc {
    
    [self.navigationController popViewControllerAnimated:YES];
    
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 2;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *identy = @"identy";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identy];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] init];
        if (indexPath.row == 0) {
            NameCell = [[JNSYLabAndFldTableViewCell alloc] init];
            NameCell.LeftLab.text = @"姓名";
            NameCell.RightFld.placeholder = @"请输入姓名";
            if (self.isCertify) {
                NameCell.RightFld.text = [self.userAccount stringByReplacingCharactersInRange:NSMakeRange(0, 1) withString:@"*"];
                NameCell.RightFld.enabled = NO;
            }
            cell = NameCell;
            
        }else if (indexPath.row == 1) {
            CertCell = [[JNSYLabAndFldTableViewCell alloc] init];
            CertCell.LeftLab.text = @"身份证号";
            CertCell.RightFld.placeholder = @"请输入身份证号";
            if (self.isCertify) {
                CertCell.RightFld.text = [self.userCert stringByReplacingCharactersInRange:NSMakeRange(6, (self.userCert.length - 10)) withString:@"********"];
                CertCell.RightFld.enabled = NO;
            }
            cell = CertCell;
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
