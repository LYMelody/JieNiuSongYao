//
//  JNSYLocalMapTableViewCell.m
//  JieNiuSongYao
//
//  Created by rongfeng on 2017/5/11.
//  Copyright © 2017年 China Zhou. All rights reserved.
//

#import "JNSYLocalMapTableViewCell.h"
#import "Common.h"
#import "Masonry.h"

@interface JNSYLocalMapTableViewCell()

@property (nonatomic, strong)UIImageView *Imageview;
@property (nonatomic, strong)UIImageView *bottomLine;

@end


@implementation JNSYLocalMapTableViewCell

- (instancetype)init {
    
    if ([super init]) {
        [self SetUpViews];
    }
    return self;
}

- (void)SetUpViews {
    
    _leftLab = [[UILabel alloc] init];
    _leftLab.textColor = ColorText;
    _leftLab.font = [UIFont systemFontOfSize:13];
    _leftLab.textAlignment = NSTextAlignmentLeft;
    [self.contentView addSubview:_leftLab];
    
//    _Imageview = [[UIImageView alloc] init];
//    _Imageview.backgroundColor = [UIColor grayColor];
//    [self.contentView addSubview:_Imageview];
    
    _bottomLine = [[UIImageView alloc] init];
    _bottomLine.backgroundColor = ColorTableViewCellSeparate;
    [self.contentView addSubview:_bottomLine];
    
    
    _mapView = [[MAMapView alloc] init];
    _mapView.showsCompass = NO;
    _mapView.showsScale = NO;
    [self.contentView addSubview:_mapView];
    
    
}

- (void)layoutSubviews {
    
    [super layoutSubviews];
    
    [_leftLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self);
        make.left.equalTo(self).offset(20);
        make.width.mas_equalTo(80);
        make.height.mas_equalTo(40);
    }];
    
//    [_Imageview mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.top.bottom.right.equalTo(self).with.insets(UIEdgeInsetsMake(6, 0, 6, 16));
//        make.left.equalTo(_leftLab.mas_right).offset(10);
//    }];
    
    [_bottomLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.equalTo(self);
        make.height.mas_equalTo(0.5);
    }];
    
    [_mapView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.bottom.right.equalTo(self).with.insets(UIEdgeInsetsMake(6, 0, 6, 16));
        make.left.equalTo(_leftLab.mas_right).offset(10);
    }];
    
    
}

@end
