//
//  JNSYCollectionTableViewCell.m
//  JieNiuSongYao
//
//  Created by rongfeng on 2017/5/18.
//  Copyright © 2017年 China Zhou. All rights reserved.
//

#import "JNSYCollectionTableViewCell.h"
#import "Common.h"
#import "Masonry.h"

@implementation JNSYCollectionTableViewCell


- (instancetype)init {
    
    
    if ([super init]) {
        [self setUpViews];
    }
    return self;
    
}


- (void)setUpViews {
    
    _leftImgView = [[UIImageView alloc] init];
    _leftImgView.backgroundColor = [UIColor grayColor];
    _leftImgView.contentMode = UIViewContentModeScaleAspectFill;
    _leftImgView.clipsToBounds = YES;
    [self.contentView addSubview:_leftImgView];
    
    _drugNameLab = [[UILabel alloc] init];
    _drugNameLab.font = [UIFont systemFontOfSize:13];
    _drugNameLab.textAlignment = NSTextAlignmentLeft;
    
    [self.contentView addSubview:_drugNameLab];
    
    _drugCotentLab = [[UILabel alloc] init];
    _drugCotentLab.font = [UIFont systemFontOfSize:11];
    _drugCotentLab.textColor = ColorText;
    _drugCotentLab.textAlignment = NSTextAlignmentLeft;
    
    [self.contentView addSubview:_drugCotentLab];
    
    _drugBelongLab = [[UILabel alloc] init];
    _drugBelongLab.font = [UIFont systemFontOfSize:11];
    _drugBelongLab.textColor = ColorText;
    _drugBelongLab.textAlignment = NSTextAlignmentLeft;
    
    [self.contentView addSubview:_drugBelongLab];
    
    _drugPriceLab = [[UILabel alloc] init];
    _drugPriceLab.font = [UIFont systemFontOfSize:11];
    _drugPriceLab.textColor = [UIColor redColor];
    _drugPriceLab.textAlignment = NSTextAlignmentLeft;
    
    [self.contentView addSubview:_drugPriceLab];
    
    _drugPrePriceLab = [[UILabel alloc] init];
    _drugPrePriceLab.font = [UIFont systemFontOfSize:11];
    _drugPrePriceLab.textColor = ColorText;
    _drugPrePriceLab.textAlignment = NSTextAlignmentLeft;
   
    
    
    [self.contentView addSubview:_drugPrePriceLab];
    
    
    _drugStoreLab = [[UILabel alloc] init];
    _drugStoreLab.font = [UIFont systemFontOfSize:11];
    _drugStoreLab.textAlignment = NSTextAlignmentLeft;
    _drugStoreLab.numberOfLines = 0;
    [self.contentView addSubview:_drugStoreLab];
    
    _drugStoreDistanceLab = [[UILabel alloc] init];
    _drugStoreDistanceLab.font = [UIFont systemFontOfSize:11];
    _drugStoreDistanceLab.textColor = ColorText;
    _drugStoreDistanceLab.textAlignment = NSTextAlignmentLeft;
    
    [self.contentView addSubview:_drugStoreDistanceLab];
    
    _DelectBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [_DelectBtn setTitle:@"移除收藏" forState:UIControlStateNormal];
    [_DelectBtn setTitleColor:ColorTabBarback forState:UIControlStateNormal];
    _DelectBtn.titleLabel.font = [UIFont systemFontOfSize:14];
    [_DelectBtn addTarget:self action:@selector(DelectBtnAction) forControlEvents:UIControlEventTouchUpInside];
    
    [self.contentView addSubview:_DelectBtn];
    
    self.bottomLine = [[UIImageView alloc] init];
    self.bottomLine.backgroundColor = ColorTableViewCellSeparate;
    [self.contentView addSubview:self.bottomLine];
    
}


- (void)DelectBtnAction {
    
    NSLog(@"删除");
    
    if (_delectCollectionBlock) {
        _delectCollectionBlock();
    }
}

- (void)layoutSubviews {
    
    [super layoutSubviews];
    
    [_leftImgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self).offset(8);
        make.bottom.equalTo(self).offset(-8);
        make.left.equalTo(self).offset(16);
        make.width.mas_equalTo(84);
    }];
    
    [_drugNameLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_leftImgView).offset(5);
        make.left.equalTo(_leftImgView.mas_right).offset(10);
        make.width.mas_equalTo(100);
        make.height.mas_equalTo(20);
    }];
    
    [_drugCotentLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_drugNameLab.mas_bottom);
        make.left.equalTo(_drugNameLab);
        make.width.mas_equalTo(100);
        make.height.mas_equalTo(15);
    }];
    
    [_drugBelongLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_drugCotentLab);
        make.left.equalTo(_drugCotentLab.mas_right).offset(26);
        make.right.equalTo(self);
        make.height.mas_equalTo(15);
    }];
    
    [_drugPriceLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_drugCotentLab.mas_bottom);
        make.left.equalTo(_drugCotentLab);
        make.width.mas_equalTo(40);
        make.height.mas_equalTo(15);
    }];
    
    [_drugPrePriceLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_drugPriceLab);
        make.left.equalTo(_drugBelongLab);
        make.width.mas_equalTo(100);
        make.height.mas_equalTo(15);
    }];
    
    [_drugStoreLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_drugPriceLab);
        make.bottom.equalTo(_leftImgView);
        make.width.mas_equalTo(80);
        make.height.mas_equalTo(20);
    }];
    
    [_drugStoreDistanceLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_drugPrePriceLab);
        make.bottom.equalTo(_drugStoreLab);
        make.width.mas_equalTo(100);
        make.height.mas_equalTo(20);
    }];
    
    [_DelectBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self).offset(6);
        make.right.equalTo(self).offset(-16);
        make.width.mas_equalTo(60);
        make.height.mas_equalTo(30);
    }];
    
    [self.bottomLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self);
        make.right.equalTo(self);
        make.left.equalTo(self).offset(20);
        make.height.mas_equalTo(0.5);
    }];
}


@end
