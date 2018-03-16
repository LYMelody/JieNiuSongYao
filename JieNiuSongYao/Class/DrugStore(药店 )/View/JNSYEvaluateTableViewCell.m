//
//  JNSYEvaluateTableViewCell.m
//  JieNiuSongYao
//
//  Created by rongfeng on 2017/6/5.
//  Copyright © 2017年 China Zhou. All rights reserved.
//

#import "JNSYEvaluateTableViewCell.h"
#import "Common.h"
#import "Masonry.h"
#import "JNSYAutoSize.h"
#import "StarView.h"

@implementation JNSYEvaluateTableViewCell

- (instancetype)init {
    
    if ([super init]) {
        _cellheight = 120;
        [self setUpViews];
    }
    return self;
}

- (void)setUpViews {
    
    _HeaderLineImg = [[UIImageView alloc] init];
    _HeaderLineImg.backgroundColor = ColorTableBack;
    
    [self.contentView addSubview:_HeaderLineImg];
    
    _UserHeaderImg = [[UIImageView alloc] init];
    _UserHeaderImg.backgroundColor = [UIColor redColor];
    _UserHeaderImg.layer.cornerRadius = 3;
    _UserHeaderImg.layer.masksToBounds = YES;
    [self.contentView addSubview:_UserHeaderImg];
    
    _UserNameLab = [[UILabel alloc] init];
    _UserNameLab.font = [UIFont systemFontOfSize:13];
    _UserNameLab.textColor = [UIColor blackColor];
    _UserNameLab.textAlignment = NSTextAlignmentLeft;
    
    [self.contentView addSubview:_UserNameLab];
    
    _RatingStarView = [[StarView alloc] initWithFrame:CGRectMake(0, 0, 85, [JNSYAutoSize AutoHeight:15])];
    //_RatingStarView.backgroundColor = [UIColor grayColor];
    [self.contentView addSubview:_RatingStarView];
    
    _RatingLab = [[UILabel alloc] init];
    _RatingLab.font = [UIFont systemFontOfSize:13];
    _RatingLab.textAlignment = NSTextAlignmentLeft;
    _RatingLab.textColor = [UIColor blackColor];
    [self.contentView addSubview:_RatingLab];
    
    _Commenttext = [[UITextView alloc] init];
    //_Commenttext.backgroundColor = [UIColor blueColor];
    _Commenttext.font = [UIFont systemFontOfSize:13];
    _Commenttext.textAlignment = NSTextAlignmentLeft;
    _Commenttext.textColor = ColorText;
    _Commenttext.editable = NO;
    _Commenttext.scrollEnabled = NO;
    _Commenttext.showsVerticalScrollIndicator = NO;
    _Commenttext.userInteractionEnabled = NO;
    _Commenttext.contentInset = UIEdgeInsetsMake(0, 0, 0, 0);
    [self.contentView addSubview:_Commenttext];
    
    _ReplyBackImg = [[UIImageView alloc] init];
    //_ReplyBackImg.backgroundColor = [UIColor orangeColor];
    _ReplyBackImg.layer.cornerRadius = 3;
    _ReplyBackImg.layer.masksToBounds = YES;
    [self.contentView addSubview:_ReplyBackImg];
    
    _ReplyContentText = [[UITextView alloc] init];
    _ReplyContentText.textColor = [UIColor blackColor];
    _ReplyContentText.textAlignment = NSTextAlignmentLeft;
    _ReplyContentText.font = [UIFont systemFontOfSize:13];
    _ReplyContentText.layer.cornerRadius = 3;
    _ReplyContentText.layer.masksToBounds = YES;
    //_ReplyContentText.backgroundColor = [UIColor redColor];
    _ReplyContentText.editable = NO;
    _ReplyContentText.showsVerticalScrollIndicator = NO;
    _ReplyContentText.contentInset = UIEdgeInsetsMake(0, 0, 0, 0);
    [_ReplyBackImg addSubview:_ReplyContentText];
    
    _ReplyTimeLab = [[UILabel alloc] init];
    _ReplyTimeLab.textAlignment = NSTextAlignmentLeft;
    _ReplyTimeLab.textColor = ColorText;
    _ReplyTimeLab.font = [UIFont systemFontOfSize:11];
    [_ReplyBackImg addSubview:_ReplyTimeLab];
    
    _CommentTimeLab = [[UILabel alloc] init];
    _CommentTimeLab.textAlignment = NSTextAlignmentLeft;
    _CommentTimeLab.textColor = ColorText;
    _CommentTimeLab.font = [UIFont systemFontOfSize:13];
    [self.contentView addSubview:_CommentTimeLab];
    
}

- (void)setCommentModel:(CommentModel *)commentModel {
    
    _commentModel = commentModel;
    
    [self layoutIfNeeded];
    
}

- (void)setcellheight:(float)height {
    
    CGRect rect = self.frame;
    rect.size.height = height;
    
    self.frame = rect;
    
}

- (void)layoutSubviews {
    
    [super layoutSubviews];
    
    
    _UserNameLab.text = _commentModel.UserNameStr;
    _RatingLab.text = [NSString stringWithFormat:@"%@分",_commentModel.Rating];
    _Commenttext.text = _commentModel.CommentStr;
    _ReplyContentText.text = [NSString stringWithFormat:@"药店回复：%@",_commentModel.ReplyCommentStr];
    _ReplyTimeLab.text = _commentModel.ReplyCommentTimeStr;
    _RatingStarView.rating = [_commentModel.Rating floatValue];
    _CommentTimeLab.text = @"2017-6-6 10:44:23";
    //计算文本高度
    
    float commentHeight = [self heightForStr:_Commenttext Width:(KscreenWidth - 65)];
    
    float replyHeight = [self heightForStr:_ReplyContentText Width:(KscreenWidth - 83)];
    
    //NSLog(@"%f,%f",commentHeight,replyHeight);
    
    if (_commentModel.ReplyCommentStr == nil || [_commentModel.ReplyCommentStr isEqualToString:@""]) {
        self.cellheight = [JNSYAutoSize AutoHeight:60] + commentHeight;
        _ReplyBackImg.hidden = YES;
    }else {
        self.cellheight = [JNSYAutoSize AutoHeight:(60 + 12)] + commentHeight + replyHeight;
    }

    
    [_HeaderLineImg mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.equalTo(self);
        make.height.mas_equalTo([JNSYAutoSize AutoHeight:3]);
    }];
    
    [_UserHeaderImg mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self).offset(15);
        make.left.equalTo(self).offset(20);
        make.height.mas_equalTo([JNSYAutoSize AutoHeight:20]);
        make.width.mas_equalTo([JNSYAutoSize AutoHeight:20]);
    }];
    
    [_UserNameLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(_UserHeaderImg);
        make.left.equalTo(_UserHeaderImg.mas_right).offset(4);
        make.width.mas_equalTo(100);
        make.height.mas_equalTo(15);
    }];
    
    [_RatingStarView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_UserNameLab.mas_bottom).offset(3);
        make.left.equalTo(_UserNameLab);
        make.width.mas_equalTo(83);
        make.height.mas_equalTo([JNSYAutoSize AutoHeight:15]);
    }];
    
    [_RatingLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_RatingStarView);
        make.left.equalTo(_RatingStarView.mas_right).offset(10);
        make.height.mas_equalTo([JNSYAutoSize AutoHeight:15]);
        make.width.mas_equalTo(60);
    }];
    
    
    [_CommentTimeLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_UserHeaderImg).offset([JNSYAutoSize AutoHeight:5]);
        make.right.equalTo(self).offset(-10);
        make.width.mas_equalTo(120);
        make.height.mas_equalTo([JNSYAutoSize AutoHeight:15]);
    }];
    
    
    [_Commenttext mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_UserNameLab);
        make.top.equalTo(_RatingStarView.mas_bottom).offset(0);
        make.right.equalTo(self).offset(-10);
        make.height.mas_equalTo([JNSYAutoSize AutoHeight:(commentHeight)]);
    }];
    
    [_ReplyBackImg mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_UserHeaderImg);
        make.top.equalTo(_Commenttext.mas_bottom).offset([JNSYAutoSize AutoHeight:0]);
        make.right.equalTo(self).offset(-10);
        make.height.mas_equalTo([JNSYAutoSize AutoHeight:(replyHeight + 12)]);
    }];
    
    [_ReplyContentText mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_ReplyBackImg).offset(2);
        make.left.equalTo(_ReplyBackImg).offset(2);
        make.right.equalTo(self).offset(-20);
        make.height.mas_equalTo([JNSYAutoSize AutoHeight:replyHeight]);
    }];
    
    [_ReplyTimeLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_ReplyContentText.mas_bottom).offset(0);
        make.left.equalTo(_ReplyContentText).offset(2);
        make.height.mas_equalTo([JNSYAutoSize AutoHeight:10]);
        make.width.equalTo(_ReplyBackImg);
    }];
    
}

- (float)heightForStr:(UITextView *)textView Width:(float)width {
    
    CGSize sizetofit = [textView sizeThatFits:CGSizeMake(width, MAXFLOAT)];
    if (sizetofit.height < [JNSYAutoSize AutoHeight:30]) {
        return [JNSYAutoSize AutoHeight:30];
    }
    return sizetofit.height;
    
}


- (float)heightForString:(NSString *)str Width:(CGFloat)width {
    
    NSMutableParagraphStyle *style = [[NSMutableParagraphStyle alloc] init];
    [style setLineSpacing:2.0];
    
    NSDictionary *dic = @{
                          NSFontAttributeName:[UIFont systemFontOfSize:13],
                          NSParagraphStyleAttributeName:style
                          };
    //计算文本大小
    CGSize size = [str boundingRectWithSize:CGSizeMake(width -16, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading attributes:dic context:nil].size;
    NSLog(@"%f",size.height);
    //
    return size.height + [JNSYAutoSize AutoHeight:50];
    
}


- (void)changeheight {
    
    CGRect rect = self.frame;
    rect.size.height = _cellheight;
    
    self.frame = rect;
    
}




@end
