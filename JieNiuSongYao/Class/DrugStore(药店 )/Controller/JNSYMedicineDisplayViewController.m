//
//  JNSYMedicineDisplayViewController.m
//  JieNiuSongYao
//
//  Created by rongfeng on 2017/5/31.
//  Copyright © 2017年 China Zhou. All rights reserved.
//

#import "JNSYMedicineDisplayViewController.h"
#import "Common.h"
#import "JNSYMedicineCollectionViewCell.h"
#import "JNSYMedicineDetailViewController.h"
#import "JNSYAutoSize.h"
#import "Masonry.h"
#import "JNSYUserInfo.h"
#import "SBJSON.h"
#import "IBHttpTool.h"
#import "UIImageView+WebCache.h"
#import "JNSYMedicineModel.h"
#import "JNShopCarCountView.h"

@interface JNSYMedicineDisplayViewController ()<UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout,UISearchBarDelegate,UIGestureRecognizerDelegate>

@property (nonatomic, strong)UICollectionView *MedicineCollectionView;
@property (nonatomic, strong)UISearchBar *DrugSearchBar;
@property (nonatomic, strong)NSArray *medicineList;
@end

@implementation JNSYMedicineDisplayViewController

- (void)viewWillAppear:(BOOL)animated {
    
    [super viewWillAppear:animated];
    self.title = @"药品展示";
    self.view.backgroundColor = ColorTableBack;
    
    self.navigationController.navigationBar.hidden = NO;
    
    NSLog(@"%@",self.shopId);
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //返回按钮
    self.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"" style:UIBarButtonItemStylePlain target:self action:nil];
    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
    //初始化药店列表
    self.medicineList = [[NSArray alloc] init];
    //获取药品列表
    [self getMedicineList:self.shopId searchKeyWord:@""];
    
    
    [self.view addSubview:self.MedicineCollectionView];
    
    [self.view addSubview:self.DrugSearchBar];
    
    //searchBtn
    UIButton *SearchBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [SearchBtn setTitle:@"搜索" forState:UIControlStateNormal];
    [SearchBtn setTitleColor:ColorTabBarback forState:UIControlStateNormal];
    [SearchBtn addTarget:self action:@selector(SearchAction) forControlEvents:UIControlEventTouchUpInside];
    [SearchBtn setBackgroundColor:ColorTableBack];
    SearchBtn.titleLabel.font = [UIFont systemFontOfSize:13];
    [self.view addSubview:SearchBtn];
    
    [SearchBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view).offset(8);
        make.right.equalTo(self.view).offset(-20);
        make.centerY.equalTo(self.DrugSearchBar);
        make.width.mas_equalTo(40);
    }];
    
}

- (void)SearchAction {
    
    NSLog(@"搜索");
    
    [self getMedicineList:self.shopId searchKeyWord:self.DrugSearchBar.text];
    
    [self.DrugSearchBar resignFirstResponder];
}

//获取药品列表
- (void)getMedicineList:(NSString *)shopId searchKeyWord:(NSString *)keyword {
    
    NSDictionary *dic = @{
                          @"shopId":shopId,
                          @"size":@"10",
                          @"page":@"1",
                          @"searchValue":keyword
                          };
    NSString *action = @"ShopMedicinesListState";
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
            
           
            self.medicineList = resultdic[@"medicinesList"];
            
            [self.MedicineCollectionView reloadData];
            
        }else {
            NSString *msg = resultdic[@"msg"];
            [JNSYAutoSize showMsg:msg];
        }
        
    } failure:^(NSError *error) {
        NSLog(@"%@",error);
    }];
    
}

//获取药品详情
- (void)getMedicineDetail:(NSString *)medicinesId {
    
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
            
        }else {
            NSString *msg = resultdic[@"msg"];
            [JNSYAutoSize showMsg:msg];
        }

    } failure:^(NSError *error) {
        NSLog(@"%@",error);
    }];
    
}


#define mark UICollectionDataSource

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    
    return self.medicineList.count;
    
}

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section {

    return UIEdgeInsetsMake(8, 8, 8, 0);
    
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    JNSYMedicineCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"cell" forIndexPath:indexPath];
    
    if (self.medicineList.count > 0) {
        NSDictionary *medicineDic = self.medicineList[indexPath.row];
        cell.MedicineNameLab.text = medicineDic[@"medicinesName"];
        cell.MedicineContentLab.text = medicineDic[@"medicinesSpecifications"];
        cell.MedicineBelongLab.text = medicineDic[@"medicinesBrand"];
        NSString *price = [NSString stringWithFormat:@"￥%@", medicineDic[@"medicinesPriceDiscount"]];
        cell.MedicinePriceLab.text = [price substringToIndex:(price.length - 2)];
        //cell.MedicinePrePriceLab.text = @"23";
        NSString *prePrice = [NSString stringWithFormat:@"￥%@",medicineDic[@"medicinesPrice"]]; //medicinesPriceDiscount
        prePrice = [prePrice substringToIndex:(prePrice.length - 2)];
        NSMutableAttributedString *attribtstr = [[NSMutableAttributedString alloc] initWithString:prePrice];
        [attribtstr setAttributes:@{NSStrikethroughStyleAttributeName:[NSNumber numberWithInteger:NSUnderlineStyleSingle],NSBaselineOffsetAttributeName : @(NSUnderlineStyleSingle)} range:NSMakeRange(0, prePrice.length)];
        cell.MedicinePrePriceLab.attributedText = attribtstr;
        [cell.DrugImgView sd_setImageWithURL:[NSURL URLWithString:medicineDic[@"medicinesPic1"]]];
    }
    cell.layer.cornerRadius = 3;
    
    return cell;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    return CGSizeMake((KscreenWidth - 24)/2.0, 160);
    
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    
    //获取药品信息
    [self getMedicineDetail:[NSString stringWithFormat:@"%@",self.medicineList[indexPath.row][@"medicinesId"]]];
    
}

- (UICollectionView *)MedicineCollectionView {
    
    if (_MedicineCollectionView == nil) {
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
        [layout setScrollDirection:UICollectionViewScrollDirectionVertical];
        layout.minimumLineSpacing = 6; //水平方向间距
        layout.minimumInteritemSpacing = 3; //垂直方向间距
        layout.itemSize = CGSizeMake((KscreenWidth - 24)/2.0, 120);
        _MedicineCollectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, [JNSYAutoSize AutoHeight:40], KscreenWidth , KscreenHeight - 104 - [JNSYAutoSize AutoHeight:40]) collectionViewLayout:layout];
        _MedicineCollectionView.backgroundColor = ColorTableBack;
        _MedicineCollectionView.delegate = self;
        _MedicineCollectionView.dataSource = self;
        _MedicineCollectionView.contentInset = UIEdgeInsetsMake(0, 0, 0, 8);
        
        [_MedicineCollectionView registerClass:[JNSYMedicineCollectionViewCell class] forCellWithReuseIdentifier:@"cell"];
        
        
        //添加点击收键盘手势
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hideKeyBoard)];
        tap.numberOfTapsRequired = 1;
        tap.delegate = self;
        
        [_MedicineCollectionView addGestureRecognizer:tap];
        
        
    }
    
    return _MedicineCollectionView;
    
}

- (UISearchBar *)DrugSearchBar {
    
    if (_DrugSearchBar == nil) {
        _DrugSearchBar = [[UISearchBar alloc] init];
        _DrugSearchBar.placeholder = @"搜索药品";
        _DrugSearchBar.barStyle = UIBarStyleDefault;
        _DrugSearchBar.layer.borderColor = ColorTabBarback.CGColor;
        _DrugSearchBar.layer.borderWidth = 1.5;
        _DrugSearchBar.layer.cornerRadius = 12;
        _DrugSearchBar.layer.masksToBounds = YES;
        _DrugSearchBar.barTintColor = [UIColor whiteColor];
        _DrugSearchBar.delegate = self;
        [self.view addSubview:_DrugSearchBar];
        [_DrugSearchBar mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.view).offset(30);
            make.top.equalTo(self.view).offset(8);
            make.right.equalTo(self.view).offset(-60);
            make.height.mas_equalTo([JNSYAutoSize AutoHeight:26]);
        }];
    }
    return _DrugSearchBar;
}


//点击键盘搜索
- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar {
    
    NSLog(@"搜索药店药品");
    
    [self getMedicineList:self.shopId searchKeyWord:searchBar.text];
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    
    [self.view endEditing:YES];
    
}

//收键盘
- (void)hideKeyBoard {
    
    
    [_DrugSearchBar resignFirstResponder];
    
}


- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(nonnull UITouch *)touch {
    
    if (touch.view != _MedicineCollectionView) {
        return NO;
    }
    
    return YES;
    
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
