//
//  JNSYOrderPayMethodTableViewCell.m
//  JieNiuSongYao
//
//  Created by rongfeng on 2017/6/16.
//  Copyright © 2017年 China Zhou. All rights reserved.
//

#import "JNSYOrderPayMethodTableViewCell.h"
#import "Common.h"
#import "Masonry.h"

@implementation JNSYOrderPayMethodTableViewCell


- (instancetype)init {
    
    if ([super init]) {
        [self setUpViews];
    }
    return self;
}


- (void)setUpViews{
    
    _selectBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [_selectBtn setImage:[UIImage imageNamed:@"送药方式-未选取"] forState:UIControlStateNormal];
    [_selectBtn setImage:[UIImage imageNamed:@"送药方式-选取"] forState:UIControlStateSelected];
    [_selectBtn addTarget:self action:@selector(selectBtnAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.contentView addSubview:_selectBtn];
    
    _leftLab = [[UILabel alloc] init];
    _leftLab.font = [UIFont systemFontOfSize:14];
    _leftLab.textColor = [UIColor blackColor];
    _leftLab.textAlignment = NSTextAlignmentLeft;
    [self.contentView addSubview:_leftLab];
    
    _rightLab = [[UILabel alloc] init];
    _rightLab.font = [UIFont systemFontOfSize:11];
    _rightLab.textAlignment = NSTextAlignmentLeft;
    _rightLab.textColor = ColorText;
    [self.contentView addSubview:_rightLab];
    
    _lineView = [[UIView alloc] init];
    _lineView.backgroundColor = ColorTableViewCellSeparate;
    [self.contentView addSubview:_lineView];
    
    
}

- (void)selectBtnAction:(UIButton *)sender {
    
    if (sender.isSelected) {
        
    }else {
        sender.selected = !sender.selected;
    }
    
    if (_payMedthodSelectBlock) {
        _payMedthodSelectBlock();
    }
    
}


- (void)layoutSubviews {
    
    [super layoutSubviews];
    
    CGFloat width = [self getWidthWithTitle:_leftLab.text font:[UIFont systemFontOfSize:14]];
    
    [_selectBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self);
        make.left.equalTo(self).offset(16);
        make.size.mas_equalTo(CGSizeMake(30, 30));
    }];
    
    [_leftLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self);
        make.left.equalTo(_selectBtn.mas_right).offset(0);
        make.height.equalTo(self);
        make.width.mas_equalTo(width);
    }];
    
    [_rightLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self);
        make.left.equalTo(_leftLab.mas_right).offset(5);
        make.height.equalTo(self);
        make.height.mas_equalTo(100);
    }];
    
    [_lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.equalTo(self);
        make.height.mas_equalTo(0.5);
    }];
    
}

- (CGFloat)getWidthWithTitle:(NSString *)title font:(UIFont *)font {
    
    title = [title stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    
    if (title.length == 0 || title == nil || [title isEqualToString:@""]) {
        return 0;
    }
    
    NSDictionary *attribute = @{NSFontAttributeName:font};
    
    CGRect newRect = [title boundingRectWithSize:CGSizeMake(CGFLOAT_MAX, font.pointSize) options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading attributes:attribute context:nil];
    
    title = nil;
    return newRect.size.width + 10;
    
    
}



@end
