//
//  JNSYSearchStoreModel.h
//  JieNiuSongYao
//
//  Created by rongfeng on 2017/5/25.
//  Copyright © 2017年 China Zhou. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface JNSYSearchStoreModel : NSObject

@property (nonatomic, copy)NSString *storeName; //药店名字

@property (nonatomic, copy)NSString *storeImg; //药店图片

@property (nonatomic, copy)NSString *openTime; //营业时间

@property (nonatomic, copy)NSString *rating; //评分

@property (nonatomic, copy)NSString *distance; //距离

@property (nonatomic, copy)NSString *address;  //药店地址

@property (nonatomic, strong)NSArray *servicerArr;  //活动详情


@end
