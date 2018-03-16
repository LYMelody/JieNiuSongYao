//
//  JNSYConversationListController.m
//  JieNiuSongYao
//
//  Created by rongfeng on 2017/7/24.
//  Copyright © 2017年 China Zhou. All rights reserved.
//

#import "JNSYConversationListController.h"
//#import "UserProfileManager.h"
#import "Common.h"
#import "JNSYHXHelper.h"
#import "JNSYMessageViewController.h"
#import "JNSYUserInfo.h"
#import "SBJSON.h"
#import "IBHttpTool.h"
#import "JNSYAutoSize.h"
@interface JNSYConversationListController ()<EaseConversationListViewControllerDelegate,EaseConversationListViewControllerDataSource>

@property(nonatomic, strong)UIView *networkStateView;

@property(nonatomic, strong)NSDictionary *infoDic;
@end

@implementation JNSYConversationListController

- (void)viewWillAppear:(BOOL)animated {
    
    [super viewWillAppear:animated];
    
    self.title = @"消息";
    
    [self.navigationController setNavigationBarHidden:NO animated:YES];
    
    EMError *error = nil;
    
    NSArray *buddyList =   [[EMClient sharedClient].chatManager getAllConversations];
    
    if(error) {
        
        NSLog(@"%@",error.errorDescription);
        
    }else {
        
        NSMutableArray *array = [NSMutableArray array];
        
        for(NSInteger i = 0;i< buddyList.count;i++) {
            
            EMConversation *conversation = buddyList[i];
            NSLog(@"用户名:%@",conversation.conversationId);
            
            [array addObject:conversation.conversationId];
            
        }
        
        NSString *ids = [array componentsJoinedByString:@","];
        
        NSLog(@"ids:%@",ids);
        
        
        if (array.count > 0) {
            
            [self getUserNameAndHeaderImg:ids];
        }
    }
    [self refresh];
    
}


- (void)viewDidLoad {
    [super viewDidLoad];
   
    
    //self.tableView.frame = CGRectMake(0, 64, KscreenWidth, KscreenHeight - 64);
    self.showRefreshHeader = YES;
    self.delegate = self;
    self.dataSource = self;
    
    [self networkStateView];
    
    [self removeEmptyConversationsFromDB];
    
    [self tableViewDidTriggerHeaderRefresh];
    
    //[JNSYHXHelper shareHelper].conversationListVc = self;
}

- (void)removeEmptyConversationsFromDB
{
    NSArray *conversations = [[EMClient sharedClient].chatManager getAllConversations];
    NSMutableArray *needRemoveConversations;
    for (EMConversation *conversation in conversations) {
        if (!conversation.latestMessage || (conversation.type == EMConversationTypeChatRoom)) {
            if (!needRemoveConversations) {
                needRemoveConversations = [[NSMutableArray alloc] initWithCapacity:0];
            }
            
            [needRemoveConversations addObject:conversation];
        }
    }
    
    if (needRemoveConversations && needRemoveConversations.count > 0) {
        [[EMClient sharedClient].chatManager deleteConversations:needRemoveConversations isDeleteMessages:YES completion:nil];
    }
}

#pragma mark - getter

- (UIView *)networkStateView
{
    if (_networkStateView == nil) {
        _networkStateView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.tableView.frame.size.width, 44)];
        _networkStateView.backgroundColor = [UIColor colorWithRed:255 / 255.0 green:199 / 255.0 blue:199 / 255.0 alpha:0.5];
        
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(10, (_networkStateView.frame.size.height - 20) / 2, 20, 20)];
        imageView.image = [UIImage imageNamed:@"messageSendFail"];
        [_networkStateView addSubview:imageView];
        
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(imageView.frame) + 5, 0, _networkStateView.frame.size.width - (CGRectGetMaxX(imageView.frame) + 15), _networkStateView.frame.size.height)];
        label.font = [UIFont systemFontOfSize:15.0];
        label.textColor = [UIColor grayColor];
        label.backgroundColor = [UIColor clearColor];
        label.text = NSLocalizedString(@"network.disconnection", @"Network disconnection");
        [_networkStateView addSubview:label];
    }
    
    return _networkStateView;
}

- (id<IConversationModel>)conversationListViewController:(EaseConversationListViewController *)conversationListViewController modelForConversation:(EMConversation *)conversation {
    
    
    EaseConversationModel *model = [[EaseConversationModel alloc] initWithConversation:conversation];
    NSDictionary *userInfoDic = _infoDic[conversation.conversationId];
    NSString *title = userInfoDic[@"imNickname"];
    NSString *imageurl = userInfoDic[@"imHeadImg"];
    if (title) {   //昵称
        model.title = title;
    }
    if (imageurl) {   //头像
        model.avatarURLPath = imageurl;
    }
    return model;

}


- (void)conversationListViewController:(EaseConversationListViewController *)conversationListViewController didSelectConversationModel:(id<IConversationModel>)conversationModel {
    
    if (conversationModel) {
        EMConversation *conversation = conversationModel.conversation;
        if (conversation) {
            JNSYMessageViewController *chatViewVc = [[JNSYMessageViewController alloc] initWithConversationChatter:conversation.conversationId conversationType:conversation.type];
            chatViewVc.title = conversationModel.title;
            chatViewVc.imageURL = conversationModel.avatarURLPath;
            [self.navigationController pushViewController:chatViewVc animated:YES];
        }
        
    }
    
    [[NSNotificationCenter defaultCenter] postNotificationName:@"setupUnreadMessageCount" object:nil];
    
    [self.tableView reloadData];

}

#pragma mark - EaseConversationListViewControllerDelegate

- (NSAttributedString *)conversationListViewController:(EaseConversationListViewController *)conversationListViewController
                latestMessageTitleForConversationModel:(id<IConversationModel>)conversationModel
{
    NSMutableAttributedString *attributedStr = [[NSMutableAttributedString alloc] initWithString:@""];
    EMMessage *lastMessage = [conversationModel.conversation latestMessage];
    if (lastMessage) {
        NSString *latestMessageTitle = @"";
        EMMessageBody *messageBody = lastMessage.body;
        switch (messageBody.type) {
            case EMMessageBodyTypeImage:{
                latestMessageTitle = NSLocalizedString(@"message.image1", @"[image]");
            } break;
            case EMMessageBodyTypeText:{
                // 表情映射。
                NSString *didReceiveText = [EaseConvertToCommonEmoticonsHelper
                                            convertToSystemEmoticons:((EMTextMessageBody *)messageBody).text];
                
                latestMessageTitle = didReceiveText;
                
                
                
                if ([lastMessage.ext objectForKey:MESSAGE_ATTR_IS_BIG_EXPRESSION]) {
                    latestMessageTitle = @"[动画表情]";
                }else if ([latestMessageTitle isEqualToString:@""]) {
                    
                    latestMessageTitle = @"[动画表情]";
                    
                }
            } break;
            case EMMessageBodyTypeVoice:{
                latestMessageTitle = NSLocalizedString(@"message.voice1", @"[voice]");
            } break;
            case EMMessageBodyTypeLocation: {
                latestMessageTitle = NSLocalizedString(@"message.location1", @"[location]");
            } break;
            case EMMessageBodyTypeVideo: {
                latestMessageTitle = NSLocalizedString(@"message.video1", @"[video]");
            } break;
            case EMMessageBodyTypeFile: {
                latestMessageTitle = NSLocalizedString(@"message.file1", @"[file]");
            } break;
            default: {
            } break;
        }
        
        if (lastMessage.direction == EMMessageDirectionReceive) {
            
            latestMessageTitle = [NSString stringWithFormat:@"%@",latestMessageTitle];
        }
        
        NSDictionary *ext = conversationModel.conversation.ext;
        if (ext && [ext[kHaveUnreadAtMessage] intValue] == kAtAllMessage) {
            latestMessageTitle = [NSString stringWithFormat:@"%@ %@", NSLocalizedString(@"group.atAll", nil), latestMessageTitle];
            attributedStr = [[NSMutableAttributedString alloc] initWithString:latestMessageTitle];
            [attributedStr setAttributes:@{NSForegroundColorAttributeName : [UIColor colorWithRed:1.0 green:.0 blue:.0 alpha:0.5]} range:NSMakeRange(0, NSLocalizedString(@"group.atAll", nil).length)];
            
        }
        else if (ext && [ext[kHaveUnreadAtMessage] intValue] == kAtYouMessage) {
            latestMessageTitle = [NSString stringWithFormat:@"%@ %@", NSLocalizedString(@"group.atMe", @"[Somebody @ me]"), latestMessageTitle];
            attributedStr = [[NSMutableAttributedString alloc] initWithString:latestMessageTitle];
            [attributedStr setAttributes:@{NSForegroundColorAttributeName : [UIColor colorWithRed:1.0 green:.0 blue:.0 alpha:0.5]} range:NSMakeRange(0, NSLocalizedString(@"group.atMe", @"[Somebody @ me]").length)];
        }
        else {
            attributedStr = [[NSMutableAttributedString alloc] initWithString:latestMessageTitle];
        }
    }
    
    return attributedStr;
}


- (NSString *)conversationListViewController:(EaseConversationListViewController *)conversationListViewController
       latestMessageTimeForConversationModel:(id<IConversationModel>)conversationModel
{
    NSString *latestMessageTime = @"";
    EMMessage *lastMessage = [conversationModel.conversation latestMessage];;
    if (lastMessage) {
        latestMessageTime = [NSDate formattedTimeFromTimeInterval:lastMessage.timestamp];
    }
    return latestMessageTime;
}


#pragma mark - public


- (void)refresh {
    
    
    [self refreshAndSortView];
    
}


- (void)refreshDataSource {
    
    [self tableViewDidTriggerHeaderRefresh];
    
}

//获取用户名和头像
- (void)getUserNameAndHeaderImg:(NSString *)userId {
    
    NSDictionary *dic = @{
                          @"ids":userId,
                          };
    NSString *action = @"SearchImAccountState";
    
    NSDictionary *requestDic = @{
                                 @"action":action,
                                 @"token":[JNSYUserInfo getUserInfo].userToken,
                                 @"data":dic
                                 };
    NSString *params = [requestDic JSONFragment];
    
    [IBHttpTool postWithURL:JNSYTestUrl params:params success:^(id result) {
        
        NSDictionary *resultdic = [result JSONValue];
        NSString *code = resultdic[@"code"];
        NSLog(@"%@,%@",resultdic,code);
        if([code isEqualToString:@"000000"]) {
            
            _infoDic = resultdic[@"accountInfo"];
            
            [self refreshDataSource];
            
        }else {
            NSString *msg = resultdic[@"msg"];
            [JNSYAutoSize showMsg:msg];
        }

        
    } failure:^(NSError *error) {
        NSLog(@"%@",error);
    }];
    
    
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
