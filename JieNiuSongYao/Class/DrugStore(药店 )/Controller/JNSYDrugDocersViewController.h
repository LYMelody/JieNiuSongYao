//
//  JNSYDrugDocersViewController.h
//  JieNiuSongYao
//
//  Created by rongfeng on 2017/5/31.
//  Copyright © 2017年 China Zhou. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface JNSYDrugDocersViewController : UIViewController


@property(nonatomic,copy)NSString *shopId;


- (float)heightForStr:(UITextView *)textView Width:(float)width;

- (float)heightForString:(NSString *)str Width:(CGFloat)width;

@end
