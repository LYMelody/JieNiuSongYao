//
//  JNSYSearchDrugStoreTableViewCell.m
//  JieNiuSongYao
//
//  Created by rongfeng on 2017/5/25.
//  Copyright © 2017年 China Zhou. All rights reserved.
//

#import "JNSYSearchDrugStoreTableViewCell.h"
#import "Common.h"
#import "Masonry.h"

@implementation JNSYSearchDrugStoreTableViewCell


- (instancetype)init {
    
    
    if ([super init]) {
        //[self setUpViews];
    }
    return self;
}

- (void)setUpViews{
    
    _StoreImg = [[UIImageView alloc] init];
    _StoreImg.backgroundColor = [UIColor grayColor];
    
    [self.contentView addSubview:_StoreImg];
    
    _StoreNameLab = [[UILabel alloc] init];
    _StoreNameLab.font = [UIFont systemFontOfSize:13];
    _StoreNameLab.textColor = [UIColor blackColor];
    _StoreNameLab.textAlignment = NSTextAlignmentLeft;
    
    [self.contentView addSubview:_StoreNameLab];
    
    _TimeLab = [[UILabel alloc] init];
    _TimeLab.textAlignment = NSTextAlignmentLeft;
    _TimeLab.textColor = ColorText;
    _TimeLab.font = [UIFont systemFontOfSize:11];
    
    [self.contentView addSubview:_TimeLab];
    
    _RatingLab = [[UILabel alloc] init];
    _RatingLab.textColor = ColorText;
    _RatingLab.font = [UIFont systemFontOfSize:11];
    _RatingLab.textAlignment = NSTextAlignmentRight;
    
    [self.contentView addSubview:_RatingLab];
    
    _DistanceLab = [[UILabel alloc] init];
    _DistanceLab.textAlignment = NSTextAlignmentRight;
    _DistanceLab.textColor = ColorText;
    _DistanceLab.font = [UIFont systemFontOfSize:11];
    _DistanceLab.numberOfLines = 0;
    
    [self.contentView addSubview:_DistanceLab];
    
    _PlaceLab = [[UILabel alloc] init];
    _PlaceLab.textColor = ColorText;
    _PlaceLab.font = [UIFont systemFontOfSize:11];
    _PlaceLab.textAlignment = NSTextAlignmentLeft;
    
    [self.contentView addSubview:_PlaceLab];
    
    
    self.bottomline = [[UIImageView alloc] init];
    _bottomline.backgroundColor = ColorTableViewCellSeparate;
    [self.contentView addSubview:self.bottomline];
    
    CGFloat startX = 92;
    CGFloat startY = 58 ;
    
    
    if (self.serviceArry != NULL && [self.serviceArry class] != [NSNull class]) {
        if (self.serviceArry.count > 0) {
            for (NSInteger i = 0; i < self.serviceArry.count; i++) {
                UILabel *lab = [[UILabel alloc] init];
                lab.tag = 100 + i;
                lab.textColor = [UIColor whiteColor];
                lab.backgroundColor = ColorTabBarback;
                lab.font = [UIFont systemFontOfSize:11];
                lab.textAlignment = NSTextAlignmentCenter;
                lab.layer.cornerRadius = 3;
                lab.layer.masksToBounds = YES;
                lab.text = self.serviceArry[i];
                CGFloat width = [self getWidthWithTitle:self.serviceArry[i] font:[UIFont systemFontOfSize:11]];
                lab.frame = CGRectMake(startX, startY, width, 15);
                startX = startX + width + 5;
                [self.contentView addSubview:lab];
            }
        }
    }
    
}



- (CGFloat)getWidthWithTitle:(NSString *)title font:(UIFont *)font {
    
    title = [title stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    
    if (title.length == 0 || title == nil || [title isEqualToString:@""]) {
        return 0;
    }
    
    NSDictionary *attribute = @{NSFontAttributeName:font};
    
    CGRect newRect = [title boundingRectWithSize:CGSizeMake(CGFLOAT_MAX, font.pointSize) options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading attributes:attribute context:nil];
    
    title = nil;
    return newRect.size.width + 5;
    
    
}


- (void)layoutSubviews {
    
    [super layoutSubviews];
    
    [_StoreImg mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self).offset(5);
        make.bottom.equalTo(self).offset(-5);
        make.left.equalTo(self).offset(16);
        make.width.mas_equalTo(70);
    }];
    
    [_StoreNameLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_StoreImg);
        make.left.equalTo(_StoreImg.mas_right).offset(6);
        make.width.mas_equalTo(200);
        make.height.mas_equalTo(20);
    }];
    
    [_TimeLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_StoreNameLab.mas_bottom);
        make.left.equalTo(_StoreNameLab);
        make.width.mas_equalTo(100);
        make.height.mas_equalTo(15);
    }];
    
    [_DistanceLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(_TimeLab);
        make.right.equalTo(self).offset(-16);
        make.height.mas_equalTo(30);
        make.width.mas_equalTo(40);
        
    }];
    
    [_RatingLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(_TimeLab);
        make.right.equalTo(_DistanceLab.mas_left).offset(-5);
        make.height.mas_equalTo(15);
        make.width.mas_equalTo(100);
    }];
    
    [_PlaceLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_TimeLab.mas_bottom);
        make.left.equalTo(_TimeLab);
        make.width.mas_equalTo(200);
        make.height.mas_equalTo(18);
    }];
    
    [self.bottomline mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self);
        make.left.equalTo(self).offset(20);
        make.right.equalTo(self);
        make.height.mas_equalTo(0.5);
    }];
}

- (void)setUpLabs {
    
}




@end
