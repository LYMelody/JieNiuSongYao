//
//  JNSYMedicineModel.h
//  JieNiuSongYao
//
//  Created by rongfeng on 2017/7/10.
//  Copyright © 2017年 China Zhou. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface JNSYMedicineModel : NSObject

@property(nonatomic,copy)NSString *medicinesId;                       //药品ID

@property(nonatomic,copy)NSString *medicinesType;                     //药品种类

@property(nonatomic,copy)NSString *medicinesName;                     //药品名称

@property(nonatomic,copy)NSString *medicinesBrand;                    //药品品牌

@property(nonatomic,copy)NSString *medicinesLicense;                  //国际批准文号

@property(nonatomic,copy)NSString *medicinesSpecifications;           //药品规格

@property(nonatomic,copy)NSString *medicinesPrice;                    //原价

@property(nonatomic,copy)NSString *medicinesPriceDiscount;            //折扣价

@property(nonatomic,copy)NSString *medicinesUsage;                    //用法用量

@property(nonatomic,copy)NSString *medicinesComponent;                //成分

@property(nonatomic,copy)NSString *medicinesFunction;                 //功能主治

@property(nonatomic,copy)NSString *medicinesInstructions;             //药品说明书

@property(nonatomic,copy)NSString *medicinesPic1;                     //药品主图

@property(nonatomic,copy)NSString *medicinesPic2;                     //药品图片2

@property(nonatomic,copy)NSString *medicinesPic3;                     //药品图片3

@property(nonatomic,copy)NSString *medicinesPic4;                     //药品图片4

@property(nonatomic,copy)NSString *medicinesPic5;                     //药品图片5

@property(nonatomic,copy)NSString *isCollect;                         //是否收藏 (1:已收藏，0：未收藏)


@end
