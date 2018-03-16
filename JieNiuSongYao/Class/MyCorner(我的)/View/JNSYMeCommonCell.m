//
//  JNSYMeCommonCell.m
//  JieNiuSongYao
//
//  Created by rongfeng on 2017/5/9.
//  Copyright © 2017年 China Zhou. All rights reserved.
//

#import "JNSYMeCommonCell.h"
#import "Masonry.h"
#import "Common.h"
@interface JNSYMeCommonCell()


@end


@implementation JNSYMeCommonCell


- (instancetype)init {
    
    if ([super init]) {
        [self setUpCell];
    }
    return self;
}

- (void)setUpCell {
    
    self.leftLab = [[UILabel alloc] init];
    _leftLab.font = [UIFont systemFontOfSize:13];
    _leftLab.textAlignment = NSTextAlignmentLeft;
    _leftLab.textColor = ColorText;
    [self.contentView addSubview:self.leftLab];
    
    self.rightLab = [[UILabel alloc] init];
    _rightLab.font = [UIFont systemFontOfSize:13];
    _rightLab.textColor = ColorText;
    _rightLab.textAlignment = NSTextAlignmentRight;
    [self.contentView addSubview:self.rightLab];
    
    self.bottomline = [[UIView alloc] init];
    _bottomline.backgroundColor = ColorTableViewCellSeparate;
    [self.contentView addSubview:_bottomline];

}

- (void)layoutSubviews {
    
    [super layoutSubviews];
    
    [_leftLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self);
        make.left.equalTo(self).offset(16);
        make.bottom.equalTo(self);
        make.width.mas_equalTo(120);
        
    }];
    
    [_rightLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.bottom.equalTo(self);
        make.right.equalTo(self).offset(-30);
        make.width.mas_equalTo(140);
    }];
    
    [_bottomline mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self).offset(-1);
        make.left.equalTo(self).offset(0);
        make.right.equalTo(self);
        make.height.mas_equalTo(0.5);
    }];
}

@end
