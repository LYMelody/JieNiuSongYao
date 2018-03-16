//
//  JNSYDrugsStoreImgTableViewCell.h
//  JieNiuSongYao
//
//  Created by rongfeng on 2017/5/11.
//  Copyright © 2017年 China Zhou. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^SelectPictureBlock)(void);
typedef void(^MangifyBlock)(UIImageView *MagnifyImg);

@interface JNSYDrugsStoreImgTableViewCell : UITableViewCell

@property (nonatomic, strong)UIImageView *StoreImgView;
@property (nonatomic, copy)SelectPictureBlock selectPictureBlock;
@property (nonatomic, copy)MangifyBlock mangifyBlock;

@end
