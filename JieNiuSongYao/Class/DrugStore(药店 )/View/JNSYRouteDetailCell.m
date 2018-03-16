//
//  JNSYRouteDetailCell.m
//  JieNiuSongYao
//
//  Created by rongfeng on 2017/7/20.
//  Copyright © 2017年 China Zhou. All rights reserved.
//

#import "JNSYRouteDetailCell.h"
#import "JNSYAutoSize.h"
#import "JNSYUserInfo.h"
#import "Common.h"
#import "Masonry.h"

@implementation JNSYRouteDetailCell


- (instancetype)init {
    
    
    if ([super init]) {
        [self setUpViews];
    }

    return self;
    
}

//
- (void)setUpViews {
    
    _logoView = [[UIImageView alloc] init];
    _logoView.image = [UIImage imageNamed:@"公交Gray"];
    [self.contentView addSubview:_logoView];
    
    _detailLab = [[UILabel alloc] init];
    _detailLab.textColor = [UIColor blackColor];
    _detailLab.numberOfLines = 0;
    _detailLab.font = [UIFont systemFontOfSize:14];
    _detailLab.textAlignment = NSTextAlignmentLeft;
    [self.contentView addSubview:_detailLab];
    
}


- (void)layoutSubviews {
    
    
    [super layoutSubviews];
    
    
    [_logoView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self);
        make.left.equalTo(self).offset(16);
        make.width.mas_equalTo(15);
        make.height.mas_equalTo(15);
    }];
    
    [_detailLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self);
        make.top.bottom.equalTo(self);
        make.left.equalTo(_logoView.mas_right).offset(10);
        make.right.equalTo(self).offset(-16);
    }];
}


@end
