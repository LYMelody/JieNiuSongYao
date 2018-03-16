//
//  JNSYGetCodeTableViewCell.h
//  JieNiuSongYao
//
//  Created by rongfeng on 2017/5/17.
//  Copyright © 2017年 China Zhou. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^BtnActionBlock)(NSString *phoneStr);


@interface JNSYGetCodeTableViewCell : UITableViewCell

@property (nonatomic, strong)UILabel *LeftLab;
@property (nonatomic, strong)UITextField *rightFld;
@property (nonatomic, strong)UIButton *GetCodeBtn;
@property (nonatomic, strong)UIImageView *BottomLine;

@property (nonatomic, copy)BtnActionBlock btnActionBlock;

@end
