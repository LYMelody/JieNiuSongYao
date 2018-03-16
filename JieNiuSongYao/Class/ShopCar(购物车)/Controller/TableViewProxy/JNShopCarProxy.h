//
//  JNShopCarProxy.h
//  购物车
//
//  Created by rongfeng on 2017/5/2.
//  Copyright © 2017年 China Zhou. All rights reserved.
//
//#import <UIKit/UIKit.h>
//#import <Foundation/Foundation.h>

typedef void(^ShopCarProxyProductSelectBlock)(BOOL isSelected,NSIndexPath *indexPath);
typedef void(^ShopCarProxyBrandSelectBlock)(BOOL isSelected,NSInteger section);
typedef void(^ShopCarProxyChangeCountBlock)(NSInteger count,NSIndexPath *indexPath);
typedef void(^ShopCarProxyDelectBlock)(NSIndexPath *indexPath);
typedef void(^ShopCarProxyStarBlock)(NSIndexPath *indexPath);
typedef void(^shopCarProxyHeaderViewSelectBlock)(NSInteger section);
@interface JNShopCarProxy : NSObject <UITableViewDelegate,UITableViewDataSource>

@property (nonatomic, strong) NSMutableArray *dataArray;
@property (nonatomic, copy)ShopCarProxyProductSelectBlock shopCarProxyProductSelectBlock;
@property (nonatomic, copy)ShopCarProxyBrandSelectBlock shopCarProxyBrandSelectBlock;
@property (nonatomic, copy)ShopCarProxyChangeCountBlock shopCarProxyChangeCountBlock;
@property (nonatomic, copy)ShopCarProxyDelectBlock shopCarProxyDelectbLOCK;
@property (nonatomic, copy)ShopCarProxyStarBlock shopCarProxyStarBlock;
@property (nonatomic, copy)shopCarProxyHeaderViewSelectBlock shopCarProxyHeaderViewSelectBlock;
@end
