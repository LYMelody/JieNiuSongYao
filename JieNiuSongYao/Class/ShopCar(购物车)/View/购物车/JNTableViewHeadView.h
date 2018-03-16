//
//  JNTableViewHeadView.h
//  购物车
//
//  Created by rongfeng on 2017/5/2.
//  Copyright © 2017年 China Zhou. All rights reserved.
//

//#import <UIKit/UIKit.h>

typedef void(^ShopCarHeaderViewBlock)(BOOL isSelected);

typedef void(^shopCarHeaderViewSelectBlock)(void);

@interface JNTableViewHeadView : UITableViewHeaderFooterView

@property(nonatomic,copy)ShopCarHeaderViewBlock shopCarHeaderViewBlock;
@property(nonatomic,copy)shopCarHeaderViewSelectBlock shopCarHeaderViewSelectBlock;

- (void)configureShopCarHeaderViewWithBrandName:(NSString *)brangName brangSelect:(BOOL)brandSelect;
@end
