//
//  JNShopCarBrandModel.h
//  购物车
//
//  Created by rongfeng on 2017/5/2.
//  Copyright © 2017年 China Zhou. All rights reserved.
//

//#import <Foundation/Foundation.h>
#import "JNShopCarProductModel.h"
@interface JNShopCarBrandModel : NSObject

@property (nonatomic, copy) NSString *brandId;
@property (nonatomic, strong) NSMutableArray<JNShopCarProductModel *> *products;
@property (nonatomic, copy) NSString *brandName;
@property (nonatomic, assign) BOOL isSelected;
@property (nonatomic, strong) NSMutableArray *selectedArray; //结算时筛选出选中的商品
@end
