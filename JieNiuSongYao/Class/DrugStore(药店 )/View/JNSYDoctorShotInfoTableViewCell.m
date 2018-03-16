//
//  JNSYDoctorShotInfoTableViewCell.m
//  JieNiuSongYao
//
//  Created by rongfeng on 2017/6/8.
//  Copyright © 2017年 China Zhou. All rights reserved.
//

#import "JNSYDoctorShotInfoTableViewCell.h"
#import "Common.h"
#import "Masonry.h"
#import "JNSYAutoSize.h"

@implementation JNSYDoctorShotInfoTableViewCell

- (instancetype)init {
    
    if ([super init]) {
        [self setUpViews];
    }
    return self;
    
}


- (void)setUpViews {
    
    _TopLab = [[UILabel alloc] init];
    _TopLab.font = [UIFont systemFontOfSize:14];
    _TopLab.textAlignment = NSTextAlignmentLeft;
    _TopLab.textColor = ColorText;
    
    [self.contentView addSubview:_TopLab];
    
    _InfoTextView = [[UITextView alloc] init];
    _InfoTextView.textColor = ColorText;
    _InfoTextView.font = [UIFont systemFontOfSize:13];
    _InfoTextView.editable = NO;
    _InfoTextView.showsVerticalScrollIndicator = NO;
    _InfoTextView.scrollEnabled = NO;
    [self.contentView addSubview:_InfoTextView];
    
}

- (void)layoutSubviews {
    
    [super layoutSubviews];
    
    CGFloat height = [self heightForString:_InfoTextView.text Width:(KscreenWidth - 40)];
    
    [_TopLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self).offset([JNSYAutoSize AutoHeight:10]);
        make.left.equalTo(self).offset(20);
        make.height.mas_equalTo([JNSYAutoSize AutoHeight:20]);
        make.width.mas_equalTo(KscreenWidth - 100);
    }];
    
    [_InfoTextView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_TopLab.mas_bottom).offset([JNSYAutoSize AutoHeight:2]);
        make.left.equalTo(_TopLab);
        make.height.mas_equalTo([JNSYAutoSize AutoHeight:height]);
        make.right.equalTo(self).offset(-20);
    }];
    
}

- (float)heightForString:(NSString *)str Width:(CGFloat)width {
    
    NSMutableParagraphStyle *style = [[NSMutableParagraphStyle alloc] init];
    [style setLineSpacing:2.0];
    
    NSDictionary *dic = @{
                          NSFontAttributeName:[UIFont systemFontOfSize:13],
                          NSParagraphStyleAttributeName:style
                          };
    //计算文本大小
    CGSize size = [str boundingRectWithSize:CGSizeMake(width, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading attributes:dic context:nil].size;
    //NSLog(@"%f",size.height);
    //
    return size.height + [JNSYAutoSize AutoHeight:10];
    
}


@end
