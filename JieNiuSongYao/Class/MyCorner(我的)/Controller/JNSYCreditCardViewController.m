//
//  JNSYCreditCardViewController.m
//  JieNiuSongYao
//
//  Created by rongfeng on 2017/5/18.
//  Copyright © 2017年 China Zhou. All rights reserved.
//

#import "JNSYCreditCardViewController.h"
#import "Common.h"
#import "Masonry.h"
#import "JNSYLabAndFldTableViewCell.h"
#import "JNSYListHeaderTableViewCell.h"
#import "JNSYVipCodeViewController.h"
#import "JNSYAutoSize.h"
#import "JNSYUserInfo.h"
#import "IBHttpTool.h"
#import "SBJSON.h"
#import "MBProgressHUD.h"
@interface JNSYCreditCardViewController ()<UITableViewDataSource,UITableViewDelegate,UITextFieldDelegate>

@end

@implementation JNSYCreditCardViewController {
    
    JNSYLabAndFldTableViewCell *CardCell;
    JNSYLabAndFldTableViewCell *YXQCell;
    JNSYLabAndFldTableViewCell *SafeCell;
    JNSYLabAndFldTableViewCell *NameCell;
    JNSYLabAndFldTableViewCell *CertCell;
    JNSYLabAndFldTableViewCell *PhoneCell;
    NSString *CardNum;
    NSString *YXQ;
    NSString *SafeCode;
    NSString *Name;
    NSString *CertNum;
    NSString *PhoneNum;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
//    CardNum = @"6258091653275896";
//    YXQ = @"0221";
//    SafeCode = @"667";
//    Name = @"周辉平";
//    CertNum = @"362424199210035912";
//    PhoneNum = @"18868825142";
    
    CardNum = @"";
    YXQ = @"";
    SafeCode = @"";
    Name = @"";
    CertNum = @"";
    PhoneNum = @"";
    
    self.title = @"联名信用卡";
    
    //返回按钮
    self.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"" style:UIBarButtonItemStylePlain target:self action:nil];
    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
    
    
    UITableView *table = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, KscreenWidth, KscreenHeight  ) style:UITableViewStylePlain];
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
    [CommitBtn setTitle:@"下一步" forState:UIControlStateNormal];
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
    
    
    
    if (CertNum == nil || YXQ == nil || SafeCode == nil || Name == nil || CertNum == nil || PhoneNum == nil) {
        [JNSYAutoSize showMsg:@"信息填写不完全!"];
        return;
    }
    
    NSDictionary *dic = @{
                          @"phone":PhoneNum
                          
                          };
    NSString *action = @"UserCardBindStateSms";
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
            
            
            JNSYVipCodeViewController *VipCode = [[JNSYVipCodeViewController alloc] init];
            VipCode.CardNUm = CardNum;
            VipCode.YXQ = YXQ;
            VipCode.SafeCode = SafeCode;
            VipCode.Name = Name;
            VipCode.CertNum = CertNum;
            VipCode.PhoneNum = PhoneNum;
            VipCode.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:VipCode animated:YES];
            
        }else {
            NSString *msg = resultdic[@"msg"];
            [JNSYAutoSize showMsg:msg];
        }
        
    } failure:^(NSError *error) {
        NSLog(@"%@",error);
    }];
    
    
    
    
    NSLog(@"下一步");
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 11;
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    NSString *identy = [NSString stringWithFormat:@"cell-%ld",indexPath.row];
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identy];
    
    //UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc] init];
        if (indexPath.row == 0) {
            cell.backgroundColor = ColorTableBack;
        }else if (indexPath.row == 1) {
            JNSYListHeaderTableViewCell *Cell = [[JNSYListHeaderTableViewCell alloc] init];
            Cell.leftLab.text = @"请填写银行卡信息";
            cell = Cell;
        }else if (indexPath.row == 2){
            CardCell = [[JNSYLabAndFldTableViewCell alloc] init];
            CardCell.LeftLab.text = @"卡号";
            CardCell.RightFld.placeholder = @"请输入银行卡号";
            CardCell.RightFld.tag = 100;
            CardCell.RightFld.text = CardNum;
            CardCell.RightFld.delegate = self;
            CardCell.RightFld.keyboardType = UIKeyboardTypeNumberPad;
            cell = CardCell;
        }else if (indexPath.row == 3) {
            YXQCell = [[JNSYLabAndFldTableViewCell alloc] init];
            YXQCell.LeftLab.text = @"有效期";
            YXQCell.RightFld.placeholder = @"请输入有限期，月/年";
            YXQCell.RightFld.tag = 101;
            YXQCell.RightFld.text = YXQ;
            YXQCell.RightFld.delegate = self;
            YXQCell.RightFld.keyboardType = UIKeyboardTypeNumberPad;
            cell = YXQCell;
        }else if (indexPath.row == 4) {
            SafeCell = [[JNSYLabAndFldTableViewCell alloc] init];
            SafeCell.LeftLab.text = @"安全码";
            SafeCell.RightFld.placeholder = @"请输入背面三位数";
            SafeCell.RightFld.tag = 102;
            SafeCell.RightFld.text = SafeCode;
            SafeCell.RightFld.delegate = self;
            SafeCell.RightFld.keyboardType = UIKeyboardTypeNumberPad;
            cell = SafeCell;
        }else if (indexPath.row == 5) {
            cell.backgroundColor = ColorTableBack;
        }else if (indexPath.row == 6) {
            JNSYListHeaderTableViewCell *Cell = [[JNSYListHeaderTableViewCell alloc] init];
            Cell.leftLab.text = @"请填写银行预留信息";
            cell = Cell;
        }else if (indexPath.row == 7) {
            NameCell = [[JNSYLabAndFldTableViewCell alloc] init];
            NameCell.LeftLab.text = @"姓名";
            NameCell.RightFld.placeholder = @"请输入姓名";
            NameCell.RightFld.tag = 103;
            NameCell.RightFld.text = Name;
            NameCell.RightFld.delegate = self;
            
            cell = NameCell;
        }else if (indexPath.row == 8) {
            JNSYLabAndFldTableViewCell *Cell = [[JNSYLabAndFldTableViewCell alloc] init];
            Cell.LeftLab.text = @"证件类型";
            Cell.RightFld.text = @"身份证";
            Cell.RightFld.enabled = NO;
            cell = Cell;
        }else if (indexPath.row == 9) {
            CertCell = [[JNSYLabAndFldTableViewCell alloc] init];
            CertCell.LeftLab.text = @"证件号码";
            CertCell.RightFld.placeholder = @"请输入身份证号码";
            CertCell.RightFld.tag = 104;
            CertCell.RightFld.text = CertNum;
            CertCell.RightFld.delegate = self;
            cell = CertCell;
        }else if (indexPath.row == 10) {
            PhoneCell = [[JNSYLabAndFldTableViewCell alloc] init];
            PhoneCell.LeftLab.text = @"预留手机号";
            PhoneCell.RightFld.placeholder = @"请输入预留手机号";
            PhoneCell.RightFld.tag = 105;
            PhoneCell.RightFld.text = PhoneNum;
            PhoneCell.RightFld.delegate = self;
            PhoneCell.RightFld.keyboardType = UIKeyboardTypeNumberPad;
            cell = PhoneCell;
        }
            
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.row == 0 || indexPath.row == 5) {
        return 5;
    }else {
        return 44;
    }
    
}


- (void)textFieldDidEndEditing:(UITextField *)textField {
    
    if (textField.tag == 100) {
        CardNum = textField.text;
    }else if (textField.tag == 101) {
        YXQ = textField.text;
    }else if (textField.tag == 102) {
        SafeCode = textField.text;
    }else if (textField.tag == 103) {
        Name = textField.text;
    }else if (textField.tag == 104) {
        CertNum = textField.text;
    }else if (textField.tag == 105) {
        PhoneNum = textField.text;
    }
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
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
