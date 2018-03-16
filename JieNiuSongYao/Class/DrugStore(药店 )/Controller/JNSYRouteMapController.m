//
//  JNSYRouteMapController.m
//  JieNiuSongYao
//
//  Created by rongfeng on 2017/7/19.
//  Copyright © 2017年 China Zhou. All rights reserved.
//

#import "JNSYRouteMapController.h"
#import "Common.h"
#import "Masonry.h"
#import <MAMapKit/MAMapKit.h>
#import <AMapLocationKit/AMapLocationKit.h>
#import <AMapFoundationKit/AMapFoundationKit.h>
#import <AMapSearchKit/AMapSearchKit.h>
#import "MANaviRoute.h"
#import "ErrorInfoUtility.h"
#import "JNSYAutoSize.h"
#import "JNSYUserInfo.h"
#import "JNSYRouteDetailCell.h"
static const NSString *RoutePlanningViewControllerStartTitle       = @"起点";
static const NSString *RoutePlanningViewControllerDestinationTitle = @"终点";

@interface JNSYRouteMapController ()<MAMapViewDelegate,UITableViewDelegate,UITableViewDataSource>

@property(nonatomic,strong)MANaviRoute *naviRoute;

@property(nonatomic,strong)NSMutableArray *routeDetailArray;

@property(nonatomic,strong)UIButton *gpsButton;

@end

@implementation JNSYRouteMapController {
    
    
    MAMapView *MapView;
    UITableView *table;
    
}

- (void)viewWillAppear:(BOOL)animated {
    
    [super viewWillAppear:animated];
    
    self.title = @"导航路线";
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    
    [self.navigationController setNavigationBarHidden:YES animated:NO];
    
    
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault animated:YES];
}

- (void)viewWillDisappear:(BOOL)animated {
    
    [super viewWillDisappear:animated];
    
    
    
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent animated:YES];
    
    
}


- (void)viewDidLoad {
    [super viewDidLoad];
    
    
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

    [self.view addSubview:MapView];

    //展示路线
    [self presentCurrentCourse];
    
    //添加默认图标
    [self addDefaultAnnotations];
    
    //定位和放大
    [self GPSAndMangfy];
    
    //创建底部视图
    [self createBottomRouteView];
    
   
    
    
    //打印路线入出抠
    [self poRouteLines];
    
    
    
    //返回按钮
    
    UIButton *BackBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    BackBtn.frame = CGRectMake(-3, 24, 60, 30);
    [BackBtn addTarget:self action:@selector(back) forControlEvents:UIControlEventTouchUpInside];
    [BackBtn setImage:[UIImage imageNamed:@"返回"] forState:UIControlStateNormal];
    BackBtn.backgroundColor = [UIColor blackColor];
    BackBtn.alpha = 0.7;
    BackBtn.layer.cornerRadius = 4;
    BackBtn.layer.masksToBounds = YES;
    [self.view addSubview:BackBtn];
    
    
}


- (void)back {
    
    
    [self.navigationController popViewControllerAnimated:YES];
    
}

- (void)GPSAndMangfy {
    
    //显示工具（定位图标和放大缩小）
    UIView *zoomPannelView = [self makeZoomPannelView];
    zoomPannelView.autoresizingMask = UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleLeftMargin;
    [self.view addSubview:zoomPannelView];
    
    self.gpsButton = [self makeGPSButtonView];
    [self.view addSubview:self.gpsButton];
    
    self.gpsButton.autoresizingMask = UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleRightMargin;
    
    [self.gpsButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view).offset(20);
        make.bottom.equalTo(self.view).offset(-120);
        make.size.mas_equalTo(CGSizeMake(40, 40));
    }];
    
    [zoomPannelView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.view).offset(-20);
        make.bottom.equalTo(self.view).offset(-120);
        make.size.mas_equalTo(CGSizeMake(53, 98));
    }];
    
    
}


//创建底部路线视图
- (void)createBottomRouteView {
    
    
    self.routeDetailArray = [[NSMutableArray alloc] init];
    
    
    //点击手势
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(TapHide:)];
    tap.numberOfTapsRequired = 1;
    //清扫手势
    UISwipeGestureRecognizer *swipe = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(Swipe:)];
    swipe.direction = UISwipeGestureRecognizerDirectionDown;
    swipe.numberOfTouchesRequired = 1;
    
    UISwipeGestureRecognizer *SwipeTwo = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(Swipe:)];
    SwipeTwo.direction = UISwipeGestureRecognizerDirectionUp;
    SwipeTwo.numberOfTouchesRequired = 1;
    
    
    float height = IsSmallScreen?(KscreenHeight/2.0):(KscreenHeight/3.0);
    
    
    UIImageView *RouteBackImg = [[UIImageView alloc] initWithFrame:CGRectMake(0, KscreenHeight - height + 10, KscreenWidth, height)];
    RouteBackImg.backgroundColor = [UIColor whiteColor];
    RouteBackImg.userInteractionEnabled = YES;
    RouteBackImg.layer.cornerRadius = 8;
    RouteBackImg.layer.masksToBounds = YES;
    
    [self.view addSubview:RouteBackImg];

    
    UIImageView *titleLogoView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 6, 40, 5)];
    titleLogoView.backgroundColor = [UIColor colorWithRed:192/255.0 green:190/255.0 blue:187/255.0 alpha:1];
    titleLogoView.layer.cornerRadius = 3;
    [RouteBackImg addSubview:titleLogoView];
    
    [titleLogoView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(RouteBackImg).offset(6);
        make.centerX.equalTo(RouteBackImg);
        make.height.mas_equalTo([JNSYAutoSize AutoHeight:5]);
        make.width.mas_equalTo(40);
    }];
    
    UIImageView *headerImg = [[UIImageView alloc] init];
    [RouteBackImg addSubview:headerImg];
    headerImg.userInteractionEnabled = YES;
    headerImg.backgroundColor = [UIColor redColor];
    //添加手势
    [headerImg addGestureRecognizer:tap];
    [headerImg addGestureRecognizer:swipe];
    [headerImg addGestureRecognizer:SwipeTwo];
    headerImg.backgroundColor = [UIColor whiteColor];
    [headerImg mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(RouteBackImg).offset(15);
        make.left.right.equalTo(RouteBackImg);
        make.height.mas_equalTo([JNSYAutoSize AutoHeight:50]);
    }];
    
    //路线
    UILabel *lab = [[UILabel alloc] init];
    lab.font = [UIFont systemFontOfSize:13];
    lab.text = self.roadStr;
    [headerImg addSubview:lab];
    
    [lab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(headerImg).offset(5);
        make.left.equalTo(headerImg).offset(16);
        make.right.equalTo(headerImg);
        make.height.mas_equalTo([JNSYAutoSize AutoHeight:15]);
    }];
    
    //时间距离
    UILabel *timeLab = [[UILabel alloc] init];
    timeLab.font = [UIFont systemFontOfSize:11];
    timeLab.textColor = [UIColor lightGrayColor];
    timeLab.text = self.timeStr;
    [headerImg addSubview:timeLab];
    
    [timeLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(lab.mas_bottom).offset(5);
        make.left.right.equalTo(lab);
        make.height.mas_equalTo([JNSYAutoSize AutoHeight:15]);
    }];
    
    //分割线
    UIImageView *lineView = [[UIImageView alloc] initWithFrame:CGRectMake(16, [JNSYAutoSize AutoHeight:50], KscreenWidth - 32, 0.5)];
    lineView.backgroundColor = ColorTableViewCellSeparate;
    [headerImg addSubview:lineView];
    
    //table
    table = [[UITableView alloc] initWithFrame:CGRectMake(0, 20+[JNSYAutoSize AutoHeight:50], KscreenWidth, (height - 17-[JNSYAutoSize AutoHeight:50] ))];
    table.delegate = self;
    table.dataSource = self;
    table.separatorStyle = UITableViewCellSeparatorStyleNone;
    [RouteBackImg addSubview:table];
    
    RouteBackImg.frame = CGRectMake(0, KscreenHeight - (20 + [JNSYAutoSize AutoHeight:50]), KscreenWidth, 20 + [JNSYAutoSize AutoHeight:50]);
    
    [self performSelector:@selector(show:) withObject:RouteBackImg afterDelay:0.8];
    
}

- (void)show:(UIImageView *)view{
    
    
    float height = IsSmallScreen?(KscreenHeight/2.0):(KscreenHeight/3.0);
    
    [UIView animateWithDuration:0.3 animations:^{
        view.frame = CGRectMake(0, KscreenHeight - (height), KscreenWidth, height);
    }];
    
}

//点击手势方法
- (void)TapHide:(UITapGestureRecognizer *)sender {
    
    
    float height = sender.view.superview.frame.size.height;
    float bottomHeight = IsSmallScreen?(KscreenHeight/2.0):(KscreenHeight/3.0);
    if (height < (bottomHeight - 10)) {
        [UIView animateWithDuration:0.3 animations:^{
            sender.view.superview.frame = CGRectMake(0, KscreenHeight - (bottomHeight), KscreenWidth, bottomHeight);
        }];

    }else {
        [UIView animateWithDuration:0.3 animations:^{
            sender.view.superview.frame = CGRectMake(0, KscreenHeight - (20 + [JNSYAutoSize AutoHeight:50]), KscreenWidth, 20 + [JNSYAutoSize AutoHeight:50]);
        }];
    }
    
}
//清扫手势方法
- (void)Swipe:(UISwipeGestureRecognizer *)sender {
    
    float bottomHeight = IsSmallScreen?(KscreenHeight/2.0):(KscreenHeight/3.0);
      //float height = sender.view.superview.frame.size.height;
    
    if (sender.direction == UISwipeGestureRecognizerDirectionUp) {
        [UIView animateWithDuration:0.3 animations:^{
            sender.view.superview.frame = CGRectMake(0, KscreenHeight - (bottomHeight), KscreenWidth, bottomHeight);
        }];
    }else if(sender.direction == UISwipeGestureRecognizerDirectionDown) {
        
        [UIView animateWithDuration:0.3 animations:^{
            sender.view.superview.frame = CGRectMake(0, KscreenHeight - (20 + [JNSYAutoSize AutoHeight:50]), KscreenWidth, 20 + [JNSYAutoSize AutoHeight:50]);
        }];
    }
    
    NSLog(@"清扫");
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    
    NSLog(@"Count:%ld",(unsigned long)self.routeDetailArray.count);
    
    return self.routeDetailArray.count;
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *identy = @"cell";
    
    JNSYRouteDetailCell *cell = [tableView dequeueReusableCellWithIdentifier:identy];
    
    if (cell == nil) {
        cell = [[JNSYRouteDetailCell alloc] init];
        cell.detailLab.text = self.routeDetailArray[indexPath.row];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
    
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    return 50;
    
}


/*    展示路线    */
- (void)presentCurrentCourse {
    
   
    if (self.routePlanningType == AMapRoutePlanningTypeBus || self.routePlanningType == AMapRoutePlanningTypeBusCrossCity) {
        
        self.naviRoute = [MANaviRoute naviRouteForTransit:self.transit startPoint:[AMapGeoPoint locationWithLatitude:self.startCoordinate.latitude longitude:self.startCoordinate.longitude] endPoint:[AMapGeoPoint locationWithLatitude:self.destinationCoordinate.latitude longitude:self.destinationCoordinate.longitude]];
        
        
    }else {
        
        MANaviAnnotationType type = MANaviAnnotationTypeWalking;
        if (self.routePlanningType == AMapRoutePlanningTypeDrive) {
            type = MANaviAnnotationTypeDrive;
        }else if (self.routePlanningType == AMapRoutePlanningTypeWalk) {
            
        }else if (self.routePlanningType == AMapRoutePlanningTypeRiding) {
            type = MANaviAnnotationTypeRiding;
        }
        
        self.naviRoute = [MANaviRoute naviRouteForPath:self.path withNaviType:type showTraffic:YES startPoint:[AMapGeoPoint locationWithLatitude:self.startCoordinate.latitude longitude:self.startCoordinate.longitude] endPoint:[AMapGeoPoint locationWithLatitude:self.destinationCoordinate.latitude longitude:self.destinationCoordinate.longitude]];
        
    }
    
    [self.naviRoute addToMapView:MapView];
    
    /*    缩放地图使其适应polylines的展示  */
    [MapView showOverlays:self.naviRoute.routePolylines edgePadding:UIEdgeInsetsMake(20, 20, 20, 20) animated:YES];
    
}


#pragma mark - MAMapViewDelegate

- (MAOverlayRenderer *)mapView:(MAMapView *)mapView rendererForOverlay:(id<MAOverlay>)overlay
{
    if ([overlay isKindOfClass:[LineDashPolyline class]])
    {
        MAPolylineRenderer *polylineRenderer = [[MAPolylineRenderer alloc] initWithPolyline:((LineDashPolyline *)overlay).polyline];
        polylineRenderer.lineWidth   = 8;
       // polylineRenderer.lineDashPattern = @[@10, @15];
        polylineRenderer.strokeColor = [UIColor redColor];
        
        return polylineRenderer;
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


- (MAAnnotationView *)mapView:(MAMapView *)mapView viewForAnnotation:(id<MAAnnotation>)annotation
{
    if ([annotation isKindOfClass:[MAUserLocation class]]) {
        
        
    }
    else if ([annotation isKindOfClass:[MAPointAnnotation class]])
    {
        static NSString *routePlanningCellIdentifier = @"RoutePlanningCellIdentifier";
        
        MAAnnotationView *poiAnnotationView = (MAAnnotationView*)[MapView dequeueReusableAnnotationViewWithIdentifier:routePlanningCellIdentifier];
        if (poiAnnotationView == nil)
        {
            poiAnnotationView = [[MAAnnotationView alloc] initWithAnnotation:annotation
                                                             reuseIdentifier:routePlanningCellIdentifier];
        }
        
        poiAnnotationView.canShowCallout = YES;
        poiAnnotationView.image = nil;
        poiAnnotationView.image = [UIImage imageNamed:@"药店-SEL"];
        
        if ([annotation isKindOfClass:[MANaviAnnotation class]])
        {
            switch (((MANaviAnnotation*)annotation).type)
            {
                case MANaviAnnotationTypeRailway:
                    poiAnnotationView.image = [UIImage imageNamed:@"railway_station"];
                    break;
                    
                case MANaviAnnotationTypeBus:
                    poiAnnotationView.image = [UIImage imageNamed:@"bus"];
                    break;
                    
                case MANaviAnnotationTypeDrive:
                    poiAnnotationView.image = [UIImage imageNamed:@"car"];
                    break;
                    
                case MANaviAnnotationTypeWalking:
                    poiAnnotationView.image = [UIImage imageNamed:@"man"];
                    break;
                case MANaviAnnotationTypeRiding:
                    poiAnnotationView.image = [UIImage imageNamed:@"ride"];
                    break;
                    
                default:
                    break;
            }
        }
        else
        {
            /* 起点. */
            if ([[annotation title] isEqualToString:(NSString *)RoutePlanningViewControllerStartTitle])
            {
                poiAnnotationView.image = [UIImage imageNamed:@"startPoint"];
            }
            /* 终点. */
            else if([[annotation title] isEqualToString:(NSString *)RoutePlanningViewControllerDestinationTitle])
            {
                poiAnnotationView.image = [UIImage imageNamed:@"endPoint"];
            }
            
        }
        
        return poiAnnotationView;
    }
    
    return nil;
}

- (void)addDefaultAnnotations
{
    MAPointAnnotation *startAnnotation = [[MAPointAnnotation alloc] init];
    startAnnotation.coordinate = self.startCoordinate;
    startAnnotation.title      = (NSString*)RoutePlanningViewControllerStartTitle;
    startAnnotation.subtitle   = [NSString stringWithFormat:@"{%f, %f}", self.startCoordinate.latitude, self.startCoordinate.longitude];
    //self.startAnnotation = startAnnotation;
    
    MAPointAnnotation *destinationAnnotation = [[MAPointAnnotation alloc] init];
    destinationAnnotation.coordinate = self.destinationCoordinate;
    destinationAnnotation.title      = (NSString*)RoutePlanningViewControllerDestinationTitle;
    destinationAnnotation.subtitle   = [NSString stringWithFormat:@"{%f, %f}", self.destinationCoordinate.latitude, self.destinationCoordinate.longitude];
    //self.destinationAnnotation = destinationAnnotation;
    
    [MapView addAnnotation:startAnnotation];
    [MapView addAnnotation:destinationAnnotation];
}


//路线细节
- (void)poRouteLines {
    
    
    
    self.routeDetailArray = [[NSMutableArray alloc] init];
    
    if (self.transit) {  //公交路线
        
        AMapTransit *transit = self.transit;
        
        NSArray *segments = transit.segments;
        
        for (NSInteger i = 0; i < segments.count; i++) {
            
            AMapSegment *segment = segments[i];
            
            //步行路线
            AMapWalking *walkLine = segment.walking;
            
            NSArray *stepArray = walkLine.steps;
            
            for (NSInteger m = 0; m < stepArray.count; m ++) {
                AMapStep *step = stepArray[m];
                
                //NSLog(@"行走指示:%@,方向:%@,道路:%@,路长:%ld",step.instruction,step.orientation,step.road,step.distance);
                
                [self.routeDetailArray addObject:step.instruction];
                
            }
            
            //公交路线
            NSArray *busLines = segment.buslines;
            for (NSInteger j = 0; j < busLines.count; j ++) {
                AMapBusLine *busLine = busLines[j];
                //启程站
                AMapBusStop *start = busLine.departureStop;
                //下车站
                AMapBusStop *stop = busLine.arrivalStop;
                
                NSArray *viaBusStops = busLine.viaBusStops;
                
                //NSLog(@"路线名:%@,启程站:%@,下车站:%@,途径%ld站 ",busLine.name,start.name,stop.name,(viaBusStops.count + 1));
                
                NSString *str = [busLine.name componentsSeparatedByString:@"("][0];
                str = [NSString stringWithFormat:@"乘坐%@,在%@上车,经过%u站,到%@站下车",str,start.name,(viaBusStops.count + 1),stop.name];
                
                [self.routeDetailArray addObject:str];
                
                
            }
            
            
            if (i >= (segments.count - 1)) {
                [table reloadData];
            }
            
        }
        
    }else if (self.path) {  //骑行、步行、驾车
        
        NSArray *steps = self.path.steps;
        
        for (NSInteger m = 0; m < steps.count; m ++) {
            AMapStep *step = steps[m];
            
            NSLog(@"行走指示:%@,方向:%@,道路:%@,路长:%ld",step.instruction,step.orientation,step.road,(long)step.distance);
            
            [self.routeDetailArray addObject:step.instruction];
            
        }
        
        [table reloadData];
        
    }else {
        
        
    }
    
    
//    for (NSInteger i = 0; i < self.routeDetailArray.count; i++) {
//        NSLog(@"%@",self.routeDetailArray[i]);
//    }
    
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
