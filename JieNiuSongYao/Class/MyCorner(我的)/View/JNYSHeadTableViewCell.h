//
//  JNYSHeadTableViewCell.h
//  JieNiuSongYao
//
//  Created by rongfeng on 2017/5/10.
//  Copyright © 2017年 China Zhou. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^LoginBlock)(void);


@interface JNYSHeadTableViewCell : UITableViewCell


@property (nonatomic, strong)UIImageView *HeaderView;
@property (nonatomic, strong)UILabel *HeaderLabOne;
@property (nonatomic, strong)UILabel *HeaderLabTwo;
@property (nonatomic, strong)UIImageView *LoginImgView;
@property (nonatomic, strong)UILabel *LoginLab;
@property (nonatomic, strong)UITapGestureRecognizer *TapLogin;
@property (nonatomic, copy)LoginBlock loginBlock;

@end
