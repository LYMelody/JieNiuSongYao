//
//  JNSYVipDetailTableViewCell.m
//  JieNiuSongYao
//
//  Created by rongfeng on 2017/5/17.
//  Copyright © 2017年 China Zhou. All rights reserved.
//

#import "JNSYVipDetailTableViewCell.h"
#import "Common.h"
#import "Masonry.h"

@implementation JNSYVipDetailTableViewCell


- (instancetype)init {
    
    if ([super init]) {
        [self SetUpViews];
    }
    
    return self;
    
}


- (void)SetUpViews {
    
    _leftLab = [[UILabel alloc] init];
    _leftLab.font = [UIFont systemFontOfSize:13];
    _leftLab.textAlignment = NSTextAlignmentLeft;
    _leftLab.textColor = ColorText;
    
    [self.contentView addSubview:_leftLab];
    
    
    _detailLab = [[UILabel alloc] init];
    _detailLab.font = [UIFont systemFontOfSize:10];
    _detailLab.textColor = [UIColor redColor];
    _detailLab.textAlignment = NSTextAlignmentLeft;
    
    [self.contentView addSubview:_detailLab];
    
}

- (void)layoutSubviews {
    
    
    [super layoutSubviews];
    
    [_leftLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self);
        make.bottom.equalTo(self).offset(-15);
        make.left.equalTo(self).offset(16);
        make.width.mas_equalTo(200);
    }];
    
    [_detailLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_leftLab.mas_bottom).offset(-8);
        make.bottom.equalTo(self);
        make.left.equalTo(self).offset(16);
        make.width.mas_equalTo(200);
    }];
    
}

@end
