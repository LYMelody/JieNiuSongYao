//
//  JNSYHistoryTableViewCell.m
//  JieNiuSongYao
//
//  Created by rongfeng on 2017/5/24.
//  Copyright © 2017年 China Zhou. All rights reserved.
//

#import "JNSYHistoryTableViewCell.h"
#import "Common.h"
#import "Masonry.h"

@implementation JNSYHistoryTableViewCell


- (instancetype)init {
    
    if ([super init]) {
        [self setUpViews];
    }
    return self;
}


- (void)setUpViews {
    
    _leftLab = [[UILabel alloc] init];
    _leftLab.textColor = ColorText;
    _leftLab.font = [UIFont systemFontOfSize:15];
    _leftLab.textAlignment = NSTextAlignmentLeft;
    [self.contentView addSubview:_leftLab];
    
    _rightBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [_rightBtn setBackgroundImage:[UIImage imageNamed:@"Delect"] forState:UIControlStateNormal];
    [_rightBtn addTarget:self action:@selector(delectAction) forControlEvents:UIControlEventTouchUpInside];
    
    [self.contentView addSubview:_rightBtn];
    
}

-(void)layoutSubviews {
    
    [super layoutSubviews];
    
    [_leftLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.bottom.equalTo(self);
        make.left.equalTo(self).offset(16);
        make.width.mas_equalTo(KscreenWidth - 60);
    }];
    
    [_rightBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self).offset(9);
        make.bottom.equalTo(self).offset(-9);
        make.right.equalTo(self).offset(-16);
        make.width.mas_equalTo(18);
    }];
    
}


- (void)delectAction {
    
    if (_delectBlock) {
        _delectBlock();
    }
}

@end
