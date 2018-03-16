//
//  JNSYMoreStoresViewController.m
//  JieNiuSongYao
//
//  Created by rongfeng on 2017/5/25.
//  Copyright © 2017年 China Zhou. All rights reserved.
//

#import "JNSYMoreStoresViewController.h"
#import "Common.h"
#import "Masonry.h"
#import "JNSYSearchDrugStoreTableViewCell.h"
#import "UIImageView+WebCache.h"
#import "JNSYDrugStoreDetailViewController.h"

@interface JNSYMoreStoresViewController ()<UITableViewDelegate,UITableViewDataSource>

@end

@implementation JNSYMoreStoresViewController

- (void)viewWillAppear:(BOOL)animated {
    
    [super viewWillAppear:animated];
    
    self.title = @"更多药店";
    
    self.view.backgroundColor = [UIColor whiteColor];
    [self.navigationController setNavigationBarHidden:NO animated:YES];
    //self.navigationController.navigationBar.hidden = NO;
    self.navigationController.navigationBar.barTintColor = ColorTabBarback;
    self.navigationController.navigationBar.translucent = NO;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    
    //返回按钮
    self.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"" style:UIBarButtonItemStylePlain target:self action:nil];
    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
    
    UITableView *table = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, KscreenWidth, KscreenHeight - 64) style:UITableViewStylePlain];
    table.delegate = self;
    table.dataSource = self;
    table.backgroundColor = ColorTableBack;
    table.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    [self.view addSubview:table];
    
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return self.drugStoreArray.count;
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *identy = @"identy";
    
    JNSYSearchDrugStoreTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identy];
    if (cell == nil) {
        
        NSDictionary *dic = self.drugStoreArray[indexPath.row];
        
        cell = [[JNSYSearchDrugStoreTableViewCell alloc] init];
        cell.serviceArry = @[@"药师咨询",@"会员折扣",@"支持医保",@"满减活动"];
        cell.serviceArry = ([dic[@"shopService"] class] != [NSNull class])?[dic[@"shopService"] componentsSeparatedByString:@","]:nil;
        [cell setUpViews];
        cell.StoreNameLab.text = dic[@"shopName"];
        cell.TimeLab.text = [NSString stringWithFormat:@"%@-%@",dic[@"startTime"],dic[@"endTime"]];
        cell.RatingLab.text = [NSString stringWithFormat:@"评分:%@分",dic[@"shopScore"]];
        cell.DistanceLab.text = [self setDistance:dic[@"distancen"]];
        cell.PlaceLab.text = dic[@"shopAddress"];
        [cell.StoreImg sd_setImageWithURL:[NSURL URLWithString:dic[@"picComp1"]]];
        
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    return 80;
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    
    JNSYDrugStoreDetailViewController *DrugStoredetailVc = [[JNSYDrugStoreDetailViewController alloc] init];
    DrugStoredetailVc.hidesBottomBarWhenPushed = YES;
    //设置药店的shopID
    DrugStoredetailVc.shopId = [NSString stringWithFormat:@"%@",self.drugStoreArray[indexPath.row][@"shopId"]];
    DrugStoredetailVc.shopName = [NSString stringWithFormat:@"%@",self.drugStoreArray[indexPath.row][@"shopName"]];
    [self.navigationController pushViewController:DrugStoredetailVc animated:YES];

    
}



//设置距离
- (NSString *)setDistance:(NSString *)distance {
    
    
    if (distance.length >= 4) {
        distance = [NSString stringWithFormat:@"%@km",[distance substringWithRange:NSMakeRange(0, distance.length - 3)]];
    }else {
        distance = [NSString stringWithFormat:@"%@m",distance];
    }
    
    return distance;
    
    
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
