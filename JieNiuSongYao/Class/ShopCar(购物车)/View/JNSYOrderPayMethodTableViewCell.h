//
//  JNSYOrderPayMethodTableViewCell.h
//  JieNiuSongYao
//
//  Created by rongfeng on 2017/6/16.
//  Copyright © 2017年 China Zhou. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^PayMedthodSelectBlock)(void);

@interface JNSYOrderPayMethodTableViewCell : UITableViewCell

@property(nonatomic,strong)UIButton *selectBtn;
@property(nonatomic,strong)UILabel *leftLab;
@property(nonatomic,strong)UILabel *rightLab;
@property(nonatomic,strong)UIView *lineView;
@property(nonatomic,copy)PayMedthodSelectBlock payMedthodSelectBlock;


@end
