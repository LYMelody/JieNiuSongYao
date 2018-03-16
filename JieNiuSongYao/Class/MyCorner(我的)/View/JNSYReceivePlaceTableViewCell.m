//
//  JNSYReceivePlaceTableViewCell.m
//  JieNiuSongYao
//
//  Created by rongfeng on 2017/5/16.
//  Copyright © 2017年 China Zhou. All rights reserved.
//

#import "JNSYReceivePlaceTableViewCell.h"
#import "Common.h"
#import "Masonry.h"

@interface JNSYReceivePlaceTableViewCell()

@property (nonatomic, strong)UIImageView *EditorBackImg;
@property (nonatomic, strong)UIImageView *EditorImg;
@property (nonatomic, strong)UILabel *EditorLab;

@property (nonatomic, strong)UIImageView *DelectBackImg;
@property (nonatomic, strong)UIImageView *DelectImg;
@property (nonatomic, strong)UILabel *DelectLab;

@property (nonatomic, strong)UITapGestureRecognizer *TapEditor;
@property (nonatomic, strong)UITapGestureRecognizer *TapDelect;
@end


@implementation JNSYReceivePlaceTableViewCell


- (instancetype)init {
    
    if ([super init]) {
        [self setUpViews];
    }
    return self;
}


- (void)setUpViews {
    
    _NameLab = [[UILabel alloc] init];
    _NameLab.font = [UIFont systemFontOfSize:15];
    _NameLab.textAlignment = NSTextAlignmentLeft;
    _NameLab.text = @"陈奕迅";
    [self.contentView addSubview:_NameLab];
    
    _PlaceLab = [[UILabel alloc] init];
    _PlaceLab.font = [UIFont systemFontOfSize:13];
    _PlaceLab.textColor = ColorText;
    _PlaceLab.textAlignment = NSTextAlignmentLeft;
    _PlaceLab.text = @"杭州市西湖区延安路001号";
    [self.contentView addSubview:_PlaceLab];
    
    _PhoneLab = [[UILabel alloc] init];
    _PhoneLab.font = [UIFont systemFontOfSize:15];
    _PhoneLab.textAlignment = NSTextAlignmentRight;
    _PhoneLab.text = @"188****8846";
    [self.contentView addSubview:_PhoneLab];
    
    _BottomLine = [[UIImageView alloc] init];
    _BottomLine.backgroundColor = ColorTableViewCellSeparate;
    
    [self.contentView addSubview:_BottomLine];
    
    _SetDefaultBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [_SetDefaultBtn setImage:[UIImage imageNamed:@"Unselected"] forState:UIControlStateNormal];
    [_SetDefaultBtn setImage:[UIImage imageNamed:@"Selected"] forState:UIControlStateSelected];
    [_SetDefaultBtn addTarget:self action:@selector(SelectAction) forControlEvents:UIControlEventTouchUpInside];
   // _SetDefaultBtn.backgroundColor = [UIColor redColor];
    //_SetDefaultBtn.imageEdgeInsets = UIEdgeInsetsMake(-5, 0, 0, 5);
    [self.contentView addSubview:_SetDefaultBtn];
    
    _DefaultLab = [[UILabel alloc] init];
    _DefaultLab.textColor = ColorText;
    _DefaultLab.font = [UIFont systemFontOfSize:13];
    _DefaultLab.textAlignment = NSTextAlignmentLeft;
    _DefaultLab.text = @"设置为默认地址";
    [self.contentView addSubview:_DefaultLab];
    
    
    
    
    //编辑
    _EditorBackImg = [[UIImageView alloc] init];
    _EditorBackImg.backgroundColor = [UIColor whiteColor];
    _EditorBackImg.userInteractionEnabled = YES;
    
    [self.contentView addSubview:_EditorBackImg];
    
    
    _EditorImg = [[UIImageView alloc] init];
    _EditorImg.userInteractionEnabled = YES;
    _EditorImg.image = [UIImage imageNamed:@"editor"];
    [_EditorBackImg addSubview:_EditorImg];
    
    _EditorLab = [[UILabel alloc] init];
    _EditorLab.textAlignment = NSTextAlignmentLeft;
    _EditorLab.textColor = ColorText;
    _EditorLab.font = [UIFont systemFontOfSize:13];
    _EditorLab.text = @"编辑";
    [_EditorBackImg addSubview:_EditorLab];
    
    
    //删除
    _DelectBackImg = [[UIImageView alloc] init];
    _DelectBackImg.backgroundColor = [UIColor whiteColor];
    _DelectBackImg.userInteractionEnabled = YES;
    [self.contentView addSubview:_DelectBackImg];
    
    _DelectImg = [[UIImageView alloc] init];
    _DelectImg.userInteractionEnabled = YES;
    _DelectImg.image = [UIImage imageNamed:@"Delect"];
    [_DelectBackImg addSubview:_DelectImg];
    
    _DelectLab = [[UILabel alloc] init];
    _DelectLab.textColor = ColorText;
    _DelectLab.text = @"删除";
    _DelectLab.font = [UIFont systemFontOfSize:13];
    _DelectLab.textAlignment = NSTextAlignmentLeft;
    
    [_DelectBackImg addSubview:_DelectLab];
    
    _TapEditor = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapEditorAction)];
    _TapEditor.numberOfTapsRequired = 1;
    
    [_EditorBackImg addGestureRecognizer:_TapEditor];
    
    _TapDelect = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(TapDelectAction)];
    _TapDelect.numberOfTapsRequired = 1;
    
    [_DelectBackImg addGestureRecognizer:_TapDelect];
    


    
}

//编辑
- (void)tapEditorAction {
    
    NSLog(@"编辑");
    if (_editorPlaceBlock) {
        _editorPlaceBlock();
    }
    
}

//删除
- (void)TapDelectAction {
    
    NSLog(@"删除");
    if (_delectPlaceBlock) {
        _delectPlaceBlock();
    }
    
}
//设置默认
- (void)SelectAction {
    
    if (_SetDefaultBtn.selected) {
        
    }else {
        _SetDefaultBtn.selected = !_SetDefaultBtn.isSelected;
    }
    
    if (self.setDefaultBlock) {
        self.setDefaultBlock();
    }
}

- (void)layoutSubviews {
    
    [super layoutSubviews];
    
    
    [_NameLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self).offset(5);
        make.left.equalTo(self).offset(16);
        make.width.mas_equalTo(100);
        make.height.mas_equalTo(30);
    }];
    
    [_PlaceLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_NameLab.mas_bottom);
        make.left.equalTo(self).offset(16);
        make.width.mas_equalTo(KscreenWidth - 16);
        make.height.mas_equalTo(20);
    }];
    
    [_PhoneLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self).offset(5);
        make.right.equalTo(self).offset(-16);
        make.width.mas_equalTo(100);
        make.height.mas_equalTo(30);
    }];
    
    [_BottomLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_PlaceLab.mas_bottom).offset(20);
        make.left.equalTo(self).offset(16);
        make.right.equalTo(self);
        make.height.mas_equalTo(0.5);
    }];
    
    [_SetDefaultBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_BottomLine.mas_bottom).offset(2);
        make.left.equalTo(self).offset(10);
        make.bottom.equalTo(self).offset(-3);
        make.width.mas_equalTo(25);
    }];
    
    [_DefaultLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_BottomLine.mas_bottom);
        make.left.equalTo(_SetDefaultBtn.mas_right).offset(10);
        make.bottom.equalTo(self);
        make.width.mas_equalTo(100);
    }];
    
    
    
    [_DelectBackImg mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_BottomLine.mas_bottom);
        make.bottom.equalTo(self);
        make.right.equalTo(self).offset(-5);
        make.width.mas_equalTo(60);
        
    }];
    
    [_DelectLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.bottom.equalTo(_DelectBackImg);
        make.right.equalTo(_DelectBackImg);
        make.width.mas_equalTo(40);
    }];
    
    
    [_DelectImg mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_DelectBackImg).offset(7);
        make.bottom.equalTo(_DelectBackImg).offset(-7);
        make.right.equalTo(_DelectLab.mas_left).offset(-3);
        make.width.mas_equalTo(13);
    }];
    
    
    [_EditorBackImg mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_BottomLine.mas_bottom);
        make.bottom.equalTo(self);
        make.right.equalTo(_DelectBackImg.mas_left).offset(8);
        make.width.mas_equalTo(60);
        
    }];
    
    [_EditorLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.bottom.equalTo(_EditorBackImg);
        make.right.equalTo(_EditorBackImg);
        make.width.mas_equalTo(40);
    }];
    
    [_EditorImg mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_EditorBackImg).offset(7);
        make.bottom.equalTo(_EditorBackImg).offset(-7);
        make.right.equalTo(_EditorLab.mas_left).offset(-3);
        make.width.mas_equalTo(15);
    }];
    
    
    
}


@end
