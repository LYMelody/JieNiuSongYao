//
//  JNSYLabsTableViewCell.m
//  JieNiuSongYao
//
//  Created by rongfeng on 2017/6/7.
//  Copyright © 2017年 China Zhou. All rights reserved.
//

#import "JNSYLabsTableViewCell.h"

@implementation JNSYLabsTableViewCell


- (instancetype)init {
    
    
    if ([super init]) {
        [self setUpViews];
    }
    
    return self;
}


- (void)setUpViews {
    
    for(NSInteger i = 0;i < _TitleArray.count;i++) {
        
//        UILabel *lab = [[UILabel alloc] init];
//        lab.font = [UIFont systemFontOfSize:13];
//        lab.
        
    }
    
    
    
}

- (void)layoutSubviews {
    
    [super layoutSubviews];
    
}

- (void)setTitleArray:(NSArray *)TitleArray {
    
    _TitleArray = TitleArray;
    
    
}

@end
