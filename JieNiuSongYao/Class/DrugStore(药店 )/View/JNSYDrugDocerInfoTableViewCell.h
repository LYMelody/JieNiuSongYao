//
//  JNSYDrugDocerInfoTableViewCell.h
//  JieNiuSongYao
//
//  Created by rongfeng on 2017/6/7.
//  Copyright © 2017年 China Zhou. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^tapToMapViewBlock)(NSString *place);

@interface JNSYDrugDocerInfoTableViewCell : UITableViewCell

@property (nonatomic, strong)UIImageView *HeaderImg;
@property (nonatomic, strong)UILabel *NameLab;
@property (nonatomic, strong)UILabel *TimeLab;
@property (nonatomic, strong)UILabel *PhoneLab;
@property (nonatomic, strong)UILabel *PlaceLab;
@property (nonatomic, strong)UIButton *PhoneBtn;
@property(nonatomic,copy)tapToMapViewBlock tapToMapViewBlock;
@end
