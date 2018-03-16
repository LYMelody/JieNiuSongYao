//
//  JNSYMedicineCollectionViewCell.m
//  JieNiuSongYao
//
//  Created by rongfeng on 2017/5/31.
//  Copyright © 2017年 China Zhou. All rights reserved.
//

#import "JNSYMedicineCollectionViewCell.h"
#import "Common.h"
#import "Masonry.h"

@implementation JNSYMedicineCollectionViewCell

- (instancetype)initWithFrame:(CGRect)frame {
    
    if ([super initWithFrame:frame]) {
        [self setUpViews];
    }
    
    return self;
    
}


- (void)setUpViews {
    
    self.DrugImgView = [[UIImageView alloc] init];
    _DrugImgView.backgroundColor = [UIColor grayColor];
    
    [self.contentView addSubview:self.DrugImgView];
    
    
    self.BottomBackImg = [[UIImageView alloc] init];
    _BottomBackImg.backgroundColor = [UIColor whiteColor];
    
    [self.contentView addSubview:self.BottomBackImg];
    
    self.MedicineNameLab = [[UILabel alloc] init];
    _MedicineNameLab.font = [UIFont systemFontOfSize:13];
    _MedicineNameLab.textColor = ColorText;
    _MedicineNameLab.textAlignment = NSTextAlignmentLeft;
    //_MedicineNameLab.backgroundColor = [UIColor redColor];
    [_BottomBackImg addSubview:self.MedicineNameLab];
    
    self.MedicineContentLab = [[UILabel alloc] init];
    _MedicineContentLab.textColor = ColorText;
    _MedicineContentLab.textAlignment = NSTextAlignmentLeft;
    _MedicineContentLab.font = [UIFont systemFontOfSize:10];
    
    [_BottomBackImg addSubview:self.MedicineContentLab];
    
    self.MedicineBelongLab = [[UILabel alloc] init];
    _MedicineBelongLab.textAlignment = NSTextAlignmentLeft;
    _MedicineBelongLab.textColor = ColorText;
    _MedicineBelongLab.font = [UIFont systemFontOfSize:10];
    
    [_BottomBackImg addSubview:self.MedicineBelongLab];
    
    self.MedicinePriceLab = [[UILabel alloc] init];
    _MedicinePriceLab.font = [UIFont systemFontOfSize:11];
    _MedicinePriceLab.textColor = [UIColor redColor];
    _MedicinePriceLab.textAlignment = NSTextAlignmentLeft;
    
    [_BottomBackImg addSubview:self.MedicinePriceLab];
    
    self.MedicinePrePriceLab = [[UILabel alloc] init];
    _MedicinePrePriceLab.font = [UIFont systemFontOfSize:11];
    _MedicinePrePriceLab.textColor = ColorText;
    _MedicinePrePriceLab.textAlignment = NSTextAlignmentLeft;
    
    [_BottomBackImg addSubview:self.MedicinePrePriceLab];
    
}

- (void)layoutSubviews {
    
    [super layoutSubviews];
    
    [_DrugImgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.equalTo(self);
        make.bottom.equalTo(self).offset(-44);
    }];
    
    [_BottomBackImg mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(_DrugImgView.mas_bottom);
        make.left.right.bottom.equalTo(self);
    }];
    
    [_MedicineNameLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_BottomBackImg).offset(2);
        make.left.equalTo(_BottomBackImg).offset(5);
        make.width.equalTo(self);
        make.height.mas_equalTo(15);
    }];
    
    [_MedicineContentLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_MedicineNameLab.mas_bottom);
        make.left.equalTo(self).offset(4);
        make.width.mas_equalTo(self.frame.size.width/2.0);
        make.height.mas_equalTo(14);
    }];
    
    [_MedicineBelongLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_MedicineContentLab);
        make.left.equalTo(_MedicineContentLab.mas_right).offset(5);
        make.right.equalTo(self);
        make.height.mas_equalTo(14);
    }];
    
    [_MedicinePriceLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self).offset(2);
        make.top.equalTo(_MedicineBelongLab.mas_bottom);
        make.width.mas_equalTo(80);
        make.bottom.equalTo(self).offset(-2);
    }];
    
    [_MedicinePrePriceLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_MedicineBelongLab);
        make.top.equalTo(_MedicineBelongLab.mas_bottom);
        make.bottom.equalTo(self);
        make.width.mas_equalTo(60);
    }];
    
    
}

@end
