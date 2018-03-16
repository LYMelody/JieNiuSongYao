//
//  JNSYMainViewController.m
//  JieNiuSongYao
//
//  Created by rongfeng on 2017/5/9.
//  Copyright © 2017年 China Zhou. All rights reserved.
//

#import "JNSYMainViewController.h"
#import "Common.h"
#import "Masonry.h"
#import "JNSYSearchViewController.h"
#import "XYMScanViewController.h"
#import "JNSYMeCommonCell.h"
#import "JNSYSearchDrugStoreTableViewCell.h"
#import "SDCycleScrollView.h"
#import "JNSYDrugDocerViewController.h"
#import "JNSYAboutUsViewController.h"
#import "JNSYAutoSize.h"
#import "JNSYDrugStoreDetailViewController.h"
#import <AMapLocationKit/AMapLocationKit.h>
#import <MapKit/MapKit.h>
#import "JNSYAutoSize.h"
#import "JNSYUserInfo.h"
#import "SBJSON.h"
#import "IBHttpTool.h"
#import "UIImageView+WebCache.h"
#import "JNSYHXHelper.h"
@interface JNSYMainViewController ()<UITableViewDelegate,UITableViewDataSource,SDCycleScrollViewDelegate,AMapLocationManagerDelegate,UIAlertViewDelegate>

@property(nonatomic,strong)AMapLocationManager *locationManager;

@property(nonatomic,copy)AMapLocatingCompletionBlock completionBlock;

@property(nonatomic,strong)CLLocation *CurLocation;

@property(nonatomic,strong)UIActivityIndicatorView *activityView;

@end

@implementation JNSYMainViewController {
    
    UITableView *table;
    UIImageView *backImg;
    UIImageView *badgeImg;
    UILabel *badgeLab;
    
}

- (void)viewWillAppear:(BOOL)animated {
    
    [super viewWillAppear:animated];
    
    [self.navigationController setNavigationBarHidden:YES animated:YES];
    
    self.navigationController.navigationBar.translucent = NO;
    
    self.navigationController.navigationBar.barTintColor = ColorTabBarback;
    self.navigationController.navigationBar.subviews[0].subviews[0].hidden = YES;
    
    self.view.backgroundColor = [UIColor whiteColor];
    //导航栏标题颜色字体
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName:[UIColor whiteColor],NSFontAttributeName:[UIFont systemFontOfSize:18]}];
    
    //统计未读消息
    [self setUpUnreadMessageCount];
    
}

//初始化定位
- (void)configLocationManager {
    
    self.locationManager = [[AMapLocationManager alloc] init];
    self.locationManager.delegate = self;
    self.locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters;   //定位精度
    
    [self.locationManager requestLocationWithReGeocode:YES completionBlock:self.completionBlock];
    
    //开始旋转
    [_activityView startAnimating];
    
    
}

//回调block
- (void)initCompleteBlock {
    
    
    __weak typeof(self) weakSelf = self;
    
    self.completionBlock = ^(CLLocation *location, AMapLocationReGeocode *regeocode, NSError *error) {
        
        
        __strong typeof(self) strongSelf = weakSelf;
        
        
        
        if (error != nil && error.code == AMapLocationErrorLocateFailed)
        {
            //定位错误：此时location和regeocode没有返回值，不进行annotation的添加
            NSLog(@"定位错误:{%ld - %@};", (long)error.code, error.localizedDescription);
            [weakSelf.activityView stopAnimating];
            
            
            UIAlertView *alertVc = [[UIAlertView alloc] initWithTitle:@"定位服务未开启" message:@"请在系统设置中开启定位" delegate:strongSelf cancelButtonTitle:@"暂不" otherButtonTitles:@"去设置", nil];
            [alertVc show];
            
            
            
            return;
        }
        else if (error != nil
                 && (error.code == AMapLocationErrorReGeocodeFailed
                     || error.code == AMapLocationErrorTimeOut
                     || error.code == AMapLocationErrorCannotFindHost
                     || error.code == AMapLocationErrorBadURL
                     || error.code == AMapLocationErrorNotConnectedToInternet
                     || error.code == AMapLocationErrorCannotConnectToHost))
        {
            //逆地理错误：在带逆地理的单次定位中，逆地理过程可能发生错误，此时location有返回值，regeocode无返回值，进行annotation的添加
            [weakSelf.activityView stopAnimating];
            NSLog(@"逆地理错误:{%ld - %@};", (long)error.code, error.localizedDescription);
        }
        else if (error != nil && error.code == AMapLocationErrorRiskOfFakeLocation)
        {
            //存在虚拟定位的风险：此时location和regeocode没有返回值，不进行annotation的添加
            NSLog(@"存在虚拟定位的风险:{%ld - %@};", (long)error.code, error.localizedDescription);
    
            [weakSelf.activityView stopAnimating];
            
            return;
        }
        else
        {
            //没有错误：location有返回值，regeocode是否有返回值取决于是否进行逆地理操作，进行annotation的添加
        }
        
        _CurLocation = location;
        
        //有无逆地理信息，annotationView的标题显示的字段不一样
        if (regeocode)
        {
            
            NSLog(@"定位地址:%@",regeocode.formattedAddress);
        }
        else
        {
            
        }
        
        
        //获取附近药店
        [strongSelf reqesetNearDrugStores:@"1" limit:@"500" services:@"所有服务"];
        
    };
}

//获取附近的药店
- (void)reqesetNearDrugStores:(NSString *)sort limit:(NSString *)limit services:(NSString *)servicesStr {
    
    
    
    NSDictionary *dic = @{
                          @"lng":[NSString stringWithFormat:@"%f",_CurLocation.coordinate.longitude],
                          @"lat":[NSString stringWithFormat:@"%f",_CurLocation.coordinate.latitude],
                          @"sort":@"1",
                          @"limit":limit,
                          @"services":servicesStr,
                          @"searchValue":@"",
                          @"page":@"1",
                          @"size":@"10"
                          };
    NSString *action = @"ShopSearchState";
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
            
            
            self.drugStoreArray = [[NSMutableArray alloc] initWithArray:resultdic[@"shopList"]];
            
            [_activityView stopAnimating];
            table.hidden = NO;
            backImg.hidden = YES;
            [table reloadData];
            
        }else {
            [self.activityView stopAnimating];
            NSString *msg = resultdic[@"msg"];
            [JNSYAutoSize showMsg:msg];
        }
       
    } failure:^(NSError *error) {
        [self.activityView stopAnimating];
        NSLog(@"%@",error);
        
       
    }];
}


- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.coversationListCtr = [[JNSYConversationListController alloc] init];
    
    [JNSYHXHelper shareHelper].conversationListVc = self.coversationListCtr;
    [JNSYHXHelper shareHelper].mainVc = self;
    
    //返回按钮
    self.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"" style:UIBarButtonItemStylePlain target:self action:nil];
    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
    
    self.drugStoreArray = [[NSArray alloc] init];
    
    [self SetUpViews];
    
    //获取定位
    [self initCompleteBlock];
    [self configLocationManager];
    
    //环信
    [JNSYHXHelper shareHelper].mainVc = self;
    
    
    //接收广告通知
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(pushAD) name:@"pushtoad" object:nil];
    
    
    
}

//跳转广告页
- (void)pushAD{
    
    
    
}

- (void)SetUpViews {
    
    UIImageView *NavBackImg = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, KscreenWidth, 64)];
    NavBackImg.backgroundColor = ColorTabBarback;
    NavBackImg.userInteractionEnabled = YES;
    
    [self.view addSubview:NavBackImg];
    
    //扫一扫
    UIButton *ScanBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [ScanBtn setBackgroundImage:[UIImage imageNamed:@"扫一扫"] forState:UIControlStateNormal];
    [ScanBtn addTarget:self action:@selector(scanButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    [NavBackImg addSubview:ScanBtn];
    
    [ScanBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(NavBackImg).offset(29);
        make.left.equalTo(NavBackImg).offset(16);
        make.width.mas_equalTo(21);
        make.height.mas_equalTo(20);
    }];
    
    UILabel *ScanLab = [[UILabel alloc] init];
    ScanLab.text = @"扫一扫";
    ScanLab.textColor = [UIColor whiteColor];
    ScanLab.font = [UIFont systemFontOfSize:9];
    ScanLab.textAlignment = NSTextAlignmentCenter;
    [NavBackImg addSubview:ScanLab];
    
    [ScanLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(ScanBtn.mas_bottom).offset(0);
        make.centerX.equalTo(ScanBtn);
        make.width.mas_equalTo(40);
        make.height.mas_equalTo(15);
    }];
    
    //消息
    UIButton *MsgBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [MsgBtn setBackgroundImage:[UIImage imageNamed:@"消息.png"] forState:UIControlStateNormal];
    [MsgBtn addTarget:self action:@selector(MsgAction:) forControlEvents:UIControlEventTouchUpInside];
    
    [NavBackImg addSubview:MsgBtn];
    
    [MsgBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(NavBackImg).offset(28);
        make.right.equalTo(NavBackImg).offset(-16);
        make.width.mas_equalTo(19);
        make.height.mas_equalTo(20);
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
    badgeLab.userInteractionEnabled = YES;
    [MsgBtn addSubview:badgeImg];
    
    [badgeImg addSubview:badgeLab];
    
    [badgeImg mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(MsgBtn.mas_right).offset(2);
        make.centerY.equalTo(MsgBtn.mas_top).offset(-2);
        make.size.mas_equalTo(CGSizeMake(20, 20));
    }];
    
    [badgeLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.centerX.equalTo(badgeImg);
    }];

    
    
    UILabel *MsgLab = [[UILabel alloc] init];
    MsgLab.text = @"消息";
    MsgLab.textColor = [UIColor whiteColor];
    MsgLab.font = [UIFont systemFontOfSize:9];
    MsgLab.textAlignment = NSTextAlignmentCenter;
    [NavBackImg addSubview:MsgLab];
    
    [MsgLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(MsgBtn);
        make.top.equalTo(MsgBtn.mas_bottom);
        make.width.mas_equalTo(40);
        make.height.mas_equalTo(15);
    }];
    
    //搜索
    UIImageView *SearchImg = [[UIImageView alloc] init];
    SearchImg.backgroundColor = [UIColor colorWithRed:255/255.0 green:194/255.0 blue:89/255.0 alpha:1];
    SearchImg.layer.cornerRadius = 14;
    SearchImg.layer.masksToBounds = YES;
    SearchImg.userInteractionEnabled = YES;
    [NavBackImg addSubview:SearchImg];
    
    [SearchImg mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(NavBackImg).offset(28);
        make.bottom.equalTo(NavBackImg).offset(-8);
        make.left.equalTo(ScanLab.mas_right).offset(8);
        make.right.equalTo(MsgLab.mas_left).offset(-8);
    }];
    
    //搜索按钮
    UIButton *SearchBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [SearchBtn setImage:[UIImage imageNamed:@"搜索.png"] forState:UIControlStateNormal];
    [SearchBtn addTarget:self action:@selector(TapSearch) forControlEvents:UIControlEventTouchUpInside];
    
    [SearchImg addSubview:SearchBtn];
    
    [SearchBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.equalTo(SearchImg).offset(5);
        make.centerY.equalTo(SearchImg);
        make.top.equalTo(SearchImg).offset(2);
        make.bottom.equalTo(SearchImg).offset(-2);
        make.width.mas_equalTo(30);
    }];
    
    
    UIButton *CameraBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [CameraBtn setImage:[UIImage imageNamed:@"相机.png"] forState:UIControlStateNormal];
    [CameraBtn addTarget:self action:@selector(CameraBtnAction) forControlEvents:UIControlEventTouchUpInside];
    
    [SearchImg addSubview:CameraBtn];
    
    [CameraBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(SearchImg).offset(-5);
        make.centerY.equalTo(SearchImg);
        make.top.equalTo(SearchImg).offset(2);
        make.bottom.equalTo(SearchImg).offset(-2);
        make.width.mas_equalTo(30);
    }];
    
    
    UILabel *SearchLab = [[UILabel alloc] init];
    SearchLab.text = @"药店、药品、药师";
    SearchLab.textColor = [UIColor whiteColor];
    SearchLab.textAlignment = NSTextAlignmentLeft;
    SearchLab.font = [UIFont systemFontOfSize:13];
    SearchLab.userInteractionEnabled = YES;
    [SearchImg addSubview:SearchLab];
    
    [SearchLab mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.equalTo(SearchBtn.mas_right).offset(2);
        make.top.equalTo(SearchImg).offset(3);
        make.bottom.equalTo(SearchImg).offset(-3);
        make.right.equalTo(CameraBtn.mas_left);
        make.centerY.equalTo(SearchImg);
    }];
    
    //点击搜索手势
    UITapGestureRecognizer *TapSearch = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(TapSearch)];
    TapSearch.numberOfTapsRequired = 1;
    
    [SearchImg addGestureRecognizer:TapSearch];
    
    
    //轮播图片
    
    UIImageView *ADImg = [[UIImageView alloc] init];
    ADImg.backgroundColor = [UIColor grayColor];
    
    [self.view addSubview:ADImg];
    
    
    
    [ADImg mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(NavBackImg.mas_bottom);
        make.left.right.equalTo(self.view);
        make.height.mas_equalTo([JNSYAutoSize AutoHeight:160]);
    }];
    
    NSArray *imgaeArray = [NSArray arrayWithObjects:[UIImage imageNamed:@"banner01"],[UIImage imageNamed:@"AD04.png"],[UIImage imageNamed:@"APP05.png"], nil];
    
    SDCycleScrollView *ADScrollView = [SDCycleScrollView cycleScrollViewWithFrame:CGRectMake(0, 64, KscreenWidth, [JNSYAutoSize AutoHeight:160]) shouldInfiniteLoop:YES imageNamesGroup:imgaeArray];
    
    ADScrollView.delegate = self;
    ADScrollView.pageControlStyle = SDCycleScrollViewPageContolStyleAnimated;
    [self.view addSubview:ADScrollView];
    
    ADScrollView.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    ADScrollView.autoScrollTimeInterval = 5;
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    //附近药店、药师服务、关于我们
    
    CGFloat width = KscreenWidth/3.0;
    
    UIImageView *NearStoreImg = [[UIImageView alloc] init];
    NearStoreImg.backgroundColor = [UIColor whiteColor];
    NearStoreImg.userInteractionEnabled = YES;
    UITapGestureRecognizer *TapNear = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(TapNearAction)];
    TapNear.numberOfTapsRequired = 1;
    
    [NearStoreImg addGestureRecognizer:TapNear];
    
    [self.view addSubview:NearStoreImg];
    
    //附近药店图片、文字
    UIImageView *NearImg = [[UIImageView alloc] init];
    NearImg.image = [UIImage imageNamed:@"NearStore"];
    NearImg.userInteractionEnabled = YES;
    [NearStoreImg addSubview:NearImg];
    
    UILabel *NearLab = [[UILabel alloc] init];
    NearLab.text = @"附近药店";
    NearLab.font = [UIFont systemFontOfSize:12];
    NearLab.textAlignment = NSTextAlignmentCenter;
    NearLab.textColor = [UIColor blackColor];
    NearLab.userInteractionEnabled = YES;
    [NearStoreImg addSubview:NearLab];
    
    [NearStoreImg mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view);
        make.top.equalTo(ADImg.mas_bottom);
        make.width.mas_equalTo(width);
        make.height.mas_equalTo([JNSYAutoSize AutoHeight:70]);
    }];
    
    [NearImg mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(NearStoreImg.mas_top).offset(9);
        make.centerX.equalTo(NearStoreImg);
        make.width.mas_equalTo([JNSYAutoSize AutoHeight:40]);
        make.height.mas_equalTo([JNSYAutoSize AutoHeight:40]);
    }];
    
    [NearLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(NearImg.mas_bottom);
        make.centerX.equalTo(NearImg);
        make.width.mas_equalTo(100);
        make.height.mas_equalTo([JNSYAutoSize AutoHeight:20]);
    }];
    
    //药师服务
    UIImageView *DrugsDorBackImg = [[UIImageView alloc] init];
    DrugsDorBackImg.backgroundColor = [UIColor whiteColor];
    DrugsDorBackImg.userInteractionEnabled = YES;
    UITapGestureRecognizer *TapDrugDor = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(TapDrugDor)];
    TapDrugDor.numberOfTapsRequired = 1;
    
    [DrugsDorBackImg addGestureRecognizer:TapDrugDor];
    
    [self.view addSubview:DrugsDorBackImg];
    
    UIImageView *DrugsDorImg = [[UIImageView alloc] init];
    DrugsDorImg.image = [UIImage imageNamed:@"药师"];
    DrugsDorImg.userInteractionEnabled = YES;
    [DrugsDorBackImg addSubview:DrugsDorImg];
    
    UILabel *DrugsLab = [[UILabel alloc] init];
    DrugsLab.textColor = [UIColor blackColor];
    DrugsLab.text = @"药师服务";
    DrugsLab.textAlignment = NSTextAlignmentCenter;
    DrugsLab.font = [UIFont systemFontOfSize:12];
    DrugsLab.userInteractionEnabled = YES;
    [DrugsDorBackImg addSubview:DrugsLab];
    
    [DrugsDorBackImg mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view);
        make.top.equalTo(ADImg.mas_bottom);
        make.left.equalTo(NearStoreImg.mas_right);
        make.width.mas_equalTo(width);
        make.height.mas_equalTo([JNSYAutoSize AutoHeight:70]);
    }];
    
    [DrugsDorImg mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(DrugsDorBackImg.mas_top).offset(9);
        make.centerX.equalTo(DrugsDorBackImg);
        make.width.height.mas_equalTo([JNSYAutoSize AutoHeight:40]);
    }];
    
    [DrugsLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(DrugsDorImg.mas_bottom);
        make.centerX.equalTo(DrugsDorImg);
        make.width.mas_equalTo(100);
        make.height.mas_equalTo([JNSYAutoSize AutoHeight:20]);
    }];
    
    //关于我们
    UIImageView *AboutBackImg = [[UIImageView alloc] init];
    AboutBackImg.backgroundColor = [UIColor whiteColor];
    AboutBackImg.userInteractionEnabled = YES;
    UITapGestureRecognizer *TapAboutUs = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(TapAboutUs)];
    TapAboutUs.numberOfTapsRequired = 1;
    
    [AboutBackImg addGestureRecognizer:TapAboutUs];
    
    [self.view addSubview:AboutBackImg];
    
    UIImageView *AboutImg = [[UIImageView alloc] init];
    AboutImg.image = [UIImage imageNamed:@"介绍"];
    AboutBackImg.userInteractionEnabled = YES;
    [AboutBackImg addSubview:AboutImg];
    
    UILabel *AboutLab = [[UILabel alloc] init];
    AboutLab.textAlignment = NSTextAlignmentCenter;
    AboutLab.textColor = [UIColor blackColor];
    AboutLab.text = @"关于我们";
    AboutLab.font = [UIFont systemFontOfSize:12];
    AboutLab.userInteractionEnabled = YES;
    [AboutBackImg addSubview:AboutLab];
    
    [AboutBackImg mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(ADImg.mas_bottom);
        make.height.mas_equalTo([JNSYAutoSize AutoHeight:70]);
        make.right.equalTo(self.view);
        make.width.mas_equalTo(width);
    }];
    
    [AboutImg mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(AboutBackImg.mas_top).offset(9);
        make.centerX.equalTo(AboutBackImg);
        make.width.height.mas_equalTo([JNSYAutoSize AutoHeight:40]);
    }];
    
    [AboutLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(AboutImg.mas_bottom);
        make.centerX.equalTo(AboutImg);
        make.height.mas_equalTo([JNSYAutoSize AutoHeight:20]);
        make.width.mas_equalTo(100);
    }];
    
    backImg = [[UIImageView alloc] init];
    backImg.backgroundColor = ColorTableBack;
    [self.view addSubview:backImg];
    
    [backImg mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(DrugsDorBackImg.mas_bottom);
        make.left.right.equalTo(self.view);
        make.bottom.equalTo(self.view);
    }];
    
    
    _activityView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    [backImg addSubview:_activityView];
    
    [_activityView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(backImg);
        make.height.width.mas_equalTo(20);
    }];
    
    
    
    //附近药店
    table = [[UITableView alloc] init];
    table.backgroundColor = ColorTableBack;
    table.delegate = self;
    table.dataSource = self;
    table.showsVerticalScrollIndicator = NO;
    table.separatorStyle = UITableViewCellSeparatorStyleNone;
    table.hidden = YES;
    [self.view addSubview:table];
    
    [table mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(ADImg.mas_bottom).offset([JNSYAutoSize AutoHeight:70]);
        make.left.right.equalTo(self.view);
        make.bottom.equalTo(self.view).offset(-50);
    }];
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


//附近药店
- (void)TapNearAction {
    
    NSLog(@"附近药店");
    
     self.tabBarController.selectedViewController = [self.tabBarController.viewControllers objectAtIndex:1];
    
    
}

- (void)TapDrugDor {
    
    NSLog(@"药师服务");
    
    JNSYDrugDocerViewController *DrugDocerVc = [[JNSYDrugDocerViewController alloc] init];
    DrugDocerVc.location = self.CurLocation;
    DrugDocerVc.hidesBottomBarWhenPushed = YES;
    
    [self.navigationController pushViewController:DrugDocerVc animated:YES];
    
}

- (void)TapAboutUs {
    
    NSLog(@"关于我们");
    
    JNSYAboutUsViewController *AboutUsVc = [[JNSYAboutUsViewController alloc] init];
    AboutUsVc.hidesBottomBarWhenPushed = YES;
    
    [self.navigationController pushViewController:AboutUsVc animated:YES];
    
}

- (void)TapSearch {
    
    NSLog(@"点击搜索");
    JNSYSearchViewController *SearchVc = [[JNSYSearchViewController alloc] init];
    SearchVc.hidesBottomBarWhenPushed = YES;
   
    SearchVc.longtilute = [NSString stringWithFormat:@"%f",_CurLocation.coordinate.longitude];
    SearchVc.latitude = [NSString stringWithFormat:@"%f",_CurLocation.coordinate.latitude];
    
    UINavigationController *Nav = [[UINavigationController alloc] initWithRootViewController:SearchVc];
    [Nav.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName:[UIColor whiteColor],NSFontAttributeName:[UIFont systemFontOfSize:18]}];
    Nav.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"" style:UIBarButtonItemStylePlain target:self action:nil];
    Nav.navigationController.navigationBar.tintColor = [UIColor whiteColor];
    
    [self presentViewController:Nav animated:YES completion:nil];
    
}

- (void)CameraBtnAction {
    
    
    NSLog(@"照相机");
}

//搜索
- (void)SearchAction{
    
    NSLog(@"搜索");
    
}

//扫一扫
- (void)scanButtonAction:(UIButton *)sender {
    
    NSLog(@"扫一扫");
    
    XYMScanViewController *ScanVc = [[XYMScanViewController alloc] init];
    ScanVc.hidesBottomBarWhenPushed = YES;
    
    [self.navigationController pushViewController:ScanVc animated:YES];
    
}

//消息
- (void)MsgAction:(UIButton *)sender {
    
    NSLog(@"消息");
    
    
    self.coversationListCtr.hidesBottomBarWhenPushed = YES;
    
    [self.navigationController pushViewController:self.coversationListCtr animated:YES];
    
    [JNSYHXHelper shareHelper].conversationListVc = self.coversationListCtr;
    
}


#define UIAlertDeleage

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    
    
    if (buttonIndex == 0) {
        
        
    }else {
        
        NSURL *url = [NSURL URLWithString:UIApplicationOpenSettingsURLString];
        
        //url = [NSURL URLWithString:@"prefs:root=LOCATION_SERVICES"];
        
        if ([[UIApplication sharedApplication] canOpenURL:url]) {
            [[UIApplication sharedApplication] openURL:url];
        }
        
    }
    
}


#define mark SDScorDeleage 

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    
    
    
}



//#define mark tableViewDeleage&&tableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    if (self.drugStoreArray.count >0) {
        return 5;
    }else {
        return 2;
    }
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *identy = @"identy";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identy];
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc] init];
        if (indexPath.row == 0) {
            cell.backgroundColor = ColorTableBack;
        }else if (indexPath.row == 1) {
            JNSYMeCommonCell *Cell = [[JNSYMeCommonCell alloc] init];
            Cell.leftLab.text = @"附近的药店";
            Cell.rightLab.text = @"更多";
            cell = Cell;
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        }else {
            
            NSDictionary *dic = self.drugStoreArray[(indexPath.row - 2)];
            
            JNSYSearchDrugStoreTableViewCell *Cell = [[JNSYSearchDrugStoreTableViewCell alloc] init];
            Cell.serviceArry = ([dic[@"shopService"] class] != [NSNull class])?[dic[@"shopService"] componentsSeparatedByString:@","]:nil;
            [Cell setUpViews];
            Cell.StoreNameLab.text = dic[@"shopName"];
            Cell.TimeLab.text = [NSString stringWithFormat:@"%@-%@",dic[@"startTime"],dic[@"endTime"]];
            Cell.RatingLab.text = [NSString stringWithFormat:@"评分:%@分",dic[@"shopScore"]];
            Cell.DistanceLab.text = [self setDistance:dic[@"distancen"]];
            Cell.PlaceLab.text = dic[@"shopAddress"];
            [Cell.StoreImg sd_setImageWithURL:[NSURL URLWithString:dic[@"picComp1"]]];
            cell = Cell;
        }
        
    }
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
    
}


//设置距离
- (NSString *)setDistance:(NSString *)distance {
    
    
    if (distance.length >= 4) {
        distance = [NSString stringWithFormat:@"%@km",[distance substringWithRange:NSMakeRange(0, distance.length - 3)]];
    }else {
        distance = [NSString stringWithFormat:@"%@m",distance];
    }
    
    return distance;
    
    
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.row == 0) {
        return 6;
    }else if (indexPath.row == 1) {
        return 40;
    }else {
        return 80;
    }
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.row == 1) {
        self.tabBarController.selectedViewController = [self.tabBarController.viewControllers objectAtIndex:1];
    }else {
        

        JNSYDrugStoreDetailViewController *DrugStoredetailVc = [[JNSYDrugStoreDetailViewController alloc] init];
        DrugStoredetailVc.hidesBottomBarWhenPushed = YES;
        //设置药店的shopID
        DrugStoredetailVc.shopId = [NSString stringWithFormat:@"%@",self.drugStoreArray[indexPath.row - 2][@"shopId"]];
        DrugStoredetailVc.shopName = [NSString stringWithFormat:@"%@",self.drugStoreArray[indexPath.row - 2][@"shopName"]];
        [self.navigationController pushViewController:DrugStoredetailVc animated:YES];
        
    }
    
}

- (void)viewWillDisappear:(BOOL)animated {
    
    //self.navigationController.navigationBar.translucent = YES;
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    
    
    [self.view endEditing:YES];
    
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
