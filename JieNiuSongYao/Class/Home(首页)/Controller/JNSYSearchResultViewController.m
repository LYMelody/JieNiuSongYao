//
//  JNSYSearchResultViewController.m
//  JieNiuSongYao
//
//  Created by rongfeng on 2017/5/24.
//  Copyright © 2017年 China Zhou. All rights reserved.
//

#import "JNSYSearchResultViewController.h"
#import "Common.h"
#import "Masonry.h"
#import "JNSYCollectionTableViewCell.h"
#import "JNSYMeCommonCell.h"
#import "JNSYSearchDrugStoreTableViewCell.h"
#import "JNSYSearchDetailViewController.h"
#import "JNSYSearchStoreModel.h"
#import "JNSYMoreStoresViewController.h"
#import "JNSYMoreDrugsViewController.h"
#import "JNSYDrugStoreDetailViewController.h"
#import "JNSYMedicineDetailViewController.h"
#import "UIImageView+WebCache.h"
#import "JNSYAutoSize.h"
#import "JNSYUserInfo.h"
#import "SBJSON.h"
#import "IBHttpTool.h"
#import "JNSYMedicineModel.h"
#import "MBProgressHUD.h"
@interface JNSYSearchResultViewController ()<UITableViewDelegate,UITableViewDataSource>

@end

@implementation JNSYSearchResultViewController

- (void)viewWillAppear:(BOOL)animated {
    
    [super viewWillAppear:animated];
    
    

    
    [self.navigationController setNavigationBarHidden:NO animated:YES];
    
//    if((!self.DrugArray || (self.DrugArray.count == 0)) && (!self.DrugStoreArray || self.DrugStoreArray == 0)) {
//        
//        self.table.hidden = YES;
//        
//    }else {
//        
//        self.table.hidden = NO;
//    }
    
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //返回按钮
    self.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"" style:UIBarButtonItemStylePlain target:self action:nil];
    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
    
    
    
    
    _table = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, KscreenWidth, KscreenHeight - 64) style:UITableViewStylePlain];
    _table.delegate = self;
    _table.dataSource = self;
    _table.showsVerticalScrollIndicator = NO;
    _table.backgroundColor = ColorTableBack;
    _table.separatorStyle = UITableViewCellSeparatorStyleNone;
    _table.tableFooterView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 0, CGFLOAT_MIN)];
    
    [self.view addSubview:_table];
    
    self.view.userInteractionEnabled = YES;
    NSLog(@"jieguo");
    
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    if ((!self.DrugArray || (self.DrugArray.count == 0)) && (!self.DrugStoreArray || self.DrugStoreArray == 0)) { //药店药品都没有
        return 0;
    }else if ((self.DrugStoreArray== nil || self.DrugStoreArray.count <= 0) && self.DrugArray.count >0 ) { //只有药品
        return self.DrugArray.count + 1;
    }else if ((self.DrugArray== nil || self.DrugArray.count <= 0) && self.DrugStoreArray.count >0) {  //只有药店
        return self.DrugStoreArray.count + 1;
    }else  {    //药店药品都有
        return ((self.DrugStoreArray.count >= 3)?3:self.DrugStoreArray.count) + ((self.DrugArray.count >= 3)?3:self.DrugArray.count) + 4;
    }
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    NSString *identy = [NSString stringWithFormat:@"cell-%ld",(long)indexPath.row];
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identy];
    
    if (cell == nil) {
        
        cell = [[UITableViewCell alloc] init];
        
        if ((!self.DrugArray && (self.DrugArray.count == 0)) && (!self.DrugStoreArray && self.DrugStoreArray == 0)) {
           
        }
        if (indexPath.row == 0) {
            cell.backgroundColor = ColorTableBack;
        }else if ((self.DrugStoreArray== nil || self.DrugStoreArray.count <= 0) && self.DrugArray.count >0 ) { //只有药品
            
            NSDictionary *dic = self.DrugArray[(indexPath.row - 1)];
            
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identy];
            JNSYCollectionTableViewCell *Cell = [[JNSYCollectionTableViewCell alloc] init];
            Cell.drugNameLab.text = dic[@"medicinesName"];;
            [Cell.leftImgView sd_setImageWithURL:[NSURL URLWithString:dic[@"medicinesPic1"]]];
            Cell.drugCotentLab.text = dic[@"medicinesSpecifications"];
            Cell.drugBelongLab.text = dic[@"medicinesBrand"];;
            Cell.drugPriceLab.text =  [NSString stringWithFormat:@"￥%d",[dic[@"medicinesPrice"] integerValue]/100];
            NSString *prePrice = [NSString stringWithFormat:@"￥%d",[dic[@"medicinesPriceDiscount"] integerValue]/100];
            NSMutableAttributedString *attribtstr = [[NSMutableAttributedString alloc] initWithString:prePrice];
            [attribtstr setAttributes:@{NSStrikethroughStyleAttributeName:[NSNumber numberWithInteger:NSUnderlineStyleSingle],NSBaselineOffsetAttributeName : @(NSUnderlineStyleSingle)} range:NSMakeRange(0, prePrice.length)];
            Cell.drugPrePriceLab.attributedText = attribtstr;
            Cell.drugStoreLab.text = dic[@"shopName"];
            Cell.drugStoreDistanceLab.text = [self setDistance:dic[@"distancen"]];
            Cell.DelectBtn.hidden = YES;
            cell = Cell;
        }else if ((self.DrugArray== nil || self.DrugArray.count <= 0) && self.DrugStoreArray.count >0) { //只有药店
            
            
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identy];
            NSDictionary *dic = self.DrugStoreArray[(indexPath.row - 1)];
            
            JNSYSearchDrugStoreTableViewCell *Cell = [[JNSYSearchDrugStoreTableViewCell alloc] init];
            Cell.serviceArry = ([dic[@"shopService"] class] != [NSNull class])?[dic[@"shopService"] componentsSeparatedByString:@","]:nil;
            [Cell setUpViews];
            Cell.StoreNameLab.text = dic[@"shopName"];
            Cell.TimeLab.text = [NSString stringWithFormat:@"%@-%@",dic[@"startTime"],dic[@"endTime"]];
            Cell.RatingLab.text = [NSString stringWithFormat:@"评分:%@分",dic[@"shopScore"]];
            Cell.DistanceLab.text = [self setDistance:dic[@"distancen"]];
            Cell.PlaceLab.text = dic[@"shopAddress"];
            [Cell.StoreImg sd_setImageWithURL:[NSURL URLWithString:dic[@"picComp1"]]];
            cell = Cell;
        }
        else if (self.DrugArray.count > 0 && self.DrugStoreArray.count > 0 ) { //药店和药品
            if (indexPath.row == 1) {
                JNSYMeCommonCell *Cell = [[JNSYMeCommonCell alloc] init];
                Cell.leftLab.text = @"药店";
                Cell.rightLab.text = @"更多";
                cell = Cell;
                cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
            }else if (indexPath.row == (((self.DrugStoreArray.count >= 3)?3:self.DrugStoreArray.count) + 2)) {
                cell.backgroundColor = ColorTableBack;
            }else if (indexPath.row == (((self.DrugStoreArray.count >= 3)?3:self.DrugStoreArray.count) + 3)) {
                JNSYMeCommonCell *Cell = [[JNSYMeCommonCell alloc] init];
                Cell.leftLab.text = @"药品";
                Cell.rightLab.text = @"更多";
                cell = Cell;
                cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
            }else if ((indexPath.row > 1) && (indexPath.row < (((self.DrugStoreArray.count >= 3)?3:self.DrugStoreArray.count) + 2))) {  //药店
                cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identy];
                
                
                NSDictionary *dic = self.DrugStoreArray[(indexPath.row - 2)];
                
                JNSYSearchDrugStoreTableViewCell *Cell = [[JNSYSearchDrugStoreTableViewCell alloc] init];
                Cell.serviceArry = ([dic[@"shopService"] class] != [NSNull class])?[dic[@"shopService"] componentsSeparatedByString:@","]:nil;
                [Cell setUpViews];
                Cell.StoreNameLab.text = dic[@"shopName"];
                Cell.TimeLab.text = [NSString stringWithFormat:@"%@-%@",dic[@"startTime"],dic[@"endTime"]];
                Cell.RatingLab.text = [NSString stringWithFormat:@"评分:%@分",dic[@"shopScore"]];
                Cell.DistanceLab.text = [self setDistance:dic[@"distancen"]];
                Cell.PlaceLab.text = dic[@"shopAddress"];
                [Cell.StoreImg sd_setImageWithURL:[NSURL URLWithString:dic[@"picComp1"]]];
                cell = Cell;
                
                NSLog(@"%ld",(long)indexPath.row);
                cell = Cell;
            }else if (((((self.DrugStoreArray.count >= 3)?3:self.DrugStoreArray.count) + 3)<indexPath.row) && (indexPath.row<(((self.DrugArray.count >= 3)?3:self.DrugArray.count) +((self.DrugStoreArray.count >= 3)?3:self.DrugStoreArray.count) + 4))) { //药品
                cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identy];
                
                NSLog(@"index:%ld,count:%ld",(long)indexPath.row,(unsigned long)self.DrugStoreArray.count);
                NSDictionary *dic = self.DrugArray[(indexPath.row - 4 - ((self.DrugStoreArray.count >= 3)?3:self.DrugStoreArray.count))];
                
                cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identy];
                JNSYCollectionTableViewCell *Cell = [[JNSYCollectionTableViewCell alloc] init];
                Cell.drugNameLab.text = dic[@"medicinesName"];;
                [Cell.leftImgView sd_setImageWithURL:[NSURL URLWithString:dic[@"medicinesPic1"]]];
                Cell.drugCotentLab.text = dic[@"medicinesSpecifications"];
                Cell.drugBelongLab.text = dic[@"medicinesBrand"];;
                Cell.drugPriceLab.text =  [NSString stringWithFormat:@"￥%d",[dic[@"medicinesPrice"] integerValue]/100];
                NSString *prePrice = [NSString stringWithFormat:@"￥%d",[dic[@"medicinesPriceDiscount"] integerValue]/100];
                NSMutableAttributedString *attribtstr = [[NSMutableAttributedString alloc] initWithString:prePrice];
                [attribtstr setAttributes:@{NSStrikethroughStyleAttributeName:[NSNumber numberWithInteger:NSUnderlineStyleSingle],NSBaselineOffsetAttributeName : @(NSUnderlineStyleSingle)} range:NSMakeRange(0, prePrice.length)];
                Cell.drugPrePriceLab.attributedText = attribtstr;
                Cell.drugStoreLab.text = dic[@"shopName"];
                Cell.drugStoreDistanceLab.text = [self setDistance:dic[@"distancen"]];
                Cell.DelectBtn.hidden = YES;
                cell = Cell;
            }
        }
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.row == 0 ) {
        return 6;
    }else if ((self.DrugStoreArray== nil || self.DrugStoreArray.count <= 0) && self.DrugArray.count >0 ) { //只要药品
        return 100;
        
    }else if ((self.DrugArray== nil || self.DrugArray.count <= 0) && self.DrugStoreArray.count >0) {//只有药店
        return 80;
        
    }else if (self.DrugArray.count > 0 && self.DrugStoreArray.count > 0) {
        if (indexPath.row == 1 || indexPath.row == (((self.DrugStoreArray.count >= 3)?3:self.DrugStoreArray.count) + 3)) {
            return 40;
        }else if (indexPath.row == (((self.DrugStoreArray.count >= 3)?3:self.DrugStoreArray.count)) + 2) {
            return 6;
        }else if(indexPath.row >= 2 && indexPath.row < (2+((self.DrugStoreArray.count >= 3)?3:self.DrugStoreArray.count))){
            return 80;
        }else {
            return 100;
        }
    }else {
        return 80;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
//    JNSYSearchDetailViewController *SearchDetailVc = [[JNSYSearchDetailViewController alloc] init];
//    SearchDetailVc.hidesBottomBarWhenPushed = YES;
    
    
    JNSYMoreStoresViewController *MoreStoreVc = [[JNSYMoreStoresViewController alloc] init];
    MoreStoreVc.hidesBottomBarWhenPushed = YES;
    
    JNSYMoreDrugsViewController *MoreDrugsVc = [[JNSYMoreDrugsViewController alloc] init];
    MoreDrugsVc.hidesBottomBarWhenPushed = YES;
    
    if (indexPath.row == 0 ) {
       
    }else if ((self.DrugStoreArray== nil || self.DrugStoreArray.count <= 0) && self.DrugArray.count >0 ) { //只有药品
    
        JNSYMedicineDetailViewController *MedicineDetialVc = [[JNSYMedicineDetailViewController alloc] init];
        MedicineDetialVc.hidesBottomBarWhenPushed = YES;
        
        [self.parentViewController.navigationController pushViewController:MedicineDetialVc animated:YES];
        if (self.saveSearchTextBlock) {
            //_saveSearchTextBlock(self.parentViewController)
        }
        
        
    }else if ((self.DrugArray== nil || self.DrugArray.count <= 0) && self.DrugStoreArray.count >0) {//只有药店
        
        NSDictionary *dic = self.DrugStoreArray[(indexPath.row - 1)];
        
        JNSYDrugStoreDetailViewController *DrugStoreVc = [[JNSYDrugStoreDetailViewController alloc] init];
        DrugStoreVc.shopId = [NSString stringWithFormat:@"%@",dic[@"shopId"]];
        DrugStoreVc.shopName = dic[@"shopName"];
        DrugStoreVc.hidesBottomBarWhenPushed = YES;
        
        [self.parentViewController.navigationController pushViewController:DrugStoreVc animated:YES];
        
    }else if (self.DrugArray.count > 0 && self.DrugStoreArray.count > 0) {
        if (indexPath.row == (((self.DrugStoreArray.count >= 3)?3:self.DrugStoreArray.count) + 2)) {
           
        }else if (indexPath.row == 1) {   //更多药店
            
            
            MoreStoreVc.drugStoreArray = self.DrugStoreArray;
            
            [self.parentViewController.navigationController pushViewController:MoreStoreVc animated:YES];
        }else if (indexPath.row == (((self.DrugStoreArray.count >= 3)?3:self.DrugStoreArray.count) + 3)){  //更多药品
            
            MoreDrugsVc.medicineArray = self.DrugArray;
            
            [self.parentViewController.navigationController pushViewController:MoreDrugsVc animated:YES];
        }
        else if((indexPath.row > 1) && (indexPath.row < (((self.DrugStoreArray.count >= 3)?3:self.DrugStoreArray.count) + 2))){ //药店
            
            
            NSDictionary *dic = self.DrugStoreArray[(indexPath.row - 2)];
            
            JNSYDrugStoreDetailViewController *DrugStoreVc = [[JNSYDrugStoreDetailViewController alloc] init];
            DrugStoreVc.hidesBottomBarWhenPushed = YES;
            DrugStoreVc.shopId = [NSString stringWithFormat:@"%@",dic[@"shopId"]];
            DrugStoreVc.shopName = dic[@"shopName"];
            [self.parentViewController.navigationController pushViewController:DrugStoreVc animated:YES];

            
        }else if ((((self.DrugStoreArray.count >= 3)?3:self.DrugStoreArray.count) + 3)<indexPath.row<(((self.DrugArray.count >= 3)?3:self.DrugArray.count) +((self.DrugStoreArray.count >= 3)?3:self.DrugStoreArray.count) + 4)) { //药品
            
            NSDictionary *dic = self.DrugArray[(indexPath.row - 4 - ((self.DrugStoreArray.count >= 3)?3:self.DrugStoreArray.count))];
            
            NSString *medicineId = dic[@"medicinesId"];
            
            [self getMedicineDetail:medicineId];
            
        }else {
            NSLog(@"点击其他");
        }
    }else {
        
    }
    NSLog(@"PUSH");
    
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
       
        NSDictionary *resultdic = [result JSONValue];
        NSString *code = resultdic[@"code"];
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
            [self.parentViewController.navigationController pushViewController:MedicineDetailVc animated:YES];
            
            [HUD hide:YES];
            
        }else {
            NSString *msg = resultdic[@"msg"];
            [JNSYAutoSize showMsg:msg];
            
            [HUD hide:YES];
        }
        
    } failure:^(NSError *error) {
        NSLog(@"%@",error);
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

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    
    
    if (self.hiddenKeyBoardBlock) {
        _hiddenKeyBoardBlock();
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
