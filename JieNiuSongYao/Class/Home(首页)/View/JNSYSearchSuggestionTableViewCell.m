//
//  JNSYSearchSuggestionTableViewCell.m
//  JieNiuSongYao
//
//  Created by rongfeng on 2017/5/25.
//  Copyright © 2017年 China Zhou. All rights reserved.
//

#import "JNSYSearchSuggestionTableViewCell.h"
# import "Common.h"
#import "Masonry.h"

@implementation JNSYSearchSuggestionTableViewCell


- (instancetype)init {
    
    if ([super init]) {
        [self setUpViews];
    }
    return self;
}



- (void)setUpViews {
    
    self.SearchImg = [[UIImageView alloc] init];
    _SearchImg.image = [UIImage imageNamed:@"Search"];
    
    [self.contentView addSubview:self.SearchImg];
    
    
    self.titleLab = [[UILabel alloc] init];
    _titleLab.textColor = ColorText;
    _titleLab.textAlignment = NSTextAlignmentLeft;
    _titleLab.font = [UIFont systemFontOfSize:13];
    
    [self.contentView addSubview:self.titleLab];
    
    
    self.bottomLine = [[UIImageView alloc] init];
    _bottomLine.backgroundColor = ColorTableViewCellSeparate;
    
    [self.contentView addSubview:self.bottomLine];
    
}

- (void)layoutSubviews {
    
    [super layoutSubviews];
    
    [self.SearchImg mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.centerY.equalTo(self);
        make.left.equalTo(self).offset(10);
        make.height.mas_equalTo(13);
        make.width.mas_equalTo(13);
    }];
    
    
    [self.titleLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.bottom.equalTo(self);
        make.left.equalTo(self.SearchImg.mas_right).offset(10);
        make.width.mas_equalTo(200);
    }];
    
    [self.bottomLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.right.equalTo(self);
        make.left.equalTo(self).offset(10);
        make.height.mas_equalTo(0.5);
    }];
    
    
}







@end
