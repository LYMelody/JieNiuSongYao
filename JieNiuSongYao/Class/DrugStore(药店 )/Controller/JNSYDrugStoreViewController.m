//
//  JNSYDrugStoreViewController.m
//  JieNiuSongYao
//
//  Created by rongfeng on 2017/5/9.
//  Copyright © 2017年 China Zhou. All rights reserved.
//

#import "JNSYDrugStoreViewController.h"
#import "JSDropDownMenu.h"
#import "Common.h"
#import "Masonry.h"
#import "JNSYSearchDrugStoreTableViewCell.h"
#import "JNSYDrugStoreDetailViewController.h"
#import <AMapLocationKit/AMapLocationKit.h>
#import <MapKit/MapKit.h>
#import "JNSYAutoSize.h"
#import "JNSYUserInfo.h"
#import "SBJSON.h"
#import "IBHttpTool.h"
#import "UIImageView+WebCache.h"
#import "MBProgressHUD.h"
@interface JNSYDrugStoreViewController ()<JSDropDownMenuDelegate,JSDropDownMenuDataSource,UITableViewDelegate,UITableViewDataSource,AMapLocationManagerDelegate> {
    
    
    NSMutableArray *_data1;
    NSMutableArray *_data2;
    NSMutableArray *_data3;
    
    NSInteger _currentData1Index;
    NSInteger _currentData2Index;
    NSInteger _currentData3Index;
    
    NSInteger _currentData1SelectedIndex;
    
    JSDropDownMenu *menu;
    
    NSString *locationStr;
    
    MBProgressHUD *hud;
    
}

@property(nonatomic,strong)AMapLocationManager *locationManager;

@property(nonatomic,copy)AMapLocatingCompletionBlock completionBlock;

@property(nonatomic,strong)UILabel *LocationLab;

@property(nonatomic,strong)UIActivityIndicatorView *ActivityView;

@property(nonatomic,strong)UIActivityIndicatorView *StoreActivityView;

@property(nonatomic,strong)CLLocation *CurLocation;

@property(nonatomic,copy)NSString *sortStr;

@property(nonatomic,copy)NSString *limitStr;

@property(nonatomic,copy)NSString *services;

@property(nonatomic,strong)UITableView *table;

@property(nonatomic,strong)NSMutableArray *drugStoreList;


@end

@implementation JNSYDrugStoreViewController

- (void)viewWillAppear:(BOOL)animated {
    
    [super viewWillAppear:animated];
    
    self.view.backgroundColor = [UIColor whiteColor];
    self.tabBarController.tabBarItem.title = @"药店";
    self.navigationItem.title = @"附近药店";
    
    self.navigationController.navigationBar.translucent = NO;
    
}



#define mark(loaction)

//初始化定位
- (void)configLocationManager {
    
    self.locationManager = [[AMapLocationManager alloc] init];
    self.locationManager.delegate = self;
    self.locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters;   //定位精度
    
    [self.locationManager requestLocationWithReGeocode:YES completionBlock:self.completionBlock];
    
    _ActivityView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    
    [self.view addSubview:_ActivityView];
    
    [_ActivityView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view);
        make.top.equalTo(self.view).offset(10);
        make.height.with.mas_equalTo(20);
    }];
    
    [_ActivityView startAnimating];
    
}

- (void)initCompleteBlock {
    
    
    __weak typeof(self) weakSelf = self;
    
    self.completionBlock = ^(CLLocation *location, AMapLocationReGeocode *regeocode, NSError *error) {
        
        
        __strong typeof(self) strongSelf = weakSelf;
        
        
        
        if (error != nil && error.code == AMapLocationErrorLocateFailed)
        {
            //定位错误：此时location和regeocode没有返回值，不进行annotation的添加
            NSLog(@"定位错误:{%ld - %@};", (long)error.code, error.localizedDescription);
            //停止转圈
            [strongSelf.ActivityView stopAnimating];
            
            [JNSYAutoSize showMsg:[NSString stringWithFormat:@"定位错误:{%ld - %@};", (long)error.code, error.localizedDescription]];
            
            return;
        }
        else if (error != nil
                 && (error.code == AMapLocationErrorReGeocodeFailed
                     || error.code == AMapLocationErrorTimeOut
                     || error.code == AMapLocationErrorCannotFindHost
                     || error.code == AMapLocationErrorBadURL
                     || error.code == AMapLocationErrorNotConnectedToInternet
                     || error.code == AMapLocationErrorCannotConnectToHost))
        {
            //逆地理错误：在带逆地理的单次定位中，逆地理过程可能发生错误，此时location有返回值，regeocode无返回值，进行annotation的添加
            NSLog(@"逆地理错误:{%ld - %@};", (long)error.code, error.localizedDescription);
        }
        else if (error != nil && error.code == AMapLocationErrorRiskOfFakeLocation)
        {
            //存在虚拟定位的风险：此时location和regeocode没有返回值，不进行annotation的添加
            NSLog(@"存在虚拟定位的风险:{%ld - %@};", (long)error.code, error.localizedDescription);
            //停止转圈
            [strongSelf.ActivityView stopAnimating];
            return;
        }
        else
        {
            //没有错误：location有返回值，regeocode是否有返回值取决于是否进行逆地理操作，进行annotation的添加
        }
        
        _CurLocation = location;
        
        //有无逆地理信息，annotationView的标题显示的字段不一样
        if (regeocode)
        {
           
            strongSelf.LocationLab.text = [NSString stringWithFormat:@"%@",regeocode.formattedAddress];
            locationStr = regeocode.formattedAddress;
            NSLog(@"定位地址:%@",regeocode.formattedAddress);
        }
        else
        {
            
        }
        //停止转圈
        [strongSelf.ActivityView stopAnimating];
        
        
        [strongSelf reqesetNearDrugStores:strongSelf.sortStr limit:strongSelf.limitStr services:strongSelf.services];
        
        
        
    };
}

//获取附近的药店
- (void)reqesetNearDrugStores:(NSString *)sort limit:(NSString *)limit services:(NSString *)servicesStr {
    
    
    if (_table.hidden) {
        
        [hud show:YES];
        
    }else {
        
        [hud removeFromSuperview];
        
        [_table addSubview:hud];
        [hud show:YES];
        
    }
    
    NSDictionary *dic = @{
                          @"lng":[NSString stringWithFormat:@"%f",_CurLocation.coordinate.longitude],
                          @"lat":[NSString stringWithFormat:@"%f",_CurLocation.coordinate.latitude],
                          @"sort":@"1",
                          @"limit":limit,
                          @"services":servicesStr,
                          @"searchValue":@"",
                          @"page":@"1",
                          @"size":@"10"
                          };
    NSString *action = @"ShopSearchState";
    NSDictionary *requestDic = @{
                                 @"action":action,
                                 @"token":[JNSYUserInfo getUserInfo].userToken,
                                 @"data":dic
                                 };
    NSString *params = [requestDic JSONFragment];
    
    [IBHttpTool postWithURL:JNSYTestUrl params:params success:^(id result) {
      
        NSDictionary *resultdic = [result JSONValue];
        NSString *code = resultdic[@"code"];
        
        
        //[self.StoreActivityView stopAnimating];
        if([code isEqualToString:@"000000"]) {
            
            
            self.drugStoreList = [[NSMutableArray alloc] initWithArray:resultdic[@"shopList"]];
            self.table.hidden = NO;
            [hud hide:YES afterDelay:0.5];
            
            [self.table reloadData];
            
        }else {
            NSString *msg = resultdic[@"msg"];
            [JNSYAutoSize showMsg:msg];
            [hud hide:YES];
        }
        
        
    } failure:^(NSError *error) {
        NSLog(@"%@",error);
        [hud hide:YES];
        //[self.StoreActivityView stopAnimating];
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


- (void)viewDidLoad {
    [super viewDidLoad];
   
    
    //获取药店列表
    _sortStr = @"综合排序";
    _limitStr = @"500";
    _services = @"所有服务";

    
    
    
    
    //[hud hide:YES];
    
    
    
    
    [_StoreActivityView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.centerY.equalTo(self.view);
        make.width.height.mas_equalTo(40);
    }];
    
    //定位
    [self initCompleteBlock];
    [self  configLocationManager];
    
    
    //[self reqesetNearDrugStores:_sortStr limit:_limitStr services:_services];
    
    //返回按钮
    self.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"" style:UIBarButtonItemStylePlain target:self action:nil];
    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
    
    /****************************  当前位置  ****************************************/
    
    UIImageView *SeperateLine = [[UIImageView alloc] init];
    SeperateLine.backgroundColor = [UIColor colorWithRed:210/255.0 green:210/255.0 blue:210/255.0 alpha:1];
    
    [self.view addSubview:SeperateLine];
    
    
    [SeperateLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.view);
        make.top.equalTo(self.view).offset(39.5);
        make.height.mas_equalTo(0.5);
    }];
    
    
    UIImageView *LocationImg = [[UIImageView alloc] init];
    LocationImg.image = [UIImage imageNamed:@"地点"];
    
    [self.view addSubview:LocationImg];
    
    [LocationImg mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view).offset(10);
        make.left.equalTo(self.view).offset(16);
        make.width.mas_equalTo(13);
        make.bottom.equalTo(SeperateLine.mas_top).offset(-10);
    }];
    
    _LocationLab = [[UILabel alloc] init];
    _LocationLab.text = @"";
    _LocationLab.textColor = [UIColor blackColor];
    _LocationLab.font = [UIFont systemFontOfSize:13];
    _LocationLab.textAlignment = NSTextAlignmentLeft;
    _LocationLab.text = locationStr;
    [self.view addSubview:_LocationLab];
    
    [_LocationLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view).offset(6);
        make.left.equalTo(LocationImg.mas_right).offset(10);
        make.centerY.equalTo(LocationImg);
        make.width.mas_equalTo(KscreenWidth - 40);
        make.height.mas_equalTo(30);
    }];
    
    
    /***************************  筛选    **********************************/
    //指定默认选中
    _currentData1Index = 0;
    _currentData2Index = 0;
    _currentData3Index = 0;
    _currentData1SelectedIndex = 1;
    
    NSArray *food = @[@"综合排序",@"距离由近到远",@"评分由高到低"];
    _data1 = [[NSMutableArray alloc] initWithArray:food];
    _data2 = [NSMutableArray arrayWithObjects:@"500m",@"1000m",@"1500m",@"2000m", nil];
    _data3 = [NSMutableArray arrayWithObjects:@"所有服务",@"药师咨询",@"24h服务",@"送药上门",@"会员优惠",@"积分抵扣", nil];
    
    menu = [[JSDropDownMenu alloc] initWithOrigin:CGPointMake(0, 40) andHeight:40];
    menu.indicatorColor = [UIColor colorWithRed:175/255.0 green:175/255.0 blue:175/255.0 alpha:1];
    menu.separatorColor = [UIColor colorWithRed:210/255.0 green:210/255.0 blue:210/255.0 alpha:1];
    menu.textColor = [UIColor colorWithRed:83/255.0 green:83/255.0 blue:83/255.0 alpha:1];
    menu.delegate = self;
    menu.dataSource = self;
    
    [self.view addSubview:menu];
    
    
    /*********************列表***************************/
    
    _table = [[UITableView alloc] initWithFrame:CGRectMake(0, 80, KscreenWidth, KscreenHeight - 194) style:UITableViewStylePlain];
    _table.delegate = self;
    _table.dataSource = self;
    _table.backgroundColor = ColorTableBack;
    _table.showsVerticalScrollIndicator = NO;
    _table.separatorStyle = UITableViewCellSeparatorStyleNone;
    _table.hidden = YES;
    
    [self.view addSubview:_table];
    
    
    hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    
    _StoreActivityView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    
    [self.view addSubview:_StoreActivityView];
    
}

#define   UITableViewDeleageUITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return self.drugStoreList.count;
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *identy = @"identy";
    
    JNSYSearchDrugStoreTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identy];
    
    if (cell == nil) {
        
        NSDictionary *drugDic = self.drugStoreList[indexPath.row];
        
        cell = [[JNSYSearchDrugStoreTableViewCell alloc] init];
        
        cell.serviceArry = ([drugDic[@"shopService"] class] != [NSNull class])?[drugDic[@"shopService"] componentsSeparatedByString:@","]:nil;  //@[@"药师咨询",@"会员折扣",@"支持医保",@"满减活动"]
        [cell setUpViews];
        cell.StoreNameLab.text = drugDic[@"shopName"];
        cell.TimeLab.text = [NSString stringWithFormat:@"%@-%@",drugDic[@"startTime"],drugDic[@"endTime"]];
        cell.RatingLab.text = [NSString stringWithFormat:@"评分:%@分",drugDic[@"shopScore"]];
        cell.DistanceLab.text = [self setDistance:drugDic[@"distancen"]];
        cell.PlaceLab.text = drugDic[@"shopAddress"];
        [cell.StoreImg sd_setImageWithURL:[NSURL URLWithString:drugDic[@"picComp1"]]];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    return 80;
    
}

//药店点击事件
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    JNSYDrugStoreDetailViewController *DrugStoredetailVc = [[JNSYDrugStoreDetailViewController alloc] init];
    DrugStoredetailVc.hidesBottomBarWhenPushed = YES;
    //设置药店的shopID
    DrugStoredetailVc.shopId = [NSString stringWithFormat:@"%@",self.drugStoreList[indexPath.row][@"shopId"]];
    DrugStoredetailVc.shopName = [NSString stringWithFormat:@"%@",self.drugStoreList[indexPath.row][@"shopName"]];
    [self.navigationController pushViewController:DrugStoredetailVc animated:YES];
    
    
}

//#define mark - JSDropDownMenu
- (NSInteger)numberOfColumnsInMenu:(JSDropDownMenu *)menu {
    
    return 3;
    
}

- (BOOL)displayByCollectionViewInColumn:(NSInteger)column {
    return NO;
}


- (BOOL)haveRightTableViewInColumn:(NSInteger)column {
    
    return NO;
}

- (CGFloat)widthRatioOfLeftColumn:(NSInteger)column {
    
    return 1;
    
}

- (NSInteger)currentLeftSelectedRow:(NSInteger)column {
    if (column == 0) {
        return _currentData1Index;
    }else if (column == 1)
    {
        return _currentData2Index;
    }else if (column == 2) {
        return _currentData3Index;
    }
    return 0;
}

- (NSInteger)menu:(JSDropDownMenu *)menu numberOfRowsInColumn:(NSInteger)column leftOrRight:(NSInteger)leftOrRight leftRow:(NSInteger)leftRow {
    
    if (column == 0) {
        return _data1.count;
    }else if (column == 1) {
        return _data2.count;
    }else if (column == 2) {
        return _data3.count;
    }
    
    return 0;
    
}

- (NSString *)menu:(JSDropDownMenu *)menu titleForColumn:(NSInteger)column {
    
    switch (column) {
        case 0:
           
            return _data1[_currentData1Index];
            break;
        case 1:
           
            return _data2[_currentData2Index];
            break;
        case 2:
            
            return _data3[_currentData3Index];
            break;
        default:
            return nil;
            break;
    }
}

- (NSString *)menu:(JSDropDownMenu *)menu titleForRowAtIndexPath:(JSIndexPath *)indexPath {
    
    if (indexPath.column == 0) {
        return _data1[indexPath.row];
    }else if (indexPath.column == 1) {
        return _data2[indexPath.row];
    }else if (indexPath.column == 2) {
        return _data3[indexPath.row];
    }
    return nil;
}

- (void)menu:(JSDropDownMenu *)menu didSelectRowAtIndexPath:(JSIndexPath *)indexPath {
    
    if (indexPath.column == 0) {
        _currentData1Index = indexPath.row;
         _sortStr = _data1[_currentData1Index];
    }else if (indexPath.column == 1) {
        _currentData2Index = indexPath.row;
         _limitStr = _data2[_currentData2Index];
    }else {
        _currentData3Index = indexPath.row;
        _services = _data3[_currentData3Index];
    }

    //重新获取药店列表
    [self reqesetNearDrugStores:_sortStr limit:_limitStr services:_services];

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
