//
//  JNSYHXHelper.h
//  JieNiuSongYao
//
//  Created by rongfeng on 2017/7/25.
//  Copyright © 2017年 China Zhou. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "JNSYConversationListController.h"
#import "JNSYMainViewController.h"
#import "JNSYMyCornerViewController.h"
#define kHaveUnreadAtMessage    @"kHaveAtMessage"
#define kAtYouMessage           1
#define kAtAllMessage           2


@interface JNSYHXHelper : NSObject<EMChatManagerDelegate,EMClientDelegate>


@property(nonatomic,strong)JNSYConversationListController *conversationListVc;

@property(nonatomic,strong)JNSYMainViewController *mainVc;

@property(nonatomic,strong)JNSYMyCornerViewController *myCornerVc;

+ (instancetype)shareHelper;


- (void)asyncPushOptions;

- (void)asyncConversationFromDB;


@end
