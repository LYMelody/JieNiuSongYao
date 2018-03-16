//
//  JNSYMapViewController.m
//  JieNiuSongYao
//
//  Created by rongfeng on 2017/7/13.
//  Copyright © 2017年 China Zhou. All rights reserved.
//

#import "JNSYMapViewController.h"
#import "Common.h"
#import "JNSYAutoSize.h"
#import "JNSYUserInfo.h"
#import "Masonry.h"
#import <MAMapKit/MAMapKit.h>
#import <AMapLocationKit/AMapLocationKit.h>
#import <AMapFoundationKit/AMapFoundationKit.h>
#import <AMapSearchKit/AMapSearchKit.h>
#import "MANaviRoute.h"
#import "ErrorInfoUtility.h"
#import "JNSYRoutePlansViewController.h"
@interface JNSYMapViewController ()<MAMapViewDelegate,AMapLocationManagerDelegate,AMapSearchDelegate>

@property(nonatomic,strong)MANaviRoute *naviRoute;

@property(nonatomic,strong)AMapRoute *route;

/* 当前路线方案索引 */
@property(nonatomic) NSInteger currentCouse;

@end

@implementation JNSYMapViewController {
    
    MAMapView *MapView;
    AMapSearchAPI *search;
    
}


- (void)viewWillAppear:(BOOL)animated {
    
    self.title = @"药店位置";
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    //隐藏导航栏
    [self.navigationController setNavigationBarHidden:YES animated:YES];
    
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault animated:YES];
    
}

- (void)viewWillDisappear:(BOOL)animated {
    
    [super viewWillDisappear:animated];
    
    
    
     [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent animated:YES];
    
    
}


- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    //返回按钮
    self.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"" style:UIBarButtonItemStylePlain target:self action:nil];
    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
    
    CLLocation *location = [[CLLocation alloc] initWithLatitude:[self.lat doubleValue] longitude:[self.lng doubleValue]];
    
    
    //初始化searcheAPI
    search = [[AMapSearchAPI alloc] init];
    search.delegate = self;
    
    //初始化mapView
    MapView = [[MAMapView alloc] initWithFrame:CGRectMake(0, 0, KscreenWidth, KscreenHeight)];
    MapView.showsScale = NO;
    MapView.showsCompass = NO;
    MapView.delegate = self;
    MapView.showsUserLocation = YES;
    //MapView.compassOrigin = CGPointMake(KscreenWidth - 60, 40);
    MapView.desiredAccuracy =  kCLLocationAccuracyNearestTenMeters;
    [MapView setUserTrackingMode:MAUserTrackingModeFollow animated:YES];
    [MapView setZoomLevel:14.1 animated:YES];
    
    [MapView setCenterCoordinate:location.coordinate];
    [self.view addSubview:MapView];
    
    //添加标注
    MAPointAnnotation *pointAnnotation = [[MAPointAnnotation alloc] init];
    [pointAnnotation setCoordinate:location.coordinate];
    [pointAnnotation setTitle:self.storeName];
    [pointAnnotation setSubtitle:self.place];
    [MapView addAnnotation:pointAnnotation];
    [MapView selectAnnotation:pointAnnotation animated:YES];

    //底部视图
    UIImageView *bottomView = [[UIImageView alloc] init];
    bottomView.backgroundColor = [UIColor whiteColor];
    bottomView.userInteractionEnabled = YES;
    
    [self.view addSubview:bottomView];
    
    [bottomView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.equalTo(self.view);
        make.height.mas_equalTo(100);
    }];
   
    //店名
    UILabel *shopLab = [[UILabel alloc] init];
    shopLab.font = [UIFont systemFontOfSize:13];
    shopLab.textAlignment = NSTextAlignmentLeft;
    shopLab.text = self.storeName;
    [bottomView addSubview:shopLab];
    
    [shopLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(bottomView).offset(15);
        make.left.equalTo(bottomView).offset(10);
        make.right.equalTo(bottomView);
        make.height.mas_equalTo([JNSYAutoSize AutoHeight:20]);
    }];
    
    //详细地址
    UILabel *placeLab = [[UILabel alloc] init];
    placeLab.font = [UIFont systemFontOfSize:11];
    placeLab.textColor = ColorText;
    placeLab.textAlignment = NSTextAlignmentLeft;
    placeLab.text = self.place;

    [bottomView addSubview:placeLab];
    
    [placeLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(shopLab.mas_bottom);
        make.left.equalTo(shopLab);
        make.right.equalTo(shopLab);
        make.height.mas_equalTo([JNSYAutoSize AutoHeight:20]);
    }];
    
    //查看路线
    UIButton *routeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [routeBtn setTitle:@"查看路线" forState:UIControlStateNormal];
    routeBtn.titleLabel.font = [UIFont systemFontOfSize:13];
    [routeBtn setTitleColor:ColorText forState:UIControlStateNormal];
    [routeBtn setBackgroundColor:ColorTableBack];
    [routeBtn addTarget:self action:@selector(getRoute) forControlEvents:UIControlEventTouchUpInside];
    routeBtn.layer.borderColor = [UIColor lightGrayColor].CGColor;
    routeBtn.layer.borderWidth = 0.5;
    routeBtn.layer.cornerRadius = 3;
    routeBtn.layer.masksToBounds = YES;
    [bottomView addSubview:routeBtn];
    
    [routeBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view).offset(10);
        make.bottom.equalTo(self.view).offset(-10);
        make.height.mas_equalTo(30);
        make.width.mas_equalTo((KscreenWidth - 40 )/3.0);
    }];
    
    //更换地图
    UIButton *MapChangeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [MapChangeBtn setTitle:@"地图导航" forState:UIControlStateNormal];
    MapChangeBtn.titleLabel.font = [UIFont systemFontOfSize:13];
    [MapChangeBtn setTitleColor:ColorText forState:UIControlStateNormal];
    [MapChangeBtn setBackgroundColor:ColorTableBack];
    [MapChangeBtn addTarget:self action:@selector(changeMap) forControlEvents:UIControlEventTouchUpInside];
    MapChangeBtn.layer.borderColor = [UIColor lightGrayColor].CGColor;
    MapChangeBtn.layer.borderWidth = 0.5;
    MapChangeBtn.layer.cornerRadius = 3;
    MapChangeBtn.layer.masksToBounds = YES;
    [bottomView addSubview:MapChangeBtn];
    
    [MapChangeBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(routeBtn.mas_right).offset(10);
        make.bottom.equalTo(self.view).offset(-10);
        make.height.mas_equalTo(30);
        make.width.mas_equalTo((KscreenWidth - 40 )/3.0);
    }];
    
    
    //显示工具（定位图标和放大缩小）
    UIView *zoomPannelView = [self makeZoomPannelView];
    zoomPannelView.autoresizingMask = UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleLeftMargin;
    [self.view addSubview:zoomPannelView];
    
    self.gpsButton = [self makeGPSButtonView];
    [self.view addSubview:self.gpsButton];
    
    self.gpsButton.autoresizingMask = UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleRightMargin;

    [self.gpsButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view).offset(20);
        make.bottom.equalTo(bottomView.mas_top).offset(-20);
        make.size.mas_equalTo(CGSizeMake(40, 40));
    }];
    
    [zoomPannelView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.view).offset(-20);
        make.bottom.equalTo(bottomView.mas_top).offset(-20);
        make.size.mas_equalTo(CGSizeMake(53, 98));
    }];
    
    //返回按钮
    
    UIButton *BackBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    BackBtn.frame = CGRectMake(-3, 24, 60, 30);
    [BackBtn setImage:[UIImage imageNamed:@"返回"] forState:UIControlStateNormal];
    [BackBtn addTarget:self action:@selector(back) forControlEvents:UIControlEventTouchUpInside];
    BackBtn.backgroundColor = [UIColor blackColor];
    BackBtn.alpha = 0.7;
    BackBtn.layer.cornerRadius = 4;
    BackBtn.layer.masksToBounds = YES;
    [self.view addSubview:BackBtn];
    
    
}

- (void)back {
    
    [self.navigationController popViewControllerAnimated:YES];
    
    
}

//查看路线
-(void)getRoute {
    
    
    NSLog(@"查看路线");
    
    CLLocation *location = [[CLLocation alloc] initWithLatitude:[self.lat doubleValue] longitude:[self.lng doubleValue]];
    
    AMapTransitRouteSearchRequest *navi = [[AMapTransitRouteSearchRequest alloc] init];
    
    navi.requireExtension = YES;
    //navi.strategy = 5;
    navi.city = @"hangzhou";
    navi.destinationCity = @"ningbo";
    navi.origin = [AMapGeoPoint locationWithLatitude:MapView.userLocation.coordinate.latitude longitude:MapView.userLocation.coordinate.longitude];
    
    navi.destination = [AMapGeoPoint locationWithLatitude:location.coordinate.latitude longitude:location.coordinate.longitude];
    
    [search AMapTransitRouteSearch:navi];
    
   
    
}

//更换地图
- (void)changeMap {
    
    
    if ([[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:@"baidumap://"]]) {
        NSLog(@"百度地图");
    } if ([[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:@"iosamap://"]]){
        NSLog(@"高德地图");
    } if ([[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:@"comgooglemaps://"]]) {
        NSLog(@"谷歌地图");
    }
    
    //获取安装的APP
    NSArray *array = [self getInstalledMapApp];
    
    //提示
    [self alertMaps:array];
    
    
}

//地图标注
- (MAAnnotationView *)mapView:(MAMapView *)mapView viewForAnnotation:(id<MAAnnotation>)annotation {
    
    
    if ([annotation isKindOfClass:[MAUserLocation class]]) { //用户定位图标
        
        
    }else if ([annotation isKindOfClass:[MAPointAnnotation class]]) {
        static NSString *pointReuseIndetifier = @"pointReuseIndetifier";
        
        MAAnnotationView *annotationView = (MAAnnotationView *)[mapView dequeueReusableAnnotationViewWithIdentifier:pointReuseIndetifier];
        if (annotationView == nil)
        {
            annotationView = [[MAAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:pointReuseIndetifier];
        }
        
        annotationView.canShowCallout   = YES;
       // annotationView.animatesDrop     = YES;
        annotationView.draggable        = NO;
    
        annotationView.image = [UIImage imageNamed:@"药店-SEL"];
    
        if ([annotation isKindOfClass:[MANaviAnnotation class]])
        {
            switch (((MANaviAnnotation*)annotation).type)
            {
                case MANaviAnnotationTypeRailway:
                    annotationView.image = [UIImage imageNamed:@"railway_station"];
                    break;
                    
                case MANaviAnnotationTypeBus:
                    annotationView.image = [UIImage imageNamed:@"bus"];
                    break;
                    
                case MANaviAnnotationTypeDrive:
                    annotationView.image = [UIImage imageNamed:@"car"];
                    break;
                    
                case MANaviAnnotationTypeWalking:
                    annotationView.image = [UIImage imageNamed:@"man"];
                    break;
                    
                default:
                    break;
            }
        }
        else
        {
            /* 起点. */
            if ([[annotation title] isEqualToString:@"起点"])
            {
                annotationView.image = [UIImage imageNamed:@"startPoint"];
            }
            /* 终点. */
            else if([[annotation title] isEqualToString:@"终点"])
            {
                annotationView.image = [UIImage imageNamed:@"endPoint"];
            }
            
        }

        
        
        return annotationView;
    }
    
    return nil;
    
}

#pragma mark - MAMapViewDelegate

- (MAOverlayRenderer *)mapView:(MAMapView *)mapView rendererForOverlay:(id<MAOverlay>)overlay
{
    if ([overlay isKindOfClass:[LineDashPolyline class]])
    {
//        MAPolylineRenderer *polylineRenderer = [[MAPolylineRenderer alloc] initWithPolyline:((LineDashPolyline *)overlay).polyline];
//        polylineRenderer.lineWidth   = 8;
//        //polylineRenderer.lineDashPattern = @[@10, @15];
//        polylineRenderer.strokeColor = [UIColor redColor];
//        
//        return polylineRenderer;
    }
    if ([overlay isKindOfClass:[MANaviPolyline class]])
    {
        MANaviPolyline *naviPolyline = (MANaviPolyline *)overlay;
        MAPolylineRenderer *polylineRenderer = [[MAPolylineRenderer alloc] initWithPolyline:naviPolyline.polyline];
        
        polylineRenderer.lineWidth = 8;
        
        if (naviPolyline.type == MANaviAnnotationTypeWalking)
        {
            polylineRenderer.strokeColor = self.naviRoute.walkingColor;
        }
        else if (naviPolyline.type == MANaviAnnotationTypeRailway)
        {
            polylineRenderer.strokeColor = self.naviRoute.railwayColor;
        }
        else
        {
            polylineRenderer.strokeColor = self.naviRoute.routeColor;
        }
        
        return polylineRenderer;
    }
    if ([overlay isKindOfClass:[MAMultiPolyline class]])
    {
        MAMultiColoredPolylineRenderer * polylineRenderer = [[MAMultiColoredPolylineRenderer alloc] initWithMultiPolyline:overlay];
        
        polylineRenderer.lineWidth = 8;
        polylineRenderer.strokeColors = [self.naviRoute.multiPolylineColors copy];
        polylineRenderer.gradient = YES;
        
        return polylineRenderer;
    }
    
    return nil;
}



/*    展示路线    */
- (void)presentCurrentCourse {
    
    //MANaviAnnotationType type = MANaviAnnotationTypeDrive;
    
//    self.naviRoute = [MANaviRoute naviRouteForPath:self.route.transits[self.currentCouse] withNaviType:type showTraffic:YES startPoint:[AMapGeoPoint locationWithLatitude:[self.lat floatValue] longitude:[self.lng floatValue]] endPoint:[AMapGeoPoint locationWithLatitude:(MapView.userLocation.coordinate.latitude) longitude:(MapView.userLocation.coordinate.longitude)]];
    
    self.naviRoute = [MANaviRoute naviRouteForTransit:self.route.transits[self.currentCouse] startPoint:[AMapGeoPoint locationWithLatitude:[self.lat floatValue] longitude:[self.lng floatValue]] endPoint:[AMapGeoPoint locationWithLatitude:(MapView.userLocation.coordinate.latitude) longitude:(MapView.userLocation.coordinate.longitude)]];
    
    [self.naviRoute addToMapView:MapView];
    
    /*    缩放地图使其适应polylines的展示  */
    [MapView showOverlays:self.naviRoute.routePolylines edgePadding:UIEdgeInsetsMake(20, 20, 20, 20) animated:YES];
    
}

/*    路径规划搜索回调     */

- (void)onRouteSearchDone:(AMapRouteSearchBaseRequest *)request response:(AMapRouteSearchResponse *)response {
    
    if (response.route == nil) {
        return;
    }
    
    self.route = response.route;
    self.currentCouse = 0;
    
    
        //[self presentCurrentCourse];
        
    JNSYRoutePlansViewController *routePlans = [[JNSYRoutePlansViewController alloc] init];
    routePlans.startCoordinate = MapView.userLocation.coordinate;
    routePlans.destinationCoordinate = CLLocationCoordinate2DMake([self.lat floatValue], [self.lng floatValue]);
    routePlans.hidesBottomBarWhenPushed = YES;
    routePlans.routePlanningType = AMapRoutePlanningTypeBusCrossCity;
    routePlans.route = response.route;
    [self.navigationController pushViewController:routePlans animated:YES];
    
    
    NSLog(@"Route:%ld Path:%@",(long)response.count,response.route.paths[_currentCouse].steps);
    
}


/*   检索失败回调  */

- (void)AMapSearchRequest:(id)request didFailWithError:(NSError *)error {
    
    
    NSLog(@"Error:%@ - %@",error,[ErrorInfoUtility errorDescriptionWithCode:error.code]);
    
}

//获取已安装的地图APP
- (NSArray *)getInstalledMapApp{
    
    NSMutableArray *maps = [NSMutableArray array];
    
    //苹果自带地图
    NSMutableDictionary *iosMapDic = [NSMutableDictionary dictionary];
    [iosMapDic setObject:@"iPhone自带地图导航" forKey:@"title"];
    
    [maps addObject:iosMapDic];
    
    //APP名字
    NSString *appStr = NSLocalizedString(@"捷牛送药", nil);
    
    //百度地图
    if ([[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:@"baidumap://"]]) {
        
        NSMutableDictionary *baiduMapDic = [NSMutableDictionary dictionary];
        [baiduMapDic setObject:@"百度地图导航" forKey:@"title"];
        NSString *urlString = [[NSString stringWithFormat:@"baidumap://map/direction?origin=%@|name:%@&destination=latlng:%f,%f|name:%@&mode=driving&scr=%@",@"我的位置",@"我的位置",[self.lat floatValue],[self.lng floatValue],self.place,appStr] stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet  URLQueryAllowedCharacterSet]];
        [baiduMapDic setObject:urlString forKey:@"url"];
        [maps addObject:baiduMapDic];
        
        NSLog(@"百度地图");
    }
    
    //高德地图
    if ([[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:@"iosamap://"]]){
        
        
        NSMutableDictionary *gaodeMapDic = [NSMutableDictionary dictionary];
        [gaodeMapDic setObject:@"高德地图导航" forKey:@"title"];
        NSString *urlString = [[NSString stringWithFormat:@"iosamap://navi?sourceApplication=%@&lat=%f&lon=%f&pointname=%@&dev=0&t=2",appStr,[self.lat floatValue],[self.lng floatValue],self.place] stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet  URLQueryAllowedCharacterSet]];
        
        [gaodeMapDic setObject:urlString forKey:@"url"];
        
        [maps addObject:gaodeMapDic];
        
        NSLog(@"高德地图");
    }
    
    //谷歌地图
    if ([[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:@"comgooglemaps://"]]) {
        
        
        NSMutableDictionary *googleMapDic = [NSMutableDictionary dictionary];
        [googleMapDic setObject:@"谷歌地图导航" forKey:@"title"];
        
        NSString *urlString = [[NSString stringWithFormat:@"comgooglemaps://?saddr=&daddr=%@&directionsmode=driving",@"我的位置"] stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet  URLQueryAllowedCharacterSet]];
        
        [googleMapDic setObject:urlString forKey:@"url"];
        
        [maps addObject:googleMapDic];
        
        NSLog(@"谷歌地图");
    }

    
    return maps;
    
}

//展示所安装的地图
- (void)alertMaps:(NSArray *)array {
    
    
    if (array.count == 0) {
        return;
    }
    
    UIAlertController *alertVc = [UIAlertController alertControllerWithTitle:nil message:nil preferredStyle:UIAlertControllerStyleActionSheet];
    for (NSInteger i = 0; i < array.count; i++) {
        /*  跳转自带地图  */
        if (i == 0) {
            [alertVc addAction:[UIAlertAction actionWithTitle:array[i][@"title"] style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                
                [self navAppleMap];
            }]];
        }else {
            
            [alertVc addAction:[UIAlertAction actionWithTitle:array[i][@"title" ] style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                [self openOtherMaps:i array:array];
            }]];
            
        }
        
        
    }
    
    [alertVc addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil]];
    
    
    [self presentViewController:alertVc animated:YES completion:nil];
}

//自带地图导航
- (void)navAppleMap {
    
    CLLocationCoordinate2D cl = CLLocationCoordinate2DMake([self.lat floatValue], [self.lng floatValue]);
    
    
    MKMapItem *currentLoc = [MKMapItem mapItemForCurrentLocation];
    
    MKPlacemark *mark = [[MKPlacemark alloc] initWithCoordinate:cl];
    
    MKMapItem *toLocation = [[MKMapItem alloc] initWithPlacemark:mark];
    toLocation.name = self.place;
    
    NSArray *items = @[currentLoc,toLocation];
    NSDictionary *dic = @{
                          MKLaunchOptionsDirectionsModeKey:MKLaunchOptionsDirectionsModeDriving,
                          MKLaunchOptionsMapTypeKey:@(MKMapTypeStandard),
                          MKLaunchOptionsShowsTrafficKey:@(YES)
                          };
    
    [MKMapItem openMapsWithItems:items launchOptions:dic];
}


- (void)openOtherMaps:(NSInteger)index array:(NSArray *)maps{
    
    NSDictionary *dic = maps[index];
    
    NSString *urlString = dic[@"url"];
    
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:urlString]];
}

//GPS 按钮
- (UIButton *)makeGPSButtonView {
    UIButton *ret = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 40, 40)];
    ret.backgroundColor = [UIColor whiteColor];
    ret.layer.cornerRadius = 4;
    
    [ret setImage:[UIImage imageNamed:@"gpsStat1"] forState:UIControlStateNormal];
    [ret addTarget:self action:@selector(gpsAction) forControlEvents:UIControlEventTouchUpInside];
    
    return ret;
}


- (UIView *)makeZoomPannelView
{
    UIView *ret = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 53, 98)];
    
    UIButton *incBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 53, 49)];
    [incBtn setImage:[UIImage imageNamed:@"increase"] forState:UIControlStateNormal];
    [incBtn sizeToFit];
    [incBtn addTarget:self action:@selector(zoomPlusAction) forControlEvents:UIControlEventTouchUpInside];
    
    UIButton *decBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 49, 53, 49)];
    [decBtn setImage:[UIImage imageNamed:@"decrease"] forState:UIControlStateNormal];
    [decBtn sizeToFit];
    [decBtn addTarget:self action:@selector(zoomMinusAction) forControlEvents:UIControlEventTouchUpInside];
    
    
    [ret addSubview:incBtn];
    [ret addSubview:decBtn];
    
    return ret;
}

#pragma mark - Action Handlers
- (void)returnAction
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)zoomPlusAction
{
    CGFloat oldZoom = MapView.zoomLevel;
    [MapView setZoomLevel:(oldZoom + 1) animated:YES];
}

- (void)zoomMinusAction
{
    CGFloat oldZoom = MapView.zoomLevel;
    [MapView setZoomLevel:(oldZoom - 1) animated:YES];
}

- (void)gpsAction {
    if(
       MapView.userLocation.updating &&
       MapView.userLocation.location) {
        [
         MapView setCenterCoordinate:
         MapView.userLocation.location.coordinate animated:YES];
        [self.gpsButton setSelected:YES];
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
