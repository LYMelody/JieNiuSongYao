//
//  JNShopCarCountView.m
//  购物车
//
//  Created by rongfeng on 2017/5/2.
//  Copyright © 2017年 China Zhou. All rights reserved.
//

#import "JNShopCarCountView.h"
#import "Masonry.h"

@interface JNShopCarCountView()<UITextFieldDelegate>

@property(nonatomic,strong)UIButton *increaseBtn;
@property(nonatomic,strong)UIButton *decreaseBtn;
//@property(nonatomic,strong)UITextField *editTextField;

@end


@implementation JNShopCarCountView


- (instancetype)init {
    if (self = [super init]) {
        [self setUpViews];
    }
    return self;
}

- (void)setUpViews {
    
    [self addSubview:self.increaseBtn];
    [self addSubview:self.decreaseBtn];
    [self addSubview:self.editTextField];
    
}

- (void)configureShopCarCountViewWithProductCount:(NSInteger)productCount productStock:(NSInteger)productStock{
    
    if (productCount == 1) {
        self.decreaseBtn.enabled = NO;
        self.increaseBtn.enabled = YES;
    }else if (productCount == productStock){
        self.decreaseBtn.enabled = YES;
        self.increaseBtn.enabled = NO;
    }else {
        self.decreaseBtn.enabled = YES;
        self.increaseBtn.enabled = YES;
    }
    
    self.editTextField.text = [NSString stringWithFormat:@"%ld",productCount];
    
}

-(void)increaseBtnAction {
    
    //路威，安德森，莱昂纳德，哈登，贝弗利，加索尔，阿德，戈登，米尔斯，堪培拉，吉诺比利，阿里扎，
    /*
     
     2017.5.4 周四  马刺VS火箭
       第四节： 6:13  106-88
     孤鸿寡鹄
     奥术大师
     色风格啊
     阿斯蒂芬
     阿士大夫
     阿斯蒂芬
     萨芬无法
     */
    
    NSInteger count = self.editTextField.text.integerValue;
    if (self.shopCarCountViewEditBlock) {
        self.shopCarCountViewEditBlock(++ count);
    }
    
    
}

- (void)decreaseBtnAction {
    
    NSInteger count = self.editTextField.text.integerValue;
    if (self.shopCarCountViewEditBlock) {
        self.shopCarCountViewEditBlock(-- count);
    }
    
}

- (void)textFieldDidEndEditing:(UITextField *)textField {
    
    if (self.shopCarCountViewEditBlock) {
        self.shopCarCountViewEditBlock(textField.text.integerValue);
    }
    
}

- (UITextField *)editTextField {
    
    if (_editTextField == nil) {
        _editTextField = [[UITextField alloc] init];
        _editTextField.textAlignment = NSTextAlignmentCenter;
        _editTextField.keyboardType = UIKeyboardTypeNumberPad;
        _editTextField.clipsToBounds = YES;
        _editTextField.layer.borderColor = [UIColor colorWithRed:0.776 green:0.780 blue:0.789 alpha:1].CGColor;
        _editTextField.layer.borderWidth = 0.5;
        _editTextField.delegate = self;
        _editTextField.font = [UIFont systemFontOfSize:13];
        _editTextField.backgroundColor = [UIColor whiteColor];
    }
    
    return _editTextField;
}

- (UIButton *)increaseBtn {
    
    if (_increaseBtn == nil) {
        _increaseBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_increaseBtn setBackgroundImage:[UIImage imageNamed:@"product_detail_add_normal"] forState:UIControlStateNormal];
        [_increaseBtn setBackgroundImage:[UIImage imageNamed:@"product_detail_add_no"] forState:UIControlStateDisabled];
        [_increaseBtn addTarget:self action:@selector(increaseBtnAction) forControlEvents:UIControlEventTouchUpInside];
    }
    
    return _increaseBtn;
}

- (UIButton *)decreaseBtn {
    
    if (_decreaseBtn == nil) {
        _decreaseBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_decreaseBtn setBackgroundImage:[UIImage imageNamed:@"product_detail_sub_normal"] forState:UIControlStateNormal];
        [_decreaseBtn setBackgroundImage:[UIImage imageNamed:@"product_detail_sub_no"] forState:UIControlStateDisabled];
        [_decreaseBtn addTarget:self action:@selector(decreaseBtnAction) forControlEvents:UIControlEventTouchUpInside];
        
    }
    
    return _decreaseBtn;
}

- (void)layoutSubviews {
    
    [super layoutSubviews];
    
    [self.decreaseBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.bottom.equalTo(self);
        make.width.equalTo(self.mas_height);
    }];
    
    [self.increaseBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.right.bottom.equalTo(self);
        make.width.equalTo(self.mas_height);
    }];
    
    [self.editTextField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.bottom.equalTo(self);
        make.left.equalTo(self.decreaseBtn.mas_right);
        make.right.equalTo(self.increaseBtn.mas_left);
    }];
    
}

@end
