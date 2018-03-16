//
//  JNSYVipViewController.m
//  JieNiuSongYao
//
//  Created by rongfeng on 2017/5/17.
//  Copyright © 2017年 China Zhou. All rights reserved.
//

#import "JNSYVipViewController.h"
#import "Common.h"
#import "Masonry.h"
#import "JNSYMeCommonCell.h"
#import "JNSYVipDetailTableViewCell.h"
#import "JNSYBindCardViewController.h"
#import "JNSYCreditCardViewController.h"
#import "JNSYAutoSize.h"
#import "JNSYUserInfo.h"
#import "JNSYBindCardListViewController.h"
@interface JNSYVipViewController ()<UITableViewDelegate,UITableViewDataSource>

@end

@implementation JNSYVipViewController {
    
    UITableView *table;
    
}

- (void)viewWillAppear:(BOOL)animated {
    
    [super viewWillAppear:animated];
    
    self.title = @"会员卡";
    self.view.backgroundColor = [UIColor whiteColor];
    
    [self.navigationController setNavigationBarHidden:NO animated:YES];
    
    [table reloadData];
}


- (void)viewDidLoad {
    [super viewDidLoad];
    
    //返回按钮
    self.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"" style:UIBarButtonItemStylePlain target:self action:nil];
    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
    
    table = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, KscreenWidth, KscreenHeight)];
    table.delegate = self;
    table.dataSource = self;
    table.backgroundColor = ColorTableBack;
    table.showsVerticalScrollIndicator = NO;
    //table.scrollEnabled = NO;
    table.separatorStyle = UITableViewCellSeparatorStyleNone;
    table.tableFooterView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 0, CGFLOAT_MIN)];
    
    [self.view addSubview:table];

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
            JNSYMeCommonCell *Cell = [[JNSYMeCommonCell alloc] init];
            Cell.leftLab.text = @"绑定会员卡";
            if ([[JNSYUserInfo getUserInfo].branderCardFlg isEqual:@1]) {//已绑卡
                Cell.rightLab.text = [NSString stringWithFormat:@"已绑定(尾号%@)",[[JNSYUserInfo getUserInfo].branderCardNo substringFromIndex:([JNSYUserInfo getUserInfo].branderCardNo.length - 4)]];
                Cell.rightLab.textColor = GreenColor;
            }else {
                Cell.rightLab.text = @"未绑定";
                Cell.rightLab.textColor = [UIColor redColor];;
            }
            cell = Cell;
        }else if (indexPath.row == 1) {
            JNSYVipDetailTableViewCell *Cell = [[JNSYVipDetailTableViewCell alloc] init];
            Cell.leftLab.text = @"申请联名信用卡";
            Cell.detailLab.text = @"联名信用卡付款高额优惠";
            cell = Cell;
        }
//        else if (indexPath.row == 2) {
//            JNSYMeCommonCell *Cell = [[JNSYMeCommonCell alloc] init];
//            Cell.leftLab.text = @"申请联名借记卡";
//            cell = Cell;
//        }
    }
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.row == 0) {
        
        if ([[JNSYUserInfo getUserInfo].branderCardFlg isEqual:@1]) { //已绑卡跳转会员卡详情
            JNSYBindCardListViewController *CardDetailVc = [[JNSYBindCardListViewController alloc] init];
            CardDetailVc.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:CardDetailVc animated:YES];
        }else {  //绑卡页面
            JNSYCreditCardViewController *BindCardVc = [[JNSYCreditCardViewController alloc] init];
            BindCardVc.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:BindCardVc animated:YES];
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
