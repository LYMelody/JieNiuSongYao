//
//  JNSYOrderHeaderView.m
//  JieNiuSongYao
//
//  Created by rongfeng on 2017/6/15.
//  Copyright © 2017年 China Zhou. All rights reserved.
//

#import "JNSYOrderHeaderView.h"
#import "Common.h"
#import "Masonry.h"

@implementation JNSYOrderHeaderView


- (instancetype)init {
    
    if ([super init]) {
        [self setUpViews];
    }
    
    return self;
    
}


- (void)setUpViews{
    
    
    _backImg = [[UIImageView alloc] init];
    _backImg.backgroundColor = [UIColor whiteColor];
    [self addSubview:_backImg];
    
    self.contentView.backgroundColor = [UIColor whiteColor];
    
    _storeLab = [[UILabel alloc] init];
    _storeLab.font = [UIFont systemFontOfSize:13];
    _storeLab.textColor = ColorText;
    _storeLab.textAlignment = NSTextAlignmentLeft;
    _storeLab.backgroundColor = [UIColor whiteColor];
    [self addSubview:_storeLab];
    
    _orderLab = [[UILabel alloc] init];
    _orderLab.font = [UIFont systemFontOfSize:13];
    _orderLab.textColor = ColorText;
    _orderLab.textAlignment = NSTextAlignmentLeft;
    _orderLab.backgroundColor = [UIColor whiteColor];
    [self addSubview:_orderLab];
    
    _lineView = [[UIView alloc] init];
    _lineView.backgroundColor = ColorTableViewCellSeparate;
    [self addSubview:_lineView];
    
}

- (void)layoutSubviews {
    
    [super layoutSubviews];
    
    [_backImg mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.bottom.left.right.equalTo(self);
    }];
    
    [_storeLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self);
        make.left.equalTo(self).offset(20);
        make.height.equalTo(self);
        make.width.mas_equalTo((KscreenWidth - 40)/2.0);
    }];
    
    
    [_orderLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self);
        make.left.equalTo(_storeLab.mas_right).offset(0);
        make.height.equalTo(self);
        make.width.mas_equalTo((KscreenWidth - 40)/2.0);
    }];
    
    [_lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.equalTo(self);
        make.height.mas_equalTo(0.5);
    }];
    
}

@end
