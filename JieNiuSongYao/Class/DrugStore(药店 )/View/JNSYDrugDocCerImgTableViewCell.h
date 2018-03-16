//
//  JNSYDrugDocCerImgTableViewCell.h
//  JieNiuSongYao
//
//  Created by rongfeng on 2017/6/7.
//  Copyright © 2017年 China Zhou. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^MagOutImgBlock)(UIImageView *img);


@interface JNSYDrugDocCerImgTableViewCell : UITableViewCell

@property (nonatomic, strong)UILabel *TopLab;
@property (nonatomic, strong)UIImageView *CerImgView;
@property (nonatomic, strong)UIImageView *BottomLineView;

@property (nonatomic, copy)MagOutImgBlock magOutImgBlock;

@end
