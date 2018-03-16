//
//  JNSYOrderPlaceTableViewCell.m
//  JieNiuSongYao
//
//  Created by rongfeng on 2017/6/15.
//  Copyright © 2017年 China Zhou. All rights reserved.
//

#import "JNSYOrderPlaceTableViewCell.h"
#import "Common.h"
#import "Masonry.h"
#import "JNSYAutoSize.h"

@implementation JNSYOrderPlaceTableViewCell

- (instancetype)init {
    
    if ([super init]) {
        [self setUpViews];
    }
    return self;
    
}

- (void)setUpViews{
    
    _nameLab = [[UILabel alloc] init];
    _nameLab.font = [UIFont systemFontOfSize:14];
    _nameLab.textColor = [UIColor blackColor];
    _nameLab.textAlignment = NSTextAlignmentLeft;
    
    [self.contentView addSubview:_nameLab];
    
    _phoneLab = [[UILabel alloc] init];
    _phoneLab.font = [UIFont systemFontOfSize:14];
    _phoneLab.textColor = [UIColor blackColor];
    _phoneLab.textAlignment = NSTextAlignmentLeft;
    
    [self.contentView addSubview:_phoneLab];
    
    _placeLab = [[UILabel alloc] init];
    _placeLab.font = [UIFont systemFontOfSize:13];
    _placeLab.textColor = ColorText;
    _placeLab.textAlignment = NSTextAlignmentLeft;
    
    [self.contentView addSubview:_placeLab];
    
    _lineView = [[UIView alloc] init];
    _lineView.backgroundColor = ColorTableViewCellSeparate;
    [self.contentView addSubview:_lineView];
    
}

- (void)layoutSubviews {
    
    [super layoutSubviews];
    
    [_nameLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self).offset(8);
        make.left.equalTo(self).offset(20);
        make.size.mas_equalTo(CGSizeMake(60, 20));
    }];
    
    [_phoneLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self).offset(8);
        make.left.equalTo(_nameLab.mas_right).offset(0);
        make.size.mas_equalTo(CGSizeMake(100, 20));
    }];
    
    [_placeLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_nameLab.mas_bottom).offset(5);
        make.left.equalTo(self).offset(20);
        make.size.mas_equalTo(CGSizeMake(KscreenWidth, 20));
    }];
    
    [_lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self);
        make.bottom.equalTo(self);
        make.height.mas_equalTo(0.5);
    }];
}

@end
