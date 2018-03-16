//
//  JNSYDoctorShotInfoTableViewCell.h
//  JieNiuSongYao
//
//  Created by rongfeng on 2017/6/8.
//  Copyright © 2017年 China Zhou. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface JNSYDoctorShotInfoTableViewCell : UITableViewCell

@property (nonatomic, strong)UILabel *TopLab;
@property (nonatomic, strong)UITextView *InfoTextView;


- (float)heightForString:(NSString *)str Width:(CGFloat)width;

@end
