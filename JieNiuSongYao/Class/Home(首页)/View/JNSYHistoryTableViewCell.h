//
//  JNSYHistoryTableViewCell.h
//  JieNiuSongYao
//
//  Created by rongfeng on 2017/5/24.
//  Copyright © 2017年 China Zhou. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^DelectBlock)(void);


@interface JNSYHistoryTableViewCell : UITableViewCell

@property (nonatomic, strong)UILabel *leftLab;
@property (nonatomic, strong)UIButton *rightBtn;
@property (nonatomic, strong)DelectBlock delectBlock;
@end
