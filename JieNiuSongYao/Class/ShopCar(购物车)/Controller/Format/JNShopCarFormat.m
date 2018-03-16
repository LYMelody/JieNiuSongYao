//
//  JNShopCarFormat.m
//  购物车
//
//  Created by rongfeng on 2017/5/2.
//  Copyright © 2017年 China Zhou. All rights reserved.
//

#import "JNShopCarFormat.h"
#import "JNShopCarBrandModel.h"
#import "MJExtension.h"
#import <UIKit/UIKit.h>
#import "MBProgressHUD.h"

#import "JNSYAutoSize.h"
#import "JNSYUserInfo.h"
#import "JNShopCarBrandModel.h"
#import "JNShopCarProductModel.h"
#import "SBJSON.h"
#import "IBHttpTool.h"
#import "Common.h"

@interface JNShopCarFormat()

@property (nonatomic, strong) NSMutableArray *shopCarListArray;

@end

@implementation JNShopCarFormat

//获取数据
- (void)requestShopCarProductList {
    
//    NSString *plistpath = [[NSBundle mainBundle] pathForResource:@"shopcart" ofType:@"plist"];
//    NSMutableArray *dataArray = [NSMutableArray arrayWithContentsOfFile:plistpath];
    //数据存储到model
    //self.shopCarListArray = [JNShopCarBrandModel mj_objectArrayWithKeyValuesArray:dataArray];
    self.shopCarListArray = [[NSMutableArray alloc] init];
    
    //获取数据
    [self requestForDataSource];
    
   // [self.delegate shopCarFormatRequestProductListDidSuccesWithArray:self.shopCarListArray];
}

- (void)changeCountAtIndexPath:(NSIndexPath *)indexPath count:(NSInteger)count {
    
    JNShopCarBrandModel *brandModel = self.shopCarListArray[indexPath.section];
    JNShopCarProductModel *productModel = brandModel.products[indexPath.row];
    
    if (count <= 0) {
        count = 1;
    }else if(count > productModel.productStocks) {
        count = productModel.productStocks;
    }
    
    productModel.productQty = count;
    
    [self.delegate shopCarFormatAccountForTotalPrice:[self accountTotalPrice] totalCount:[self accountTotalCount] isAllSelected:[self isAllSelected]];
    
}
//选择商家
- (void)selectBrandAtSection:(NSInteger)section isSelected:(BOOL)isSelected {
    
    JNShopCarBrandModel *brandModel = self.shopCarListArray[section];
    brandModel.isSelected = isSelected;
    for(JNShopCarProductModel *productModel in brandModel.products) {
        
        productModel.isSelected = brandModel.isSelected;
    }
    [self.delegate shopCarFormatAccountForTotalPrice:[self accountTotalPrice] totalCount:[self accountTotalCount] isAllSelected:[self isAllSelected]];
    
}

//选择商品
- (void)selectProductAtIndexPath:(NSIndexPath *)indexPath isSelected:(BOOL)isSelected {
    
    JNShopCarBrandModel *brandModel = self.shopCarListArray[indexPath.section];
    JNShopCarProductModel *productModel = brandModel.products[indexPath.row];
    productModel.isSelected = isSelected;
    BOOL isBrandSelected = YES;
    for(JNShopCarProductModel *aproductModel in brandModel.products) {
        if (aproductModel.isSelected == NO) {
            isBrandSelected = NO;
        }
    }
    brandModel.isSelected = isBrandSelected;
    
    [self.delegate shopCarFormatAccountForTotalPrice:[self accountTotalPrice] totalCount:[self accountTotalCount] isAllSelected:[self isAllSelected]];

}
//全选
- (void)selectAllProductWithStatus:(BOOL)isSelected {
    
    for(JNShopCarBrandModel *brandModel in self.shopCarListArray) {
        brandModel.isSelected = isSelected;
        for(JNShopCarProductModel *productModel in brandModel.products) {
            productModel.isSelected = isSelected;
        }
    }
    
    [self.delegate shopCarFormatAccountForTotalPrice:[self accountTotalPrice] totalCount:[self accountTotalCount] isAllSelected:[self isAllSelected]];
}
//删除一个商品
- (void)delecteProductAtIndexPath:(NSIndexPath *)indexPath {
    
    JNShopCarBrandModel *brandModel = self.shopCarListArray[indexPath.section];
    JNShopCarProductModel *productModel = brandModel.products[indexPath.row];
    
    //根据请求结果决定是否删除
    [brandModel.products removeObject:productModel];
    if (brandModel.products.count == 0) {
        [self.shopCarListArray removeObject:brandModel];
    }
    
    [self.delegate shopCarFormatAccountForTotalPrice:[self accountTotalPrice] totalCount:[self accountTotalCount] isAllSelected:[self isAllSelected]];
    
    if (self.shopCarListArray.count == 0) {
        [self.delegate shopCarFormatHasDeleteAllProducts];
    }

}

//删除所选商品
- (void)deleteSelectedProducts:(NSArray *)selectedArray {
    
    for(NSInteger i = 0;i < self.shopCarListArray.count;i++) {
        
        JNShopCarBrandModel *brandModel = self.shopCarListArray[i];
        
        for(NSInteger j = 0; j < brandModel.products.count;j++) {
            JNShopCarProductModel *productModel = brandModel.products[j];
            if (productModel.isSelected) {
                [brandModel.products removeObject:productModel];
                if (brandModel.products.count == 0) {
                    [self.shopCarListArray removeObject:brandModel];
                }
            }
        }
    }
    
    [self.delegate shopCarFormatAccountForTotalPrice:[self accountTotalPrice] totalCount:[self accountTotalCount] isAllSelected:[self isAllSelected]];
    
    if (self.shopCarListArray.count == 0) {
        [self.delegate shopCarFormatHasDeleteAllProducts];
    }
    
}


//收藏一个商品
- (void)starProductAtIndexPath:(NSIndexPath *)indexPath {
    
    NSLog(@"商品已收藏");
    
}
//编辑 收藏
- (void)starSelectedProducts {
    
    
    NSLog(@"勾选商品已收藏");
    
    
}

- (void)beginToDeleteSelectedProducts {
    
    
    
}

- (void)settleSelectedProducts {
    
    
    
}

#pragma mark private methods

- (float)accountTotalPrice {
    
    float totalPrice = 0.f;
    
    for(JNShopCarBrandModel *brandModel in self.shopCarListArray) {
        
        for (JNShopCarProductModel *productModel in brandModel.products) {
            if (productModel.isSelected) {
                totalPrice += productModel.productPrice * productModel.productQty;
            }
        }
        
    }
    
    return totalPrice;
    
    
}

- (NSInteger)accountTotalCount {
    
    NSInteger totalCount = 0;
    for(JNShopCarBrandModel *brandModel in self.shopCarListArray) {
    
        for(JNShopCarProductModel *productModel in brandModel.products) {
            if (productModel.isSelected) {
                totalCount += productModel.productQty;
            }
        }
    
    }
    
    return totalCount;
}

- (BOOL)isAllSelected {
    
    if (self.shopCarListArray.count == 0)  return NO;
    BOOL isAllSelected = YES;
    for(JNShopCarBrandModel *brandModel in self.shopCarListArray) {
        
        if (brandModel.isSelected == NO) {
            isAllSelected = NO;
        }
        
    }
    
    return isAllSelected;

}


//获取数据源
- (void)requestForDataSource {
    
    //[self.shopCarFormat requestShopCarProductList];
    
    if ([JNSYUserInfo getUserInfo].isLoggedIn) {
        NSDictionary *dic = @{
                              @"timestamp":[JNSYAutoSize getTimeNow]
                              };
        NSString *action = @"OrderCartListState";
        
        NSDictionary *requestDic = @{
                                     @"action":action,
                                     @"token":[JNSYUserInfo getUserInfo].userToken,
                                     @"data":dic
                                     };
        NSString *params = [requestDic JSONFragment];
        
        [IBHttpTool postWithURL:JNSYTestUrl params:params success:^(id result) {
            NSLog(@"%@",result);
            NSDictionary *resultdic = [result JSONValue];
            NSString *code = resultdic[@"code"];
            NSLog(@"%@,%@",resultdic,code);
            if([code isEqualToString:@"000000"]) {
                
                
                NSArray * drugArray = resultdic[@"cartList"];
                
                //数据存储到model
                self.shopCarListArray = [self dataToModel:drugArray];
                
                [self.delegate shopCarFormatRequestProductListDidSuccesWithArray:self.shopCarListArray];

                NSLog(@"%@",drugArray);
                
                
            }else {
                NSString *msg = resultdic[@"msg"];
                [JNSYAutoSize showMsg:msg];
            }
        } failure:^(NSError *error) {
            NSLog(@"%@",error);
        }];
        
    }else {
        
        [self.delegate shopCarFormatRequestProductListDidSuccesWithArray:self.shopCarListArray];
        
    }
    
    NSLog(@"获取购物车列表");
    
}

//
- (NSMutableArray *)dataToModel:(NSArray *)array {
    
    
    NSMutableArray *brandArray = [[NSMutableArray alloc] init];
    
    for(NSInteger i = 0; i < array.count; i++) {   //药店
        
        NSDictionary *dic = array[i];
        
        JNShopCarBrandModel *brandModel = [[JNShopCarBrandModel alloc] init];
        brandModel.brandId = [NSString stringWithFormat:@"%@",dic[@"shopId"]];
        brandModel.brandName = [NSString stringWithFormat:@"%@",dic[@"shopName"]];
        
        //药品
        NSMutableArray *medicineModelArray = [[NSMutableArray alloc] init];
        
        NSArray  *productArray = dic[@"medicinesList"];
        for (NSInteger j = 0; j < productArray.count; j++) { //药店药品
            NSDictionary *productDic = productArray[j];
            JNShopCarProductModel *product = [[JNShopCarProductModel alloc] init];
            product.productId = [NSString stringWithFormat:@"%@",productDic[@"medicinesId"]];
            //product.productNum = [NSString stringWithFormat:@"%@",productDic[@"goodsCount"]];
            product.brandName = [NSString stringWithFormat:@"%@",productDic[@"medicinesBrand"]];
            product.cartId = [NSString stringWithFormat:@"%@",productDic[@"cartId"]];
            product.productName = [NSString stringWithFormat:@"%@",productDic[@"medicinesName"]];
            product.productPicUri = [NSString stringWithFormat:@"%@",productDic[@"medicinesPic1"]];
            product.productPrice = [productDic[@"medicinesPrice"] integerValue]/100;
            product.originPrice = [productDic[@"medicinesPriceDiscount"] integerValue]/100;
             product.productQty = [productDic[@"goodsCount"] integerValue];
            product.productStocks = 999;      //库存
            product.productStyle = [NSString stringWithFormat:@"%@", productDic[@"medicinesSpecifications"]];
            [medicineModelArray addObject:product];
        }
        
        brandModel.products = medicineModelArray;
        
        [brandArray addObject:brandModel];
        
    }
    
    return brandArray;
}


@end
