//
//  ShopCarViewController.m
//  购物车
//
//  Created by rongfeng on 2017/5/2.
//  Copyright © 2017年 China Zhou. All rights reserved.
//

#import "ShopCarViewController.h"
#import "Masonry.h"
#import "JNTableViewCell.h"
#import "JNTableViewHeadView.h"
#import "JNShopCarProxy.h"
#import "JNShopCarFormat.h"
#import "JNShopCarBottonView.h"
#import "JNSYMedicineDetailViewController.h"
#import "MBProgressHUD.h"
#import "JNShopCarBrandModel.h"
#import "JNSYOrderSettleViewController.h"
#import "JNSYAutoSize.h"
#import "JNSYUserInfo.h"
#import "SBJSON.h"
#import "IBHttpTool.h"
#import "Common.h"
#import "MJExtension.h"
#import "JNShopCarProductModel.h"
#import "JNSYDrugStoreDetailViewController.h"
@interface ShopCarViewController () <JNShopCarFormatDelegate>

@property(nonatomic,strong)UITableView *shopCarTableView;
@property(nonatomic,strong)JNShopCarBottonView *shopCarBottomView;
@property(nonatomic,strong)JNShopCarProxy *shopCarProxy;
@property(nonatomic,strong)JNShopCarFormat *shopCarFormat;
@property(nonatomic,strong)MBProgressHUD *HUD;
@end

@implementation ShopCarViewController {
    
    
    UIButton *editorbtn;
    
}

- (void)viewWillAppear:(BOOL)animated {
    
    [super viewWillAppear:animated];
    
    [self.navigationController setNavigationBarHidden:NO animated:YES];
    
    //返回按钮
    self.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"" style:UIBarButtonItemStylePlain target:self action:nil];
    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
    self.navigationController.navigationBar.translucent = NO;
    
    [self requestForDataSource];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
    self.title = @"购物车";
   
    [self addSubViews];
    
    //[self requestForDataSource];
    
    
    self.HUD = [[MBProgressHUD alloc] initWithFrame:CGRectMake(0, 0, 100, 60)];
    self.HUD.center = self.view.center;
    _HUD.mode = MBProgressHUDModeText;
    _HUD.labelText = @"收藏成功";
    self.view.userInteractionEnabled = YES;
    self.HUD.userInteractionEnabled = NO;
    [self.view insertSubview:_HUD aboveSubview:self.shopCarTableView];
    
}

//获取数据源
- (void)requestForDataSource {
    
    [self.shopCarFormat requestShopCarProductList];

    NSLog(@"获取购物车列表");
    
}


#pragma mark JNShopCarFormatDelegate
//回调
- (void)shopCarFormatRequestProductListDidSuccesWithArray:(NSMutableArray *)dataArray {
    
    self.shopCarProxy.dataArray = dataArray;
    [self.shopCarTableView reloadData];
    
}

//计算购物车总额
- (void)shopCarFormatAccountForTotalPrice:(float)totalPrice totalCount:(NSInteger)totalCount isAllSelected:(BOOL)isAllSelected {
    
    [self.shopCarBottomView configureShopCarBottomViewWithTotalPrice:totalPrice totalCount:totalCount isAllselected:isAllSelected];
    [self.shopCarTableView reloadData];
    
}

- (void)shopCarFormatSettleForSelectedProducts:(NSArray *)selectedProducts {
    
    NSLog(@"勾选");
    
}

- (void)shopCarFormatWillDeleteSeletedProducts:(NSArray *)selectedProducts {
    
    NSLog(@"将要删除");
    
}

- (void)shopCarFormatHasDeleteAllProducts {
    
    NSLog(@"已经删除所有商品");
}

#pragma mark getters
//tableview初始化
- (UITableView *)shopCarTableView {
    if (_shopCarTableView == nil) {
        
        _shopCarTableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStyleGrouped];
        _shopCarTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _shopCarTableView.rowHeight = 120;
        _shopCarTableView.sectionFooterHeight = 10;
        _shopCarTableView.showsVerticalScrollIndicator = NO;
        _shopCarTableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 0, CGFLOAT_MIN)];
        _shopCarTableView.tableHeaderView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 0, CGFLOAT_MIN)];
        [_shopCarTableView registerClass:[JNTableViewCell class] forCellReuseIdentifier:@"JNTableViewCell"];
        [_shopCarTableView registerClass:[JNTableViewHeadView class] forHeaderFooterViewReuseIdentifier:@"JNTableViewHeadView"];
        _shopCarTableView.delegate = self.shopCarProxy;
        _shopCarTableView.dataSource = self.shopCarProxy;
        return _shopCarTableView;
        
    }
    
    return _shopCarTableView;
}


- (JNShopCarBottonView *)shopCarBottomView {
    
    if (_shopCarBottomView == nil) {
        _shopCarBottomView = [[JNShopCarBottonView alloc] init];
        
    }
    
    __weak __typeof(self) WeakSelf = self;
    
    //全选
    _shopCarBottomView.shopCarBottomViewAllSelectBlock = ^(BOOL isSelected) {
        [WeakSelf.shopCarFormat selectAllProductWithStatus:isSelected];
    };
    
    __weak typeof(MBProgressHUD) *weakHUD = _HUD;
   
    //收藏
    _shopCarBottomView.shopCarBottomViewStarBlock = ^{
        [WeakSelf.shopCarFormat starSelectedProducts];
        NSLog(@"弹出视图");
        __strong typeof(MBProgressHUD) *StrongHUd = weakHUD;
        
        //[StrongHUd showAnimated:YES];
        [StrongHUd show:YES];
        StrongHUd.center = WeakSelf.view.center;
        //[StrongHUd hideAnimated:YES afterDelay:2.0];
        [StrongHUd hide:YES afterDelay:2.0];
        NSLog(@"%f,%f",StrongHUd.frame.size.width,StrongHUd.frame.size.height);
        
    };
    
    //删除购物车选中
    _shopCarBottomView.shopCarBottomViewDelectBlock = ^{
        
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:nil message:@"确认要将选中宝贝移除购物车？" preferredStyle:UIAlertControllerStyleAlert];
        [alert addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil]];
        [alert addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            [WeakSelf.shopCarFormat deleteSelectedProducts:nil];
        }]];
        [WeakSelf presentViewController:alert animated:YES completion:nil];
        
    };
    
    _shopCarBottomView.shopCarBottomViewSettleBlock = ^{
        NSLog(@"结算!");
        
        JNSYOrderSettleViewController *SettleVc = [[JNSYOrderSettleViewController alloc] init];
        SettleVc.hidesBottomBarWhenPushed = YES;
        [WeakSelf.navigationController pushViewController:SettleVc animated:YES];
    };
    return _shopCarBottomView;
}



- (NSMutableArray *)getArray {
    
    NSMutableArray *array = [[NSMutableArray alloc] init];
    
    for(NSInteger j = 0;j<self.shopCarProxy.dataArray.count;j++) {
        
        JNShopCarBrandModel *brandModel = self.shopCarProxy.dataArray[j];
        [array addObjectsFromArray:brandModel.products];
        NSLog(@"%ld",(unsigned long)array.count);
    }

    return array;
}


- (void)hiddenWindow {
    
    
}

//tableview代理
- (JNShopCarProxy *)shopCarProxy {
    
    if (_shopCarProxy == nil) {
        _shopCarProxy = [[JNShopCarProxy alloc] init];
    }
    
    __weak __typeof(self) WeakSelf = self;
    
    //点击修改数目
    _shopCarProxy.shopCarProxyChangeCountBlock = ^(NSInteger count, NSIndexPath *indexPath) {
        [WeakSelf.shopCarFormat changeCountAtIndexPath:indexPath count:count];
    };
    
    //点击勾选商家
    _shopCarProxy.shopCarProxyBrandSelectBlock = ^(BOOL isSelected, NSInteger section) {
        [WeakSelf.shopCarFormat selectBrandAtSection:section isSelected:isSelected];
    };
    
    //勾选商品
    _shopCarProxy.shopCarProxyProductSelectBlock = ^(BOOL isSelected, NSIndexPath *indexPath) {
        [WeakSelf.shopCarFormat selectProductAtIndexPath:indexPath isSelected:isSelected];
    };
    
    //删除
    _shopCarProxy.shopCarProxyDelectbLOCK = ^(NSIndexPath *indexPath) {
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:nil message:@"确认要删除这个宝贝吗？" preferredStyle:UIAlertControllerStyleAlert];
        [alert addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil]];
        [alert addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            [WeakSelf.shopCarFormat delecteProductAtIndexPath:indexPath];
        }]];
        [WeakSelf presentViewController:alert animated:YES completion:nil];
    };
    
    //收藏
    _shopCarProxy.shopCarProxyStarBlock = ^(NSIndexPath *indexPath) {
        [WeakSelf.shopCarFormat starProductAtIndexPath:indexPath];
    };
    
    //头视图点击跳药店
//    _shopCarProxy.shopCarProxyHeaderViewSelectBlock = ^{
//        NSLog(@"跳转到药店");
//        JNSYMedicineDetailViewController *MedicineVc = [[JNSYMedicineDetailViewController alloc] init];
//        MedicineVc.hidesBottomBarWhenPushed = YES;
//        [WeakSelf.navigationController pushViewController:MedicineVc animated:YES];
//    };
    
    _shopCarProxy.shopCarProxyHeaderViewSelectBlock = ^(NSInteger section) {
        JNSYDrugStoreDetailViewController *disPlayVc = [[JNSYDrugStoreDetailViewController alloc] init];
        JNShopCarBrandModel *model = WeakSelf.shopCarProxy.dataArray[section];
        disPlayVc.shopId = model.brandId;
        disPlayVc.shopName = model.brandName;
        disPlayVc.hidesBottomBarWhenPushed = YES;
        [WeakSelf.navigationController pushViewController:disPlayVc animated:YES];
    };
    
    return _shopCarProxy;
    
}

- (JNShopCarFormat *)shopCarFormat {
    
    
    if (_shopCarFormat == nil) {
        _shopCarFormat = [[JNShopCarFormat alloc] init];
        _shopCarFormat.delegate = self;
    }
    
    return _shopCarFormat;
}

- (void)addSubViews {
    //编辑按钮
    editorbtn = [UIButton buttonWithType:UIButtonTypeCustom];
    editorbtn.frame = CGRectMake(0, 0, 40, 40);
    [editorbtn setTitle:@"编辑" forState:UIControlStateNormal];
    [editorbtn setTitle:@"完成" forState:UIControlStateSelected];
    [editorbtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    editorbtn.titleLabel.font = [UIFont systemFontOfSize:13];
    [editorbtn addTarget:self action:@selector(editor) forControlEvents:UIControlEventTouchUpInside];
    
    UIBarButtonItem *barbtn = [[UIBarButtonItem alloc] initWithCustomView:editorbtn];
    self.navigationItem.rightBarButtonItem = barbtn;
    
    [self.view addSubview:self.shopCarBottomView];
    [self.shopCarBottomView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.view);
        make.bottom.equalTo(self.view).offset(-50);
        make.height.equalTo(@52);
    }];
    
    //添加tableView
    [self.view addSubview:self.shopCarTableView];
    //布局tableview
    [self.shopCarTableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view).offset(0);
        make.left.right.equalTo(self.view);
        make.bottom.equalTo(self.shopCarBottomView.mas_top);
    }];
}

- (void)editor {
    //反选
    editorbtn.selected = !editorbtn.selected;
    
    [self.shopCarBottomView changeShopCarBottomViewWithStatus:editorbtn.selected];
}


- (void)showlab {
    
    UILabel *lab = [[UILabel alloc] init];
    lab.frame = CGRectMake(0, 0, 100, 40);
    lab.center = self.view.center;
    lab.text = @"收藏成功";
    
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
