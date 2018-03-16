//
//  JNSYImageSelectTableViewCell.h
//  JieNiuSongYao
//
//  Created by rongfeng on 2017/5/12.
//  Copyright © 2017年 China Zhou. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^ChangeRowHeightBlock)(void);
typedef void(^DelectImageBlock)(void);
typedef void(^MagnifyBlock)(UIImageView *ImageToMagnify);

@interface JNSYImageSelectTableViewCell : UITableViewCell

@property (nonatomic, strong)UILabel *leftLab;

@property (nonatomic, strong)UIImageView *CerImgView;
@property (nonatomic, strong)UIImageView *bottomline;
@property (nonatomic, strong)UIButton *rightBtn;
@property (nonatomic, strong)UIButton *delectBtn;
@property (nonatomic, copy)ChangeRowHeightBlock changeRowHeightBlock;
@property (nonatomic, copy)DelectImageBlock delectImageBlock;
@property (nonatomic, copy)MagnifyBlock magnifyBlock;

@property (nonatomic, copy)UITapGestureRecognizer *TapMagnify;
@end
