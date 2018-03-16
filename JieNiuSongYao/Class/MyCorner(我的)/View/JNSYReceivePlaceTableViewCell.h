//
//  JNSYReceivePlaceTableViewCell.h
//  JieNiuSongYao
//
//  Created by rongfeng on 2017/5/16.
//  Copyright © 2017年 China Zhou. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^EditorPlaceBlock)(void);
typedef void(^DelectPlaceBlock)(void);
typedef void(^SetDefaultBlock)(void);
@interface JNSYReceivePlaceTableViewCell : UITableViewCell

@property (nonatomic, strong)UILabel *NameLab;
@property (nonatomic, strong)UILabel *PlaceLab;
@property (nonatomic, strong)UILabel *PhoneLab;
@property (nonatomic, strong)UIButton *SetDefaultBtn;
@property (nonatomic, strong)UILabel *DefaultLab;

@property (nonatomic, strong)UIImageView *BottomLine;

@property (nonatomic, copy)EditorPlaceBlock editorPlaceBlock;
@property (nonatomic, copy)DelectPlaceBlock delectPlaceBlock;
@property (nonatomic, copy)SetDefaultBlock setDefaultBlock;
@end
