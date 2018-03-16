//
//  JNSYDeliverWaysViewController.h
//  JieNiuSongYao
//
//  Created by rongfeng on 2017/6/16.
//  Copyright © 2017年 China Zhou. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^DeliverSelectBlock)(NSString *DeliverMedthod);

@interface JNSYDeliverWaysViewController : UIViewController

@property(nonatomic,assign)NSInteger currentDeliverSelect;
@property(nonatomic,copy)DeliverSelectBlock deliverSelectBlock;

@end
