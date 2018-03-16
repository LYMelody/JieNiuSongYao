//
//  JNYSHeadTableViewCell.m
//  JieNiuSongYao
//
//  Created by rongfeng on 2017/5/10.
//  Copyright © 2017年 China Zhou. All rights reserved.
//

#import "JNYSHeadTableViewCell.h"
#import "Masonry.h"
#import "Common.h"
#import "JNSYAutoSize.h"
@implementation JNYSHeadTableViewCell

- (instancetype)init {
    
    if ([super init]) {
        
        [self SetUpViews];
    }
    
    return self;
}


- (void)SetUpViews {
    
    self.HeaderView = [[UIImageView alloc] init];
    _HeaderView.backgroundColor = [UIColor clearColor];
    _HeaderView.layer.cornerRadius = 8.0;
    _HeaderView.contentMode = UIViewContentModeScaleAspectFill;
    _HeaderView.clipsToBounds = YES;
    [self.contentView addSubview:_HeaderView];
    
    _HeaderLabOne = [[UILabel alloc] init];
    _HeaderLabOne.textColor = [UIColor whiteColor];
    _HeaderLabOne.font = [UIFont systemFontOfSize:15];
    [self.contentView addSubview:_HeaderLabOne];
    
    _HeaderLabTwo = [[UILabel alloc] init];
    _HeaderLabTwo.textColor = [UIColor whiteColor];
    _HeaderLabTwo.font = [UIFont systemFontOfSize:15];
    [self.contentView addSubview:_HeaderLabTwo];

    _LoginImgView = [[UIImageView alloc] init];
    _LoginImgView.backgroundColor = [UIColor whiteColor];
    _LoginImgView.layer.cornerRadius = 5;
    _LoginImgView.userInteractionEnabled = YES;
    
    [self.contentView addSubview:_LoginImgView];
    
    
    _LoginLab = [[UILabel alloc] init];
    _LoginLab.userInteractionEnabled = YES;
    _LoginLab.textColor = ColorTabBarback;
    _LoginLab.font = [UIFont systemFontOfSize:13];
    _LoginLab.textAlignment = NSTextAlignmentLeft;
    _LoginLab.text = @"登录/注册";
    [_LoginImgView addSubview:_LoginLab];
    
    _TapLogin = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(TapLoginAction)];
    _TapLogin.numberOfTapsRequired = 1;
    [_LoginImgView addGestureRecognizer:_TapLogin];
    
    
}


- (void)TapLoginAction {
    
    
    if (_loginBlock) {
        _loginBlock();
    }
    
    NSLog(@"登录");
    
}

- (void)layoutSubviews {
    
    [super layoutSubviews];
    
    [_HeaderView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self);
        make.left.equalTo(self).offset(20);
        make.width.mas_equalTo([JNSYAutoSize AutoHeight:80]);
        make.height.mas_equalTo([JNSYAutoSize AutoHeight:80]);
    }];
    
    [_HeaderLabOne mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_HeaderView.mas_right).offset(10);
        make.top.equalTo(_HeaderView.mas_top).offset(10);
        make.width.mas_equalTo(200);
        make.height.mas_equalTo([JNSYAutoSize AutoHeight:30]);
    }];
    
    [_HeaderLabTwo mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_HeaderLabOne);
        make.top.equalTo(_HeaderLabOne.mas_bottom);
        make.width.mas_equalTo(200);
        make.height.mas_equalTo([JNSYAutoSize AutoHeight:30]);
    }];
    
    [_LoginImgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self);
        make.right.equalTo(self).offset(10);
        make.height.mas_equalTo([JNSYAutoSize AutoHeight:30]);
        make.width.mas_equalTo(100);
    }];

    
    [_LoginLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(_LoginImgView);
        make.left.equalTo(_LoginImgView).offset(10);
        make.width.height.equalTo(_LoginImgView);
    }];
    

}
@end
