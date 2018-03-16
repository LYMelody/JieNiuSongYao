//
//  JNSYSearchDrugStoreTableViewCell.h
//  JieNiuSongYao
//
//  Created by rongfeng on 2017/5/25.
//  Copyright © 2017年 China Zhou. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface JNSYSearchDrugStoreTableViewCell : UITableViewCell

@property (nonatomic, strong)UIImageView *StoreImg;
@property (nonatomic, strong)UILabel *StoreNameLab;
@property (nonatomic, strong)UILabel *TimeLab;
@property (nonatomic, strong)UILabel *RatingLab;
@property (nonatomic, strong)UILabel *DistanceLab;
@property (nonatomic, strong)UILabel *PlaceLab;
@property (nonatomic, strong)NSArray *serviceArry;
@property (nonatomic, strong)UIImageView *bottomline;
- (void)setUpLabs;

- (void)setUpViews;
@end
