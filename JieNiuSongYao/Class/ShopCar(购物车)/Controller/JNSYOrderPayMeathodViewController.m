//
//  JNSYOrderPayMeathodViewController.m
//  JieNiuSongYao
//
//  Created by rongfeng on 2017/6/16.
//  Copyright © 2017年 China Zhou. All rights reserved.
//

#import "JNSYOrderPayMeathodViewController.h"
#import "Common.h"
#import "Masonry.h"
#import "JNSYOrderPayMethodTableViewCell.h"
@interface JNSYOrderPayMeathodViewController ()<UITableViewDelegate,UITableViewDataSource>

@end

@implementation JNSYOrderPayMeathodViewController {
    NSArray *titleArray;
    NSArray *subTitleArray;
    UITableView *table;
}

- (void)viewWillAppear:(BOOL)animated {
    
    self.title = @"付款方式";
    self.view.backgroundColor = [UIColor whiteColor];
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _currentSelect = self.currentSelect;
    
    titleArray = @[@"联名信用卡",@"支付宝",@"微信",@"现金"];
    subTitleArray = @[@"9.8折优惠（葵花药品9.5折）",@"9.8折优惠（葵花药品9.5折）",@"",@"",@""];
    table = [[UITableView alloc] initWithFrame:CGRectMake(0, 2, KscreenWidth, KscreenHeight) style:UITableViewStylePlain];
    table.delegate = self;
    table.dataSource = self;
    table.backgroundColor = ColorTableBack;
    table.showsVerticalScrollIndicator = NO;
    table.scrollEnabled = NO;
    table.separatorStyle = UITableViewCellSeparatorStyleNone;
    table.tableHeaderView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 0, CGFLOAT_MIN)];
    table.tableFooterView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 0, CGFLOAT_MIN)];
    [self.view addSubview:table];
    
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return 4;
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *identy = @"identy";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identy];
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc] init];
        JNSYOrderPayMethodTableViewCell *Cell = [[JNSYOrderPayMethodTableViewCell alloc] init];
        Cell.leftLab.text = titleArray[indexPath.row];
        Cell.rightLab.text = subTitleArray[indexPath.row];
        
        __weak typeof(self) WeakSelf = self;
        __weak typeof(Cell) WeakCell = Cell;
        Cell.payMedthodSelectBlock = ^{
            _currentSelect = indexPath.row;
            __strong typeof(self) StrongSelf = WeakSelf;
            __strong typeof(Cell) StrongCell = WeakCell;
            if (StrongSelf.orderPayMedthodBlock) {
                StrongSelf.orderPayMedthodBlock(StrongCell.leftLab.text);
            };
            [tableView reloadData];
        };
        
        if (indexPath.row == _currentSelect) {
            [Cell.selectBtn setImage:[UIImage imageNamed:@"送药方式-选取"] forState:UIControlStateNormal];
        }else {
            [Cell.selectBtn setImage:[UIImage imageNamed:@"送药方式-未选取"] forState:UIControlStateNormal];
        }
        
        cell = Cell;
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
