//
//  JNSYOrderPayMeathodViewController.h
//  JieNiuSongYao
//
//  Created by rongfeng on 2017/6/16.
//  Copyright © 2017年 China Zhou. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^OrderPayMedthodBlock)(NSString *payMedthod);

@interface JNSYOrderPayMeathodViewController : UIViewController

@property(nonatomic,assign)NSInteger currentSelect;
@property(nonatomic,copy)OrderPayMedthodBlock orderPayMedthodBlock;


@end
