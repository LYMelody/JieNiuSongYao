//
//  JNSYPayMethodTableViewCell.m
//  JieNiuSongYao
//
//  Created by rongfeng on 2017/6/15.
//  Copyright © 2017年 China Zhou. All rights reserved.
//

#import "JNSYPayMethodTableViewCell.h"
#import "Common.h"
#import "Masonry.h"

@implementation JNSYPayMethodTableViewCell


- (instancetype)init {
    
    if ([super init]) {
        [self setUpViews];
    }
    
    return self;
    
}


- (void)setUpViews{
    
    _PayMethodLab = [[UILabel alloc] init];
    _PayMethodLab.font = [UIFont systemFontOfSize:13];
    _PayMethodLab.text = @"付款方式：";
    _PayMethodLab.textColor = ColorText;
    _PayMethodLab.textAlignment = NSTextAlignmentLeft;
    [self.contentView addSubview:_PayMethodLab];
    
    _MethodsLab = [[UILabel alloc] init];
    _MethodsLab.textColor = [UIColor blackColor];
    _MethodsLab.font = [UIFont systemFontOfSize:13];
    _MethodsLab.textAlignment = NSTextAlignmentRight;
    
    [self.contentView addSubview:_MethodsLab];
    
}

- (void)layoutSubviews {
    
    [super layoutSubviews];
    
    [_PayMethodLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self);
        make.left.equalTo(self).offset(KscreenWidth/5.0);
        make.height.equalTo(self);
    }];
    
    [_MethodsLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self);
        make.right.equalTo(self).offset(-40);
        make.height.equalTo(self);
    }];
    
}

@end
