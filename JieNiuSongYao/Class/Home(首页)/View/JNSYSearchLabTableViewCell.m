//
//  JNSYSearchLabTableViewCell.m
//  JieNiuSongYao
//
//  Created by rongfeng on 2017/5/24.
//  Copyright © 2017年 China Zhou. All rights reserved.
//

#import "JNSYSearchLabTableViewCell.h"
#import "Common.h"
#import "Masonry.h"

@implementation JNSYSearchLabTableViewCell


- (instancetype)init {
    
    if ([super init]) {
        
        NSArray *array = @[@"清热解毒",@"感冒",@"板蓝根",@"兴业银行葵花药业"];
        _titleArray = [[NSMutableArray alloc] initWithArray:array];
        _cellheight = 80;
        self.backgroundColor = ColorTableBack;
        //[self setUpViews];
    }
    
    return self;
}

- (void)setUpViews {
    
    CGFloat labelWidth = 20;
    CGFloat labelHeight = 12;
    int rowHeight = 0;
    
    
    for(NSInteger i = 0; i < _titleArray.count;i++) {
        
        
        CGFloat width = [self getWidthWithTitle:_titleArray[i] font:[UIFont systemFontOfSize:13]];
        if (labelWidth + width + 10 > KscreenWidth) {
            rowHeight++;
            labelWidth = 20;
            labelHeight = labelHeight + 40 ;
        }
        
        
        UILabel *rectangleLab = [[UILabel alloc] init];
        rectangleLab.userInteractionEnabled = YES;
        rectangleLab.textColor = ColorTabBarback;
        rectangleLab.font = [UIFont systemFontOfSize:13];
        rectangleLab.text = _titleArray[i];
        rectangleLab.textAlignment = NSTextAlignmentCenter;
        rectangleLab.layer.cornerRadius = 5;
        rectangleLab.layer.masksToBounds = YES;
        rectangleLab.layer.borderColor = [UIColor grayColor].CGColor;
        rectangleLab.layer.borderWidth = 0.5;
        rectangleLab.backgroundColor = [UIColor whiteColor];
        [rectangleLab addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tagDidClick:)]];
        
        rectangleLab.frame = CGRectMake(labelWidth, labelHeight, width, 23);
        
        [self.contentView addSubview:rectangleLab];
        
        labelWidth = labelWidth + 6 + width;
        
    }
    
    _cellheight = rowHeight * 40 + 60;
    
    
}

- (void)tagDidClick:(UITapGestureRecognizer *)sender {
    
    UILabel *label = (UILabel *)sender.view;
    
    if (self.labClickBlock) {
        _labClickBlock(label.text);
    }
    
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


- (void)changeCellHeight {
    
    CGRect frame = self.frame;
    
    frame.size.height = _cellheight;
    
    self.frame = frame;
    
}


@end
