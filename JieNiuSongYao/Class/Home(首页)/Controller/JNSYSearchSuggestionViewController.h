//
//  JNSYSearchSuggestionViewController.h
//  JieNiuSongYao
//
//  Created by rongfeng on 2017/5/25.
//  Copyright © 2017年 China Zhou. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^SelectSearchTextBlock)(NSString *text);

typedef void(^HiddenKeyBoardBlock)(void);

@interface JNSYSearchSuggestionViewController : UIViewController


@property (nonatomic, copy)SelectSearchTextBlock selectSearchTextBlock;

@property (nonatomic, copy)HiddenKeyBoardBlock hiddenKeyBoardBlock;

@property (nonatomic, strong)UITableView *table;

@end
