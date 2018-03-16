//
//  JNSYJiFenDetailTableViewCell.m
//  JieNiuSongYao
//
//  Created by rongfeng on 2017/5/19.
//  Copyright © 2017年 China Zhou. All rights reserved.
//

#import "JNSYJiFenDetailTableViewCell.h"
#import "Common.h"
#import "Masonry.h"

@implementation JNSYJiFenDetailTableViewCell


- (instancetype)init {
    
    if ([super init]) {
        [self setUpViews];
    }
    return self;
}


- (void)setUpViews {
    
    [self.contentView addSubview:self.MesageLab];
    [self.contentView addSubview:self.timeLab];
    [self.contentView addSubview:self.ScoreLab];
    [self.contentView addSubview:self.bottomline];
}

- (void)layoutSubviews {
    
    [super layoutSubviews];
    
    [self.MesageLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self).offset(5);
        make.left.equalTo(self).offset(16);
        make.width.mas_equalTo(KscreenWidth - 60);
        make.height.mas_equalTo(20);
    }];
    
    [self.timeLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.MesageLab.mas_bottom);
        make.left.equalTo(self.MesageLab);
        make.width.mas_equalTo(200);
        make.height.mas_equalTo(13);
    }];
    
    [self.ScoreLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.bottom.equalTo(self);
        make.right.equalTo(self).offset(-16);
        make.width.mas_equalTo(40);
    }];
    
    [self.bottomline mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self);
        make.left.equalTo(self).offset(16);
        make.right.equalTo(self);
        make.height.mas_equalTo(0.5);
    }];
    
}

- (UILabel *)MesageLab {
    
    if (_MesageLab == nil) {
        _MesageLab = [[UILabel alloc] init];
        _MesageLab.textAlignment = NSTextAlignmentLeft;
        _MesageLab.font = [UIFont systemFontOfSize:13];
        _MesageLab.textColor = [UIColor blackColor];
    }
    return _MesageLab;
}

- (UILabel *)timeLab {
    
    if (_timeLab == nil) {
        _timeLab = [[UILabel alloc] init];
        _timeLab.textAlignment = NSTextAlignmentLeft;
        _timeLab.textColor = ColorText;
        _timeLab.font = [UIFont systemFontOfSize:11];
    }
    return _timeLab;
    
}

- (UILabel *)ScoreLab {
    
    if (_ScoreLab == nil) {
        _ScoreLab = [[UILabel alloc] init];
        _ScoreLab.textAlignment = NSTextAlignmentRight;
        _ScoreLab.textColor = [UIColor redColor];
        _ScoreLab.font = [UIFont systemFontOfSize:12];
    }
    return _ScoreLab;
    
}

- (UIImageView *)bottomline {
    
    if (_bottomline == nil) {
        _bottomline = [[UIImageView alloc] init];
        _bottomline.backgroundColor = ColorTableViewCellSeparate;
        
    }
    return _bottomline;
    
}
@end
