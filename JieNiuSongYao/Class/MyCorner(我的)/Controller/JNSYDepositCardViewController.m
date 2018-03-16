//
//  JNSYDepositCardViewController.m
//  JieNiuSongYao
//
//  Created by rongfeng on 2017/5/18.
//  Copyright © 2017年 China Zhou. All rights reserved.
//

#import "JNSYDepositCardViewController.h"
#import "Common.h"
#import "JNSYListHeaderTableViewCell.h"
#import "JNSYLabAndFldTableViewCell.h"
#import "Common.h"
#import "Masonry.h"
#import "JNSYVipCodeViewController.h"


@interface JNSYDepositCardViewController ()<UITableViewDelegate,UITableViewDataSource>

@end

@implementation JNSYDepositCardViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    //self.view.backgroundColor = [UIColor redColor];
    
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
    
    JNSYVipCodeViewController *ViopCode = [[JNSYVipCodeViewController alloc] init];
    ViopCode.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:ViopCode animated:YES];
    
    
    
    NSLog(@"下一步");
    
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return 7;
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *identy = @"identy";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identy];
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc] init];
        if(indexPath.row == 0) {
            cell.backgroundColor = ColorTableBack;
        }
        if (indexPath.row == 1) {
            JNSYListHeaderTableViewCell *Cell = [[JNSYListHeaderTableViewCell alloc] init];
            Cell.leftLab.text = @"请填写银行卡信息";
            cell = Cell;
        }else if (indexPath.row == 2) {
            JNSYLabAndFldTableViewCell *Cell = [[JNSYLabAndFldTableViewCell alloc] init];
            Cell.LeftLab.text = @"姓名";
            Cell.RightFld.placeholder = @"请输入姓名";
            cell = Cell;
            
        }else if (indexPath.row == 3) {
            JNSYLabAndFldTableViewCell *Cell = [[JNSYLabAndFldTableViewCell alloc] init];
            Cell.LeftLab.text = @"证件类型";
            Cell.RightFld.text = @"身份证";
            Cell.RightFld.enabled = NO;
            cell = Cell;
        }else if (indexPath.row == 4) {
            JNSYLabAndFldTableViewCell *Cell = [[JNSYLabAndFldTableViewCell alloc] init];
            Cell.LeftLab.text = @"证件号码";
            Cell.RightFld.placeholder= @"请输入身份证";
            cell = Cell;
            
        }else if (indexPath.row == 5) {
            JNSYLabAndFldTableViewCell *Cell = [[JNSYLabAndFldTableViewCell alloc] init];
            Cell.LeftLab.text = @"卡号";
            Cell.RightFld.placeholder = @"请输入银行卡号";
            cell =Cell;
        }
        else if (indexPath.row == 6) {
            JNSYLabAndFldTableViewCell *Cell = [[JNSYLabAndFldTableViewCell alloc] init];
            Cell.LeftLab.text = @"预留手机号";
            Cell.RightFld.placeholder = @"请输入银行预留手机号";
            cell =Cell;
        }
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.row == 0) {
        return 5;
    }else {
        return 44;
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
