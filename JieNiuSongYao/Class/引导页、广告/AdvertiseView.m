//
//  AdvertiseView.m
//  JieNiuSongYao
//
//  Created by rongfeng on 2017/7/28.
//  Copyright © 2017年 China Zhou. All rights reserved.
//

#import "AdvertiseView.h"
#import "Common.h"

@interface AdvertiseView()

@property(nonatomic, strong)UIImageView *adView;

@property(nonatomic, strong)UIButton *slipBtn;

@property(nonatomic, strong)NSTimer *countTimer;

@property(nonatomic, assign)int count;

@end

// 广告显示的时间
static int const showtime = 3;

@implementation AdvertiseView

- (instancetype)initWithFrame:(CGRect)frame {
    
    if ([super initWithFrame:frame]) {
        
        //创建广告图
        _adView = [[UIImageView alloc] initWithFrame:frame];
        _adView.userInteractionEnabled = YES;
        _adView.contentMode = UIViewContentModeScaleAspectFill;
        _adView.clipsToBounds = YES;
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(pushtoAD)];
        tap.numberOfTapsRequired = 1;
        [_adView addGestureRecognizer:tap];
        
        //创建跳过按钮
        CGFloat btnW = 60;
        CGFloat btnH = 30;
        _slipBtn = [[UIButton alloc] initWithFrame:CGRectMake(KscreenWidth - btnW - 24, btnH, btnW, btnH)];
        [_slipBtn addTarget:self action:@selector(dismiss) forControlEvents:UIControlEventTouchUpInside];
        [_slipBtn setTitle:[NSString stringWithFormat:@"跳过%d",showtime] forState:UIControlStateNormal];
        _slipBtn.titleLabel.font = [UIFont systemFontOfSize:15];
        [_slipBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        _slipBtn.backgroundColor = [UIColor colorWithRed:38/255.0 green:38/255.0 blue:38/255.0 alpha:0.6];
        _slipBtn.layer.cornerRadius = 4;
        _slipBtn.layer.masksToBounds = YES;
        [self addSubview:_adView];
        [self addSubview:_slipBtn];
        
    }
    
    return self;
    
}

- (NSTimer *)countTimer {
    
    if (!_countTimer) {
        _countTimer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(countDown) userInfo:nil repeats:YES];
    }
    
    return _countTimer;
}


- (void)countDown {
    
    _count --;
    
    if (_count < 0) {
        
        [self dismiss];
        return;
    }
    
    [_slipBtn setTitle:[NSString stringWithFormat:@"跳过%d",_count] forState:UIControlStateNormal];
    
}

//点击图片跳转广告
- (void)pushtoAD {
    
    [self dismiss];
    
    [[NSNotificationCenter defaultCenter] postNotificationName:@"pushtoAd" object:nil];
    
}
//点击跳过按钮
- (void)dismiss {
    
    
    [_countTimer invalidate];
    self.countTimer = nil;
    
    [UIView animateWithDuration:0.3 animations:^{
        self.alpha = 0;
    } completion:^(BOOL finished) {
        
        [[UIApplication sharedApplication] setStatusBarHidden:NO];
        
        [self removeFromSuperview];
    }];
    
}

- (void)startTimer {
    
    _count = showtime;
    
    [[NSRunLoop mainRunLoop] addTimer:self.countTimer forMode:NSRunLoopCommonModes];
    
    
}
//展示广告

- (void)show {
    
    [self startTimer];
    
    UIWindow *window = [UIApplication sharedApplication].keyWindow;
    
    [window addSubview:self];
    
    
}

- (void)setFilePath:(NSString *)filePath {
    
    _filePath = filePath;
    
    _adView.image = [UIImage imageWithContentsOfFile:filePath];
    
}



@end
