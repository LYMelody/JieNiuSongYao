//
//  JNSYSearchLabTableViewCell.h
//  JieNiuSongYao
//
//  Created by rongfeng on 2017/5/24.
//  Copyright © 2017年 China Zhou. All rights reserved.
//

#import <UIKit/UIKit.h>


typedef void(^LabClickBlcok)(NSString *text);


@interface JNSYSearchLabTableViewCell : UITableViewCell

@property (nonatomic,strong)NSMutableArray *titleArray;

@property (nonatomic,assign)CGFloat cellheight;

@property (nonatomic,copy)LabClickBlcok labClickBlock;


- (void)changeCellHeight;

- (void)setUpViews;

@end
