//
//  JNSYSearchViewController.h
//  JieNiuSongYao
//
//  Created by rongfeng on 2017/5/23.
//  Copyright © 2017年 China Zhou. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface JNSYSearchViewController : UIViewController

@property (nonatomic, strong)NSMutableArray *hotSearchArray;
@property (nonatomic, strong)NSMutableArray *SearchHistoryArray;
@property (nonatomic, copy)NSString *longtilute;
@property (nonatomic, copy)NSString *latitude;
@end
