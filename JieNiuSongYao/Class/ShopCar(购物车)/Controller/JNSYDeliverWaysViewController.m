//
//  JNSYDeliverWaysViewController.m
//  JieNiuSongYao
//
//  Created by rongfeng on 2017/6/16.
//  Copyright © 2017年 China Zhou. All rights reserved.
//

#import "JNSYDeliverWaysViewController.h"
#import "Common.h"
#import "Masonry.h"
#import "JNSYOrderPayMethodTableViewCell.h"
@interface JNSYDeliverWaysViewController ()<UITableViewDelegate,UITableViewDataSource>

@end

@implementation JNSYDeliverWaysViewController {
    
    NSArray *titleArray;
    
    
}

- (void)viewWillAppear:(BOOL)animated {
    
    [super viewWillAppear:animated];
    
    self.title = @"配送方式";
    self.view.backgroundColor = [UIColor whiteColor];
}


- (void)viewDidLoad {
    [super viewDidLoad];
    
    _currentDeliverSelect = self.currentDeliverSelect;
    
    titleArray = @[@"送药上门",@"药店自取"];
    
    UITableView *table = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, KscreenWidth, KscreenHeight) style:UITableViewStylePlain];
    table.delegate = self;
    table.dataSource = self;
    table.showsVerticalScrollIndicator = NO;
    table.backgroundColor = ColorTableBack;
    table.scrollEnabled = NO;
    table.separatorStyle = UITableViewCellSeparatorStyleNone;
    table.tableFooterView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 0, CGFLOAT_MIN)];
    table.tableHeaderView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 0, CGFLOAT_MIN)];
    [self.view addSubview:table];
    
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
        }else {
            JNSYOrderPayMethodTableViewCell *Cell = [[JNSYOrderPayMethodTableViewCell alloc] init];
            Cell.leftLab.text = titleArray[(indexPath.row - 1)];
            
            __weak typeof(self) WeakSelf = self;
            __weak typeof(Cell) WeakCell = Cell;
            Cell.payMedthodSelectBlock = ^{
                _currentDeliverSelect = indexPath.row;
                __strong typeof(self) strongSelf = WeakSelf;
                __strong typeof(Cell) strongCell = WeakCell;
                if(strongSelf.deliverSelectBlock) {
                    strongSelf.deliverSelectBlock(strongCell.leftLab.text);
                }
                [tableView reloadData];
            };
            if (_currentDeliverSelect == indexPath.row) {
                [Cell.selectBtn setImage:[UIImage imageNamed:@"送药方式-选取"] forState:UIControlStateNormal];
            }else {
                [Cell.selectBtn setImage:[UIImage imageNamed:@"送药方式-未选取"] forState:UIControlStateNormal];
            }
            cell = Cell;
        }
        
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.row == 0) {
        return 0;
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
