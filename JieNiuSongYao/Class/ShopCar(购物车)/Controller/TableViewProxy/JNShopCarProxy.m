//
//  JNShopCarProxy.m
//  购物车
//
//  Created by rongfeng on 2017/5/2.
//  Copyright © 2017年 China Zhou. All rights reserved.
//

#import "JNShopCarProxy.h"
#import "JNTableViewCell.h"
#import "JNTableViewHeadView.h"
#import "JNShopCarBrandModel.h"
#import "JNShopCarProductModel.h"
@interface JNShopCarProxy()

@end


@implementation JNShopCarProxy

#pragma mark UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    
    return self.dataArray.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    JNShopCarBrandModel *brandModel = self.dataArray[section];
    NSArray *productArray = brandModel.products;
    
    return productArray.count;
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    JNTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"JNTableViewCell"];
    JNShopCarBrandModel *brandModel = self.dataArray[indexPath.section];
    NSArray *productArray = brandModel.products;
    if (productArray.count > indexPath.row) {
       
        JNShopCarProductModel *prouctModel = productArray[indexPath.row];
        NSString *productName = [NSString stringWithFormat:@"%@%@%@",brandModel.brandName, prouctModel.productStyle, prouctModel.productType];
        productName = prouctModel.productName;
        NSString *productSize = [NSString stringWithFormat:@"W:%ld H:%ld D:%ld", prouctModel.specWidth, prouctModel.specHeight, prouctModel.specLength];
        productSize = prouctModel.productStyle;
        
        NSString *productBelong = prouctModel.brandName;
        NSString *prePrice = [NSString stringWithFormat:@"￥%ld",(long)prouctModel.originPrice];
        
        [cell configureShopCarCellWithProductURL:prouctModel.productPicUri productName:productName productSize:productSize productPrice:prouctModel.productPrice productCount:prouctModel.productQty productStock:prouctModel.productStocks productSelected:prouctModel.isSelected productBelong:productBelong productprePrice:prePrice];
        
    }
    
    
    
    //传递改变商品数量的block
    __weak __typeof(self) weakSelf = self;
    cell.shopCarCellEditBlock = ^(NSInteger count) {
        if (weakSelf.shopCarProxyChangeCountBlock) {
            weakSelf.shopCarProxyChangeCountBlock(count, indexPath);
        }
    };
    
    //传递选择商品的block
    cell.shopCarCellSelectBlock = ^(BOOL isSelected) {
        if (weakSelf.shopCarProxyProductSelectBlock) {
            weakSelf.shopCarProxyProductSelectBlock(isSelected, indexPath);
        }
    };
    
    return cell;
    
}

#pragma mark UITableViewDelegate
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    
    JNTableViewHeadView *shopCarHearderView = [tableView dequeueReusableHeaderFooterViewWithIdentifier:@"JNTableViewHeadView"];
    if (self.dataArray.count > section) {
        JNShopCarBrandModel *brandModel = self.dataArray[section];
        [shopCarHearderView configureShopCarHeaderViewWithBrandName:brandModel.brandName brangSelect:brandModel.isSelected];
    }
    
    __weak __typeof(self) WeakSelf = self;
    shopCarHearderView.shopCarHeaderViewBlock = ^(BOOL isSelected) {
        if (WeakSelf.shopCarProxyBrandSelectBlock) {
            WeakSelf.shopCarProxyBrandSelectBlock(isSelected, section);
        }
    };
    
    shopCarHearderView.shopCarHeaderViewSelectBlock = ^{
        if (WeakSelf.shopCarProxyHeaderViewSelectBlock) {
            WeakSelf.shopCarProxyHeaderViewSelectBlock(section);
        }
    };
    
    return shopCarHearderView;
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 40;
}

- (NSArray<UITableViewRowAction *> *)tableView:(UITableView *)tableView editActionsForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    UITableViewRowAction *deleteAction = [UITableViewRowAction rowActionWithStyle:UITableViewRowActionStyleDestructive title:@"删除" handler:^(UITableViewRowAction * _Nonnull action, NSIndexPath * _Nonnull indexPath) {
        if (self.shopCarProxyDelectbLOCK) {
            self.shopCarProxyDelectbLOCK(indexPath);
        }
    }];
    
    UITableViewRowAction *starAction = [UITableViewRowAction rowActionWithStyle:UITableViewRowActionStyleNormal title:@"收藏" handler:^(UITableViewRowAction * _Nonnull action, NSIndexPath * _Nonnull indexPath) {
        if (self.shopCarProxyStarBlock) {
            self.shopCarProxyStarBlock(indexPath);
        }
    }];
    
    return @[deleteAction,starAction];
    
}


@end
