//
//  JNSYBindCardDetailCell.h
//  JieNiuSongYao
//
//  Created by rongfeng on 2017/7/3.
//  Copyright © 2017年 China Zhou. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^UnBindCardBlock)(void);


@interface JNSYBindCardDetailCell : UITableViewCell

@property(nonatomic,strong)UILabel *CardNameLab;

@property(nonatomic,strong)UILabel *CardNumLab;

@property(nonatomic,strong)UIButton *UnBindBtn;

@property(nonatomic,copy)UnBindCardBlock unBindCardBlock;

@property(nonatomic,strong)UIImageView *BottomLineView;
@end
