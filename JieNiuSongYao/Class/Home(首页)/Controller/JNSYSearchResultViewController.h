//
//  JNSYSearchResultViewController.h
//  JieNiuSongYao
//
//  Created by rongfeng on 2017/5/24.
//  Copyright © 2017年 China Zhou. All rights reserved.
//

#import <UIKit/UIKit.h>


typedef void(^SaveSearchTextBlock)(NSString *SearchText);

typedef void(^HiddenKeyBoardBlock)(void);

@interface JNSYSearchResultViewController : UIViewController

@property (nonatomic, strong)NSArray *DrugStoreArray;
@property (nonatomic, strong)NSArray *DrugArray;
@property (nonatomic, copy)SaveSearchTextBlock saveSearchTextBlock;
@property (nonatomic, copy)HiddenKeyBoardBlock hiddenKeyBoardBlock;
@property (nonatomic, strong)UITableView *table;

@end
