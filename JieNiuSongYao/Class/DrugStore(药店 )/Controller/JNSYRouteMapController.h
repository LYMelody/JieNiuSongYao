//
//  JNSYRouteMapController.h
//  JieNiuSongYao
//
//  Created by rongfeng on 2017/7/19.
//  Copyright © 2017年 China Zhou. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AMapSearchKit/AMapSearchAPI.h>
#import <MapKit/MapKit.h>

@interface JNSYRouteMapController : UIViewController

@property(nonatomic, strong)AMapRoute *route;

@property(nonatomic, strong)AMapTransit *transit;

@property(nonatomic, strong)AMapPath *path;

/*     起点经纬度  */
@property(nonatomic)CLLocationCoordinate2D startCoordinate;
/*   终点经纬度 */
@property(nonatomic)CLLocationCoordinate2D destinationCoordinate;


@property(nonatomic)AMapRoutePlanningType routePlanningType;

//路线
@property(nonatomic, copy)NSString *roadStr;
//时间、距离、步行
@property(nonatomic, copy)NSString *timeStr;




@end
