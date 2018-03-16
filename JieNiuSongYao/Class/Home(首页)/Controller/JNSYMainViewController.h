//
//  JNSYMainViewController.h
//  JieNiuSongYao
//
//  Created by rongfeng on 2017/5/9.
//  Copyright © 2017年 China Zhou. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JNSYConversationListController.h"
@interface JNSYMainViewController : UIViewController


@property(nonatomic,strong)JNSYConversationListController *coversationListCtr;

@property(nonatomic,strong)NSArray *drugStoreArray;

- (void)setUpUnreadMessageCount;

@end
