//
//  JNSYHeaderTableViewCell.m
//  JieNiuSongYao
//
//  Created by rongfeng on 2017/5/15.
//  Copyright © 2017年 China Zhou. All rights reserved.
//

#import "JNSYHeaderTableViewCell.h"
#import "Common.h"
#import "Masonry.h"

@implementation JNSYHeaderTableViewCell

- (instancetype)init {
    
    if ([super init]) {
        [self setUpViews];
    }
    
    return self;
    
}


- (void)setUpViews {
    
    _leftLab = [[UILabel alloc] init];
    _leftLab.text = @"头像";
    _leftLab.textAlignment = NSTextAlignmentLeft;
    _leftLab.font = [UIFont systemFontOfSize:15];
    
    [self.contentView addSubview:_leftLab];
    
    
    _headImg = [[UIImageView alloc] init];
    _headImg.backgroundColor = [UIColor clearColor];
    _headImg.layer.cornerRadius = 5;
    _headImg.layer.masksToBounds = YES;
    _headImg.contentMode = UIViewContentModeScaleAspectFill;
    _headImg.clipsToBounds = YES;
    [self.contentView addSubview:_headImg];
    
    _bottomLine = [[UIImageView alloc] init];
    _bottomLine.backgroundColor = ColorTableViewCellSeparate;
    [self.contentView addSubview:_bottomLine];
    
    
}

- (void)layoutSubviews {
    
    
    [super layoutSubviews];
    
    [_leftLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.bottom.equalTo(self).with.insets(UIEdgeInsetsMake(5, 0, 5, 0));
        make.left.equalTo(self).offset(16);
        make.width.mas_equalTo(100);
    }];
    
    [_headImg mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.bottom.equalTo(self).with.insets(UIEdgeInsetsMake(5, 0, 5, 0));
        make.right.equalTo(self).offset(-30);
        make.width.mas_equalTo(60);
    }];
    
    [_bottomLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.right.equalTo(self);
        make.left.equalTo(self).offset(16);
        make.height.mas_equalTo(0.5);
    }];
}

@end
