//
//  JNSYRoutePlansCell.m
//  JieNiuSongYao
//
//  Created by rongfeng on 2017/7/18.
//  Copyright © 2017年 China Zhou. All rights reserved.
//

#import "JNSYRoutePlansCell.h"
#import "Common.h"
#import "JNSYAutoSize.h"
#import "JNSYUserInfo.h"
#import "Masonry.h"

@implementation JNSYRoutePlansCell


- (instancetype)init {
    
    if ([super init]) {
        [self setUpViews];
    }
    
    return self;
    
    
}

- (void)setUpViews{
    
    self.tagLab = [[UILabel alloc] init];
    self.tagLab.font = [UIFont systemFontOfSize:13];
    self.tagLab.textColor = ColorTabBarback;
    self.tagLab.textAlignment = NSTextAlignmentCenter;
    [self.contentView addSubview:self.tagLab];
    
    
    self.roadLab = [[UILabel alloc] init];
    self.roadLab.font = [UIFont systemFontOfSize:13];
    self.roadLab.textColor = [UIColor blackColor];
    self.roadLab.textAlignment = NSTextAlignmentLeft;
    [self.contentView addSubview:self.roadLab];
    
    self.timeLab = [[UILabel alloc] init];
    self.timeLab.font = [UIFont systemFontOfSize:11];
    self.timeLab.textColor = [UIColor lightGrayColor];
    self.timeLab.textAlignment = NSTextAlignmentLeft;
    [self.contentView addSubview:self.timeLab];
    
    self.bottomLineView = [[UIImageView alloc] init];
    self.bottomLineView.backgroundColor = ColorTableViewCellSeparate;
    [self.contentView addSubview:self.bottomLineView];
    
    
    
    self.backgroundColor = ColorTableBack;
}


- (void)layoutSubviews {
    
    [super layoutSubviews];
    
    [self.tagLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self);
        make.left.equalTo(self).offset(10);
        make.size.mas_equalTo(CGSizeMake(15, 15));
    }];
    
    [self.roadLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self).offset(10);
        make.left.equalTo(self.tagLab.mas_right).offset(15);
        make.size.mas_equalTo(CGSizeMake(KscreenWidth - 40, 15));
    }];
    
    [self.timeLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.roadLab.mas_bottom);
        make.left.equalTo(self.roadLab);
        make.size.mas_equalTo(CGSizeMake(KscreenWidth - 40, 15));
    }];
    
    [self.bottomLineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.equalTo(self);
        make.height.mas_equalTo(0.5);
    }];
    
    
}

/*    公交参数设置   */
- (void)configTag:(NSString *)num trsit:(AMapTransit *)transit {
    
    
    
    NSMutableArray *mArray = [[NSMutableArray alloc] init];
    
    NSArray *segmentsArray = transit.segments;   //换乘路段
    
    if (segmentsArray.count < 1) {
        return;
    }
    
    for (NSInteger j = 0; j < segmentsArray.count; j++) {
        AMapSegment *Asegment = segmentsArray[j];
        NSArray *busRoadArray = Asegment.buslines;
        for (NSInteger m = 0; m < busRoadArray.count; m ++) {   //公交路线
            AMapBusLine *line = busRoadArray[m];
            NSRange range = [line.name rangeOfString:@"("];
            [mArray addObject:[line.name substringToIndex:range.location]];
        }
    }
    
    NSString *str = mArray[0];
    
    for (NSInteger n = 0; n < mArray.count; n ++) {
        
        
        if (n == 0) {
            
            
        }else {
            str = [str stringByAppendingString:[NSString stringWithFormat:@"-%@",mArray[n]]];
        }
        
        
        NSLog(@"单个路线名称----%@",str);
    }
    
    
    //设置参数
    self.roadLab.text = str;
    NSInteger hour =  transit.duration/60/60;
    NSInteger min = transit.duration/60 - hour*60;
    
    if (hour) {
         self.timeLab.text = [NSString stringWithFormat:@"%ld小时%ld分钟  |  %.1f公里  | 步行%ld米",(long)hour,(long)min,transit.distance/1000.0,(long)transit.walkingDistance];
    }else {
         self.timeLab.text = [NSString stringWithFormat:@"%ld分钟  |  %.1f公里  | 步行%ld米",(long)min,transit.distance/1000.0,(long)transit.walkingDistance];
    }
    
   
    
}



/*    驾车、步行、骑行路线参数布局    */
- (void)configTag:(NSInteger)num path:(AMapPath *)path {
    
    NSInteger hour =  path.duration/60/60;
    NSInteger min = path.duration/60 - hour*60;
    
    if (hour) {
        self.timeLab.text = [NSString stringWithFormat:@"%ld小时%ld分钟  |  %.1f公里  ",(long)hour,(long)min,path.distance/1000.0];
    }else {
        self.timeLab.text = [NSString stringWithFormat:@"%ld分钟  |  %.1f公里  ",(long)min,path.distance/1000.0];
    }
    
    
    if (path.steps.count > 1) {
        
        NSString *roadOne = nil;
        NSString *roadTwo = nil;
        
        NSInteger  m = 0;
        NSInteger  n = 0;
        
        for (NSInteger i = 0; i < path.steps.count; i ++) {
            
            roadOne = path.steps[m].road;
            roadTwo = path.steps[n].road;
            
            if (roadOne != nil && (![roadOne isEqualToString:@""])) {
                
                
            }else {
                m = i;
            }
            
            if (roadTwo != nil && (roadTwo != roadOne) && (![roadTwo isEqualToString:@""])) {
                
                
            }else {
                n = i;
            }
            
        }
        
        self.roadLab.text = [NSString stringWithFormat:@"途径%@和%@",roadOne,roadTwo];
        
    }else if(path.steps.count == 1){
        self.roadLab.text = [NSString stringWithFormat:@"途径%@",path.steps[0].road];
    }
    
    
    
//    for (NSInteger i = 0; i < path.steps.count; i ++) {
//        NSLog(@"线路:%@",path.steps[i].road);
//    }
    
    
}


@end
