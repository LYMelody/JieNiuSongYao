//
//  JNSYBindCardDetailCell.m
//  JieNiuSongYao
//
//  Created by rongfeng on 2017/7/3.
//  Copyright © 2017年 China Zhou. All rights reserved.
//

#import "JNSYBindCardDetailCell.h"
#import "Common.h"
#import "Masonry.h"
#import "JNSYAutoSize.h"
@implementation JNSYBindCardDetailCell


- (instancetype)init {
    
    if ([super init]) {
        [self setUpViews];
    }
    
    return self;
}


- (void)setUpViews {
    
    
    //解除绑定按钮
    _UnBindBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [_UnBindBtn setTitle:@"解除绑定" forState:UIControlStateNormal];
    [_UnBindBtn setBackgroundColor:ColorTabBarback];
    _UnBindBtn.layer.cornerRadius = 3;
    _UnBindBtn.layer.masksToBounds = YES;
    _UnBindBtn.titleLabel.font = [UIFont systemFontOfSize:13];
    [_UnBindBtn addTarget:self action:@selector(UnBindBtnAction) forControlEvents:UIControlEventTouchUpInside];
    [self.contentView addSubview:_UnBindBtn];
    
    //银行卡
    _CardNameLab = [[UILabel alloc] init];
    _CardNameLab.font = [UIFont systemFontOfSize:13];
    _CardNameLab.textAlignment = NSTextAlignmentLeft;
    
    [self.contentView addSubview:_CardNameLab];
    
    
    //银行卡号
    _CardNumLab = [[UILabel alloc] init];
    _CardNumLab.font = [UIFont systemFontOfSize:13];
    _CardNumLab.textColor = GreenColor;
    _CardNumLab.textAlignment = NSTextAlignmentLeft;
    
    [self.contentView addSubview:_CardNumLab];
    
    
    
    //底部分割线
    _BottomLineView = [[UIImageView alloc] init];
    _BottomLineView.backgroundColor = ColorTableViewCellSeparate;
    
    [self.contentView addSubview:_BottomLineView];
    
}

//点击解除绑定
- (void)UnBindBtnAction {
    
    if (self.unBindCardBlock) {
        self.unBindCardBlock();
    }
    
}


- (void)layoutSubviews {
    
    [super layoutSubviews];
    
    [_BottomLineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self);
        make.bottom.equalTo(self);
        make.height.mas_equalTo(0.5);
    }];
    
    
    [_UnBindBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self);
        make.right.equalTo(self).offset(-20);
        make.width.mas_equalTo(80);
        make.height.mas_equalTo([JNSYAutoSize AutoHeight:26]);
    }];

    
    [_CardNameLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self).offset(20);
        make.top.equalTo(self).offset(16);
        make.width.mas_equalTo(KscreenWidth - 100);
        make.height.mas_equalTo(26);
        
    }];
    
    [_CardNumLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self).offset(20);
        make.top.equalTo(_CardNameLab.mas_bottom);
        make.width.mas_equalTo(KscreenWidth - 100);
        make.height.mas_equalTo(26);
    }];
    
    
  
}




@end
