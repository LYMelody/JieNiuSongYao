//
//  JNSYJiFenTableViewCell.m
//  JieNiuSongYao
//
//  Created by rongfeng on 2017/5/10.
//  Copyright © 2017年 China Zhou. All rights reserved.
//

#import "JNSYJiFenTableViewCell.h"
#import "Masonry.h"
#import "Common.h"
@implementation JNSYJiFenTableViewCell

- (instancetype)init {
    
    if ([super init]) {
        
        [self SetUpViews];
    }
    return self;
}

- (void)SetUpViews {
    
    
    UITapGestureRecognizer *TapJiFen = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(TapJiFen)];
    TapJiFen.numberOfTapsRequired = 1;
    
    UITapGestureRecognizer *TapCollection = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(TapCollection)];
    TapCollection.numberOfTapsRequired = 1;
    
    UITapGestureRecognizer *TapNearByDrugs = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(TapNearByDrugs)];
    TapNearByDrugs.numberOfTapsRequired = 1;
    
    //积分
    self.imageViewOne = [[UIImageView alloc] init];
    _imageViewOne.userInteractionEnabled = YES;
    [_imageViewOne addGestureRecognizer:TapJiFen];
     //积分数
    self.JiFenLabOne = [[UILabel alloc] init];
    _JiFenLabOne.textColor = ColorText;
    _JiFenLabOne.textAlignment = NSTextAlignmentCenter;
    _JiFenLabOne.font = [UIFont systemFontOfSize:15];
    [_imageViewOne addSubview:_JiFenLabOne];
     //积分
    self.JiFenLabTwo = [[UILabel alloc] init];
    _JiFenLabTwo.textColor = ColorText;
    _JiFenLabTwo.text = @"积分";
    _JiFenLabTwo.textAlignment = NSTextAlignmentCenter;
    _JiFenLabTwo.font = [UIFont systemFontOfSize:13];
    [_imageViewOne addSubview:_JiFenLabTwo];
    [self.contentView addSubview:_imageViewOne];
    
    //收藏
    self.imageViewTwo = [[UIImageView alloc] init];
    _imageViewTwo.userInteractionEnabled = YES;
    [_imageViewTwo addGestureRecognizer:TapCollection];
      //收藏数
    _CollectionLabOne = [[UILabel alloc] init];
    _CollectionLabOne.textAlignment = NSTextAlignmentCenter;
    _CollectionLabOne.textColor = ColorText;
    _CollectionLabOne.font = [UIFont systemFontOfSize:15];
    [_imageViewTwo addSubview:_CollectionLabOne];
      //收藏
    _CollectionLabTwo = [[UILabel alloc] init];
    _CollectionLabTwo.textAlignment = NSTextAlignmentCenter;
    _CollectionLabTwo.textColor = ColorText;
    _CollectionLabTwo.text = @"收藏";
    _CollectionLabTwo.font = [UIFont systemFontOfSize:13];
    [_imageViewTwo addSubview:_CollectionLabTwo];
    [self.contentView addSubview:_imageViewTwo];
    
    //附近的药店
    self.imageViewThree = [[UIImageView alloc] init];
    _imageViewThree.userInteractionEnabled = YES;
    [_imageViewThree addGestureRecognizer:TapNearByDrugs];
      //附近的药店数
    _NearByDrugLabOne = [[UILabel alloc] init];
    _NearByDrugLabOne.textAlignment = NSTextAlignmentCenter;
    _NearByDrugLabOne.textColor = ColorText;
    _NearByDrugLabOne.font = [UIFont systemFontOfSize:13];
    [_imageViewThree addSubview:_NearByDrugLabOne];
       //附近的药店
    _NearByDrugLabTwo = [[UILabel alloc] init];
    _NearByDrugLabTwo.textAlignment = NSTextAlignmentCenter;
    _NearByDrugLabTwo.textColor = ColorText;
    _NearByDrugLabTwo.text = @"附近药店";
    _NearByDrugLabTwo.font = [UIFont systemFontOfSize:13];
    [_imageViewThree addSubview:_NearByDrugLabTwo];
    [self.contentView addSubview:_imageViewThree];
    
    
    
    
    
}

- (void)TapJiFen {
    
    if (_jifenTapBlock) {
        _jifenTapBlock();
    }
}

- (void)TapCollection {
    
    if (_collectionTapBlock) {
        _collectionTapBlock();
    }
}

- (void)TapNearByDrugs {
    
    if (_nearbyDrugsBlock) {
        _nearbyDrugsBlock();
    }
    
}

- (void)layoutSubviews {
    
    
    [super layoutSubviews];
    
    [_imageViewOne mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.bottom.equalTo(self);
        make.width.mas_equalTo(self.frame.size.width/3.0);
    }];
    
    [_JiFenLabOne mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(_imageViewOne);
        make.top.equalTo(_imageViewOne).offset(20);
        make.width.equalTo(_imageViewOne);
        make.height.mas_equalTo(15);
    }];
    
    [_JiFenLabTwo mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(_imageViewOne);
        make.top.equalTo(_JiFenLabOne.mas_bottom);
        make.width.equalTo(_imageViewOne);
        make.height.mas_equalTo(30);
    }];
    
    [_imageViewTwo mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.bottom.equalTo(self);
        make.left.equalTo(_imageViewOne.mas_right);
        make.width.mas_equalTo(self.frame.size.width/3.0);
    }];
    
    [_CollectionLabOne mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(_imageViewTwo);
        make.top.equalTo(_imageViewTwo).offset(20);
        make.width.equalTo(_imageViewTwo);
        make.height.mas_equalTo(15);
    }];
    
    [_CollectionLabTwo mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(_imageViewTwo);
        make.top.equalTo(_CollectionLabOne.mas_bottom);
        make.width.equalTo(_imageViewTwo);
        make.height.mas_equalTo(30);
    }];
    
    [_imageViewThree mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.bottom.right.equalTo(self);
        make.width.mas_equalTo(self.frame.size.width/3.0);
    }];
    
    [_NearByDrugLabOne mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(_imageViewThree);
        make.top.equalTo(_imageViewThree).offset(20);
        make.width.equalTo(_imageViewThree);
        make.height.mas_equalTo(15);
    }];
    
    [_NearByDrugLabTwo mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(_imageViewThree);
        make.top.equalTo(_NearByDrugLabOne.mas_bottom);
        make.width.equalTo(_imageViewThree);
        make.height.mas_equalTo(30);
    }];
}


@end
