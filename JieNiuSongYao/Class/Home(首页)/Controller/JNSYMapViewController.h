//
//  JNSYMapViewController.h
//  JieNiuSongYao
//
//  Created by rongfeng on 2017/7/13.
//  Copyright © 2017年 China Zhou. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface JNSYMapViewController : UIViewController

@property(nonatomic,copy)NSString *lat;

@property(nonatomic,copy)NSString *lng;

@property(nonatomic,copy)NSString *storeName;

@property(nonatomic,copy)NSString *place;

@property(nonatomic,strong)UIButton *gpsButton;

@end
