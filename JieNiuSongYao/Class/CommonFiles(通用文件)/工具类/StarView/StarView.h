//
//  StarView.h
//  Movie
//
//  Created by apple on 15/6/8.
//  Copyright (c) 2015年 huiwen. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UIViewExt.h"
@interface StarView : UIView{

    UIView *grayView;
    UIView *yellowView;


}

@property (nonatomic,assign)CGFloat rating; //分数
@end
