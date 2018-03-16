//
//  JNSYOrderBottomView.h
//  JieNiuSongYao
//
//  Created by rongfeng on 2017/6/16.
//  Copyright © 2017年 China Zhou. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^CommitOrderBlock)(void);

@interface JNSYOrderBottomView : UIView


@property(nonatomic,strong)UILabel *totalPriceLab;
@property(nonatomic,strong)UILabel *scoreLab;
@property(nonatomic,strong)UIButton *commitBtn;
@property(nonatomic,copy)CommitOrderBlock commitOrderBlock;

- (void)configureTotalPrice:(NSString *)totalPrice score:(NSString *)score;

- (void)configureTotalPrice:(NSString *)totalPrice;

@end
