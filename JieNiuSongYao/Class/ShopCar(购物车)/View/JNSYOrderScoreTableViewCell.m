//
//  JNSYOrderScoreTableViewCell.m
//  JieNiuSongYao
//
//  Created by rongfeng on 2017/6/16.
//  Copyright © 2017年 China Zhou. All rights reserved.
//

#import "JNSYOrderScoreTableViewCell.h"
#import "Common.h"
#import "Masonry.h"

@implementation JNSYOrderScoreTableViewCell


- (instancetype)init {
    
    if ([super init]) {
        [self setUpViews];
    }
    return self;
    
}


- (void)setUpViews{
    
    _avaiableLab = [[UILabel alloc] init];
    _avaiableLab.font = [UIFont systemFontOfSize:13];
    _avaiableLab.textColor = ColorText;
    _avaiableLab.textAlignment = NSTextAlignmentLeft;
    [self.contentView addSubview:_avaiableLab];
    
    _selectBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [_selectBtn setImage:[UIImage imageNamed:@"未选"] forState:UIControlStateNormal];
    [_selectBtn setImage:[UIImage imageNamed:@"选中"] forState:UIControlStateSelected];
    [_selectBtn addTarget:self action:@selector(selectBtnAction:) forControlEvents:UIControlEventTouchUpInside];
    
    [self.contentView addSubview:_selectBtn];
    
    _useLab = [[UILabel alloc] init];
    _useLab.font = [UIFont systemFontOfSize:13];
    _useLab.textAlignment = NSTextAlignmentLeft;
    _useLab.textColor = ColorText;
    _useLab.text = @"使用";
    [self.contentView addSubview:_useLab];
    
    _topLineView = [[UIView alloc] init];
    _topLineView.backgroundColor = ColorTableViewCellSeparate;
    [self.contentView addSubview:_topLineView];
    
    
}

- (void)selectBtnAction:(UIButton *)sender{
    sender.selected = !sender.selected;
    
    if (_scoreSelectBlock) {
        _scoreSelectBlock(sender);
    }
    
}

- (void)layoutSubviews {
    
    [super layoutSubviews];
    
    [_avaiableLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self);
        make.left.equalTo(self).offset(20);
        make.height.equalTo(self);
        make.width.mas_equalTo(KscreenWidth/3.0*2.0);
    }];
    
    [_selectBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self);
        make.left.equalTo(_avaiableLab.mas_right).offset(5);
        make.size.mas_equalTo(CGSizeMake(30, 30));
    }];
    
    [_useLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self);
        make.left.equalTo(_selectBtn.mas_right);
        make.height.mas_equalTo(self);
        make.width.mas_equalTo(60);
    }];
    
    [_topLineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.equalTo(self);
        make.height.mas_equalTo(0.5);
    }];
}

@end
