//
//  JNSYJiFenTableViewCell.h
//  JieNiuSongYao
//
//  Created by rongfeng on 2017/5/10.
//  Copyright © 2017年 China Zhou. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^JiFenTapBlock)(void);
typedef void(^CollectionTapBlock)(void);
typedef void(^NearbyDrugsBlock)(void);

@interface JNSYJiFenTableViewCell : UITableViewCell

@property (nonatomic, strong)UIImageView *imageViewOne;
@property (nonatomic, strong)UIImageView *imageViewTwo;
@property (nonatomic, strong)UIImageView *imageViewThree;
@property (nonatomic, strong)UILabel *JiFenLabOne;
@property (nonatomic, strong)UILabel *JiFenLabTwo;
@property (nonatomic, strong)UILabel *CollectionLabOne;
@property (nonatomic, strong)UILabel *CollectionLabTwo;
@property (nonatomic, strong)UILabel *NearByDrugLabOne;
@property (nonatomic, strong)UILabel *NearByDrugLabTwo;

@property (nonatomic, copy)JiFenTapBlock jifenTapBlock;
@property (nonatomic, copy)CollectionTapBlock collectionTapBlock;
@property (nonatomic, copy)NearbyDrugsBlock nearbyDrugsBlock;

@end
