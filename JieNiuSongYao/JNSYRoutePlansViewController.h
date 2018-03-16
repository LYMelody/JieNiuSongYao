//
//  JNSYRoutePlansViewController.h
//  JieNiuSongYao
//
//  Created by rongfeng on 2017/7/18.
//  Copyright © 2017年 China Zhou. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AMapSearchKit/AMapSearchAPI.h>
#import <MapKit/MapKit.h>
@interface JNSYRoutePlansViewController : UIViewController

@property(nonatomic, strong)AMapRoute *route;

@property(nonatomic)AMapRoutePlanningType routePlanningType;

/*     起点经纬度  */
@property(nonatomic)CLLocationCoordinate2D startCoordinate;
/*   终点经纬度 */
@property(nonatomic)CLLocationCoordinate2D destinationCoordinate;

@end
