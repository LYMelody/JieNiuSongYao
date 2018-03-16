//
//  JNSYMoreDrugsViewController.m
//  JieNiuSongYao
//
//  Created by rongfeng on 2017/5/25.
//  Copyright © 2017年 China Zhou. All rights reserved.
//

#import "JNSYMoreDrugsViewController.h"
#import "Common.h"
#import "JNSYCollectionTableViewCell.h"
#import "UIImageView+WebCache.h"
#import "JNSYUserInfo.h"
#import "SBJSON.h"
#import "IBHttpTool.h"
#import "JNSYAutoSize.h"
#import "JNSYMedicineModel.h"
#import "JNSYMedicineDetailViewController.h"
#import "MBProgressHUD.h"
@interface JNSYMoreDrugsViewController ()<UITableViewDelegate,UITableViewDataSource>

@end

@implementation JNSYMoreDrugsViewController


- (void)viewWillAppear:(BOOL)animated {
    
    [super viewWillAppear:animated];
    
    self.title = @"更多药品";
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    [self.navigationController setNavigationBarHidden:NO animated:YES];
    //self.navigationController.navigationBar.hidden = NO;
    self.navigationController.navigationBar.barTintColor = ColorTabBarback;
    
    self.navigationController.navigationBar.translucent = NO;
}

- (void)viewDidLoad {
    [super viewDidLoad];

    UITableView *table = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, KscreenWidth, KscreenHeight - 64) style:UITableViewStylePlain];
    table.delegate = self;
    table.dataSource = self;
    table.backgroundColor = ColorTableBack;
    table.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    [self.view addSubview:table];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return self.medicineArray.count;
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *identy = @"identy";
    
    JNSYCollectionTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identy];
    if (cell == nil) {
        
        NSDictionary *dic = self.medicineArray[indexPath.row];
        
        cell = [[JNSYCollectionTableViewCell alloc] init];
        cell.drugNameLab.text = dic[@"medicinesName"];;
        [cell.leftImgView sd_setImageWithURL:[NSURL URLWithString:dic[@"medicinesPic1"]]];
        cell.drugCotentLab.text = dic[@"medicinesSpecifications"];
        cell.drugBelongLab.text = dic[@"medicinesBrand"];;
        cell.drugPriceLab.text =  [NSString stringWithFormat:@"￥%d",[dic[@"medicinesPrice"] integerValue]/100];
        NSString *prePrice = [NSString stringWithFormat:@"￥%d",[dic[@"medicinesPriceDiscount"] integerValue]/100];
        NSMutableAttributedString *attribtstr = [[NSMutableAttributedString alloc] initWithString:prePrice];
        [attribtstr setAttributes:@{NSStrikethroughStyleAttributeName:[NSNumber numberWithInteger:NSUnderlineStyleSingle],NSBaselineOffsetAttributeName : @(NSUnderlineStyleSingle)} range:NSMakeRange(0, prePrice.length)];
        cell.drugPrePriceLab.attributedText = attribtstr;
        cell.drugStoreLab.text = dic[@"shopName"];
        cell.drugStoreDistanceLab.text = [self setDistance:dic[@"distancen"]];
        cell.DelectBtn.hidden = YES;
        
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
    
    
}




- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    return 100;
    
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    NSDictionary *dic = self.medicineArray[indexPath.row];
    
    NSString *medicineId = dic[@"medicinesId"];
    
    [self getMedicineDetail:medicineId];
}


//获取药品详情
- (void)getMedicineDetail:(NSString *)medicinesId {
    
    MBProgressHUD *HUD = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    
    NSDictionary *dic = @{
                          @"medicinesId":medicinesId
                          };
    NSString *action = @"ShopMedicinesDetailState";
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
            
            JNSYMedicineModel *model = [[JNSYMedicineModel alloc] init];
            model.medicinesId = resultdic[@"medicinesId"];
            model.medicinesType = resultdic[@"medicinesType"];
            model.medicinesName = resultdic[@"medicinesName"];
            model.medicinesBrand = resultdic[@"medicinesBrand"];
            model.medicinesLicense = resultdic[@"medicinesLicense"];
            model.medicinesPriceDiscount = resultdic[@"medicinesPriceDiscount"];
            model.medicinesSpecifications = resultdic[@"medicinesSpecifications"];
            model.medicinesPrice = resultdic[@"medicinesPrice"];
            model.medicinesUsage = resultdic[@"medicinesUsage"];
            model.medicinesComponent = resultdic[@"medicinesComponent"];
            model.medicinesFunction = resultdic[@"medicinesFunction"];
            model.medicinesInstructions = resultdic[@"medicinesInstructions"];
            model.medicinesPic1 = resultdic[@"medicinesPic1"];
            model.medicinesPic2 = resultdic[@"medicinesPic2"];
            model.medicinesPic3 = resultdic[@"medicinesPic3"];
            model.medicinesPic4 = resultdic[@"medicinesPic4"];
            model.medicinesPic5 = resultdic[@"medicinesPic5"];
            model.isCollect = [NSString stringWithFormat:@"%@",resultdic[@"isCollect"]];
            
            JNSYMedicineDetailViewController *MedicineDetailVc = [[JNSYMedicineDetailViewController alloc] init];
            MedicineDetailVc.hidesBottomBarWhenPushed = YES;
            MedicineDetailVc.medicineModel = model;
            [self.navigationController pushViewController:MedicineDetailVc animated:YES];
            
            [HUD hide:YES];
        }else {
            NSString *msg = resultdic[@"msg"];
            [JNSYAutoSize showMsg:msg];
            [HUD hide:YES];
        }
        
    } failure:^(NSError *error) {
        NSLog(@"%@",error);
        
        
        [HUD hide:YES];
    }];
    
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
