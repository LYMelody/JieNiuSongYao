//
//  JNSYDrugDocerInfoTableViewCell.m
//  JieNiuSongYao
//
//  Created by rongfeng on 2017/6/7.
//  Copyright © 2017年 China Zhou. All rights reserved.
//

#import "JNSYDrugDocerInfoTableViewCell.h"
#import "Common.h"
#import "Masonry.h"
#import "JNSYAutoSize.h"
@implementation JNSYDrugDocerInfoTableViewCell


//药店资质药师信息单元格

- (instancetype)init {
    
    if ([super init]) {
        [self setUpViews];
    }
    return self;
}

- (void)setUpViews {
    
    self.userInteractionEnabled = YES;
    
    
    _HeaderImg = [[UIImageView alloc] init];
    _HeaderImg.backgroundColor = [UIColor grayColor];
    [self.contentView addSubview:_HeaderImg];
    
    _NameLab = [[UILabel alloc] init];
    _NameLab.font = [UIFont systemFontOfSize:13];
    _NameLab.textColor = ColorText;
    _NameLab.textAlignment = NSTextAlignmentLeft;
    [self.contentView addSubview:_NameLab];
    
    _TimeLab = [[UILabel alloc] init];
    _TimeLab.font = [UIFont systemFontOfSize:13];
    _TimeLab.textColor = ColorText;
    _TimeLab.textAlignment = NSTextAlignmentLeft;
    [self.contentView addSubview:_TimeLab];
    
    _PhoneLab = [[UILabel alloc] init];
    _PhoneLab.font = [UIFont systemFontOfSize:13];
    _PhoneLab.textColor = ColorText;
    _PhoneLab.textAlignment = NSTextAlignmentLeft;
    
    [self.contentView addSubview:_PhoneLab];
    
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapToMap)];
    tap.numberOfTapsRequired = 1;
    
    _PlaceLab = [[UILabel alloc] init];
    _PlaceLab.font = [UIFont systemFontOfSize:13];
    _PlaceLab.textColor = ColorText;
    _PlaceLab.textAlignment = NSTextAlignmentLeft;
    _PlaceLab.userInteractionEnabled = YES;
    [self.contentView addSubview:_PlaceLab];
    [_PlaceLab addGestureRecognizer:tap];
    
    
    _PhoneBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [_PhoneBtn setImage:[UIImage imageNamed:@"电话"] forState:UIControlStateNormal];
    [_PhoneBtn addTarget:self action:@selector(PhoneBtnAction) forControlEvents:UIControlEventTouchUpInside];
    [self.contentView addSubview:_PhoneBtn];
    
}

- (void)layoutSubviews {
    
    [super layoutSubviews];
    
    [_HeaderImg mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self);
        make.left.equalTo(self).offset(20);
        make.width.height.mas_equalTo([JNSYAutoSize AutoHeight:80]);
    }];
    
    [_NameLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_HeaderImg);
        make.left.equalTo(_HeaderImg.mas_right).offset(12);
        make.height.mas_equalTo([JNSYAutoSize AutoHeight:20]);
        make.width.mas_equalTo(KscreenWidth - 90);
    }];
    
    [_TimeLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_NameLab.mas_bottom).offset(0);
        make.left.equalTo(_NameLab);
        make.height.mas_equalTo([JNSYAutoSize AutoHeight:20]);
        make.width.mas_equalTo(KscreenWidth - 90);
    }];
    
    [_PhoneLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_TimeLab.mas_bottom).offset(0);
        make.left.equalTo(_TimeLab);
        make.height.mas_equalTo([JNSYAutoSize AutoHeight:20]);
        make.width.mas_equalTo(160);
    }];
    
    [_PlaceLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_PhoneLab.mas_bottom).offset(0);
        make.left.equalTo(_PhoneLab);
        make.height.mas_equalTo([JNSYAutoSize AutoHeight:20]);
        make.width.mas_equalTo(KscreenWidth - 120);
    }];
    
    [_PhoneBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(_PhoneLab);
        make.left.equalTo(_PhoneLab.mas_right).offset(0);
        make.width.height.mas_equalTo([JNSYAutoSize AutoHeight:40]);
    }];
    
}

//点击电话按钮
- (void)PhoneBtnAction {
    
    NSLog(@"打电话");
    
}

//点击地址
- (void)tapToMap {
    
    NSLog(@"跳转地图");
    
    if (self.tapToMapViewBlock) {
        self.tapToMapViewBlock(_PlaceLab.text);
    }
    
}


@end
