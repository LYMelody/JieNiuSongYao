//
//  JNSYMyCornerViewController.m
//  JieNiuSongYao
//
//  Created by rongfeng on 2017/5/9.
//  Copyright © 2017年 China Zhou. All rights reserved.
//

#import "JNSYMyCornerViewController.h"
#import "Common.h"
#import "JNSYMeCommonCell.h"
#import "Masonry.h"
#import "JNSYAutoSize.h"
#import "JNYSHeadTableViewCell.h"
#import "JNSYJiFenTableViewCell.h"
#import "JNSYOrderTypeTableViewCell.h"
#import "JNSYDrugsEnterViewController.h"
#import "JNSYAccountMessageViewController.h"
#import "JNSYSettingViewController.h"
#import "JNSYInfoCerfityViewController.h"
#import "JNSYReceivePlaceViewController.h"
#import "JNSYVipViewController.h"
#import "JNSYCollectionViewController.h"
#import "JNSYScoreViewController.h"
#import "JNSYLoginViewController.h"
#import "JNSYUserInfo.h"
#import "UIImageView+WebCache.h"
#import "JNSYAutoSize.h"
#import "JNSYUserInfo.h"
#import "MBProgressHUD.h"
#import "SBJSON.h"
#import "IBHttpTool.h"
#import "JNSYConversationListController.h"
#import "JNSYHXHelper.h"
#import "EaseImageView.h"
@interface JNSYMyCornerViewController ()<UITableViewDelegate,UITableViewDataSource,UINavigationControllerDelegate>

@property (nonatomic, strong)UIImage *headerImg;

@end

@implementation JNSYMyCornerViewController {
    
    NSUserDefaults *User;
    UITableView *table;
    UIImageView *tableHeaderView;
    UIImageView *HeaderView;
    BOOL isLogin;
    UIButton *MeseageBtn;
    UIImageView *badgeImg;
    UILabel *badgeLab;
}

- (void)viewWillAppear:(BOOL)animated {
    
    [super viewWillAppear:animated];
    
    self.view.backgroundColor = ColorTableBack;
    //tabbar
    self.navigationController.navigationBar.barTintColor = ColorTabBarback;
    
    self.tabBarController.tabBar.hidden = NO;

    [self.navigationController setNavigationBarHidden:YES animated:YES];
    
    //返回按钮
    self.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"" style:UIBarButtonItemStylePlain target:self action:nil];
    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
    
    //是否登录
    isLogin = [JNSYUserInfo getUserInfo].isLoggedIn;
    
    
    //获取基本信息(如果是登录状态则请求)
    if (isLogin) {
        [self getBaseInfo];
    }
    
    
    [self setUpUnreadMessageCount];
    
    self.converSationListVc = [[JNSYConversationListController alloc] init];
    [JNSYHXHelper shareHelper].conversationListVc = self.converSationListVc;
    [JNSYHXHelper shareHelper].myCornerVc = self;
    
    [table reloadData];
    
    
    
}

- (void)viewDidAppear:(BOOL)animated {
    
    [super viewDidAppear:animated];
    
    
}


- (void)viewDidLoad {
    [super viewDidLoad];
    //self.title = @"我的";
    
    //self.edgesForExtendedLayout = UIRectEdgeAll;
    MeseageBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [MeseageBtn sizeToFit];
    [MeseageBtn setImage:[UIImage imageNamed:@"消息New"] forState:UIControlStateNormal];
    [MeseageBtn addTarget:self action:@selector(Meseage) forControlEvents:UIControlEventTouchUpInside];

    
    UIButton *SettingBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [SettingBtn sizeToFit];
    [SettingBtn setImage:[UIImage imageNamed:@"设置New"] forState:UIControlStateNormal];
    [SettingBtn addTarget:self action:@selector(Setting) forControlEvents:UIControlEventTouchUpInside];
    
    
    table = [[UITableView alloc] initWithFrame:CGRectMake(0, -22, KscreenWidth, KscreenHeight) style:UITableViewStylePlain];
    table.delegate = self;
    table.dataSource = self;
    table.backgroundColor = ColorTableBack;
    table.tableFooterView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 0, CGFLOAT_MIN)];
    table.separatorStyle = UITableViewCellSeparatorStyleNone;
    table.showsVerticalScrollIndicator = NO;

    tableHeaderView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, KscreenWidth, [JNSYAutoSize AutoHeight:50])];
    tableHeaderView.backgroundColor = ColorTabBarback;
    tableHeaderView.userInteractionEnabled  = YES;
    table.tableHeaderView = tableHeaderView;
    
    [tableHeaderView addSubview:MeseageBtn];
    [tableHeaderView addSubview:SettingBtn];
    
    
    
    [MeseageBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(tableHeaderView).offset(10);
        make.right.equalTo(tableHeaderView).offset(-10);
        make.width.mas_equalTo([JNSYAutoSize AutoHeight:60]);
        make.height.mas_equalTo([JNSYAutoSize AutoHeight:60]);
    }];
    
    
    [MeseageBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(tableHeaderView).offset(10);
        make.right.equalTo(tableHeaderView).offset(-10);
        make.width.mas_equalTo([JNSYAutoSize AutoHeight:40]);
        make.height.mas_equalTo([JNSYAutoSize AutoHeight:40]);
    }];
    
    [SettingBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(tableHeaderView).offset(10);
        make.right.equalTo(MeseageBtn.mas_left);
        make.width.mas_equalTo([JNSYAutoSize AutoHeight:40]);
        make.height.mas_equalTo([JNSYAutoSize AutoHeight:40]);
    }];
    
    
    badgeImg = [[UIImageView alloc] init];
    badgeImg.backgroundColor = [UIColor redColor];
    badgeImg.layer.cornerRadius = 10;
    badgeImg.layer.masksToBounds = YES;
    badgeImg.hidden = YES;
    
    badgeLab = [[UILabel alloc] init];
    badgeLab.font = [UIFont systemFontOfSize:11];
    badgeLab.textColor = [UIColor whiteColor];
    badgeLab.text = @"1";
    badgeLab.textAlignment = NSTextAlignmentCenter;
    
    [MeseageBtn addSubview:badgeImg];
    
    [badgeImg addSubview:badgeLab];
    
    [badgeImg mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(MeseageBtn.mas_right).offset(-10);
        make.centerY.equalTo(MeseageBtn.mas_top).offset(5);
        make.size.mas_equalTo(CGSizeMake(20, 20));
    }];
    
    [badgeLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.centerX.equalTo(badgeImg);
    }];

    [self.view addSubview:table];
    
    User = [NSUserDefaults standardUserDefaults];
    
    //self.navigationController.delegate = self;
    
    //顶部图像
    HeaderView = [[UIImageView alloc] init];
    HeaderView.image = [UIImage imageNamed:@"MonaLisa.jpg"];
    
    HeaderView.frame = CGRectMake(0, -200, KscreenWidth, 200);
    HeaderView.backgroundColor = ColorTabBarback;
    HeaderView.contentMode = UIViewContentModeScaleAspectFill;
    HeaderView.clipsToBounds = YES;
    [table addSubview:HeaderView];
    
    
    
}
//点击设置方法
- (void)Setting {
    
    NSLog(@"设置");
    
    JNSYSettingViewController *SettingVc = [[JNSYSettingViewController alloc] init];
    
    SettingVc.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:SettingVc animated:YES];
    
}

//点击消息方法
- (void)Meseage {
    
    NSLog(@"消息");
    
    
    
    self.converSationListVc.hidesBottomBarWhenPushed = YES;
    
    [self.navigationController pushViewController:self.converSationListVc animated:YES];
    
    
}

//统计未读消息
- (void)setUpUnreadMessageCount {
    
    NSArray *conversations = [[EMClient sharedClient].chatManager getAllConversations];
    NSInteger unreadCount = 0;
    for (EMConversation *conversation in conversations) {
        unreadCount += conversation.unreadMessagesCount;
    }
    
    if (unreadCount > 0) {
        badgeImg.hidden = NO;
       
        if (unreadCount > 99) {
            badgeLab.text = @"99+";
        }else {
            badgeLab.text = [NSString stringWithFormat:@"%ld",(long)unreadCount];
        }
    
    }else {
        badgeImg.hidden = YES;
    }
    
    
    UIApplication *application = [UIApplication sharedApplication];
    [application setApplicationIconBadgeNumber:unreadCount];
    
}


//获取个人基本信息
- (void)getBaseInfo {
    
    NSString *timestamp = [JNSYAutoSize getTimeNow];
    
    NSDictionary *dic = @{
                          @"timestamp":timestamp
                          };
    
    NSString *action = @"UserBaseInfoState";
    
    NSDictionary *requestDic = @{
                                 @"action":action,
                                 @"token":[JNSYUserInfo getUserInfo].userToken,
                                 @"data":dic
                                 };
    NSString *params = [requestDic JSONFragment];
    
    [IBHttpTool postWithURL:JNSYTestUrl params:params success:^(id result) {
        //NSLog(@"%@",result);
        NSDictionary *resultdic = [result JSONValue];
        NSString *code = resultdic[@"code"];
       // NSLog(@"%@,%@",resultdic,code);
        if([code isEqualToString:@"000000"]) {
            
            [JNSYUserInfo getUserInfo].userCode = resultdic[@"userCode"];
            [JNSYUserInfo getUserInfo].userPhone = resultdic[@"userPhone"];
            [JNSYUserInfo getUserInfo].userName = resultdic[@"userName"];
            [JNSYUserInfo getUserInfo].userAccount = resultdic[@"userAccount"];
            [JNSYUserInfo getUserInfo].userCert = resultdic[@"userCert"];
            [JNSYUserInfo getUserInfo].userPoints = resultdic[@"userPoints"];
            [JNSYUserInfo getUserInfo].branderCardFlg = resultdic[@"branderCardFlg"];
            [JNSYUserInfo getUserInfo].branderCardNo = resultdic[@"branderCardNo"];
            
        }else {
            NSString *msg = resultdic[@"msg"];
            [JNSYAutoSize showMsg:msg];
        }
        //刷新视图
        [table reloadData];
    } failure:^(NSError *error) {
       
        //[JNSYAutoSize showMsg:error];
    }];
    
}

//获取实名认信息
- (void)getRealNameInfo {
    
    NSString *timestamp = [JNSYAutoSize getTimeNow];
    
    NSDictionary *dic = @{
                          @"timestamp":timestamp
                          };
    
    NSString *action = @"UserRealInfoState";
    
    NSDictionary *requestDic = @{
                                 @"action":action,
                                 @"token":[JNSYUserInfo getUserInfo].userToken,
                                 @"data":dic
                                 };
    NSString *params = [requestDic JSONFragment];
    
    [IBHttpTool postWithURL:JNSYTestUrl params:params success:^(id result) {
        NSLog(@"%@",result);
        NSDictionary *resultdic = [result JSONValue];
        NSString *code = resultdic[@"code"];
        NSLog(@"%@,%@",resultdic,code);
        if([code isEqualToString:@"000000"]) {
            
            [JNSYUserInfo getUserInfo].userAccount = resultdic[@"userAccount"];
            [JNSYUserInfo getUserInfo].userCert = resultdic[@"userCert"];
            
            JNSYInfoCerfityViewController *CerfityVc = [[JNSYInfoCerfityViewController alloc] init];
            
            //判断是否有实名认证信息
            if([[JNSYUserInfo getUserInfo].userCert isEqualToString:@""] || [JNSYUserInfo getUserInfo].userCert == nil) {
                
                CerfityVc.isCertify = NO;
                
            }else {
                
                CerfityVc.isCertify = YES;
                CerfityVc.userCert = [JNSYUserInfo getUserInfo].userCert;
                CerfityVc.userAccount = [JNSYUserInfo getUserInfo].userAccount;
                
            }
            
            CerfityVc.hidesBottomBarWhenPushed = YES;
            
            [self.navigationController pushViewController:CerfityVc animated:YES];
            
        }else {
            NSString *msg = resultdic[@"msg"];
            [JNSYAutoSize showMsg:msg];
        }
    } failure:^(NSError *error) {
        
        
    }];
    
    
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return 12;
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *identy = @"identy";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identy];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] init];
        if (indexPath.row == 0) {
            
            JNYSHeadTableViewCell *Cell = [[JNYSHeadTableViewCell alloc] init];
            //NSData *data = [User objectForKey:@"HeaderImgData"];
            if ([JNSYUserInfo getUserInfo].picHeader) {
                [Cell.HeaderView sd_setImageWithURL:[NSURL URLWithString:[JNSYUserInfo getUserInfo].picHeader]];
            }else {
                Cell.HeaderView.image = [UIImage imageNamed:@"头像"];
            }
            Cell.HeaderLabOne.text = [JNSYUserInfo getUserInfo].userName == nil?@"商户昵称":[JNSYUserInfo getUserInfo].userName;
            Cell.HeaderLabTwo.text = [[JNSYUserInfo getUserInfo].userPhone stringByReplacingCharactersInRange:NSMakeRange(3, 4) withString:@"****"];
            
            if ([JNSYUserInfo getUserInfo].isLoggedIn) {
                Cell.HeaderLabOne.hidden = NO;
                Cell.HeaderLabTwo.hidden = NO;
                Cell.LoginImgView.hidden = YES;
            }else {
                Cell.HeaderLabOne.hidden = YES;
                Cell.HeaderLabTwo.hidden = YES;
                Cell.LoginImgView.hidden = NO;
            }
            
            Cell.loginBlock = ^{
                JNSYLoginViewController *loginvC = [[JNSYLoginViewController alloc] init];
                loginvC.hidesBottomBarWhenPushed = YES;
                [self.navigationController pushViewController:loginvC animated:YES];
            };
            cell = Cell;
            cell.backgroundColor = ColorTabBarback;
            //cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
            
            
        }else if (indexPath.row == 1) {
            JNSYJiFenTableViewCell *Cell = [[JNSYJiFenTableViewCell alloc] init];
            Cell.JiFenLabOne.text = [NSString stringWithFormat:@"%@",[JNSYUserInfo getUserInfo].userPoints?[JNSYUserInfo getUserInfo].userPoints:@""];
            Cell.CollectionLabOne.text = @"2";
            Cell.NearByDrugLabOne.text = @"10";
            Cell.jifenTapBlock = ^{
                NSLog(@"积分");
                JNSYScoreViewController *CollectionVc = [[JNSYScoreViewController alloc] init];
                CollectionVc.hidesBottomBarWhenPushed = YES;
                [self.navigationController pushViewController:CollectionVc animated:YES];
                
            };
            Cell.collectionTapBlock = ^{
                NSLog(@"收藏");
                JNSYCollectionViewController *CollectionVc = [[JNSYCollectionViewController alloc] init];
                CollectionVc.hidesBottomBarWhenPushed = YES;
                [self.navigationController pushViewController:CollectionVc animated:YES];
                
            };
            Cell.nearbyDrugsBlock = ^{
                NSLog(@"附近药店");
            };
            cell = Cell;
            
        }else if (indexPath.row == 2 || indexPath.row == 5 || indexPath.row == 9) {
            cell.contentView.backgroundColor = ColorTableBack;
        }else if (indexPath.row == 3) {
            JNSYMeCommonCell *Cell = [[JNSYMeCommonCell alloc] init];
            Cell.leftLab.text = @"我的订单";
            Cell.rightLab.text = @"查看全部订单";
            Cell.bottomline.hidden = YES;
            cell = Cell;
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        }else if (indexPath.row == 4) {
            
            JNSYOrderTypeTableViewCell *Cell = [[JNSYOrderTypeTableViewCell alloc] init];
            Cell.WaitToPayImg.image = [UIImage imageNamed:@"待付款.png"];
            Cell.WaitToDeliverImg.image = [UIImage imageNamed:@"待发货.png"];
            Cell.WaitToReciveImg.image = [UIImage imageNamed:@"待收货.png"];
            Cell.WaitToEvaluateImg.image = [UIImage imageNamed:@"待评价.png"];
            Cell.CompleteImg.image = [UIImage imageNamed:@"已完成.png"];
            Cell.blockWaitToPay = ^{
                NSLog(@"待付款!");
            };
            Cell.blockWaitToDeliver = ^{
                NSLog(@"待发货!");
            };
            Cell.blockWaitToRecive = ^{
                NSLog(@"待收货!");
            };
            Cell.blockWaitToEvaluate = ^{
                NSLog(@"待评估!");
            };
            Cell.blockComplete = ^{
                NSLog(@"已完成!");
            };
            cell = Cell;
        }else if (indexPath.row == 6) {
            JNSYMeCommonCell *Cell = [[JNSYMeCommonCell alloc] init];
            Cell.leftLab.text = @"收货地址";
            cell = Cell;
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        }
        else if (indexPath.row == 7) {
            JNSYMeCommonCell *Cell = [[JNSYMeCommonCell alloc] init];
            Cell.leftLab.text = @"实名认证";
            cell = Cell;
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
            
        }else if (indexPath.row == 8) {
            JNSYMeCommonCell *Cell = [[JNSYMeCommonCell alloc] init];
            Cell.leftLab.text = @"会员卡";
            Cell.rightLab.hidden = YES;
            Cell.bottomline.hidden = YES;
            cell = Cell;
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        }else if (indexPath.row == 10) {
            JNSYMeCommonCell *Cell = [[JNSYMeCommonCell alloc] init];
            Cell.leftLab.text = @"客服热线";
            Cell.rightLab.text = @"40099099";
            cell = Cell;
            //cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        }else if (indexPath.row == 11) {
            JNSYMeCommonCell *Cell = [[JNSYMeCommonCell alloc] init];
            Cell.leftLab.text = @"药店入驻";
            Cell.bottomline.hidden = YES;
            cell = Cell;
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        }
        cell.textLabel.font = [UIFont systemFontOfSize:13];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.row == 0) {
        return 100;
    }else if(indexPath.row == 1 || indexPath.row == 4) {
        return 80;
    }else if (indexPath.row == 2 || indexPath.row == 5 || indexPath.row == 9) {
        return 10;
    }
    return 44;
}

//单元格点击事件
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    
    
    if (indexPath.row == 11) { //药店入驻
        
        if (isLogin) {  //药店入驻
            JNSYDrugsEnterViewController *EnterVc = [[JNSYDrugsEnterViewController alloc] init];
            self.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:EnterVc animated:YES];
            self.hidesBottomBarWhenPushed = NO;
            
        }else {   //登录
            
            JNSYLoginViewController *LoginVc = [[JNSYLoginViewController alloc] init];
            LoginVc.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:LoginVc animated:YES];
        }
        
    }else if (indexPath.row == 0) { //个人信息
        
        
        
        if (isLogin) {
            JNSYAccountMessageViewController *AccountMessageVc = [[JNSYAccountMessageViewController alloc] init];
            AccountMessageVc.changeHeaderImgBlock = ^{
                [table reloadData];
            };
            self.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:AccountMessageVc animated:YES];
            self.hidesBottomBarWhenPushed = NO;
        }else {
            
            
        }
        
    }else if (indexPath.row == 6) {
        
        JNSYReceivePlaceViewController *ReceivePlaceVc = [[JNSYReceivePlaceViewController alloc] init];
        ReceivePlaceVc.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:ReceivePlaceVc animated:YES];
    }
    else if (indexPath.row == 7) { //实名认证
        
        //判断是否登录!未登录先登录
        if (isLogin) {    //获取实名认信息
            [self getRealNameInfo];
        }else {       //跳转登录页面
            JNSYLoginViewController *LoginVc = [[JNSYLoginViewController alloc] init];
            LoginVc.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:LoginVc animated:YES];
        }

    }else if (indexPath.row == 8) {  //会员卡申请
        
        if (isLogin) { //会员卡页面
            JNSYVipViewController *VipVc = [[JNSYVipViewController alloc] init];
            VipVc.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:VipVc animated:YES];
        }else {    //登录页面
            JNSYLoginViewController *LoginVc = [[JNSYLoginViewController alloc] init];
            LoginVc.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:LoginVc animated:YES];
        }
    
    }
}


//顶部滑动视图滑动方法
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    
    CGPoint offset = scrollView.contentOffset;
    if (offset.y < 0) {
        CGRect frame = HeaderView.frame;
        frame.origin.y = offset.y;
        frame.size.height = - offset.y;
        HeaderView.frame = frame;
         //NSLog(@"%f,%f",offset.x,offset.y);
    }
   
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
