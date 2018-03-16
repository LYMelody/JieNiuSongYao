//
//  StarView.m
//  Movie
//
//  Created by apple on 15/6/8.
//  Copyright (c) 2015年 huiwen. All rights reserved.
//

#import "StarView.h"
@implementation StarView


//如果星星视图存在在xib中,则此方法会调用
- (void)awakeFromNib{

    [super awakeFromNib];
    [self _creatSubViews];

}

//如果星星视图是通过alloc方式创建,此方法会被调用
- (id)initWithFrame:(CGRect)frame{ // 60

    self = [super initWithFrame:frame];
    if (self) {
     
        [self _creatSubViews];
        
    }
    
    return self;

}

- (void)_creatSubViews{

    UIImage *grayImg = [UIImage imageNamed:@"gray"]; //30 30
    UIImage *yellowImg = [UIImage imageNamed:@"yellow.png"];
    //灰色星星
    grayView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, grayImg.size.width * 5, grayImg.size.height)];
    grayView.backgroundColor = [UIColor colorWithPatternImage:grayImg];
    [self addSubview:grayView];
    
    //黄色星星
    yellowView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, yellowImg.size.width * 5, yellowImg.size.height)];
    yellowView.backgroundColor = [UIColor colorWithPatternImage:yellowImg];
    
    [self addSubview:yellowView];
    
    //放大星星 ,通过外部传入的高度计算星星的放大倍数
    float scale = self.frame.size.height / grayImg.size.height; // 2
    //改变transform会影响视图的坐标
    grayView.transform = CGAffineTransformMakeScale(scale, scale);
    yellowView.transform = CGAffineTransformMakeScale(scale, scale);
    
    //还原坐标
    /*
     CGRect grayFrame = grayView.frame;
     grayFrame.origin = CGPointZero;
     grayView.frame = grayFrame;
     
     CGRect yellowFrame = yellowView.frame;
     yellowFrame.origin = CGPointZero;
     yellowView.frame = yellowFrame;
     */
    
    //引入类目(扩展UIView设置frame的方法)
    grayView.origin = CGPointZero;
    yellowView.origin = CGPointZero;

}

//重写set方法,监听分数的传入 //满分:10分
- (void)setRating:(CGFloat)rating{

    _rating = rating;

    [self setNeedsLayout];
}

- (void)layoutSubviews{

    [super layoutSubviews];
    
    //根据比例算出黄色星星的宽度
    CGFloat width = _rating / 5.0 * grayView.frame.size.width;
    
//    CGRect frame = yellowView.frame;
//    frame.size.width = width;
//    yellowView.frame = frame;
    
    yellowView.width = width;
    

    


}


@end
