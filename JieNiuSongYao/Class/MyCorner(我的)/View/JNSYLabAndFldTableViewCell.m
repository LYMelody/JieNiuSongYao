//
//  JNSYLabAndFldTableViewCell.m
//  JieNiuSongYao
//
//  Created by rongfeng on 2017/5/11.
//  Copyright © 2017年 China Zhou. All rights reserved.
//

#import "JNSYLabAndFldTableViewCell.h"
#import "Masonry.h"
#import "Common.h"
@implementation JNSYLabAndFldTableViewCell


- (instancetype)init {
    
    if ([super init]) {
        [self SetUpViews];
    }
    
    return self;
}

- (void)SetUpViews {
    
    _LeftLab = [[UILabel alloc] init];
    _LeftLab.font = [UIFont systemFontOfSize:13];
    _LeftLab.textAlignment = NSTextAlignmentLeft;
    _LeftLab.textColor = ColorText;
    [self.contentView addSubview:_LeftLab];
    
    _RightFld = [[UITextField alloc] init];
    _RightFld.font = [UIFont systemFontOfSize:13];
    _RightFld.textAlignment = NSTextAlignmentLeft;
    _RightFld.textColor = ColorText;
    _RightFld.delegate = self;
    [self.contentView addSubview:_RightFld];
    
    _BottomLineView = [[UIImageView alloc] init];
    _BottomLineView.backgroundColor = ColorTableViewCellSeparate;
    [self.contentView addSubview:_BottomLineView];
}


- (void)layoutSubviews {
    
    [super layoutSubviews];
    
    [_LeftLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.bottom.equalTo(self);
        make.left.equalTo(self).offset(20);
        make.width.mas_equalTo(80);
    }];
    
    [_RightFld mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.bottom.right.equalTo(self);
        make.left.equalTo(_LeftLab.mas_right).offset(10);
    }];
    
    [_BottomLineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.right.equalTo(self);
        make.left.equalTo(self).offset(16);
        make.height.mas_equalTo(0.5);
    }];
}

@end
