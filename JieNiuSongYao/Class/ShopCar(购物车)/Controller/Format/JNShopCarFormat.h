//
//  JNShopCarFormat.h
//  购物车
//
//  Created by rongfeng on 2017/5/2.
//  Copyright © 2017年 China Zhou. All rights reserved.
//

//#import <Foundation/Foundation.h>

@protocol JNShopCarFormatDelegate <NSObject>

@required
- (void)shopCarFormatRequestProductListDidSuccesWithArray:(NSMutableArray *)dataArray;

- (void)shopCarFormatAccountForTotalPrice:(float)totalPrice
                               totalCount:(NSInteger)totalCount
                            isAllSelected:(BOOL)isAllSelected;

- (void)shopCarFormatSettleForSelectedProducts:(NSArray *)selectedProducts;

- (void)shopCarFormatWillDeleteSeletedProducts:(NSArray *)selectedProducts;

- (void)shopCarFormatHasDeleteAllProducts;

@end


@interface JNShopCarFormat : NSObject

@property(nonatomic,weak) id <JNShopCarFormatDelegate> delegate;

- (void)requestShopCarProductList;

- (void)selectProductAtIndexPath:(NSIndexPath *)indexPath isSelected:(BOOL)isSelected;

- (void)selectBrandAtSection:(NSInteger)section isSelected:(BOOL)isSelected;

- (void)changeCountAtIndexPath:(NSIndexPath *)indexPath count:(NSInteger)count;

- (void)delecteProductAtIndexPath:(NSIndexPath *)indexPath;

- (void)beginToDeleteSelectedProducts;

- (void)deleteSelectedProducts:(NSArray *)selectedArray;

- (void)starProductAtIndexPath:(NSIndexPath *)indexPath;

- (void)starSelectedProducts;


- (void)selectAllProductWithStatus:(BOOL)isSelected;

- (void)settleSelectedProducts;

@end
