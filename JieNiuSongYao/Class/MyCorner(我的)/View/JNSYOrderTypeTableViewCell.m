//
//  JNSYOrderTypeTableViewCell.m
//  JieNiuSongYao
//
//  Created by rongfeng on 2017/5/10.
//  Copyright © 2017年 China Zhou. All rights reserved.
//

#import "JNSYOrderTypeTableViewCell.h"
#import "Common.h"
#import "Masonry.h"

#define Distance KscreenWidth  / 5.0


@implementation JNSYOrderTypeTableViewCell

- (instancetype)init {
    
    if ([super init]) {
        
        [self SetUpViews];
    }
    
    return self;
}

- (void)SetUpViews {
    
    
    _TopLineView = [[UIImageView alloc] init];
    _TopLineView.backgroundColor = ColorTableBack;
    [self.contentView addSubview:_TopLineView];
    
    //5个背景
    _WaitToPayBackImg = [[UIImageView alloc] init];
    _WaitToPayBackImg.userInteractionEnabled = YES;
    [self.contentView addSubview:_WaitToPayBackImg];
    _TapWaitToPay = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(TapWaitToPayAction)];
    _TapWaitToPay.numberOfTapsRequired = 1;
    [_WaitToPayBackImg addGestureRecognizer:_TapWaitToPay];
    
    _WaitToDeliverBackImg = [[UIImageView alloc] init];
    _WaitToDeliverBackImg.userInteractionEnabled = YES;
    [self.contentView addSubview:_WaitToDeliverBackImg];
    _TapWaitToDeliver = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(TapWaitToDeliverAction)];
    _TapWaitToDeliver.numberOfTapsRequired = 1;
    [_WaitToDeliverBackImg addGestureRecognizer:_TapWaitToDeliver];
    
    _WaitToReciveBackImg = [[UIImageView alloc] init];
    _WaitToReciveBackImg.userInteractionEnabled = YES;
    [self.contentView addSubview:_WaitToReciveBackImg];
    _TapWaitToRecive  = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(TapWaitToReciveAction)];
    _TapWaitToRecive.numberOfTapsRequired = 1;
     [_WaitToReciveBackImg addGestureRecognizer:_TapWaitToRecive];
    
    _WaitToEvaluateBcakImg = [[UIImageView alloc] init];
    _WaitToEvaluateBcakImg.userInteractionEnabled = YES;
    [self.contentView addSubview:_WaitToEvaluateBcakImg];
    _TapWaitToEvaluate = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(TapWaitToEvaluateAction)];
    _TapWaitToEvaluate.numberOfTapsRequired = 1;
    [_WaitToEvaluateBcakImg addGestureRecognizer:_TapWaitToEvaluate];
    
    _CompleteBackImg = [[UIImageView alloc] init];
    _CompleteBackImg.userInteractionEnabled = YES;
    [self.contentView addSubview:_CompleteBackImg];
    _TapCompletel = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(TapCompletelAction)];
    _TapCompletel.numberOfTapsRequired = 1;
    [_CompleteBackImg addGestureRecognizer:_TapCompletel];
    
    
    //待付款
    self.WaitToPayImg = [[UIImageView alloc] init];
    _WaitToPayImg.userInteractionEnabled = YES;
    
      //待付款lab
    _WaitToPayLab = [[UILabel alloc] init];
    _WaitToPayLab.textColor = ColorText;
    _WaitToPayLab.textAlignment = NSTextAlignmentCenter;
    _WaitToPayLab.text = @"待付款";
    _WaitToPayLab.font = [UIFont systemFontOfSize:13];
    _WaitToPayLab.userInteractionEnabled = YES;
    [_WaitToPayImg addSubview:_WaitToPayLab];
    [_WaitToPayBackImg addSubview:_WaitToPayImg];
    
    //待发货
    self.WaitToDeliverImg = [[UIImageView alloc] init];
    _WaitToDeliverImg.userInteractionEnabled = YES;

       //待发货lab
    _WaitToDeliverLab = [[UILabel alloc] init];
    _WaitToDeliverLab.textColor = ColorText;
    _WaitToDeliverLab.text = @"待发货";
    _WaitToDeliverLab.textAlignment = NSTextAlignmentCenter;
    _WaitToDeliverLab.font = [UIFont systemFontOfSize:13];
    _WaitToDeliverLab.userInteractionEnabled = YES;
    [_WaitToDeliverImg addSubview:_WaitToDeliverLab];
    [_WaitToDeliverBackImg addSubview:_WaitToDeliverImg];
    
    //待收货
    _WaitToReciveImg = [[UIImageView alloc] init];
    _WaitToReciveImg.userInteractionEnabled = YES;
    
       //待收货lab
    _WaitToReciveLab = [[UILabel alloc] init];
    _WaitToReciveLab.textColor = ColorText;
    _WaitToReciveLab.text = @"待收货";
    _WaitToReciveLab.font = [UIFont systemFontOfSize:13];
    _WaitToReciveLab.textAlignment = NSTextAlignmentCenter;
    _WaitToReciveLab.userInteractionEnabled = YES;
    [_WaitToReciveImg addSubview:_WaitToReciveLab];
    [_WaitToReciveBackImg addSubview:_WaitToReciveImg];
    
    //待评价
    _WaitToEvaluateImg = [[UIImageView alloc] init];
    _WaitToEvaluateImg.userInteractionEnabled = YES;
    
    _WaitToEvaluateLab = [[UILabel alloc] init];
    _WaitToEvaluateLab.textColor = ColorText;
    _WaitToEvaluateLab.text = @"待评价";
    _WaitToEvaluateLab.textAlignment = NSTextAlignmentCenter;
    _WaitToEvaluateLab.font = [UIFont systemFontOfSize:13];
    _WaitToEvaluateLab.userInteractionEnabled = YES;
    [_WaitToEvaluateImg addSubview:_WaitToEvaluateLab];
    [_WaitToEvaluateBcakImg addSubview:_WaitToEvaluateImg];
    
    //已完成
    _CompleteImg = [[UIImageView alloc] init];
    _CompleteImg.userInteractionEnabled = YES;
    
    _CompleteLab = [[UILabel alloc] init];
    _CompleteLab.textAlignment = NSTextAlignmentCenter;
    _CompleteLab.text = @"已完成";
    _CompleteLab.textColor = ColorText;
    _CompleteLab.font = [UIFont systemFontOfSize:13];
    _CompleteLab.userInteractionEnabled = YES;
    [_CompleteImg addSubview:_CompleteLab];
    [_CompleteBackImg addSubview:_CompleteImg];
    
    
    
}

- (void)TapWaitToPayAction {
    
    if (_blockWaitToPay) {
        _blockWaitToPay();
    }
    
}

- (void)TapWaitToDeliverAction {
    if (_blockWaitToDeliver) {
        _blockWaitToDeliver();
    }
    
}

- (void)TapWaitToReciveAction {
    if (_blockWaitToRecive) {
        _blockWaitToRecive();
    }
    
}
- (void)TapWaitToEvaluateAction {
    
    if (_blockWaitToEvaluate) {
        _blockWaitToEvaluate();
    }
}
- (void)TapCompletelAction {
    
    if (_blockComplete) {
        _blockComplete();
    }
    
}
- (void)layoutSubviews {
    [super layoutSubviews];
    
    [_TopLineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.right.left.equalTo(self);
        make.height.mas_equalTo(0.5);
    }];
    
    [_WaitToPayBackImg mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.bottom.equalTo(self);
        make.width.mas_equalTo(Distance);
    }];
    
    [_WaitToDeliverBackImg mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.bottom.equalTo(self);
        make.left.equalTo(_WaitToPayBackImg.mas_right);
        make.width.mas_equalTo(Distance);
    }];
    
    [_WaitToReciveBackImg mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.bottom.equalTo(self);
        make.left.equalTo(_WaitToDeliverBackImg.mas_right);
        make.width.mas_equalTo(Distance);
    }];
    
    [_WaitToEvaluateBcakImg mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.bottom.equalTo(self);
        make.left.equalTo(_WaitToReciveBackImg.mas_right);
        make.width.mas_equalTo(Distance);
    }];
    
    [_CompleteBackImg mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.right.bottom.equalTo(self);
        make.width.mas_equalTo(Distance);
    }];
    
    
    
    //待付款
    [_WaitToPayImg mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self).offset(12);
        make.centerX.equalTo(_WaitToPayBackImg);
        make.width.mas_equalTo(26);
        make.height.mas_equalTo(30);
    }];
    
    [_WaitToPayLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_WaitToPayImg.mas_bottom).offset(7);
        make.centerX.equalTo(_WaitToPayImg);
        make.width.mas_equalTo(50);
        make.height.mas_equalTo(20);
    }];
    
    //待发货
    [_WaitToDeliverImg mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_WaitToDeliverBackImg).offset(12);
        make.centerX.equalTo(_WaitToDeliverBackImg);
        make.width.mas_equalTo(30);
        make.height.mas_equalTo(30);
    }];
    
    [_WaitToDeliverLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_WaitToDeliverImg.mas_bottom).offset(7);
        make.centerX.equalTo(_WaitToDeliverImg);
        make.width.mas_equalTo(50);
        make.height.mas_equalTo(20);
    }];
    
    //待收货
    [_WaitToReciveImg mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_WaitToReciveBackImg).offset(17);
        make.centerX.equalTo(_WaitToReciveBackImg);
        make.width.mas_equalTo(30);
        make.height.mas_equalTo(25);
    }];
    
    [_WaitToReciveLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_WaitToReciveImg.mas_bottom).offset(7);
        make.centerX.equalTo(_WaitToReciveImg);
        make.width.mas_equalTo(50);
        make.height.mas_equalTo(20);
    }];
    //待评价
    [_WaitToEvaluateImg mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_WaitToEvaluateBcakImg).offset(14);
        make.centerX.equalTo(_WaitToEvaluateBcakImg);
        make.width.mas_equalTo(28);
        make.height.mas_equalTo(28);
    }];
    
    [_WaitToEvaluateLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_WaitToEvaluateImg.mas_bottom).offset(7);
        make.centerX.equalTo(_WaitToEvaluateImg);
        make.width.mas_equalTo(50);
        make.height.mas_equalTo(20);
    }];
    
    //已完成
    [_CompleteImg mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_CompleteBackImg).offset(14);
        make.centerX.equalTo(_CompleteBackImg);
        make.width.mas_equalTo(28);
        make.height.mas_equalTo(28);
    }];
    
    [_CompleteLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_CompleteImg.mas_bottom).offset(7);
        make.centerX.equalTo(_CompleteImg);
        make.width.mas_equalTo(50);
        make.height.mas_equalTo(20);
    }];
}


@end
