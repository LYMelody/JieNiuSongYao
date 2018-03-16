//
//  JNSYOrderTypeTableViewCell.h
//  JieNiuSongYao
//
//  Created by rongfeng on 2017/5/10.
//  Copyright © 2017年 China Zhou. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^BlockWaitToPay)(void);
typedef void(^BlockWaitToDeliver)(void);
typedef void(^BlockWaitToRecive)(void);
typedef void(^BlockWaitToEvaluate)(void);
typedef void(^BlockComplete)(void);

@interface JNSYOrderTypeTableViewCell : UITableViewCell

@property (nonatomic, strong)UIImageView *TopLineView;
@property (nonatomic, strong)UIImageView *WaitToPayBackImg;
@property (nonatomic, strong)UIImageView *WaitToDeliverBackImg;
@property (nonatomic, strong)UIImageView *WaitToReciveBackImg;
@property (nonatomic, strong)UIImageView *WaitToEvaluateBcakImg;
@property (nonatomic, strong)UIImageView *CompleteBackImg;

@property (nonatomic, strong)UIImageView *WaitToPayImg;
@property (nonatomic, strong)UIImageView *WaitToDeliverImg;
@property (nonatomic, strong)UIImageView *WaitToReciveImg;
@property (nonatomic, strong)UIImageView *WaitToEvaluateImg;
@property (nonatomic, strong)UIImageView *CompleteImg;
@property (nonatomic, strong)UILabel *WaitToPayLab;
@property (nonatomic, strong)UILabel *WaitToDeliverLab;
@property (nonatomic, strong)UILabel *WaitToReciveLab;
@property (nonatomic, strong)UILabel *WaitToEvaluateLab;
@property (nonatomic, strong)UILabel *CompleteLab;


@property (nonatomic, strong)UITapGestureRecognizer *TapWaitToPay;
@property (nonatomic, strong)UITapGestureRecognizer *TapWaitToDeliver;
@property (nonatomic, strong)UITapGestureRecognizer *TapWaitToRecive;
@property (nonatomic, strong)UITapGestureRecognizer *TapWaitToEvaluate;
@property (nonatomic, strong)UITapGestureRecognizer *TapCompletel;


@property (nonatomic, copy)BlockWaitToPay blockWaitToPay;
@property (nonatomic, copy)BlockWaitToDeliver blockWaitToDeliver;
@property (nonatomic, copy)BlockWaitToRecive blockWaitToRecive;
@property (nonatomic, copy)BlockWaitToEvaluate blockWaitToEvaluate;
@property (nonatomic, copy)BlockComplete blockComplete;



@end
