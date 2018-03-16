//
//  JNShopCarBrandModel.m
//  购物车
//
//  Created by rongfeng on 2017/5/2.
//  Copyright © 2017年 China Zhou. All rights reserved.
//

#import "JNShopCarBrandModel.h"

@implementation JNShopCarBrandModel

+ (NSDictionary *)objectClassInArray {
    
    return @{
             @"products":[JNShopCarProductModel class]
             };
    
}
@end
