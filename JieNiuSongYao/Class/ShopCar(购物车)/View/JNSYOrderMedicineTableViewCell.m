//
//  JNSYOrderMedicineTableViewCell.m
//  JieNiuSongYao
//
//  Created by rongfeng on 2017/6/15.
//  Copyright © 2017年 China Zhou. All rights reserved.
//

#import "JNSYOrderMedicineTableViewCell.h"
#import "Common.h"
#import "Masonry.h"

@implementation JNSYOrderMedicineTableViewCell

- (instancetype)init{
    
    if ([super init]) {
        [self setUpViews];
    }
    return self;
}


- (void)setUpViews{
    
    _MedicineImg = [[UIImageView alloc] init];
    _MedicineImg.backgroundColor = [UIColor grayColor];
    [self.contentView addSubview:_MedicineImg];
    
    _nameLab = [[UILabel alloc] init];
    _nameLab.font = [UIFont systemFontOfSize:13];
    _nameLab.textColor = [UIColor blackColor];
    _nameLab.textAlignment = NSTextAlignmentLeft;
    [self.contentView addSubview:_nameLab];
    
    _contentLab = [[UILabel alloc] init];
    _contentLab.font = [UIFont systemFontOfSize:11];
    _contentLab.textColor = ColorText;
    _contentLab.textAlignment = NSTextAlignmentLeft;
    [self.contentView addSubview:_contentLab];
    
    _belongLab = [[UILabel alloc] init];
    _belongLab.font = [UIFont systemFontOfSize:11];
    _belongLab.textAlignment = NSTextAlignmentCenter;
    _belongLab.textColor = ColorText;
    [self.contentView addSubview:_belongLab];
    
    _priceLab = [[UILabel alloc] init];
    _priceLab.font = [UIFont systemFontOfSize:11];
    _priceLab.textAlignment = NSTextAlignmentLeft;
    _priceLab.textColor = [UIColor redColor];
    [self.contentView addSubview:_priceLab];
    
    _prePriceLab = [[UILabel alloc] init];
    _prePriceLab.font = [UIFont systemFontOfSize:11];
    _prePriceLab.textColor = ColorText;
    _prePriceLab.textAlignment = NSTextAlignmentLeft;
    [self.contentView addSubview:_prePriceLab];
    
    _numLab = [[UILabel alloc] init];
    _numLab.font = [UIFont systemFontOfSize:11];
    _numLab.textAlignment = NSTextAlignmentCenter;
    _numLab.textColor = ColorText;
    [self.contentView addSubview:_numLab];
    
    _lineView = [[UIView alloc] init];
    _lineView.backgroundColor = ColorTableViewCellSeparate;
    [self.contentView addSubview:_lineView];
}
- (void)layoutSubviews {
    
    [super layoutSubviews];
    
    [_MedicineImg mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self);
        make.left.equalTo(self).offset((KscreenWidth - 40)/5.0);
        make.size.mas_equalTo(CGSizeMake(50, 50));
    }];
    
    [_nameLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_MedicineImg);
        make.left.equalTo(_MedicineImg.mas_right).offset(10);
        make.height.mas_equalTo(50/3.0);
        make.width.mas_equalTo(KscreenWidth);
    }];
    
    [_contentLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_nameLab.mas_bottom);
        make.left.equalTo(_nameLab);
        make.height.mas_equalTo(50/3.0);
        make.width.mas_equalTo((KscreenWidth - 40)/4.0);
    }];
    
    [_belongLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_nameLab.mas_bottom);
        make.left.equalTo(_contentLab.mas_right).offset(10);
        make.height.mas_equalTo(50/3.0);
        make.width.mas_equalTo((KscreenWidth - 40)/5.0);
    }];
    
    [_priceLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_contentLab.mas_bottom);
        make.left.equalTo(_contentLab);
        make.height.mas_equalTo(50/3.0);
        make.width.mas_equalTo(40);
    }];
    
    [_prePriceLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_priceLab).offset(2);
        make.left.equalTo(_priceLab.mas_right).offset(10);
        make.width.mas_equalTo(40);
        make.height.mas_equalTo(50/3.0);
    }];
    
    [_numLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_belongLab.mas_bottom);
        make.left.equalTo(_belongLab);
        make.width.height.equalTo(_belongLab);
    }];
    
    [_lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.bottom.equalTo(self);
        make.left.equalTo(_MedicineImg);
        make.height.mas_equalTo(0.5);
    }];
}

@end
