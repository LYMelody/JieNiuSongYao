//
//  JNTableViewCell.h
//  购物车
//
//  Created by rongfeng on 2017/5/2.
//  Copyright © 2017年 China Zhou. All rights reserved.
//

//#import <UIKit/UIKit.h>

typedef void(^ShopCarCellSelectBlock)(BOOL isSelected);
typedef void(^ShopCarCellEditBlock)(NSInteger count);

@interface JNTableViewCell : UITableViewCell

@property(nonatomic,copy)ShopCarCellSelectBlock shopCarCellSelectBlock;
@property(nonatomic,copy)ShopCarCellEditBlock shopCarCellEditBlock;

@property (nonatomic, strong)UIButton *productSelectButton;

- (void)configureShopCarCellWithProductURL:(NSString *)productURL
                               productName:(NSString *)productName
                               productSize:(NSString *)productSize
                              productPrice:(NSInteger)productPrice
                              productCount:(NSInteger)productCount
                              productStock:(NSInteger)productStock
                           productSelected:(BOOL)producSelected
                             productBelong:(NSString *)productBelong
                           productprePrice:(NSString *)productprePrice;

@end
