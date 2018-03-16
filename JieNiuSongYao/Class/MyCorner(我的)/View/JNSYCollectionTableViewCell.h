//
//  JNSYCollectionTableViewCell.h
//  JieNiuSongYao
//
//  Created by rongfeng on 2017/5/18.
//  Copyright © 2017年 China Zhou. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^DelectCollectionBlock)(void);


@interface JNSYCollectionTableViewCell : UITableViewCell

@property (nonatomic, strong)UIImageView *leftImgView;
@property (nonatomic, strong)UILabel *drugNameLab;
@property (nonatomic, strong)UILabel *drugCotentLab;
@property (nonatomic, strong)UILabel *drugBelongLab;
@property (nonatomic, strong)UILabel *drugPriceLab;
@property (nonatomic, strong)UILabel *drugPrePriceLab;
@property (nonatomic, strong)UILabel *drugStoreLab;
@property (nonatomic, strong)UILabel *drugStoreDistanceLab;
@property (nonatomic, strong)UIButton *DelectBtn;
@property (nonatomic, copy)NSString *attrStr;
@property (nonatomic, strong)UIImageView *bottomLine;
@property (nonatomic, copy)DelectCollectionBlock delectCollectionBlock;

@end
