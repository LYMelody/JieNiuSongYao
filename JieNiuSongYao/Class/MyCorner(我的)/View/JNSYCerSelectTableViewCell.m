//
//  JNSYCerSelectTableViewCell.m
//  JieNiuSongYao
//
//  Created by rongfeng on 2017/5/11.
//  Copyright © 2017年 China Zhou. All rights reserved.
//

#import "JNSYCerSelectTableViewCell.h"
#import "Common.h"
#import "Masonry.h"

@interface JNSYCerSelectTableViewCell()

@property (nonatomic, strong)UILabel *leftLab;

@property (nonatomic, strong)UILabel *YesLab;
@property (nonatomic, strong)UILabel *NoLab;
@property (nonatomic, strong)UIImageView *BottomLine;

@end


@implementation JNSYCerSelectTableViewCell

- (instancetype)init {
    
    if ([super init]) {
        [self SetUpViews];
    }
    return self;
}

- (void)SetUpViews {
    
    _leftLab = [[UILabel alloc] init];
    _leftLab.textColor = ColorTabBarback;
    _leftLab.font = [UIFont systemFontOfSize:13];
    _leftLab.text = @"五证合一";
    _leftLab.textAlignment = NSTextAlignmentLeft;
    [self.contentView addSubview:_leftLab];
    
    [self.contentView addSubview:self.BtnOne];
    
    [self.contentView addSubview:self.BtnTwo];
    
    _YesLab = [[UILabel alloc] init];
    _YesLab.textAlignment = NSTextAlignmentLeft;
    _YesLab.text = @"是";
    _YesLab.font = [UIFont systemFontOfSize:13];
    _YesLab.textColor = ColorText;
    [self.contentView addSubview:_YesLab];
    
    _NoLab = [[UILabel alloc] init];
    _NoLab.textAlignment = NSTextAlignmentLeft;
    _NoLab.text = @"否";
    _NoLab.font = [UIFont systemFontOfSize:13];
    _NoLab.textColor = ColorText;
    [self.contentView addSubview:_NoLab];
    
    _BottomLine = [[UIImageView alloc] init];
    _BottomLine.backgroundColor = ColorTableViewCellSeparate;
    [self.contentView addSubview:_BottomLine];
    
}

- (UIButton *)BtnOne {
    
    
    if (_BtnOne == nil) {
        _BtnOne = [UIButton buttonWithType:UIButtonTypeCustom];
        [_BtnOne setBackgroundImage:[UIImage imageNamed:@"Select-NO.png"] forState:UIControlStateNormal];
        [_BtnOne setBackgroundImage:[UIImage imageNamed:@"Select-Yes.png"] forState:UIControlStateSelected];
        
        [_BtnOne addTarget:self action:@selector(BtnOneAction) forControlEvents:UIControlEventTouchUpInside];
    }
    
    return _BtnOne;
}

- (UIButton *)BtnTwo {
    
    if (_BtnTwo == nil) {
        _BtnTwo = [UIButton buttonWithType:UIButtonTypeCustom];
        [_BtnTwo setBackgroundImage:[UIImage imageNamed:@"Select-NO.png"] forState:UIControlStateNormal];
        [_BtnTwo setBackgroundImage:[UIImage imageNamed:@"Select-Yes.png"] forState:UIControlStateSelected];
        
        [_BtnTwo addTarget:self action:@selector(BtnTwoAction) forControlEvents:UIControlEventTouchUpInside];
    }
    return _BtnTwo;
}

- (void)BtnOneAction {
    
    NSLog(@"sdfsd");
    
    
    if (_BtnOne.selected) {
        
    }else {
        _BtnOne.selected = !_BtnOne.selected;
        _BtnTwo.selected = !_BtnTwo.selected;
        
        if (_changeStatusYesBlock) {
            _changeStatusYesBlock(_BtnOne.selected);
        }
    }
}

- (void)BtnTwoAction {
    
    NSLog(@"asdasd");
    if (_BtnTwo.selected) {
        
        
    }else {
        _BtnTwo.selected = !_BtnTwo.selected;
        _BtnOne.selected = !_BtnOne.selected;
        if (_changeStatusNoBlock) {
            _changeStatusNoBlock(_BtnTwo.selected);
        }
    }
    
}

- (void)layoutSubviews {
    
    [super layoutSubviews];
    
    [_leftLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.bottom.equalTo(self);
        make.left.equalTo(self).offset(20);
        make.width.mas_equalTo(80);
    }];
    
    [_BtnOne mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self);
        make.left.equalTo(_leftLab.mas_right).offset(10);
        make.width.height.mas_equalTo(30);
    }];
    
    [_YesLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self);
        make.left.equalTo(_BtnOne.mas_right);
        make.width.mas_equalTo(15);
        make.height.mas_equalTo(10);
    }];
    
    
    [_BtnTwo mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self);
        make.left.equalTo(_YesLab.mas_right).offset(30);
        make.width.height.mas_equalTo(30);
    }];
    
    [_NoLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self);
        make.left.equalTo(_BtnTwo.mas_right);
        make.width.mas_equalTo(15);
        make.height.mas_equalTo(10);
    }];
    
    [_BottomLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.left.right.equalTo(self);
        make.height.mas_equalTo(0.5);
    }];
    
}

@end
