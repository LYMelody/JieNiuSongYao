//
//  JNTableViewHeadView.m
//  购物车
//
//  Created by rongfeng on 2017/5/2.
//  Copyright © 2017年 China Zhou. All rights reserved.
//

#import "JNTableViewHeadView.h"
#import "Masonry.h"

@interface JNTableViewHeadView()

@property(nonatomic,strong)UIView *shopCarHeaderBgView;
@property(nonatomic,strong)UIButton *allSelectButton;
@property(nonatomic,strong)UILabel *brandLable;
@property(nonatomic,strong)UIImageView *Indicatorimg;
@property(nonatomic,strong)UITapGestureRecognizer *tapToDrugStoreTwo;
@end

@implementation JNTableViewHeadView

- (instancetype)initWithReuseIdentifier:(NSString *)reuseIdentifier {
    
    if (self = [super initWithReuseIdentifier:reuseIdentifier]) {
        [self setUpSubViews];
    }
    return self;
}

- (void)setUpSubViews {
    
    [self addSubview:self.shopCarHeaderBgView];
    [self.shopCarHeaderBgView addSubview:self.allSelectButton];
    [self.shopCarHeaderBgView addSubview:self.brandLable];
    [self.shopCarHeaderBgView addSubview:self.Indicatorimg];

}

- (void)allSelectButtonAction {
    
    self.allSelectButton.selected = !self.allSelectButton.selected;
    
    if (self.shopCarHeaderViewBlock) {
        self.shopCarHeaderViewBlock(self.allSelectButton.selected);
    }
    
}

- (void)configureShopCarHeaderViewWithBrandName:(NSString *)brangName brangSelect:(BOOL)brandSelect {
    
    self.allSelectButton.selected = brandSelect;
    self.brandLable.text = brangName;
    
}


- (UIView *)shopCarHeaderBgView {
    if (_shopCarHeaderBgView == nil) {
        _shopCarHeaderBgView = [[UIView alloc] init];
        _shopCarHeaderBgView.backgroundColor = [UIColor whiteColor];
        _shopCarHeaderBgView.userInteractionEnabled = YES;
        [_shopCarHeaderBgView addGestureRecognizer:self.tapToDrugStoreTwo];
    }
    return _shopCarHeaderBgView;
}

- (UIButton *)allSelectButton {
    
    if (_allSelectButton == nil) {
        _allSelectButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_allSelectButton setImage:[UIImage imageNamed:@"Unselected"] forState:UIControlStateNormal];
        [_allSelectButton setImage:[UIImage imageNamed:@"Selected"] forState:UIControlStateSelected];
        [_allSelectButton addTarget:self action:@selector(allSelectButtonAction) forControlEvents:UIControlEventTouchUpInside];
    }
    return _allSelectButton;
}

- (UILabel *)brandLable {
    
    if (_brandLable == nil) {
        _brandLable = [[UILabel alloc] init];
        _brandLable.font = [UIFont systemFontOfSize:13];
        _brandLable.textColor = [UIColor colorWithRed:70/255.0 green:70/255.0 blue:70/255.0 alpha:1];
        _brandLable.userInteractionEnabled = YES;
        
    }
    return _brandLable;
}

- (UIImageView *)Indicatorimg {
    
    if (_Indicatorimg == nil) {
        _Indicatorimg = [[UIImageView alloc] init];
        _Indicatorimg.image = [UIImage imageNamed:@"indator"];
        _Indicatorimg.alpha = 0.6;
        _Indicatorimg.userInteractionEnabled = YES;
        //_Indicatorimg.backgroundColor = [UIColor redColor];
    }
    return _Indicatorimg;
}


- (UITapGestureRecognizer *)tapToDrugStoreTwo {
    
    if (_tapToDrugStoreTwo == nil) {
        _tapToDrugStoreTwo = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapToDrugStoreAction)];
        _tapToDrugStoreTwo.numberOfTapsRequired = 1;
    }
    return _tapToDrugStoreTwo;
    
}
- (void)tapToDrugStoreAction {
    
    NSLog(@"点击进入药店");
    
    if (_shopCarHeaderViewSelectBlock) {
        _shopCarHeaderViewSelectBlock();
    }
}

- (void)layoutSubviews {
    
    [super layoutSubviews];
    
    [self.shopCarHeaderBgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self);
    }];
    
    [self.allSelectButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.shopCarHeaderBgView).offset(10);
        make.centerY.equalTo(self.shopCarHeaderBgView);
        make.size.mas_equalTo(CGSizeMake(30, 30));
    }];
    
    [self.brandLable mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.shopCarHeaderBgView).offset(50);
        make.top.bottom.equalTo(self.shopCarHeaderBgView);
    }];
    
    [self.Indicatorimg mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.shopCarHeaderBgView);
        make.right.equalTo(self.shopCarHeaderBgView).offset(-8);
        make.size.mas_equalTo(CGSizeMake(40, 40));
    }];
    
}

@end
