//
//  JNSYRoutePlansViewController.m
//  JieNiuSongYao
//
//  Created by rongfeng on 2017/7/18.
//  Copyright © 2017年 China Zhou. All rights reserved.
//

#import "JNSYRoutePlansViewController.h"
#import "JNSYAutoSize.h"
#import "JNSYUserInfo.h"
#import "Common.h"
#import "Masonry.h"
#import "JNSYRoutePlansCell.h"
#import <AMapSearchKit/AMapSearchKit.h>
#import "MANaviRoute.h"
#import "ErrorInfoUtility.h"
#import "JNSYRouteMapController.h"
@interface JNSYRoutePlansViewController ()<UITableViewDelegate,UITableViewDataSource,AMapSearchDelegate>


@property(nonatomic,strong)AMapSearchAPI *search;

@property(nonatomic,strong)MANaviRoute *naviRoute;



@end

@implementation JNSYRoutePlansViewController {
    
    UITableView *table;
    UIButton *busBtn;
    UIButton *driveBtn;
    UIButton *walkBtn;
    UIButton *rideBtn;
}

- (void)viewWillAppear:(BOOL)animated {
    
    [super viewWillAppear:animated];
    
    self.title = @"查看路线";
    self.view.backgroundColor = [UIColor whiteColor];
    
    
    [self.navigationController setNavigationBarHidden:NO animated:YES];
    
    [table reloadData];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //返回按钮
    self.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"" style:UIBarButtonItemStylePlain target:self action:nil];
    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
    
    UIImageView *backImg = [[UIImageView alloc] init];
    //backImg.backgroundColor = [UIColor redColor];
    backImg.userInteractionEnabled = YES;
    
    [self.view addSubview:backImg];
    
    [backImg mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view).offset(0);
        make.left.right.equalTo(self.view);
        make.height.mas_equalTo([JNSYAutoSize AutoHeight:50]);
    }];

    //底部图片
    UIImageView *BottomLineView = [[UIImageView alloc] init];
    BottomLineView.backgroundColor = ColorTableBack;
    BottomLineView.layer.shadowColor = [UIColor blackColor].CGColor;
    BottomLineView.layer.shadowOffset = CGSizeMake(3, 3);
    BottomLineView.layer.shadowOpacity = 0.5;
    BottomLineView.layer.shadowRadius = 2;
    //[backImg addSubview:BottomLineView];
    
    //[BottomLineView mas_makeConstraints:^(MASConstraintMaker *make) {
    //    make.left.right.equalTo(backImg);
    //    make.bottom.equalTo(backImg).offset(-0.5);
    //    make.height.mas_equalTo(0.5);
    //}];
    
    
    busBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    
    [busBtn setImage:[UIImage imageNamed:@"公交Gray"] forState:UIControlStateNormal];
    [busBtn setImage:[UIImage imageNamed:@"公交"] forState:UIControlStateSelected];
    [busBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [busBtn addTarget:self action:@selector(busRoutes:) forControlEvents:UIControlEventTouchUpInside];
    busBtn.titleLabel.font = [UIFont systemFontOfSize:13];
    busBtn.layer.cornerRadius = 3;
    busBtn.selected = YES;
    [backImg addSubview:busBtn];
    
    driveBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [driveBtn setImage:[UIImage imageNamed:@"驾车Gray"] forState:UIControlStateNormal];
    [driveBtn setImage:[UIImage imageNamed:@"驾车"] forState:UIControlStateSelected];
    [driveBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [driveBtn addTarget:self action:@selector(driveRoutes:) forControlEvents:UIControlEventTouchUpInside];
    driveBtn.titleLabel.font = [UIFont systemFontOfSize:13];
    driveBtn.layer.cornerRadius = 3;
    [backImg addSubview:driveBtn];
    
    walkBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [walkBtn setTitle:@"步行" forState:UIControlStateNormal];
    [walkBtn setImage:[UIImage imageNamed:@"步行Gray"] forState:UIControlStateNormal];
    [walkBtn setImage:[UIImage imageNamed:@"步行"] forState:UIControlStateSelected];
    [walkBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [walkBtn addTarget:self action:@selector(walkRoutes:) forControlEvents:UIControlEventTouchUpInside];
    walkBtn.titleLabel.font = [UIFont systemFontOfSize:13];
    walkBtn.layer.cornerRadius = 3;
    [backImg addSubview:walkBtn];
    
    rideBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [rideBtn setTitle:@"骑行" forState:UIControlStateNormal];
    [rideBtn setImage:[UIImage imageNamed:@"骑行Gray"] forState:UIControlStateNormal];
    [rideBtn setImage:[UIImage imageNamed:@"骑行"] forState:UIControlStateSelected];
    [rideBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [rideBtn addTarget:self action:@selector(rideRoutes:) forControlEvents:UIControlEventTouchUpInside];
    rideBtn.titleLabel.font = [UIFont systemFontOfSize:13];
    rideBtn.layer.cornerRadius = 3;
    [backImg addSubview:rideBtn];
    
    float distance = (KscreenWidth  - [JNSYAutoSize AutoHeight:26]*4)/5.0;
    float width = 30;
    [busBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(backImg).offset(3);
        make.left.equalTo(self.view).offset(distance);
        make.width.mas_equalTo([JNSYAutoSize AutoHeight:width]);
        make.height.mas_equalTo([JNSYAutoSize AutoHeight:width]);
    }];

    [driveBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(backImg).offset(3);
        make.left.equalTo(busBtn.mas_right).offset(distance);
        make.width.mas_equalTo([JNSYAutoSize AutoHeight:width]);
        make.height.mas_equalTo([JNSYAutoSize AutoHeight:width]);
    }];
    
    [walkBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(backImg).offset(3);
        make.left.equalTo(driveBtn.mas_right).offset(distance);
        make.width.mas_equalTo([JNSYAutoSize AutoHeight:width]);
        make.height.mas_equalTo([JNSYAutoSize AutoHeight:width]);
    }];
    
    [rideBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(backImg).offset(3);
        make.left.equalTo(walkBtn.mas_right).offset(distance);
        make.width.mas_equalTo([JNSYAutoSize AutoHeight:width]);
        make.height.mas_equalTo([JNSYAutoSize AutoHeight:width]);
    }];
    
    table = [[UITableView alloc] initWithFrame:CGRectMake(0, 50, KscreenWidth, KscreenHeight - 114) style:UITableViewStylePlain];
    table.backgroundColor = ColorTableBack;
    table.delegate = self;
    table.dataSource = self;
    table.tableFooterView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 0, CGFLOAT_MIN)];
    table.tableHeaderView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 0, CGFLOAT_MIN)];
    table.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:table];
    

    NSLog(@"Route:%@",self.route.transits);
    
    [self setTime:self.route.transits];
    
    
    
    self.search = [[AMapSearchAPI alloc] init];
    
    self.search.delegate = self;
    
}


//公交
- (void)busRoutes:(UIButton *)sender {
    
    
    if (sender.isSelected) {
        return;
    }else {
        
        driveBtn.selected = NO;
        walkBtn.selected = NO;
        rideBtn.selected = NO;
        
         sender.selected = !sender.selected;
    }
    
   
    
    NSLog(@"🚍");
    self.routePlanningType = AMapRoutePlanningTypeBus;
    
    AMapTransitRouteSearchRequest *navi = [[AMapTransitRouteSearchRequest alloc] init];
    navi.requireExtension = YES;
    navi.city = @"杭州";
    navi.destinationCity = @"ningbo";
    navi.origin = [AMapGeoPoint locationWithLatitude:self.startCoordinate.latitude longitude:self.startCoordinate.longitude];
    navi.destination = [AMapGeoPoint locationWithLatitude:self.destinationCoordinate.latitude longitude:self.destinationCoordinate.longitude];
    
    [self.search AMapTransitRouteSearch:navi];
    
}

//驾车
- (void)driveRoutes:(UIButton *)sender {
    
    if (sender.isSelected) {
    
        return;
        
    }else {
        
        busBtn.selected = NO;
        walkBtn.selected = NO;
        rideBtn.selected = NO;
        
         sender.selected = !sender.selected;
    }
    
    NSLog(@"🚘");
    //设置路线规划类型
    self.routePlanningType = AMapRoutePlanningTypeDrive;
    
    AMapDrivingRouteSearchRequest *navi = [[AMapDrivingRouteSearchRequest alloc] init];
    navi.requireExtension = YES;
    
    navi.origin = [AMapGeoPoint locationWithLatitude:self.startCoordinate.latitude longitude:self.startCoordinate.longitude];
    
    navi.destination = [AMapGeoPoint locationWithLatitude:self.destinationCoordinate.latitude longitude:self.destinationCoordinate.longitude];
    
    [self.search AMapDrivingRouteSearch:navi];
    
}
//步行
- (void)walkRoutes:(UIButton *)sender {
    
    if (sender.isSelected) {
        return;
    }else {
        
        busBtn.selected = NO;
        driveBtn.selected = NO;
        rideBtn.selected = NO;
        
        sender.selected = !sender.selected;
    }
    
    
    
    self.routePlanningType = AMapRoutePlanningTypeWalk;
    
    AMapWalkingRouteSearchRequest *navi = [[AMapWalkingRouteSearchRequest alloc] init];
    
    navi.origin = [AMapGeoPoint locationWithLatitude:self.startCoordinate.latitude longitude:self.startCoordinate.longitude];
    navi.destination = [AMapGeoPoint locationWithLatitude:self.destinationCoordinate.latitude longitude:self.destinationCoordinate.longitude];
    
    [self.search AMapWalkingRouteSearch:navi];
    
    NSLog(@"🚶");
    
}

//骑行
- (void)rideRoutes:(UIButton *)sender {
    
    if (sender.isSelected) {
        return;
    }else {
        
        busBtn.selected = NO;
        driveBtn.selected = NO;
        walkBtn.selected = NO;
        
        sender.selected = !sender.selected;
    }
    
    
    self.routePlanningType = AMapRoutePlanningTypeRiding;
    
    AMapRidingRouteSearchRequest *navi = [[AMapRidingRouteSearchRequest alloc] init];
    
    navi.origin = [AMapGeoPoint locationWithLatitude:self.startCoordinate.latitude longitude:self.startCoordinate.longitude];
    navi.destination = [AMapGeoPoint locationWithLatitude:self.destinationCoordinate.latitude longitude:self.destinationCoordinate.longitude];
    
    [self.search AMapRidingRouteSearch:navi];
    
    
    NSLog(@"🚲");
    
}

#pragma mark - AMapSearchDelegate
- (void)AMapSearchRequest:(id)request didFailWithError:(NSError *)error
{
    
    [table reloadData];
    [JNSYAutoSize showMsg:[ErrorInfoUtility errorDescriptionWithCode:error.code]];
    
    NSLog(@"Error: %@ - %@", error, [ErrorInfoUtility errorDescriptionWithCode:error.code]);
}

/* 路径规划搜索回调. */
- (void)onRouteSearchDone:(AMapRouteSearchBaseRequest *)request response:(AMapRouteSearchResponse *)response
{
    if (response.route == nil)
    {
        
        self.route = response.route;
        [table reloadData];
        
        return;
    }
    
    self.route = response.route;
    NSLog(@"%ld条路线",(unsigned long)self.route.paths.count);
    [table reloadData];
    
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
   if (self.routePlanningType == AMapRoutePlanningTypeBusCrossCity || self.routePlanningType == AMapRoutePlanningTypeBus) { /*   公交   */
        return self.route.transits.count;
   }else {
       
       return self.route.paths.count;
       
   }
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *identy = @"identy";
    
    JNSYRoutePlansCell *cell = [tableView dequeueReusableCellWithIdentifier:identy];
    
    if (cell == nil) {
        cell = [[JNSYRoutePlansCell alloc] init];
        
        cell.tagLab.text = [NSString stringWithFormat:@"%ld",(long)indexPath.row];
        //填充路线
        
        if (self.routePlanningType == AMapRoutePlanningTypeBus || self.routePlanningType == AMapRoutePlanningTypeBusCrossCity) {  /* 公交  */
            [cell configTag:@"" trsit:self.route.transits[indexPath.row]];
        }else {            /*    步行、驾车、骑行    */
            
            [cell configTag:0 path:self.route.paths[indexPath.row]];
            
        }
        
    }
    
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    return cell;
    
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    
    return 50;
    
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    
    JNSYRoutePlansCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    NSString *roadstr = cell.roadLab.text;
    NSString *timeStr = cell.timeLab.text;
    
    
    JNSYRouteMapController *MapVc = [[JNSYRouteMapController alloc] init];
    MapVc.hidesBottomBarWhenPushed = YES;
    MapVc.routePlanningType = self.routePlanningType;
    MapVc.startCoordinate = self.startCoordinate;
    MapVc.destinationCoordinate = self.destinationCoordinate;
    MapVc.roadStr = roadstr;
    MapVc.timeStr = timeStr;
    
    if (self.routePlanningType == AMapRoutePlanningTypeBus || self.routePlanningType == AMapRoutePlanningTypeBusCrossCity) {
        MapVc.transit = self.route.transits[indexPath.row];
    }else {
        
        MapVc.path = self.route.paths[indexPath.row];
        
    }
    
    [self.navigationController pushViewController:MapVc animated:YES];
    
    
}


- (void)setTime:(NSArray *)array {
    
    
    for (NSInteger i = 0; i < array.count; i ++) {
        NSMutableArray *mArray = [[NSMutableArray alloc] init];
        
        AMapTransit *transit = array[i];
        NSArray *segmentsArray = transit.segments;   //换乘路段
        for (NSInteger j = 0; j < segmentsArray.count; j++) {
            AMapSegment *Asegment = segmentsArray[j];
            NSArray *busRoadArray = Asegment.buslines;
            for (NSInteger m = 0; m < busRoadArray.count; m ++) {   //公交路线
                AMapBusLine *line = busRoadArray[m];
                NSLog(@"%ld线路路线名称:%@",(long)i,line.name);
                NSRange range = [line.name rangeOfString:@"("];
                [mArray addObject:[line.name substringToIndex:range.location]];
            }
        }
        
        NSString *str = [mArray lastObject];
        for (NSInteger n = (mArray.count-1); n > 0; n --) {
            
            
            if (n == mArray.count - 1) {
                
                
            }else {
                str = [str stringByAppendingString:[NSString stringWithFormat:@"-%@",mArray[n]]];
            }
            
            
            NSLog(@"单个路线名称----%@",str);
        }
        
        
        
        
    }
    
}

- (void)setDistance:(NSString *)distance {
    
    
    
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
