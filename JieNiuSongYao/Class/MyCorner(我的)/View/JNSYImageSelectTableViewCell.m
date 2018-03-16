//
//  JNSYImageSelectTableViewCell.m
//  JieNiuSongYao
//
//  Created by rongfeng on 2017/5/12.
//  Copyright © 2017年 China Zhou. All rights reserved.
//

#import "JNSYImageSelectTableViewCell.h"
#import "Common.h"
#import "Masonry.h"

@interface JNSYImageSelectTableViewCell()




@end



@implementation JNSYImageSelectTableViewCell


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
    
    _rightBtn  = [UIButton buttonWithType:UIButtonTypeCustom];
    [_rightBtn setTitle:@"选择文件" forState:UIControlStateNormal];
    [_rightBtn setTitleColor:ColorTabBarback forState:UIControlStateNormal];
    [_rightBtn addTarget:self action:@selector(BtnAction) forControlEvents:UIControlEventTouchUpInside];
    _rightBtn.titleLabel.font = [UIFont systemFontOfSize:13];
    [self.contentView addSubview:_rightBtn];
    
    _bottomline = [[UIImageView alloc] init];
    _bottomline.backgroundColor = ColorTableBack;
    
    [self.contentView addSubview:_bottomline];
    
    _CerImgView = [[UIImageView alloc] init];
    _CerImgView.backgroundColor = ColorTableBack;
    _CerImgView.userInteractionEnabled = YES;
    
    _TapMagnify = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(Magnify)];
    _TapMagnify.numberOfTapsRequired = 1;
    [_CerImgView addGestureRecognizer:_TapMagnify];
    
    [self.contentView addSubview:_CerImgView];
    
    _delectBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [_delectBtn setImage:[UIImage imageNamed:@"删除.png"] forState:UIControlStateNormal];
    [_delectBtn addTarget:self action:@selector(delectBtnAction) forControlEvents:UIControlEventTouchUpInside];
    [self.contentView addSubview:_delectBtn];
    
    self.contentView.userInteractionEnabled = YES;
    
}

- (void)BtnAction {
    
    NSLog(@"选择文件");
    
    if (_changeRowHeightBlock) {
        _changeRowHeightBlock();
    }
}

- (void)delectBtnAction {
    
    NSLog(@"删除");
    if (_delectImageBlock) {
        _delectImageBlock();
    }
    
}

- (void)Magnify {
    
    if (_magnifyBlock) {
        _magnifyBlock(self.CerImgView);
    }
    
}

- (void)layoutSubviews {
    
    [_leftLab mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.equalTo(self);
        make.left.equalTo(self).offset(20);
        make.width.mas_equalTo(200);
        make.height.mas_equalTo(40);
        
    }];
    
    [_rightBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self);
        make.right.equalTo(self).offset(-20);
        make.width.mas_equalTo(100);
        make.height.mas_equalTo(40);
        
    }];
    
    [_bottomline mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.right.equalTo(self).offset(-1);
        make.left.equalTo(self).offset(16);
        make.height.mas_equalTo(0.5);
    }];
    
    [_CerImgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_leftLab.mas_bottom);
        make.bottom.equalTo(self).offset(-5);
        make.left.equalTo(self).offset(20);
        make.width.mas_equalTo(80);
    }];
    
    [_delectBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.centerX.equalTo(_CerImgView.mas_right);
        make.centerY.equalTo(_CerImgView.mas_top);
        make.width.height.mas_equalTo(30);
    }];
    
    
}

@end
