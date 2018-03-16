//
//  JNSYEvaluateTableViewCell.h
//  JieNiuSongYao
//
//  Created by rongfeng on 2017/6/5.
//  Copyright © 2017年 China Zhou. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CommentModel.h"
#import "StarView.h"
@interface JNSYEvaluateTableViewCell : UITableViewCell

@property (nonatomic, strong)UIImageView *UserHeaderImg;
@property (nonatomic, strong)UILabel *UserNameLab;
@property (nonatomic, strong)StarView *RatingStarView;
@property (nonatomic, strong)UILabel *RatingLab;
@property (nonatomic, strong)UITextView *Commenttext;
@property (nonatomic, strong)UIImageView *ReplyBackImg;
@property (nonatomic, strong)UITextView *ReplyContentText;
@property (nonatomic, strong)UILabel *ReplyTimeLab;
@property (nonatomic, strong)UILabel *CommentTimeLab;
@property (nonatomic, strong)UIImageView *HeaderLineImg;
@property (nonatomic, strong)UILabel *ReplyLab;
@property (nonatomic, strong)CommentModel *commentModel;

@property (nonatomic, assign)float cellheight;

- (float)heightForString:(NSString *)str Width:(CGFloat)width;

- (void)changeheight;

- (float)heightForStr:(UITextView *)textView Width:(float)width;

@end
