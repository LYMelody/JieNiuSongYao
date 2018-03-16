//
//  JNSYCerSelectTableViewCell.h
//  JieNiuSongYao
//
//  Created by rongfeng on 2017/5/11.
//  Copyright © 2017年 China Zhou. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^ChangeStatusYesBlock)(BOOL isSelect);
typedef void(^ChangeStatusNoBlock)(BOOL isSelect);

@interface JNSYCerSelectTableViewCell : UITableViewCell

@property (nonatomic, copy)ChangeStatusYesBlock changeStatusYesBlock;
@property (nonatomic, copy)ChangeStatusNoBlock changeStatusNoBlock;

@property (nonatomic, strong)UIButton *BtnOne;
@property (nonatomic, strong)UIButton *BtnTwo;

@end
