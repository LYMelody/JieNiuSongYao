//
//  JNSYMedicineDetailViewController.h
//  JieNiuSongYao
//
//  Created by rongfeng on 2017/6/1.
//  Copyright © 2017年 China Zhou. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "XHSegmentViewController.h"
#import "JNSYMedicineModel.h"
@interface JNSYMedicineDetailViewController : XHSegmentViewController


@property(nonatomic,strong)JNSYMedicineModel *medicineModel;


- (CGFloat)AutoHeight:(CGFloat)height;


@end
