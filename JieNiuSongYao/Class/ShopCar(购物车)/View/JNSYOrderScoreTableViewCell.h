//
//  JNSYOrderScoreTableViewCell.h
//  JieNiuSongYao
//
//  Created by rongfeng on 2017/6/16.
//  Copyright © 2017年 China Zhou. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^ScoreSelectBlock)(UIButton *btn);


@interface JNSYOrderScoreTableViewCell : UITableViewCell

@property(nonatomic,strong)UILabel *avaiableLab;
@property(nonatomic,strong)UIButton *selectBtn;
@property(nonatomic,strong)UILabel *useLab;
@property(nonatomic,strong)UIView *topLineView;
@property(nonatomic,copy)ScoreSelectBlock scoreSelectBlock;

@end
