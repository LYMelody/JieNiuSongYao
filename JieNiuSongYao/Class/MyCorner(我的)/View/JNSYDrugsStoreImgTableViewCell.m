//
//  JNSYDrugsStoreImgTableViewCell.m
//  JieNiuSongYao
//
//  Created by rongfeng on 2017/5/11.
//  Copyright © 2017年 China Zhou. All rights reserved.
//

#import "JNSYDrugsStoreImgTableViewCell.h"
#import "Common.h"
#import "Masonry.h"

@interface JNSYDrugsStoreImgTableViewCell()

@property (nonatomic, strong)UIButton *SelectFileBtn;
@property (nonatomic, strong)UIButton *PreWatchBtn;


@end


@implementation JNSYDrugsStoreImgTableViewCell

- (instancetype)init {
    
    if ([super init]) {
        [self SetUpViews];
    }
    
    return self;
}


- (void)SetUpViews {
    
    _StoreImgView = [[UIImageView alloc] init];
    _StoreImgView.backgroundColor = [UIColor grayColor];
    [self.contentView addSubview:_StoreImgView];
    
    _SelectFileBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [_SelectFileBtn setTitle:@"选择文件" forState:UIControlStateNormal];
    _SelectFileBtn.titleLabel.font = [UIFont systemFontOfSize:10];
    [_SelectFileBtn setBackgroundColor:ColorTabBarback];
    [_SelectFileBtn addTarget:self action:@selector(SelectFileBtnAction) forControlEvents:UIControlEventTouchUpInside];
    [self.contentView addSubview:_SelectFileBtn];
    
    _PreWatchBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [_PreWatchBtn setTitle:@"预览" forState:UIControlStateNormal];
    _PreWatchBtn.titleLabel.font = [UIFont systemFontOfSize:10];
    [_PreWatchBtn setBackgroundColor:ColorTabBarback];
    [_PreWatchBtn addTarget:self action:@selector(PreWatchBtnAction) forControlEvents:UIControlEventTouchUpInside];
    [self.contentView addSubview:_PreWatchBtn];
    
}

- (void)SelectFileBtnAction {
    
    if (_selectPictureBlock) {
        _selectPictureBlock();
    }
    
    
}

- (void)PreWatchBtnAction {
    
    if (_mangifyBlock) {
        _mangifyBlock(_StoreImgView);
    }
    
}


- (void)layoutSubviews {
    
    [super layoutSubviews];
    
    [_StoreImgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.bottom.equalTo(self).with.insets(UIEdgeInsetsMake(5, 20, 30, 20));
        
    }];
    
    [_SelectFileBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(_StoreImgView);
        make.top.equalTo(_StoreImgView.mas_bottom).offset(2);
        make.width.mas_equalTo(60);
        make.height.mas_equalTo(20);
        
    }];
    
    [_PreWatchBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(_SelectFileBtn.mas_left).offset(-5);
        make.top.equalTo(_SelectFileBtn);
        make.width.mas_equalTo(40);
        make.height.mas_equalTo(20);
    }];
    
}
@end
