//
//  JNShopCarBottonView.h
//  购物车
//
//  Created by rongfeng on 2017/5/4.
//  Copyright © 2017年 China Zhou. All rights reserved.
//

//#import <UIKit/UIKit.h>

typedef void(^ShopCarBottomViewAllSelectBlock)(BOOL isSelected);
typedef void(^ShopCarBottomViewSettleBlock)(void);
typedef void(^ShopCarBottomViewStarBlock)(void);
typedef void(^ShopCarBottomViewDelecteBlock)(void);

@interface JNShopCarBottonView : UIView

@property(nonatomic,copy)ShopCarBottomViewAllSelectBlock shopCarBottomViewAllSelectBlock;
@property(nonatomic,copy)ShopCarBottomViewSettleBlock shopCarBottomViewSettleBlock;
@property(nonatomic,copy)ShopCarBottomViewStarBlock shopCarBottomViewStarBlock;
@property(nonatomic,copy)ShopCarBottomViewDelecteBlock shopCarBottomViewDelectBlock;


- (void)configureShopCarBottomViewWithTotalPrice:(float)totalPrice
                                      totalCount:(NSInteger)totalCount
                                   isAllselected:(BOOL)isAllSelected;

- (void)changeShopCarBottomViewWithStatus:(BOOL)status;

@end
