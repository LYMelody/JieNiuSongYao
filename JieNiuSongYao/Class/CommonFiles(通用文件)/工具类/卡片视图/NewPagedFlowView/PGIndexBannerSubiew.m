//
//  PGIndexBannerSubiew.m
//  NewPagedFlowViewDemo
//
//  Created by Mars on 16/6/18.
//  Copyright © 2016年 Mars. All rights reserved.
//  Designed By PageGuo,
//  QQ:799573715
//  github:https://github.com/PageGuo/NewPagedFlowView

#import "PGIndexBannerSubiew.h"
#import "Common.h"
#import "Masonry.h"
#import "JNSYAutoSize.h"
@implementation PGIndexBannerSubiew

- (instancetype)initWithFrame:(CGRect)frame {
    
    self = [super initWithFrame:frame];
    
    if (self) {
        
        [self addSubview:self.mainImageView];
        [self addSubview:self.coverView];
        [self addSubview:self.headerView];
        [self addSubview:self.NameLab];
        [self addSubview:self.StatusImg];
        [self addSubview:self.ConsultBtn];
        [self addSubview:self.CerNameLab];
        [self addSubview:self.CerNumLab];
        [self addSubview:self.ResignNumLab];
        [self addSubview:self.ConnectTimesLab];
        [self addSubview:self.RatingLab];
        [self addSubview:self.PhoneLab];
        [self addSubview:self.PhoneBtn];
        
        
    }
    
    return self;
}

- (void)layoutSubviews {
    
    [super layoutSubviews];
    
    [_headerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self);
        make.left.equalTo(self).offset(10);
        make.height.mas_equalTo([JNSYAutoSize AutoHeight:100]);
        make.width.mas_equalTo([JNSYAutoSize AutoHeight:100]);
    }];
    
    [_NameLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self).offset([JNSYAutoSize AutoHeight:20]);
        make.left.equalTo(_headerView.mas_right).offset(10);
        make.height.mas_equalTo([JNSYAutoSize AutoHeight:20]);
        make.width.mas_equalTo(60);
    }];
    
    [_StatusImg mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_NameLab);
        make.left.equalTo(_NameLab.mas_right).offset(-5);
        make.height.mas_equalTo([JNSYAutoSize AutoHeight:18]);
        make.width.mas_equalTo([JNSYAutoSize AutoHeight:18]);
        
    }];
    
    [_ConsultBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_NameLab);
        make.right.equalTo(self).offset(-30);
        make.height.mas_equalTo([JNSYAutoSize AutoHeight:20]);
        make.width.mas_equalTo(40);
    }];
    
    [_CerNameLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_NameLab.mas_bottom).offset(10);
        make.left.equalTo(_NameLab);
        make.right.equalTo(self);
        make.height.mas_equalTo([JNSYAutoSize AutoHeight:20]);
    }];
    
    [_CerNumLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_CerNameLab.mas_bottom).offset(5);
        make.left.equalTo(_CerNameLab);
        make.right.equalTo(self);
        make.height.mas_equalTo([JNSYAutoSize AutoHeight:20]);
        
    }];
    
    [_ResignNumLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_CerNumLab.mas_bottom).offset(5);
        make.left.equalTo(_CerNumLab);
        make.right.equalTo(self);
        make.height.mas_equalTo([JNSYAutoSize AutoHeight:20]);
    }];
    
    [_ConnectTimesLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_ResignNumLab.mas_bottom).offset(5);
        make.left.equalTo(_ResignNumLab);
        make.height.mas_equalTo([JNSYAutoSize AutoHeight:20]);
        make.width.mas_equalTo(KscreenWidth/4.0 + (IsMidScreen?10:20));
    }];
    
    [_RatingLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_ConnectTimesLab);
        make.left.equalTo(_ConnectTimesLab.mas_right).offset(0);
        make.height.mas_equalTo([JNSYAutoSize AutoHeight:20]);
        make.width.mas_equalTo(100);
    }];
    
    [_PhoneLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_ConnectTimesLab.mas_bottom).offset(5);
        make.left.equalTo(_ConnectTimesLab);
        make.height.mas_equalTo([JNSYAutoSize AutoHeight:20]);
        make.width.mas_equalTo(KscreenWidth/3.0 + (IsMidScreen?20:35));
    }];
    
    [_PhoneBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(_PhoneLab);
        make.left.equalTo(_PhoneLab.mas_right).offset(-10);
        make.height.mas_equalTo([JNSYAutoSize AutoHeight:40]);
        make.width.mas_equalTo(40);
    }];
}

- (UIImageView *)mainImageView {
    
    if (_mainImageView == nil) {
        _mainImageView = [[UIImageView alloc] initWithFrame:self.bounds];
        _mainImageView.userInteractionEnabled = YES;
    }
    return _mainImageView;
}

- (UIView *)coverView {
    if (_coverView == nil) {
        _coverView = [[UIView alloc] initWithFrame:self.bounds];
        _coverView.backgroundColor = [UIColor blackColor];
    }
    return _coverView;
}

- (UIImageView *)headerView {
    
    if (_headerView == nil) {
        _headerView = [[UIImageView alloc] init];
        _headerView.contentMode = UIViewContentModeScaleAspectFill;
        _headerView.clipsToBounds = YES;
        _headerView.layer.cornerRadius = ([JNSYAutoSize AutoHeight:100])/2.0;
        _headerView.layer.masksToBounds = YES;
    }
    return _headerView;
}

- (UILabel *)NameLab {
    
    if (_NameLab == nil) {
        _NameLab = [[UILabel alloc] init];
        _NameLab.text = @"张三丰";
        _NameLab.font = [UIFont systemFontOfSize:14];
        _NameLab.textColor = [UIColor blackColor];
        _NameLab.textAlignment = NSTextAlignmentLeft;
        
    }
    return _NameLab;
}

- (UIImageView *)StatusImg {
    
    if (_StatusImg == nil) {
        _StatusImg = [[UIImageView alloc] init];
        //_StatusImg .backgroundColor = [UIColor redColor];
        _StatusImg.image = [UIImage imageNamed:@"Online"];
    }
    return _StatusImg;
}

- (UIButton *)ConsultBtn {
    if (_ConsultBtn == nil) {
        _ConsultBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_ConsultBtn setTitle:@"咨询" forState:UIControlStateNormal];
        _ConsultBtn.titleLabel.font = [UIFont systemFontOfSize:12];
        [_ConsultBtn setBackgroundColor:ColorTabBarback];
        _ConsultBtn.layer.cornerRadius = 3;
        _ConsultBtn.layer.masksToBounds = YES;
        
        [_ConsultBtn addTarget:self action:@selector(ConsultBtnAction) forControlEvents:UIControlEventTouchUpInside];
    }
    return _ConsultBtn;
}

- (UILabel *)CerNameLab {
    if (_CerNameLab == nil) {
        _CerNameLab = [[UILabel alloc] init];
        _CerNameLab.text = @"资质名称:职业药师证书";
        _CerNameLab.font = [UIFont systemFontOfSize:12];
        _CerNameLab.textColor = ColorText;
        _CerNameLab.textAlignment = NSTextAlignmentLeft;
    }
    return _CerNameLab;
}

- (UILabel *)CerNumLab {
    if (_CerNumLab == nil) {
        _CerNumLab = [[UILabel alloc] init];
        _CerNumLab.text = @"资格证号:XXXXXXXX";
        _CerNumLab.font = [UIFont systemFontOfSize:12];
        _CerNumLab.textColor = ColorText;
        _CerNumLab.textAlignment = NSTextAlignmentLeft;
    }
    return _CerNumLab;
}

- (UILabel *)ResignNumLab {
    if (_ResignNumLab == nil) {
        _ResignNumLab = [[UILabel alloc] init];
        _ResignNumLab.text = @"注册证号:XXXXXXXXXXXX";
        _ResignNumLab.font = [UIFont systemFontOfSize:12];
        _ResignNumLab.textColor = ColorText;
        _ResignNumLab.textAlignment = NSTextAlignmentLeft;
    }
    return _ResignNumLab;
}

- (UILabel *)ConnectTimesLab {
    if (_ConnectTimesLab == nil) {
        _ConnectTimesLab = [[UILabel alloc] init];
        _ConnectTimesLab.text = @"咨询人次:100次";
        _ConnectTimesLab.font = [UIFont systemFontOfSize:12];
        _ConnectTimesLab.textColor = ColorText;
        _ConnectTimesLab.textAlignment = NSTextAlignmentLeft;
    }
    return _ConnectTimesLab;
}

- (UILabel *)RatingLab {
    
    if (_RatingLab == nil) {
        _RatingLab = [[UILabel alloc] init];
        _RatingLab.text = @"评分:4.5分";
        _RatingLab.font = [UIFont systemFontOfSize:13];
        _RatingLab.textColor = ColorText;
        _RatingLab.textAlignment = NSTextAlignmentLeft;
    }
    return _RatingLab;
}

- (UILabel *)PhoneLab {
    
    if (_PhoneLab == nil) {
        _PhoneLab = [[UILabel alloc] init];
        _PhoneLab.text = @"联系电话:1886888888";
        _PhoneLab.font = [UIFont systemFontOfSize:12];
        _PhoneLab.textColor = ColorText;
        _PhoneLab.textAlignment = NSTextAlignmentLeft;
    }
    return _PhoneLab;
}

- (UIButton *)PhoneBtn {
    
    if (_PhoneBtn == nil) {
        _PhoneBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_PhoneBtn setImage:[UIImage imageNamed:@"电话"] forState:UIControlStateNormal];
        [_PhoneBtn addTarget:self action:@selector(PhoneBtnAction) forControlEvents:UIControlEventTouchUpInside];
    }
    return _PhoneBtn;
    
}

- (void)PhoneBtnAction {
    
    if (_phoneCallActionBlock) {
        _phoneCallActionBlock();
    }
    
}

- (void)ConsultBtnAction {
    
    if (_consultActionBlock) {
        _consultActionBlock();
    }
    
}

@end
