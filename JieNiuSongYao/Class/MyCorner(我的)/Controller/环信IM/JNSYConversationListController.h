//
//  JNSYConversationListController.h
//  JieNiuSongYao
//
//  Created by rongfeng on 2017/7/24.
//  Copyright © 2017年 China Zhou. All rights reserved.
//

//#import <EaseUI/EaseUI.h>
#import <EaseUI.h>
@interface JNSYConversationListController : EaseConversationListViewController


@property(nonatomic, strong)NSMutableArray *conversationsArray;

- (void)refresh;
- (void)refreshDataSource;

- (void)inConnect:(BOOL)isConnect;
- (void)networkChanged:(EMConnectionState)connectionState;

@end
