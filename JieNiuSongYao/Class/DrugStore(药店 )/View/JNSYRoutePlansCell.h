//
//  JNSYRoutePlansCell.h
//  JieNiuSongYao
//
//  Created by rongfeng on 2017/7/18.
//  Copyright © 2017年 China Zhou. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AMapSearchKit/AMapSearchKit.h>
@interface JNSYRoutePlansCell : UITableViewCell

@property(nonatomic,strong)UILabel *tagLab;

@property(nonatomic,strong)UILabel *roadLab;

@property(nonatomic,strong)UILabel *timeLab;

@property(nonatomic,strong)UILabel *totalDistanceLab;

@property(nonatomic,strong)UILabel *walkDistanceLab;

@property(nonatomic,strong)UIImageView *bottomLineView;


- (void)configTag:(NSString *)num trsit:(AMapTransit *)transit ;
    
    
- (void)configTag:(NSInteger)num path:(AMapPath *)path;

@end
