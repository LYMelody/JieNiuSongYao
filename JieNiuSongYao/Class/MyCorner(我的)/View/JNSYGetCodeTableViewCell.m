//
//  JNSYGetCodeTableViewCell.m
//  JieNiuSongYao
//
//  Created by rongfeng on 2017/5/17.
//  Copyright © 2017年 China Zhou. All rights reserved.
//

#import "JNSYGetCodeTableViewCell.h"
#import "Common.h"
#import "Masonry.h"
@implementation JNSYGetCodeTableViewCell


- (instancetype)init {
    
    if ([super init]) {
        [self setUpViews];
    }
    
    return self;
}


- (void)setUpViews {
    
    _LeftLab = [[UILabel alloc] init];
    _LeftLab.textColor = ColorText;
    _LeftLab.font  = [UIFont systemFontOfSize:13];
    _LeftLab.textAlignment = NSTextAlignmentLeft;
    [self.contentView addSubview:_LeftLab];
    
    _rightFld = [[UITextField alloc] init];
    _rightFld.font = [UIFont systemFontOfSize:13];
    _rightFld.textColor = ColorText;
    _rightFld.textAlignment = NSTextAlignmentLeft;
    //_rightFld.keyboardType = UIKeyboardTypeNumberPad;
    [self.contentView addSubview:_rightFld];
    
    _GetCodeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    _GetCodeBtn.backgroundColor = ColorTabBarback;
    [_GetCodeBtn setTitle:@"获取验证码" forState:UIControlStateNormal];
    [_GetCodeBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    _GetCodeBtn.titleLabel.font = [UIFont systemFontOfSize:13];
    [_GetCodeBtn addTarget:self action:@selector(GetCodeBtnAction) forControlEvents:UIControlEventTouchUpInside];
    _GetCodeBtn.layer.cornerRadius = 3;
    _GetCodeBtn.layer.masksToBounds = YES;
    [self.contentView addSubview:_GetCodeBtn];
    
    _BottomLine = [[UIImageView alloc] init];
    _BottomLine.backgroundColor = ColorTableBack;
    
    [self.contentView addSubview:_BottomLine];
    
    
    
}

- (void)GetCodeBtnAction {
    
    if (_btnActionBlock) {
        _btnActionBlock(_rightFld.text);
    }
    
}


- (void)layoutSubviews {
    
    [super layoutSubviews];
    
    [_LeftLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.bottom.equalTo(self);
        make.left.equalTo(self).offset(20);
        make.width.mas_equalTo(80);
        
    }];
    
    [_rightFld mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.bottom.equalTo(self);
        make.left.equalTo(_LeftLab.mas_right).offset(10);
        make.width.mas_equalTo(140);
    }];
    
    [_GetCodeBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self).offset(10);
        make.bottom.equalTo(self).offset(-10);
        make.right.equalTo(self).offset(-10);
        make.width.mas_equalTo(80);
    }];
    
    [_BottomLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.right.equalTo(self);
        make.left.equalTo(self).offset(16);
        make.height.mas_equalTo(0.5);
    }];
    
}


@end
