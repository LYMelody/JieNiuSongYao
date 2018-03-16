//
//  MedicineInfoView.m
//  JieNiuSongYao
//
//  Created by rongfeng on 2017/6/6.
//  Copyright © 2017年 China Zhou. All rights reserved.
//

#import "MedicineInfoView.h"
#import "Common.h"
#import "Masonry.h"
#import "JNSYAutoSize.h"

@implementation MedicineInfoView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (instancetype)initWithFrame:(CGRect)frame {
    
    if ([super initWithFrame:frame]) {
        [self setUpViews];
    }
    
    return self;
    
}

- (void)setUpViews {
    
    _MedcineImg = [[UIImageView alloc] init];
    _MedcineImg.backgroundColor = [UIColor grayColor];
    _MedcineImg.contentMode = UIViewContentModeScaleAspectFill;
    _MedcineImg.clipsToBounds = YES;
    [self addSubview:_MedcineImg];
    
    _NameLab = [[UILabel alloc] init];
    _NameLab.textColor = [UIColor blackColor];
    _NameLab.textAlignment = NSTextAlignmentLeft;
    _NameLab.font = [UIFont systemFontOfSize:13];
    [self addSubview:_NameLab];
    
    _contentLab = [[UILabel alloc] init];
    _contentLab.font = [UIFont systemFontOfSize:12];
    _contentLab.textColor = ColorText;
    _contentLab.textAlignment = NSTextAlignmentLeft;
    [self addSubview:_contentLab];
    
    _BelongLab = [[UILabel alloc] init];
    _BelongLab.font = [UIFont systemFontOfSize:12];
    _BelongLab.textColor = ColorText;
    _BelongLab.textAlignment = NSTextAlignmentLeft;
    [self addSubview:_BelongLab];
    
    _PriceLab = [[UILabel alloc] init];
    _PriceLab.font = [UIFont systemFontOfSize:12];
    _PriceLab.textColor = [UIColor redColor];
    _PriceLab.textAlignment = NSTextAlignmentLeft;
    [self addSubview:_PriceLab];
    
    _PrePriceLab = [[UILabel alloc] init];
    _PrePriceLab.font = [UIFont systemFontOfSize:12];
    _PrePriceLab.textColor = ColorText;
    _PrePriceLab.textAlignment = NSTextAlignmentLeft;
    [self addSubview:_PrePriceLab];
    
    
    //布局
    [_MedcineImg mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self).offset(0);
        make.left.equalTo(self).offset(0);
        make.width.height.mas_equalTo([JNSYAutoSize AutoHeight:50]);
    }];
    [_NameLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self).offset(0);
        make.left.equalTo(_MedcineImg.mas_right).offset(5);
        make.height.mas_equalTo([JNSYAutoSize AutoHeight:15]);
        make.width.mas_equalTo(self.frame.size.width - 45);
    }];
    [_contentLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_NameLab.mas_bottom).offset(2);
        make.left.equalTo(_NameLab);
        make.width.mas_equalTo(100);
        make.height.mas_equalTo([JNSYAutoSize AutoHeight:15]);
    }];
    [_BelongLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_contentLab);
        make.right.equalTo(self).offset(0);
        make.left.equalTo(_contentLab.mas_right).offset(10);
        make.height.mas_equalTo([JNSYAutoSize AutoHeight:15]);
    }];
    [_PriceLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_contentLab.mas_bottom).offset(2);
        make.left.equalTo(_contentLab);
        make.height.mas_equalTo([JNSYAutoSize AutoHeight:15]);
        make.width.mas_equalTo(60);
        
    }];
    [_PrePriceLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_PriceLab);
        make.left.equalTo(_PriceLab.mas_right).offset(10);
        make.width.mas_equalTo(60);
        make.height.mas_equalTo([JNSYAutoSize AutoHeight:15]);
    }];
    
}



@end
