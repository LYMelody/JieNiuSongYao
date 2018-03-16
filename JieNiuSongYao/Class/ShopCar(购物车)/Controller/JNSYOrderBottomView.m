//
//  JNSYOrderBottomView.m
//  JieNiuSongYao
//
//  Created by rongfeng on 2017/6/16.
//  Copyright © 2017年 China Zhou. All rights reserved.
//

#import "JNSYOrderBottomView.h"
#import "Common.h"
#import "Masonry.h"

@implementation JNSYOrderBottomView


- (instancetype)init {
    
    if ([super init]) {
        [self setUpViews];
    }
    return self;
}


- (void)setUpViews{
    
    _totalPriceLab = [[UILabel alloc] init];
    _totalPriceLab.textColor = ColorText;
    _totalPriceLab.textAlignment = NSTextAlignmentLeft;
    _totalPriceLab.font = [UIFont systemFontOfSize:13];
    [self addSubview:_totalPriceLab];
    
    _scoreLab = [[UILabel alloc] init];
    _scoreLab.textColor = ColorText;
    _scoreLab.font = [UIFont systemFontOfSize:11];
    _scoreLab.textAlignment = NSTextAlignmentLeft;
    [self addSubview:_scoreLab];
    
    _commitBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [_commitBtn setBackgroundColor:[UIColor redColor]];
    [_commitBtn setTitle:@"提交订单" forState:UIControlStateNormal];
    _commitBtn.titleLabel.textColor = [UIColor whiteColor];
    _commitBtn.titleLabel.font = [UIFont systemFontOfSize:13];
    [_commitBtn addTarget:self action:@selector(commitBtnAction) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:_commitBtn];
    
    
}


- (void)configureTotalPrice:(NSString *)totalPrice score:(NSString *)score {
    

    NSMutableAttributedString *attributedStr = [[NSMutableAttributedString alloc] initWithString:totalPrice];
    [attributedStr addAttributes:@{
                                  NSForegroundColorAttributeName:[UIColor redColor],
                                  NSFontAttributeName:[UIFont systemFontOfSize:16]
                                  }range:NSMakeRange(3, totalPrice.length - 3)];
    _totalPriceLab.attributedText = attributedStr;
    
    _scoreLab.text = score;
}

- (void)configureTotalPrice:(NSString *)totalPrice {
    
    NSMutableAttributedString *attributedStr = [[NSMutableAttributedString alloc] initWithString:totalPrice];
    [attributedStr addAttributes:@{
                                   NSForegroundColorAttributeName:[UIColor redColor],
                                   NSFontAttributeName:[UIFont systemFontOfSize:16]
                                   }range:NSMakeRange(3, totalPrice.length - 3)];
    _totalPriceLab.attributedText = attributedStr;
    
}

- (void)commitBtnAction {
    
    NSLog(@"提交订单");
    
    if (_commitOrderBlock) {
        _commitOrderBlock();
    }
    
    
}

- (void)layoutSubviews {
    
    [super layoutSubviews];
    
    [_totalPriceLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self);
        make.left.equalTo(self).offset(20);
        make.height.equalTo(self);
        make.width.mas_equalTo(KscreenWidth/3.0 + 10);
    }];
    
    [_scoreLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self);
        make.left.equalTo(_totalPriceLab.mas_right);
        make.height.equalTo(self);
        make.width.mas_equalTo(KscreenWidth/4.0);
    }];
    
    [_commitBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.bottom.right.equalTo(self);
        make.width.mas_equalTo(KscreenWidth/4.0);
    }];
}




@end
