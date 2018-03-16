//
//  JNSYSetDefaultTableViewCell.m
//  JieNiuSongYao
//
//  Created by rongfeng on 2017/5/16.
//  Copyright © 2017年 China Zhou. All rights reserved.
//

#import "JNSYSetDefaultTableViewCell.h"
#import "Common.h"
#import "Masonry.h"

@implementation JNSYSetDefaultTableViewCell


- (instancetype)init {
    
    if ([super init]) {
        [self setUpViews];
    }
    
    return  self;
}

- (void)setUpViews {
    
    _SelectBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [_SelectBtn setImage:[UIImage imageNamed:@"Unselected"] forState:UIControlStateNormal];
    [_SelectBtn setImage:[UIImage imageNamed:@"Selected"] forState:UIControlStateSelected];
    [_SelectBtn addTarget:self action:@selector(SelectBtnAction) forControlEvents:UIControlEventTouchUpInside];
    [self.contentView addSubview:_SelectBtn];
    
    _DefaultLab = [[UILabel alloc] init];
    _DefaultLab.text = @"设为默认地址";
    _DefaultLab.textColor = ColorText;
    _DefaultLab.font = [UIFont systemFontOfSize:13];
    _DefaultLab.textAlignment = NSTextAlignmentLeft;
    
    [self.contentView addSubview:_DefaultLab];
    
}

- (void)SelectBtnAction {
    
    _SelectBtn.selected = !_SelectBtn.isSelected;
    
}

- (void)layoutSubviews {
    
    [super layoutSubviews];
    
    [_SelectBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self);
        make.left.equalTo(self).offset(16);
        make.width.height.mas_equalTo(24);
    }];
    
    [_DefaultLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.bottom.equalTo(self);
        make.left.equalTo(_SelectBtn.mas_right).offset(10);
        make.width.mas_equalTo(100);
    }];
}

@end
