//
//  PGIndexBannerSubiew.h
//  NewPagedFlowViewDemo
//
//  Created by Mars on 16/6/18.
//  Copyright © 2016年 Mars. All rights reserved.
//  Designed By PageGuo,
//  QQ:799573715
//  github:https://github.com/PageGuo/NewPagedFlowView

/******************************
 
 可以根据自己的需要再次重写view
 
 ******************************/

#import <UIKit/UIKit.h>

typedef void(^ConsultActionBlock)(void);
typedef void(^PhoneCallActionBlock)(void);

@interface PGIndexBannerSubiew : UIView

/**
 *  主图
 */
@property (nonatomic, strong) UIImageView *mainImageView;

/**
 *  用来变色的view
 */
@property (nonatomic, strong) UIView *coverView;


@property (nonatomic, strong)UIImageView *headerView;
@property (nonatomic, strong)UILabel *NameLab;
@property (nonatomic, strong)UIImageView *StatusImg;
@property (nonatomic, strong)UIButton *ConsultBtn;
@property (nonatomic, strong)UILabel *CerNameLab;
@property (nonatomic, strong)UILabel *CerNumLab;
@property (nonatomic, strong)UILabel *ResignNumLab;
@property (nonatomic, strong)UILabel *ConnectTimesLab;
@property (nonatomic, strong)UILabel *RatingLab;
@property (nonatomic, strong)UILabel *PhoneLab;
@property (nonatomic, strong)UIButton *PhoneBtn;

@property (nonatomic, copy)ConsultActionBlock consultActionBlock;
@property (nonatomic, copy)PhoneCallActionBlock phoneCallActionBlock;


@end
