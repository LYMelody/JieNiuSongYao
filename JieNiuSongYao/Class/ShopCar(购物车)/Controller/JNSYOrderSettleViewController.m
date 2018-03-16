//
//  JNSYOrderSettleViewController.m
//  JieNiuSongYao
//
//  Created by rongfeng on 2017/6/15.
//  Copyright © 2017年 China Zhou. All rights reserved.
//

#import "JNSYOrderSettleViewController.h"
#import "Common.h"
#import "Masonry.h"
#import "JNSYAutoSize.h"
#import "JNSYOrderPlaceTableViewCell.h"
#import "JNSYPayMethodTableViewCell.h"
#import "JNSYOrderHeaderView.h"
#import "JNSYOrderMedicineTableViewCell.h"
#import "JNSYOrderTotalPriceTableViewCell.h"
#import "JNSYOrderBottomView.h"
#import "JNSYOrderScoreTableViewCell.h"
#import "JNSYReceivePlaceViewController.h"
#import "JNSYOrderPayMeathodViewController.h"
#import "JNSYDeliverWaysViewController.h"
#import "JNSYPayCenterViewController.h"
#import "UIViewController+BackButtonHandler.h"
@interface JNSYOrderSettleViewController ()<UITableViewDelegate,UITableViewDataSource,BackButtonHandlerProtocol,UIAlertViewDelegate>

@end

@implementation JNSYOrderSettleViewController {
    
    JNSYOrderBottomView *bottomView;
    UITableView *table;
    NSUserDefaults *User;
}

- (void)viewWillAppear:(BOOL)animated {
    
    [super viewWillAppear:animated];
    
    self.title = @"订单结算";
    self.view.backgroundColor = [UIColor whiteColor];
    //返回按钮
    self.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"" style:UIBarButtonItemStylePlain target:self action:nil];
    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
    self.navigationController.navigationBar.translucent = YES;
   
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //初始化UserDefault
    User = [NSUserDefaults standardUserDefaults];
    [User setObject:@"联名信用卡" forKey:@"PayMedthod"];
    [User setBool:NO forKey:@"ScoreBtnSelection"];
    [User synchronize];

    for(NSInteger j = 1;j < 3;j++) {
        
        [User setObject:@"送药上门" forKey:[NSString stringWithFormat:@"Deliver%ld",(long)j]];
        [User synchronize];
    }
    
    //初始化tableview
    table = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStyleGrouped];
    table.delegate = self;
    table.dataSource = self;
    table.showsVerticalScrollIndicator = NO;
    table.separatorStyle = UITableViewCellSeparatorStyleNone;
    table.sectionFooterHeight = 8;
    table.tableFooterView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 0, CGFLOAT_MIN)];
    table.tableHeaderView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 0, CGFLOAT_MIN)];
    [self.view addSubview:table];
    
    [table mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.view);
        make.top.equalTo(self.view).offset(2);
        make.bottom.equalTo(self.view).offset(-45);
    }];
    
    //添加底部视图
    [self addButtomView];
    
}

#define mark TableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return 3;
    
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    if (section == 0) {
        return 2;
    }else if (section == 1){
        return 4;
    }else if (section == 2) {
        return 3 + 1;
    }else {
        return 4;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        if (indexPath.row == 0) {
            return 60;
        }else if (indexPath.row == 1) {
            return 40;
        }else {
            return 60;
        }
    }else {
        
        if (indexPath.section == 1) {
            if (indexPath.row == 0 || indexPath.row == 1 ) {
                return 60;
            }else if (indexPath.row == 2) {
                return 40;
            }else {
                return 60;
            }
        }else if (indexPath.section == 2) {
            if (indexPath.row == 0) {
                return 60;
            }else if (indexPath.row == 1) {
                return 40;
            }else if(indexPath.row == 2){
                return 60;
            }else {
                return 40;
            }
        }else {
            return 60;
        }
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *identy = @"identy";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identy];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] init];
        if (indexPath.section == 0) {
            if (indexPath.row == 0) {
                JNSYOrderPlaceTableViewCell *Cell = [[JNSYOrderPlaceTableViewCell alloc] init];
                Cell.nameLab.text = @"陈奕迅";
                Cell.phoneLab.text = @"1886888888";
                Cell.placeLab.text = @"浙江省杭州市西湖区延安路";
                cell = Cell;
                cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
            }else if (indexPath.row == 1) {
                
                JNSYPayMethodTableViewCell *Cell = [[JNSYPayMethodTableViewCell alloc] init];
                Cell.MethodsLab.text = [User objectForKey:@"PayMedthod"];
                cell = Cell;
                cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
            }
        }else {
            if(indexPath.section == 1) {
                if (indexPath.row == 0 || indexPath.row == 1) {
                    JNSYOrderMedicineTableViewCell *Cell = [[JNSYOrderMedicineTableViewCell alloc] init];
                    Cell.nameLab.text = @"999牌平炎平止咳糖浆达克宁";
                    Cell.contentLab.text = @"10ml*6支/盒";
                    Cell.belongLab.text = @"葵花药业";
                    Cell.priceLab.text = @"￥15.9";
                    NSString *prePrice = @"23";
                    NSMutableAttributedString *attribtstr = [[NSMutableAttributedString alloc] initWithString:prePrice];
                    [attribtstr setAttributes:@{NSStrikethroughStyleAttributeName:[NSNumber numberWithInteger:NSUnderlineStyleSingle],NSBaselineOffsetAttributeName : @(NSUnderlineStyleSingle)} range:NSMakeRange(0, prePrice.length)];
                    Cell.prePriceLab.attributedText = attribtstr;
                    
                    Cell.numLab.text = @"x4";
                    cell = Cell;
                    cell.selectionStyle = UITableViewCellSelectionStyleNone;
                }else if (indexPath.row == 2) {
                    JNSYPayMethodTableViewCell *Cell = [[JNSYPayMethodTableViewCell alloc] init];
                    Cell.PayMethodLab.text = @"配送方式：";
                    Cell.MethodsLab.text = [User objectForKey:[NSString stringWithFormat:@"Deliver%ld",(long)indexPath.section]];
                    cell = Cell;
                    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
                }else {
                    JNSYOrderTotalPriceTableViewCell *Cell = [[JNSYOrderTotalPriceTableViewCell alloc] init];
                    Cell.totalNumberLab.text = @"共4件";
                    Cell.totalPriceLab.text = @"商品总额：￥99";
                    NSString *disCountStr = @"折扣价：￥99";
                    NSMutableAttributedString *attributedStr = [[NSMutableAttributedString alloc] initWithString:disCountStr];
                    [attributedStr addAttributes:@{
                                                  NSForegroundColorAttributeName:[UIColor redColor]
                                                  }range:NSMakeRange(4, disCountStr.length - 4)];
                    Cell.disCountLab.attributedText = attributedStr;
                    Cell.deliverLab.text = @"配送费用：￥8";
                    Cell.finalPriceLab.text = @"合   计：100";
                    cell = Cell;
                }
            }else if (indexPath.section == 2) {
                if (indexPath.row == 0) {
                    JNSYOrderMedicineTableViewCell *Cell = [[JNSYOrderMedicineTableViewCell alloc] init];
                    Cell.nameLab.text = @"999牌平炎平止咳糖浆达克宁";
                    Cell.contentLab.text = @"10ml*6支/盒";
                    Cell.belongLab.text = @"葵花药业";
                    Cell.priceLab.text = @"￥15.9";
                    NSString *prePrice = @"23";
                    NSMutableAttributedString *attributedStr = [[NSMutableAttributedString alloc] initWithString:prePrice];
                    [attributedStr addAttributes:@{NSStrikethroughStyleAttributeName:[NSNumber numberWithInteger:NSUnderlineStyleSingle],NSBaselineOffsetAttributeName:@(NSUnderlineStyleSingle)} range:NSMakeRange(0, prePrice.length)];
                    Cell.prePriceLab.attributedText = attributedStr;
                    Cell.numLab.text = @"x4";
                    cell = Cell;
                    cell.selectionStyle = UITableViewCellSelectionStyleNone;
                }else if (indexPath.row == 1) {
                    JNSYPayMethodTableViewCell *Cell = [[JNSYPayMethodTableViewCell alloc] init];
                    Cell.PayMethodLab.text = @"配送方式：";
                    Cell.MethodsLab.text = [User objectForKey:[NSString stringWithFormat:@"Deliver%ld",(long)indexPath.section]];
                    cell = Cell;
                    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
                }else if(indexPath.row == 2){
                    JNSYOrderTotalPriceTableViewCell *Cell = [[JNSYOrderTotalPriceTableViewCell alloc] init];
                    Cell.totalNumberLab.text = @"共4件";
                    Cell.totalPriceLab.text = @"商品总额：￥99";
                    NSString *disCountStr = @"折扣价：￥99";
                    NSMutableAttributedString *attributedStr = [[NSMutableAttributedString alloc] initWithString:disCountStr];
                    [attributedStr addAttributes:@{
                                                   NSForegroundColorAttributeName:[UIColor redColor]
                                                   }range:NSMakeRange(4, disCountStr.length - 4)];
                    Cell.disCountLab.attributedText = attributedStr;
                    Cell.deliverLab.text = @"配送费用：￥8";
                    Cell.finalPriceLab.text = @"合   计：￥100";
                    cell = Cell;
                }else {
                    JNSYOrderScoreTableViewCell *Cell = [[JNSYOrderScoreTableViewCell alloc] init];
                    Cell.avaiableLab.text = @"可用积分：120分(1积分抵扣0.01元)";
                    Cell.selectBtn.selected = [User boolForKey:@"ScoreBtnSelection"];
                    Cell.scoreSelectBlock = ^(UIButton *btn) {
                        if (btn.isSelected) {
                            [bottomView configureTotalPrice:@"总额:￥98.80" score:@"积分抵扣￥1.20"];
                            [User setBool:YES forKey:@"ScoreBtnSelection"];
                            [User synchronize];
                        }else {
                            [bottomView configureTotalPrice:@"总额:￥100.00" score:@""];
                            [User setBool:NO forKey:@"ScoreBtnSelection"];
                            [User synchronize];
                        }
                    };
                    cell = Cell;
                }
            }
            
        }
        
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    
    static NSString *identy = @"orderHeaderView";
    JNSYOrderHeaderView *header = [tableView dequeueReusableHeaderFooterViewWithIdentifier:identy];
    
    if(section == 0) {
        return nil;
    }else {
        if (header == nil) {
            JNSYOrderHeaderView *HeaderView = [[JNSYOrderHeaderView alloc] init];
            HeaderView.storeLab.text = @"杭州大药房";
            HeaderView.orderLab.text = @"20170615101010";
            return HeaderView;
        }else {
            return header;
        }
    }

}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    
    if (section == 0) {
        return 0;
    }else {
        return 40;
    }

}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.section == 0) {
        if (indexPath.row == 0) { //收货地址
            JNSYReceivePlaceViewController *ReceiveVc = [[JNSYReceivePlaceViewController alloc] init];
            ReceiveVc.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:ReceiveVc animated:YES];
        }else if (indexPath.row == 1) { //付款方式
            JNSYOrderPayMeathodViewController *OrderMeathodVc = [[JNSYOrderPayMeathodViewController alloc] init];
            
            NSString *method = [User objectForKey:@"PayMedthod"];
            if ([method isEqualToString:@"联名信用卡"]) {
                OrderMeathodVc.currentSelect = 0;
            }else if ([method isEqualToString:@"支付宝"]) {
               OrderMeathodVc.currentSelect = 1;
            }else if ([method isEqualToString:@"微信"]) {
                OrderMeathodVc.currentSelect = 2;
            }else if ([method isEqualToString:@"现金"]) {
                OrderMeathodVc.currentSelect = 3;
            }
            
            OrderMeathodVc.orderPayMedthodBlock = ^(NSString *payMedthod) {
                JNSYPayMethodTableViewCell *cell = (JNSYPayMethodTableViewCell *)[table cellForRowAtIndexPath:indexPath];
                cell.MethodsLab.text = payMedthod;
                [User setObject:payMedthod forKey:@"PayMedthod"];
                [User synchronize];
            };
            OrderMeathodVc.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:OrderMeathodVc animated:YES];
        }
    }else if ((indexPath.section == 1 && indexPath.row == 2) || (indexPath.section == 2 && indexPath.row == 1)) {
        
        JNSYDeliverWaysViewController *PayMeathodVc = [[JNSYDeliverWaysViewController alloc] init];
        PayMeathodVc.currentDeliverSelect = ([[User objectForKey:[NSString stringWithFormat:@"Deliver%ld",(long)indexPath.section]] isEqualToString:@"药店自取"])?2:1;
        PayMeathodVc.deliverSelectBlock = ^(NSString *DeliverMedthod) {
            JNSYPayMethodTableViewCell *cell = (JNSYPayMethodTableViewCell *)[table cellForRowAtIndexPath:indexPath];
            cell.MethodsLab.text = DeliverMedthod;
            [User setObject:DeliverMedthod forKey:[NSString stringWithFormat:@"Deliver%ld",(long)indexPath.section]];
            [User synchronize];
            //获取总额的indexPath和CELL
            NSIndexPath *index = [NSIndexPath indexPathForRow:(indexPath.row +1) inSection:indexPath.section];
            
            JNSYOrderTotalPriceTableViewCell *PriceCell = (JNSYOrderTotalPriceTableViewCell *)[table cellForRowAtIndexPath:index];
            NSString *deliverPrice = @"配送费：￥0";
            NSString *finalPrice = @"合   计：99";
            //改变单个订单金额
            if ([DeliverMedthod isEqualToString:@"药店自取"]) {
                
            }else {
                deliverPrice = @"配送费：￥8";
                finalPrice = @"合   计：100";
            }
            PriceCell.deliverLab.text = deliverPrice;
            PriceCell.finalPriceLab.text = finalPrice;
            
            //变更所有订单总额
            [bottomView configureTotalPrice:@"总额:￥99"];
        };
        PayMeathodVc.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:PayMeathodVc animated:YES];
    }
}

//设置底部视图
- (void)addButtomView {
    
    bottomView = [[JNSYOrderBottomView alloc] init];
    bottomView.backgroundColor = [UIColor whiteColor];
    [bottomView configureTotalPrice:@"总额:￥100.00" score:@""];
    
    __weak typeof(self) WeakSelf = self;
    
    bottomView.commitOrderBlock = ^{
        
        __strong typeof(self) StrongSelf = WeakSelf;
        JNSYPayCenterViewController *PayCenterVc = [[JNSYPayCenterViewController alloc] init];
        UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:PayCenterVc];
        PayCenterVc.hidesBottomBarWhenPushed = YES;
        [StrongSelf presentViewController:nav animated:YES completion:nil];
    };
    [self.view addSubview:bottomView];
    
    [bottomView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.equalTo(self.view);
        make.height.mas_equalTo(45);
    }];

}
//返回按钮点击事件
- (BOOL)navigationShouldPopOnBackButton {
    
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:@"药到病除，早用早好！" delegate:self cancelButtonTitle:@"暂不购买" otherButtonTitles:@"继续购买", nil];
    
    [alert show];
    return NO;
    
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    
    if (buttonIndex == 0) {
        
        [self.navigationController popViewControllerAnimated:YES];
        
    }else {
        
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
