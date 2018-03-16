//
//  JNShopCarCountView.h
//  购物车
//
//  Created by rongfeng on 2017/5/2.
//  Copyright © 2017年 China Zhou. All rights reserved.
//

//#import <UIKit/UIKit.h>


typedef void(^ShopCarCountViewEditBlock)(NSInteger count);

@interface JNShopCarCountView : UIView

@property(nonatomic,copy)ShopCarCountViewEditBlock shopCarCountViewEditBlock;
@property(nonatomic,strong)UITextField *editTextField;

- (void)configureShopCarCountViewWithProductCount:(NSInteger)productCount productStock:(NSInteger)productStock;

@end
