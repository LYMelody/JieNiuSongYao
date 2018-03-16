//
//  JNSYOrderMedicineTableViewCell.h
//  JieNiuSongYao
//
//  Created by rongfeng on 2017/6/15.
//  Copyright © 2017年 China Zhou. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface JNSYOrderMedicineTableViewCell : UITableViewCell

@property(nonatomic,strong)UIImageView *MedicineImg;
@property(nonatomic,strong)UILabel *nameLab;
@property(nonatomic,strong)UILabel *contentLab;
@property(nonatomic,strong)UILabel *belongLab;
@property(nonatomic,strong)UILabel *priceLab;
@property(nonatomic,strong)UILabel *prePriceLab;
@property(nonatomic,strong)UILabel *numLab;
@property(nonatomic,strong)UIView *lineView;
@end
