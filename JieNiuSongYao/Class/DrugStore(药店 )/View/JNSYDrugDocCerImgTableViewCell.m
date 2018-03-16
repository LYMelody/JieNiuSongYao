//
//  JNSYDrugDocCerImgTableViewCell.m
//  JieNiuSongYao
//
//  Created by rongfeng on 2017/6/7.
//  Copyright © 2017年 China Zhou. All rights reserved.
//

#import "JNSYDrugDocCerImgTableViewCell.h"
#import "Common.h"
#import "Masonry.h"
#import "JNSYAutoSize.h"

@implementation JNSYDrugDocCerImgTableViewCell


- (instancetype)init {
    
    if ([super init]) {
        [self setUpViews];
    }
    
    return self;
}

- (void)setUpViews {
    
    _TopLab = [[UILabel alloc] init];
    _TopLab.font = [UIFont systemFontOfSize:14];
    _TopLab.textAlignment = NSTextAlignmentLeft;
    _TopLab.textColor = [UIColor blackColor];
    
    [self.contentView addSubview:_TopLab];
    
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapAction:)];
    tap.numberOfTapsRequired = 1;
    
    _CerImgView = [[UIImageView alloc] init];
    _CerImgView.backgroundColor = [UIColor whiteColor];
    _CerImgView.contentMode = UIViewContentModeScaleAspectFit;
    _CerImgView.userInteractionEnabled = YES;
    [self.contentView addSubview:_CerImgView];
    [_CerImgView addGestureRecognizer:tap];
    
    _BottomLineView = [[UIImageView alloc] init];
    _BottomLineView.backgroundColor = ColorTableBack;
    [self.contentView addSubview:_BottomLineView];
}


- (void)tapAction:(UITapGestureRecognizer *)sender {
    
    if (self.magOutImgBlock) {
        self.magOutImgBlock(_CerImgView);
    }
    
}

- (void)layoutSubviews {
    
    [super layoutSubviews];
    
    [_TopLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self).offset([JNSYAutoSize AutoHeight:10]);
        make.left.equalTo(self).offset(20);
        make.height.mas_equalTo([JNSYAutoSize AutoHeight:20]);
        make.width.mas_equalTo(KscreenWidth - 40);
    }];
    
    [_CerImgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_TopLab.mas_bottom).offset([JNSYAutoSize AutoHeight:3]);
        make.left.equalTo(_TopLab);
        make.right.equalTo(self).offset(-20);
        make.height.mas_equalTo([JNSYAutoSize AutoHeight:120]);
    }];
    
    [_BottomLineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self).offset([JNSYAutoSize AutoHeight:0]);
        make.left.equalTo(self).offset(20);
        make.right.equalTo(self);
        make.height.mas_equalTo([JNSYAutoSize AutoHeight:0.5]);
    }];
}

@end
