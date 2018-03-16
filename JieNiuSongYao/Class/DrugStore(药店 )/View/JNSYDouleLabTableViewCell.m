//
//  JNSYDouleLabTableViewCell.m
//  JieNiuSongYao
//
//  Created by rongfeng on 2017/6/7.
//  Copyright © 2017年 China Zhou. All rights reserved.
//

#import "JNSYDouleLabTableViewCell.h"
#import "Common.h"
#import "Masonry.h"
#import "JNSYAutoSize.h"
@implementation JNSYDouleLabTableViewCell


- (instancetype)init {
    
    if ([super init]) {
        [self setUpViews];
    }
    return self;
}


- (void)setUpViews {
    
    _LabOne = [[UILabel alloc] init];
    _LabOne.font = [UIFont systemFontOfSize:14];
    _LabOne.textColor = ColorTabBarback;
    _LabOne.textAlignment = NSTextAlignmentLeft;
    
    [self.contentView addSubview:_LabOne];
    
    _LabTwo = [[UILabel alloc] init];
    _LabTwo.font = [UIFont systemFontOfSize:14];
    _LabTwo.textColor = ColorTabBarback;
    _LabTwo.textAlignment = NSTextAlignmentLeft;
    
    [self.contentView addSubview:_LabTwo];
    
    _topImgView = [[UIImageView alloc] init];
    _topImgView.backgroundColor = ColorTableBack;
    
    [self.contentView addSubview:_topImgView];
    
}

- (void)layoutSubviews {
    
    [super layoutSubviews];
    
    [_LabOne mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self).offset([JNSYAutoSize AutoHeight:10]);
        make.left.equalTo(self).offset(20);
        make.height.mas_equalTo([JNSYAutoSize AutoHeight:20]);
        make.width.mas_equalTo(KscreenWidth - 40);
    }];
    
    [_LabTwo mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_LabOne.mas_bottom).offset(0);
        make.left.equalTo(_LabOne);
        make.height.mas_equalTo([JNSYAutoSize AutoHeight:20]);
        make.width.mas_equalTo(KscreenWidth - 40);
    }];
    
    [_topImgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self);
        make.left.equalTo(self).offset(20);
        make.right.equalTo(self);
        make.height.mas_equalTo([JNSYAutoSize AutoHeight:0.5]);
    }];
    
}


@end
