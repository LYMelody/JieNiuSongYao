//
//  JNSYOrderTotalPriceTableViewCell.m
//  JieNiuSongYao
//
//  Created by rongfeng on 2017/6/15.
//  Copyright © 2017年 China Zhou. All rights reserved.
//

#import "JNSYOrderTotalPriceTableViewCell.h"
#import "Common.h"
#import "Masonry.h"

@implementation JNSYOrderTotalPriceTableViewCell

- (instancetype)init {
    
    if ([super init]) {
        [self setUpViews];
    }
    return self;
}


- (void)setUpViews{
    
    _totalNumberLab = [[UILabel alloc] init];
    _totalNumberLab.font = [UIFont systemFontOfSize:13];
    _totalNumberLab.textColor =  ColorText;
    _totalNumberLab.textAlignment = NSTextAlignmentLeft;
    
    [self.contentView addSubview:_totalNumberLab];
    
    _totalPriceLab = [[UILabel alloc] init];
    _totalPriceLab.font = [UIFont systemFontOfSize:13];
    _totalPriceLab.textColor = ColorText;
    _totalPriceLab.textAlignment = NSTextAlignmentLeft;
    [self.contentView addSubview:_totalPriceLab];
    
    _disCountLab = [[UILabel alloc] init];
    _disCountLab.font = [UIFont systemFontOfSize:13];
    _disCountLab.textAlignment = NSTextAlignmentLeft;
    _disCountLab.textColor = ColorText;
    [self.contentView addSubview:_disCountLab];
    
    _deliverLab = [[UILabel alloc] init];
    _deliverLab.font = [UIFont systemFontOfSize:13];
    _deliverLab.textColor = ColorText;
    _deliverLab.textAlignment = NSTextAlignmentLeft;
    [self.contentView addSubview:_deliverLab];
    
    _finalPriceLab = [[UILabel alloc] init];
    _finalPriceLab.font = [UIFont systemFontOfSize:13];
    _finalPriceLab.textAlignment = NSTextAlignmentLeft;
    _finalPriceLab.textColor = ColorText;
    [self.contentView addSubview:_finalPriceLab];
    
    
    
}

- (void)layoutSubviews {
    
    [super layoutSubviews];
    
    [_totalNumberLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self).offset(8);
        make.left.equalTo(self).offset((KscreenWidth - 40)/5.0);
        make.width.mas_equalTo((KscreenWidth - 60)/5.0);
        make.height.mas_equalTo(20);
    }];
    
    [_totalPriceLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_totalNumberLab);
        make.left.equalTo(_totalNumberLab.mas_right);
        make.width.mas_equalTo(KscreenWidth/3.0);
        make.height.mas_equalTo(20);
    }];
    
    [_disCountLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_totalPriceLab);
        make.left.equalTo(_totalPriceLab.mas_right);
        make.width.mas_equalTo(KscreenWidth/3.0);
        make.height.mas_equalTo(20);
    }];
    
    [_deliverLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_totalPriceLab.mas_bottom);
        make.left.equalTo(_totalPriceLab);
        make.height.width.mas_equalTo(_totalPriceLab);
    }];
    
    [_finalPriceLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_disCountLab.mas_bottom);
        make.left.width.height.equalTo(_disCountLab);
    }];
    
}




@end
