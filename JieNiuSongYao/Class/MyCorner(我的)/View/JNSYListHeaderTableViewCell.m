//
//  JNSYListHeaderTableViewCell.m
//  JieNiuSongYao
//
//  Created by rongfeng on 2017/5/11.
//  Copyright © 2017年 China Zhou. All rights reserved.
//

#import "JNSYListHeaderTableViewCell.h"
#import "Common.h"
#import "Masonry.h"

@implementation JNSYListHeaderTableViewCell

- (instancetype)init {
    if ([super init]) {
        [self SetUpViews];
    }
    return self;
}

- (void)SetUpViews {
    
    _leftLab = [[UILabel alloc] init];
    _leftLab.textColor = ColorText;
    _leftLab.font = [UIFont systemFontOfSize:15];
    _leftLab.textAlignment = NSTextAlignmentLeft;
    [self.contentView addSubview:_leftLab];
    
    _bottomLine = [[UIImageView alloc] init];
    _bottomLine.backgroundColor = ColorTableViewCellSeparate;
    [self.contentView addSubview:_bottomLine];
    
    
}

- (void)layoutSubviews {
    
    [super layoutSubviews];
    
    [_leftLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.bottom.equalTo(self);
        make.left.equalTo(self).offset(16);
        make.width.mas_equalTo(KscreenWidth);
    }];
    
    [_bottomLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.left.right.equalTo(self);
        make.height.mas_equalTo(0.5);
    }];
    
}


@end
