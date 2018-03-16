//
//  JNSYLocalMapTableViewCell.h
//  JieNiuSongYao
//
//  Created by rongfeng on 2017/5/11.
//  Copyright © 2017年 China Zhou. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MAMapKit/MAMapKit.h>
#import <AMapLocationKit/AMapLocationKit.h>

@interface JNSYLocalMapTableViewCell : UITableViewCell

@property (nonatomic, strong)UILabel *leftLab;
@property (nonatomic, copy)NSString *location;

@property (nonatomic, strong)MAMapView *mapView;

@end
