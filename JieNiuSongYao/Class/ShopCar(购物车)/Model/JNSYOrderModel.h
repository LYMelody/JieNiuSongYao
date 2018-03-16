//
//  JNSYOrderModel.h
//  JieNiuSongYao
//
//  Created by rongfeng on 2017/6/23.
//  Copyright © 2017年 China Zhou. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface JNSYOrderModel : NSObject

@property (nonatomic, copy)NSString *OrderDrugStore;   //订单药店名称

@property (nonatomic, copy)NSString *OrderNumber;      //订单编号

@property (nonatomic, copy)NSString *OrderGoodsNum;    //订单商品数量

@property (nonatomic, copy)NSString *OrderGoodsTotalPrice;  //订单商品总额

@property (nonatomic, copy)NSString *OrderGoodsDiscountPrice; //订单折扣价

@property (nonatomic, copy)NSString *OrderDeliverPrice;  //订单配送费

@property (nonatomic, copy)NSString *OrderGoodsFinalPrice;  //订单合计总额




@end
