//
//  JNTableViewCell.m
//  购物车
//
//  Created by rongfeng on 2017/5/2.
//  Copyright © 2017年 China Zhou. All rights reserved.
//

#import "JNTableViewCell.h"
#import "Masonry.h"
#import "UIImageView+WebCache.h"
#import "JNShopCarCountView.h"
#import "Common.h"

@interface JNTableViewCell()


@property (nonatomic, strong)UIImageView *productImageView;
@property (nonatomic, strong)UILabel *productNameLable;
@property (nonatomic, strong)UILabel *productSizeLable;
@property (nonatomic, strong)UILabel *productPriceLable;
@property (nonatomic, strong)JNShopCarCountView *productCountView;
@property (nonatomic, strong)UILabel *productStockLable;
@property (nonatomic, strong)UIView *shopcarBgView;
@property (nonatomic, strong)UIView *topLineView;
@property (nonatomic, strong)UILabel *belongLab;
@property (nonatomic, strong)UILabel *prePriceLab;

@end


@implementation JNTableViewCell


- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        [self setUpSubViews];
    }
    
    return self;
}

- (void)setUpSubViews {
    
    [self.contentView addSubview:self.shopcarBgView];
    [self.shopcarBgView addSubview:self.productSelectButton];
    [self.shopcarBgView addSubview:self.productImageView];
    [self.shopcarBgView addSubview:self.productNameLable];
    [self.shopcarBgView addSubview:self.productSizeLable];
    [self.shopcarBgView addSubview:self.productPriceLable];
    [self.shopcarBgView addSubview:self.productCountView];
    [self.shopcarBgView addSubview:self.productStockLable];
    [self.shopcarBgView addSubview:self.topLineView];
    [self.shopcarBgView addSubview:self.belongLab];
    [self.shopcarBgView addSubview:self.prePriceLab];
    
}

- (void)configureShopCarCellWithProductURL:(NSString *)productURL productName:(NSString *)productName productSize:(NSString *)productSize productPrice:(NSInteger)productPrice productCount:(NSInteger)productCount productStock:(NSInteger)productStock productSelected:(BOOL)producSelected productBelong:(NSString *)productBelong productprePrice:(NSString *)productprePrice{
    
    
    NSURL *encodingURL = [NSURL URLWithString:[productURL stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]]];
    [self.productImageView sd_setImageWithURL:encodingURL];
    self.productNameLable.text = productName;
    self.productSizeLable.text = productSize;
    self.productPriceLable.text = [NSString stringWithFormat:@"￥%ld", (long)productPrice];
    self.productSelectButton.selected = producSelected;
    [self.productCountView configureShopCarCountViewWithProductCount:productCount productStock:productStock];
    self.productStockLable.text = [NSString stringWithFormat:@"库存:%ld", productStock];
    self.belongLab.text = productBelong;
    
    NSString *prePrice = productprePrice;
    NSMutableAttributedString *attribtstr = [[NSMutableAttributedString alloc] initWithString:prePrice];
    [attribtstr setAttributes:@{NSStrikethroughStyleAttributeName:[NSNumber numberWithInteger:NSUnderlineStyleSingle],NSBaselineOffsetAttributeName : @(NSUnderlineStyleSingle),NSFontAttributeName:[UIFont systemFontOfSize:13]} range:NSMakeRange(0, prePrice.length)];
    self.prePriceLab.attributedText = attribtstr;
    
}

- (void)productSelectButtonAction {
    
    _productSelectButton.selected = !_productSelectButton.selected;
    if (self.shopCarCellSelectBlock) {
        self.shopCarCellSelectBlock(self.productSelectButton.selected);
    }
    
}

- (UIButton *)productSelectButton {
    
    if (_productSelectButton == nil) {
        _productSelectButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_productSelectButton setImage:[UIImage imageNamed:@"Unselected"] forState:UIControlStateNormal];
        [_productSelectButton setImage:[UIImage imageNamed:@"Selected"] forState:UIControlStateSelected];
        [_productSelectButton addTarget:self action:@selector(productSelectButtonAction) forControlEvents:UIControlEventTouchUpInside];
        
    }
    return _productSelectButton;
}

- (UIImageView *)productImageView {
    if (_productImageView == nil) {
        _productImageView = [[UIImageView alloc] init];
    }
    return _productImageView;
}

- (UILabel *)productNameLable {
    
    if (_productNameLable == nil) {
        _productNameLable = [[UILabel alloc] init];
        _productNameLable.font = [UIFont systemFontOfSize:13];
        _productNameLable.textColor = [UIColor colorWithRed:70/255.0 green:70/255.0 blue:70/255.0 alpha:1];
        
    }
    return _productNameLable;
}

- (UILabel *)productSizeLable {
    if (_productSizeLable == nil) {
        _productSizeLable = [[UILabel alloc] init];
        _productSizeLable.font = [UIFont systemFontOfSize:13];
        _productSizeLable.textColor = [UIColor colorWithRed:150/255.0 green:150/255.0 blue:150/255.0 alpha:1];
    }
    return _productSizeLable;
}

- (UILabel *)productPriceLable {
    
    if (_productPriceLable == nil) {
        _productPriceLable = [[UILabel alloc] init];
        _productPriceLable.font = [UIFont systemFontOfSize:13];
        _productPriceLable.textColor = [UIColor colorWithRed:0.918 green:0.141 blue:0.137 alpha:1];
    }
    
    return _productPriceLable;
}

//传递block
- (JNShopCarCountView *)productCountView {
    
    if (_productCountView == nil) {
        _productCountView = [[JNShopCarCountView alloc] init];
        __weak __typeof(self) weakSelf = self;
        _productCountView.shopCarCountViewEditBlock = ^(NSInteger count) {
            if (weakSelf.shopCarCellEditBlock) {
                weakSelf.shopCarCellEditBlock(count);
            }
        };
    }
    
    return _productCountView;
}

- (UILabel *)productStockLable {
    
    if (_productStockLable == nil) {
        _productStockLable = [[UILabel alloc] init];
        _productStockLable.font = [UIFont systemFontOfSize:13];
        _productStockLable.textColor = [UIColor colorWithRed:150/255.0 green:150/255.0 blue:150/255.0 alpha:1];
    }
    return _productStockLable;
    
}


- (UIView *)shopcarBgView {
    
    if (_shopcarBgView == nil) {
        _shopcarBgView = [[UIView alloc] init];
        _shopcarBgView.backgroundColor = [UIColor whiteColor];
    }
    return _shopcarBgView;
}

- (UIView *)topLineView {
    if (_topLineView == nil) {
        _topLineView = [[UIView alloc] init];
        _topLineView.backgroundColor = [UIColor colorWithRed:233/255.0 green:233/255.0 blue:233/255.0 alpha:1];
        
    }
    return _topLineView;
}

- (UILabel *)belongLab {
    
    if (_belongLab == nil) {
        _belongLab = [[UILabel alloc] init];
        _belongLab.textColor = [UIColor colorWithRed:150/255.0 green:150/255.0 blue:150/255.0 alpha:1];
        _belongLab.font = [UIFont systemFontOfSize:13];
    }
    
    return _belongLab;
}

- (UILabel *)prePriceLab {
    
    if (_prePriceLab == nil) {
        _prePriceLab = [[UILabel alloc] init];
        _prePriceLab.textColor = [UIColor colorWithRed:150/255.0 green:150/255.0 blue:150/255.0 alpha:1];
        _belongLab.font = [UIFont systemFontOfSize:13];
    }
    return _prePriceLab;
}

- (void)layoutSubviews {
    
    [super layoutSubviews];
    
    [self.productSelectButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.shopcarBgView).offset(10);
        make.centerY.equalTo(self.shopcarBgView).offset(-20);
        make.size.mas_equalTo(CGSizeMake(30, 30));
    }];
    
    [self.productImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.shopcarBgView).offset(50);
        make.centerY.equalTo(self.shopcarBgView).offset(-20);
        make.size.mas_equalTo(CGSizeMake(60, 60));
    }];
    
    [self.productNameLable mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.productImageView.mas_right).offset(10);
        make.top.equalTo(self.shopcarBgView).offset(10);
        make.right.equalTo(self.shopcarBgView).offset(-5);
    }];
    
    [self.productSizeLable mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.productImageView.mas_right).offset(10);
        make.top.equalTo(self.productNameLable.mas_bottom);
        make.width.mas_equalTo(KscreenWidth/3.0);
        make.height.equalTo(@20);
    }];
    
    [self.belongLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.productSizeLable);
        make.left.equalTo(self.productSizeLable.mas_right);
        make.width.mas_equalTo(KscreenWidth/3.0);
        make.height.mas_equalTo(@20);
    }];
    
    [self.productPriceLable mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.productImageView.mas_right).offset(10);
        make.top.equalTo(self.productSizeLable.mas_bottom).offset(5);
        make.width.mas_equalTo(KscreenWidth/3.0);
        make.height.equalTo(@20);
    }];
    
    [self.prePriceLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.productPriceLable);
        make.left.equalTo(self.productPriceLable.mas_right);
        make.width.mas_equalTo(KscreenWidth/3.0);
        make.height.mas_equalTo(@20);
    }];
    
    
    [self.productCountView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.productImageView.mas_right).offset(10);
        make.bottom.equalTo(self.shopcarBgView).offset(-5);
        make.size.mas_equalTo(CGSizeMake(90, 25));
    }];
    
    [self.productStockLable mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.productCountView.mas_right).offset(20);
        make.centerY.equalTo(self.productCountView);
    }];
    
    [self.shopcarBgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.contentView);
    }];
    
    [self.topLineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.shopcarBgView).offset(50);
        make.top.right.equalTo(self.shopcarBgView);
        make.height.equalTo(@0.4);
    }];

}

@end
