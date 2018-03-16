//
//  JNSYPlaceAddAndEditorViewController.m
//  JieNiuSongYao
//
//  Created by rongfeng on 2017/5/16.
//  Copyright © 2017年 China Zhou. All rights reserved.
//

#import "JNSYPlaceAddAndEditorViewController.h"
#import "Common.h"
#import "Masonry.h"
#import "JNSYAutoSize.h"
#import "JNSYUserInfo.h"
#import "SBJSON.h"
#import "IBHttpTool.h"
#import "MBProgressHUD.h"
#import "JNSYLabAndFldTableViewCell.h"
#import "JNSYLocalMapTableViewCell.h"
#import "JNSYSetDefaultTableViewCell.h"
#import <MAMapKit/MAMapKit.h>
#import <AMapLocationKit/AMapLocationKit.h>
@interface JNSYPlaceAddAndEditorViewController ()<UITableViewDelegate,UITableViewDataSource,MAMapViewDelegate,AMapLocationManagerDelegate>

@property(nonatomic,strong)AMapLocationManager *locationManager;

@property(nonatomic,copy)AMapLocatingCompletionBlock completionBlock;

@end

@implementation JNSYPlaceAddAndEditorViewController {
    
    JNSYLocalMapTableViewCell *MapCell;
    JNSYLabAndFldTableViewCell *NameCell;
    JNSYLabAndFldTableViewCell *PhoneCell;
    JNSYLabAndFldTableViewCell *PlaceCell;
    JNSYSetDefaultTableViewCell *DefaultCell;
    CLLocation *_Uplocation;
}

- (void)viewWillAppear:(BOOL)animated {
    
    [super viewWillAppear:animated];
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    if (self.tag == 2)  {
        self.title = @"编辑地址";
    }else {
        self.title = @" 新增地址";
    }
    UIBarButtonItem *keepBtn = [[UIBarButtonItem alloc] initWithTitle:@"保存" style:UIBarButtonItemStylePlain target:self action:@selector(KeepAction)];
    self.navigationItem.rightBarButtonItem = keepBtn;
    
    //设置定位
    [self initCompleteBlock];
    [self configLocationManager];
    
    
    UITableView *table = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, KscreenWidth, KscreenHeight) style:UITableViewStylePlain];
    table.delegate = self;
    table.dataSource = self;
    table.backgroundColor = ColorTableBack;
    table.separatorStyle = UITableViewCellSeparatorStyleNone;
    table.showsVerticalScrollIndicator = NO;
    table.scrollEnabled = NO;
    
    
    table.tableFooterView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 0, CGFLOAT_MIN)];
    [self.view addSubview:table];
    
}

//初始化定位
- (void)configLocationManager {
    
    self.locationManager = [[AMapLocationManager alloc] init];
    self.locationManager.delegate = self;
    self.locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters;   //定位精度
    
    [self.locationManager requestLocationWithReGeocode:YES completionBlock:self.completionBlock];
}

- (void)initCompleteBlock {
    
    
    __weak typeof(self) weakSelf = self;
    
    self.completionBlock = ^(CLLocation *location, AMapLocationReGeocode *regeocode, NSError *error) {
        if (error != nil && error.code == AMapLocationErrorLocateFailed)
        {
            //定位错误：此时location和regeocode没有返回值，不进行annotation的添加
            NSLog(@"定位错误:{%ld - %@};", (long)error.code, error.localizedDescription);
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
            return;
        }
        else
        {
            //没有错误：location有返回值，regeocode是否有返回值取决于是否进行逆地理操作，进行annotation的添加
        }
        
        //根据定位信息，添加annotation
        MAPointAnnotation *annotation = [[MAPointAnnotation alloc] init];
        [annotation setCoordinate:location.coordinate];
        
        //设置全局定位
        _Uplocation = location;
        
        //有无逆地理信息，annotationView的标题显示的字段不一样
        if (regeocode)
        {
            [annotation setTitle:[NSString stringWithFormat:@"%@", regeocode.formattedAddress]];
            NSLog(@"定位地址:%@",regeocode.formattedAddress);
        }
        else
        {
            [annotation setTitle:[NSString stringWithFormat:@"纬度:%f;经度:%f;", location.coordinate.latitude, location.coordinate.longitude]];
            [annotation setSubtitle:[NSString stringWithFormat:@"精准度:%.2fm", location.horizontalAccuracy]];
            
        }

        __strong typeof(self) strongSelf = weakSelf;
        [strongSelf addAnnotationToMapView:annotation];
        
    };
}

//添加地图图标
- (void)addAnnotationToMapView:(id<MAAnnotation>)annotation {
    
    [MapCell.mapView addAnnotation:annotation];
    [MapCell.mapView selectAnnotation:annotation animated:YES];
    [MapCell.mapView setZoomLevel:15.1 animated:NO];
    [MapCell.mapView setCenterCoordinate:annotation.coordinate animated:YES];
    //选中图标
    [MapCell.mapView selectAnnotation:annotation animated:YES];
}
//设置地图图标
- (MAAnnotationView *)mapView:(MAMapView *)mapView viewForAnnotation:(id<MAAnnotation>)annotation
{
    if ([annotation isKindOfClass:[MAPointAnnotation class]])
    {
        static NSString *pointReuseIndetifier = @"pointReuseIndetifier";
        
        MAPinAnnotationView *annotationView = (MAPinAnnotationView *)[mapView dequeueReusableAnnotationViewWithIdentifier:pointReuseIndetifier];
        if (annotationView == nil)
        {
            annotationView = [[MAPinAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:pointReuseIndetifier];
        }
        
        annotationView.canShowCallout   = YES;
        annotationView.animatesDrop     = YES;
        annotationView.draggable        = NO;
        annotationView.pinColor         = MAPinAnnotationColorPurple;
        
        return annotationView;
    }
    
    return nil;
}


//点击保存地址
- (void)KeepAction {
    
    NSLog(@"保存");
    
    if ([NameCell.RightFld.text isEqualToString:@""] || NameCell.RightFld.text == nil) {
        [JNSYAutoSize showMsg:@"收货人为空!"];
        return;
    }else if ([PhoneCell.RightFld.text isEqualToString:@""] || PhoneCell.RightFld.text == nil) {
        
        [JNSYAutoSize showMsg:@"联系人为空"];
        return;
        
    }else if ([PlaceCell.RightFld.text isEqualToString:@""] || PlaceCell.RightFld.text == nil ){
        [JNSYAutoSize showMsg:@"地址为空"];
        return;
    }
    
    MBProgressHUD *HUD = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    
    /*****************   添加地址  **************************/
    
    NSDictionary *dic = @{
                          @"addressAccount":NameCell.RightFld.text,
                          @"addressPhone":PhoneCell.RightFld.text,
                          @"addressInfo":PlaceCell.RightFld.text,
                          @"addressDefault":DefaultCell.SelectBtn.isSelected?@"1":@"0",
                          @"longitude":[NSString stringWithFormat:@"%f",_Uplocation.coordinate.longitude],
                          @"latitude":[NSString stringWithFormat:@"%f",_Uplocation.coordinate.latitude]
                          };
    NSString *action = @"UserAddressAddState";
    
    /********************  编辑地址 ********************/
    if (self.tag == 2) {
        action = @"UserAddressEditState";
        dic = @{
                @"addressId":[NSString stringWithFormat:@"%@",self.placeInfoDic[@"addressId"]],
                @"addressAccount":NameCell.RightFld.text,
                @"addressPhone":PhoneCell.RightFld.text,
                @"addressInfo":PlaceCell.RightFld.text,
                @"addressDefault":DefaultCell.SelectBtn.isSelected?@"1":@"0",
                @"longitude":[NSString stringWithFormat:@"%f",_Uplocation.coordinate.longitude],
                @"latitude":[NSString stringWithFormat:@"%f",_Uplocation.coordinate.latitude]
                };
    }else {
        
    }
    
    NSDictionary *RequestDic = @{
                                 @"action":action,
                                 @"token":[JNSYUserInfo getUserInfo].userToken,
                                 @"data":dic
                                 };
    NSString *params = [RequestDic JSONFragment];
    
    [IBHttpTool postWithURL:JNSYTestUrl params:params success:^(id result) {
        NSLog(@"%@",result);
        NSDictionary *resultdic = [result JSONValue];
        NSString *code = resultdic[@"code"];
        NSLog(@"%@,%@",resultdic,code);
        if([code isEqualToString:@"000000"]) {
        
            HUD.labelText = @"保存成功!";
            HUD.mode = MBProgressHUDModeText;
            //[HUD hideAnimated:YES afterDelay:1.4];
            [HUD hide:YES afterDelay:1.4];
            [self performSelector:@selector(back) withObject:nil afterDelay:1.5];
            
        }else {
            NSString *msg = resultdic[@"msg"];
            [JNSYAutoSize showMsg:msg];
            //[HUD hideAnimated:YES];
            [HUD hide:YES];
        }

    } failure:^(NSError *error) {
        NSLog(@"%@",error);
        //[HUD hideAnimated:YES];
        [HUD hide:YES];
    }];
    
}

//返回上一层
- (void)back {
    
    [self.navigationController popViewControllerAnimated:YES];
    
}



- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return 5;
}

- (UITableViewCell *) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *identy = @"identy";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identy];
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc] init];
        if (indexPath.row == 0) {
            NameCell = [[JNSYLabAndFldTableViewCell alloc] init];
            NameCell.LeftLab.text = @"收货人";
            NameCell.RightFld.placeholder = @"请输入收货人姓名";
            if (self.tag == 2 && self.placeInfoDic != nil) {
                NameCell.RightFld.text = self.placeInfoDic[@"addressAccount"];
            }
            cell = NameCell;
        }else if (indexPath.row == 1) {
            PhoneCell = [[JNSYLabAndFldTableViewCell alloc] init];
            PhoneCell.LeftLab.text = @"联系电话";
            PhoneCell.RightFld.placeholder = @"输入联系电话";
            PhoneCell.RightFld.keyboardType = UIKeyboardTypeNumberPad;
            if (self.tag == 2 && self.placeInfoDic != nil) {
                PhoneCell.RightFld.text = self.placeInfoDic[@"addressPhone"];
            }
            cell = PhoneCell;
        }else if (indexPath.row == 2) {
            PlaceCell = [[JNSYLabAndFldTableViewCell alloc] init];
            PlaceCell.LeftLab.text = @"详细地址";
            PlaceCell.RightFld.placeholder = @"请填写详细地址，如***路***号";
            if (self.tag == 2 && self.placeInfoDic != nil) {
                PlaceCell.RightFld.text = self.placeInfoDic[@"addressInfo"];
            }
            cell = PlaceCell;
        }else if (indexPath.row == 3) {
            MapCell = [[JNSYLocalMapTableViewCell alloc] init];
            MapCell.mapView.delegate = self;
            MapCell.leftLab.text = @"地址定位";
            cell = MapCell;
        }else if (indexPath.row == 4) {
            DefaultCell = [[JNSYSetDefaultTableViewCell alloc] init];
            if (self.tag == 2 &&[self.placeInfoDic[@"addressDefault"] isEqual:@1]) {
                DefaultCell.SelectBtn.selected = YES;
            }
            cell = DefaultCell;
            
        }
        
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
    
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.row == 3) {
        return 120;
    }else{
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
