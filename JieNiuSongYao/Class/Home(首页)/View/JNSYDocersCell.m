//
//  JNSYDocersCell.m
//  JieNiuSongYao
//
//  Created by rongfeng on 2017/7/31.
//  Copyright © 2017年 China Zhou. All rights reserved.
//

#import "JNSYDocersCell.h"
#import "Common.h"
#import "JNSYAutoSize.h"
#import "Masonry.h"
#import "UIImageView+WebCache.h"
@implementation JNSYDocersCell

- (instancetype)init {
    
    
    if ([super init]) {
        [self setUpViews];
    }
    
    return self;
    
}

- (void)setUpViews{
    
    
    self.headerImg = [[UIImageView alloc] init];
    _headerImg.backgroundColor = [UIColor grayColor];
    _headerImg.contentMode = UIViewContentModeScaleAspectFill;
    _headerImg.clipsToBounds = YES;
    [self.contentView addSubview:self.headerImg];
    
    self.titleLab = [[UILabel alloc] init];
    _titleLab.font = [UIFont systemFontOfSize:13];
    _titleLab.textAlignment = NSTextAlignmentLeft;
    
    [self.contentView addSubview:self.titleLab];
    
    self.statusImg = [[UIImageView alloc] init];
    _statusImg.image = [UIImage imageNamed:@"Online"];
    [self.contentView addSubview:_statusImg];
    
    self.cerNameLab = [[UILabel alloc] init];
    _cerNameLab.font = [UIFont systemFontOfSize:12];
    _cerNameLab.textColor = ColorText;
    _cerNameLab.textAlignment = NSTextAlignmentLeft;
    [self.contentView addSubview:self.cerNameLab];
    
    self.cerNumLab = [[UILabel alloc] init];
    _cerNumLab.font = [UIFont systemFontOfSize:12];
    _cerNumLab.textColor = ColorText;
    _cerNumLab.textAlignment = NSTextAlignmentLeft;
    [self.contentView addSubview:self.cerNumLab];
    
    self.cerPhoneLab = [[UILabel alloc] init];
    _cerPhoneLab.font = [UIFont systemFontOfSize:12];
    _cerPhoneLab.textColor = ColorText;
    _cerPhoneLab.textAlignment = NSTextAlignmentLeft;
    [self.contentView addSubview:_cerPhoneLab];
    
    self.timesLab = [[UILabel alloc] init];
    _timesLab.font = [UIFont systemFontOfSize:12];
    _timesLab.textAlignment = NSTextAlignmentLeft;
    _timesLab.textColor = ColorText;
    [self.contentView addSubview:_timesLab];
    
    self.ratingLab = [[UILabel alloc] init];
    _ratingLab.font = [UIFont systemFontOfSize:12];
    _ratingLab.textColor = ColorText;
    _ratingLab.textAlignment = NSTextAlignmentRight;
    [self.contentView addSubview:_ratingLab];
    
    self.locationImg = [[UIImageView alloc] init];
    _locationImg.image = [UIImage imageNamed:@"地点"];
    [self.contentView addSubview:_locationImg];
    
    self.locationLab = [[UILabel alloc] init];
    _locationLab.font = [UIFont systemFontOfSize:12];
    _locationLab.textColor = ColorText;
    _locationLab.textAlignment = NSTextAlignmentLeft;
    [self.contentView addSubview:_locationLab];
    
    self.distanceLab = [[UILabel alloc] init];
    _distanceLab.font = [UIFont systemFontOfSize:12];
    _distanceLab.textAlignment = NSTextAlignmentRight;
    _distanceLab.textColor = ColorText;
    [self.contentView addSubview:_distanceLab];
    
    self.consultBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [_consultBtn setTitle:@"咨询" forState:UIControlStateNormal];
    _consultBtn.layer.cornerRadius = 3;
    _consultBtn.titleLabel.font = [UIFont systemFontOfSize:12];
    [_consultBtn setBackgroundColor:ColorTabBarback];
    [_consultBtn addTarget:self action:@selector(consultBtnAction) forControlEvents:UIControlEventTouchUpInside];
    [self.contentView addSubview:_consultBtn];
    
}

//咨询按钮点击方法
- (void)consultBtnAction {
    
    if (self.consultBlock) {
        self.consultBlock();
    }
    
}


- (void)configDocerInfo:(NSDictionary *)infoDic {
    
    //NSString *headerImg = infoDic[@""];
    NSString *docerName = infoDic[@"pharmacistsName"];
    NSString *phone = infoDic[@"pharmacistsPhone"];
    NSString *cerName = infoDic[@"pharmacistsType"];
    NSString *cerNum = infoDic[@"pharmacistsMerno"];
    //NSString *rating = infoDic[@"pharmacistsScore"];
    NSString *header = infoDic[@"pharmacistsPic1"];
    NSString *discince = infoDic[@"distancen"];
    if ([cerName isEqual:@1]) {
        cerName = @"执业药师中医证书";
    }else {
        cerName = @"执业药师西医证书";
    }
    
    _titleLab.text = docerName;
    _cerNameLab.text = [NSString stringWithFormat:@"资质名称:%@",cerName];
    _cerNumLab.text = [NSString stringWithFormat:@"资质编号:%@",cerNum];
    _cerPhoneLab.text = [NSString stringWithFormat:@"联系电话:%@",phone];
    _ratingLab.text = [NSString stringWithFormat:@"评分:%@分",@"4.5"];
    _timesLab.text = [NSString stringWithFormat:@"咨询人次:%@",@"100"];
    _locationLab.text = [NSString stringWithFormat:@"杭州大药房"];
    _distanceLab.text = [NSString stringWithFormat:@"%@",[self setDistance:discince]];
    [_headerImg sd_setImageWithURL:[NSURL URLWithString:header]];
    
}

//设置距离
- (NSString *)setDistance:(NSString *)distance {
    
    if (distance.length >= 4) {
        distance = [NSString stringWithFormat:@"%@km",[distance substringWithRange:NSMakeRange(0, distance.length - 3)]];
    }else {
        distance = [NSString stringWithFormat:@"%@m",distance];
    }
    
    return distance;
    
    
}




- (void)layoutSubviews {
    
    [super layoutSubviews];
    
    [self.headerImg mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self).offset(10);
        make.left.equalTo(self).offset(16);
        make.size.mas_equalTo(CGSizeMake(60, 60));
    }];
    
    [self.titleLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self).offset(10);
        make.left.equalTo(_headerImg.mas_right).offset(6);
        make.size.mas_equalTo(CGSizeMake(46, 15));
    }];
    
    [self.statusImg mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_titleLab);
        make.left.equalTo(_titleLab.mas_right).offset(0);
        make.size.mas_equalTo(CGSizeMake(15, 15));
    }];
    
    [self.cerNameLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_titleLab.mas_bottom).offset(3);
        make.left.equalTo(_titleLab);
        make.size.mas_equalTo(CGSizeMake(KscreenWidth - 80, 15));
    }];
    
    [self.cerNumLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_cerNameLab.mas_bottom).offset(3);
        make.left.equalTo(_titleLab);
        make.size.mas_equalTo(CGSizeMake(KscreenWidth - 80, 15));
    }];
    
    [self.cerPhoneLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_cerNumLab.mas_bottom).offset(3);
        make.left.equalTo(_titleLab);
        make.size.mas_equalTo(CGSizeMake(KscreenWidth - 80, 15));
    }];
    
    [self.timesLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_cerPhoneLab.mas_bottom).offset(3);
        make.left.equalTo(_titleLab);
        make.size.mas_equalTo(CGSizeMake(100, 15));
    }];
    
    [self.ratingLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_timesLab);
        make.right.equalTo(self).offset(-60);
        make.size.mas_equalTo(CGSizeMake(120, 15));
    }];
    
    [self.locationImg mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_timesLab.mas_bottom).offset(8);
        make.left.equalTo(_timesLab);
        make.size.mas_equalTo(CGSizeMake(8, 12));
    }];
    
    [self.locationLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(_locationImg);
        make.left.equalTo(_locationImg.mas_right).offset(5);
        make.size.mas_equalTo(CGSizeMake(100, 15));
    }];
    
    [self.distanceLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_locationLab);
        make.right.equalTo(_ratingLab);
        make.size.mas_equalTo(CGSizeMake(80, 15));
    }];
    
    [self.consultBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_titleLab);
        make.right.equalTo(self).offset(-16);
        make.size.mas_equalTo(CGSizeMake(50, 20));
    }];
}

@end
