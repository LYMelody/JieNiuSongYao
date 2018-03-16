//
//  AppDelegate.m
//  JieNiuSongYao
//
//  Created by rongfeng on 2017/5/9.
//  Copyright © 2017年 China Zhou. All rights reserved.
//

#import "AppDelegate.h"
#import "JNSYMainViewController.h"
#import "JNSYDrugStoreViewController.h"
#import "ShopCarViewController.h"
#import "JNSYMyCornerViewController.h"
#import "Common.h"
#import "JNSYUserInfo.h"
#import "JNSYConversationListController.h"
#import "WelcomeViewController.h"
#import "JNSYMainBarController.h"
#import "AdvertiseView.h"
#import "SBJSON.h"
#import "IBHttpTool.h"
#import "JNSYAutoSize.h"
//蒲公英
#import <PgySDK/PgyManager.h>
#import <PgyUpdate/PgyUpdateManager.h>
#define PGYAPPID @"7ba5a794ca800ad1ebf40ae45a2de637"
//高德地图
#import <AMapFoundationKit/AMapFoundationKit.h>
//环信IM
  //,:git=> 'https://github.com/easemob/easeui-ios-hyphenate-cocoapods.git',:tag => '3.3.3'
//#import <Hyphenate/Hyphenate.h>
#import <HyphenateLite/HyphenateLite.h>
#import <EaseUI.h>
#import <UserNotifications/UserNotifications.h>
#import "JNSYHXHelper.h"
@interface AppDelegate ()<UNUserNotificationCenterDelegate>

@end

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
    
    //延迟1秒
    [NSThread sleepForTimeInterval:1];
    
    //启动蒲公英
    //[[PgyManager sharedPgyManager] startManagerWithAppId:PGYAPPID];
    //启动更新
    //[[PgyUpdateManager sharedPgyManager] startManagerWithAppId:PGYAPPID];
    //关闭反馈
    //[[PgyManager sharedPgyManager] setEnableFeedback:NO];
    
    //检测更新
    //[[PgyUpdateManager sharedPgyManager] checkUpdate];
    
    //高德地图
    [AMapServices sharedServices].apiKey = GaoDeKey;
    //开启ATS
    [AMapServices sharedServices].enableHTTPS = YES;
    
    [JNSYUserInfo getUserInfo].userKey = KEY;
    [JNSYUserInfo getUserInfo].userToken = TOKEN;
    
    
    [self SetUpControllers];
   
    //环信SDK
    EMOptions *options = [EMOptions optionsWithAppkey:HXAPPKEYNEW];
    options.apnsCertName = APNSCertName;
    EMError *error = [[EMClient sharedClient] initializeSDKWithOptions:options];
    
    if (!error) {
        NSLog(@"环信初始化成功~");
    }else {
        NSLog(@"环信初始化失败!");
    }
    
    [[EaseSDKHelper shareHelper] hyphenateApplication:application didFinishLaunchingWithOptions:launchOptions appkey:HXAPPKEYNEW apnsCertName:APNSCertName otherConfig:@{kSDKConfigEnableConsoleLogger:[NSNumber numberWithBool:YES]}];
    
    //注册离线APNS
    [self resignAPNS];
    
    /*     广告展示    */
    //判断沙河中是否存在图片，如果存在直接显示图片
    
    NSString *filePath = [self getFilePathWithImageName:[kUserDefaults valueForKey:adImageName]];
    
    BOOL isExist = [self isFileExistWithFilePath:filePath];
    
    AdvertiseView *advertiseView = [[AdvertiseView alloc] initWithFrame:[UIScreen mainScreen].bounds];

    if (isExist) { //图片存在展示图片
        
        advertiseView.filePath = filePath;
        
        [advertiseView show];
        
    }else {
        
        //下载默认广告图片
        
        NSString *defaultFilePath = [self getFilePathWithImageName:@"20122220201612322865.png"];
        
        BOOL exist = [self isFileExistWithFilePath:defaultFilePath];
        
        if (exist) {
            advertiseView.filePath = defaultFilePath;
            
            [advertiseView show];
        }else {
            
            //显示状态栏
            [[UIApplication sharedApplication] setStatusBarHidden:NO];
        
            NSData *data = [NSData dataWithContentsOfURL:[NSURL URLWithString:@"http://pic.paopaoche.net/up/2012-2/20122220201612322865.png"]];
            UIImage *image = [UIImage imageWithData:data];
            
            if ([UIImagePNGRepresentation(image) writeToFile:defaultFilePath atomically:YES]) {
//                //保存成功
//                filePath = defaultFilePath;
                
            }else {
                
            };
        }
    }
    
    //下载广告图片并缓存
    
    [self getAdvertisingImage];
    
    return YES;
}


- (void)resignAPNS {
    
    UIApplication *application = [UIApplication sharedApplication];
    
//    //iOS10 注册APNs
    if (NSClassFromString(@"UNUserNotificationCenter")) {
        [[UNUserNotificationCenter currentNotificationCenter] requestAuthorizationWithOptions:UNAuthorizationOptionBadge | UNAuthorizationOptionSound | UNAuthorizationOptionAlert completionHandler:^(BOOL granted, NSError *error) {
            if (granted) {
#if !TARGET_IPHONE_SIMULATOR
                [application registerForRemoteNotifications];
#endif
            }
        }];
        return;
    }
    
    if([application respondsToSelector:@selector(registerUserNotificationSettings:)])
    {
        UIUserNotificationType notificationTypes = UIUserNotificationTypeBadge | UIUserNotificationTypeSound | UIUserNotificationTypeAlert;
        UIUserNotificationSettings *settings = [UIUserNotificationSettings settingsForTypes:notificationTypes categories:nil];
        [application registerUserNotificationSettings:settings];
    }
    
#if !TARGET_IPHONE_SIMULATOR
    if ([application respondsToSelector:@selector(registerForRemoteNotifications)]) {
        [application registerForRemoteNotifications];
    }else{
        UIRemoteNotificationType notificationTypes = UIRemoteNotificationTypeBadge |
        UIRemoteNotificationTypeSound |
        UIRemoteNotificationTypeAlert;
        [[UIApplication sharedApplication] registerForRemoteNotificationTypes:notificationTypes];
    }
#endif
    
    
}


// 将得到的deviceToken传给SDK
- (void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken{
    [[EMClient sharedClient] bindDeviceToken:deviceToken];
}

// 注册deviceToken失败
- (void)application:(UIApplication *)application didFailToRegisterForRemoteNotificationsWithError:(NSError *)error{
    NSLog(@"error -- %@",error);
}

//关联四个控制器
- (void)SetUpControllers{
    
    
    
    self.window = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
    self.window.backgroundColor = ColorTabBarback;
    [self.window makeKeyAndVisible];
    
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent animated:YES];
    
    JNSYMainBarController *mainBarVc = [[JNSYMainBarController alloc] init];
    
    self.window.rootViewController = mainBarVc;
    
    
    NSUserDefaults *user = [NSUserDefaults standardUserDefaults];
    BOOL isfirst =  [user boolForKey:@"IsFirstLaunchAPP"];
    if (isfirst) {
        
        self.window.rootViewController = mainBarVc;
    }else {
        
        [user setBool:YES forKey:@"IsFirstLaunchAPP"];
        
        WelcomeViewController *welcomVc = [[WelcomeViewController alloc] init];
        self.window.rootViewController = welcomVc;
        
    }
    
}


#define mark 广告文件管理

/*      根据图片名拼接文件路径  */
- (NSString *)getFilePathWithImageName:(NSString *)imageName{
    
    if (imageName) {
        NSArray *paths = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES);
        NSString *filePath = [[paths objectAtIndex:0] stringByAppendingPathComponent:imageName];
        
        return filePath;
    }
    
    return nil;
    
}

/*     判断文件是否存在 */
-(BOOL)isFileExistWithFilePath:(NSString *)filePath {
    
    NSFileManager *fileManager = [NSFileManager defaultManager];
    BOOL isDirectory = FALSE;
    
    return [fileManager fileExistsAtPath:filePath isDirectory:&isDirectory];
    
}

//获取广告图片
- (void)getAdvertisingImage {
    
    // 这里原本采用美团的广告接口，现在了一些固定的图片url代替
    NSArray *imageArray = @[@"http://imgsrc.baidu.com/forum/pic/item/9213b07eca80653846dc8fab97dda144ad348257.jpg", @"http://pic.paopaoche.net/up/2012-2/20122220201612322865.png", @"http://img5.pcpop.com/ArticleImages/picshow/0x0/20110801/2011080114495843125.jpg", @"http://www.mangowed.com/uploads/allimg/130410/1-130410215449417.jpg"];
    NSString *imageUrl = imageArray[arc4random() % imageArray.count];
    imageUrl = @"http://pic.paopaoche.net/up/2012-2/20122220201612322865.png";
    // 获取图片名:43-130P5122Z60-50.jpg
    //NSArray *stringArr = [imageUrl componentsSeparatedByString:@"/"];
    NSString *imageName = @"20122220201612322865.png";
    
    // 拼接沙盒路径
    NSString *filePath = [self getFilePathWithImageName:imageName];
    BOOL isExist = [self isFileExistWithFilePath:filePath];
    if (!isExist){// 如果该图片不存在，则删除老图片，下载新图片
        
        [self downloadAdImageWithUrl:imageUrl imageName:imageName];
        
    }
}

/**
 *  下载新图片
 */
- (void)downloadAdImageWithUrl:(NSString *)imageUrl imageName:(NSString *)imageName
{
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        
        NSData *data = [NSData dataWithContentsOfURL:[NSURL URLWithString:imageUrl]];
        UIImage *image = [UIImage imageWithData:data];
        
        NSString *filePath = [self getFilePathWithImageName:imageName]; // 保存文件的名称
        
        if ([UIImagePNGRepresentation(image) writeToFile:filePath atomically:YES]) {// 保存成功
            NSLog(@"保存成功");
            [self deleteOldImage];
            [kUserDefaults setValue:imageName forKey:adImageName];
            [kUserDefaults synchronize];
            // 如果有广告链接，将广告链接也保存下来
        }else{
            NSLog(@"保存失败");
        }
        
    });
}

/**
 *  删除旧图片
 */
- (void)deleteOldImage
{
    NSString *imageName = [kUserDefaults valueForKey:adImageName];
    if (imageName) {
        NSString *filePath = [self getFilePathWithImageName:imageName];
        NSFileManager *fileManager = [NSFileManager defaultManager];
        [fileManager removeItemAtPath:filePath error:nil];
    }
}

#define notification 通知

//收到本地通知
- (void)application:(UIApplication *)application didReceiveLocalNotification:(UILocalNotification *)notification {
    
    
    
    
}

////收到远程消息
//- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo {
//    
//    
//    [[EaseSDKHelper shareHelper] hyphenateApplication:application didReceiveRemoteNotification:userInfo];
//    
//}


- (void)userNotificationCenter:(UNUserNotificationCenter *)center willPresentNotification:(UNNotification *)notification withCompletionHandler:(void (^)(UNNotificationPresentationOptions))completionHandler {
    
    
    NSDictionary *userInfo = notification.request.content.userInfo;
    
    [[EaseSDKHelper shareHelper] hyphenateApplication:[UIApplication sharedApplication] didReceiveRemoteNotification:userInfo];
    
    
}


- (void)userNotificationCenter:(UNUserNotificationCenter *)center didReceiveNotificationResponse:(UNNotificationResponse *)response withCompletionHandler:(void (^)())completionHandler
{
    
    completionHandler();
    
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
}


- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    
    
    [[EMClient sharedClient] applicationDidEnterBackground:application];
    
    
}


- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    
    [[EMClient sharedClient] applicationDidEnterBackground:application];
    
    
}


- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}


- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}


@end
