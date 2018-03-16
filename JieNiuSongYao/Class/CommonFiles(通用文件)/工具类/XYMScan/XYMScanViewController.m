//
//  XYMScanViewController.m
//  healthcoming
//
//  Created by jack xu on 16/11/15.
//  Copyright © 2016年 Franky. All rights reserved.
//

#define ScreenWidth [UIScreen mainScreen].bounds.size.width
#define ScreenHeight [UIScreen mainScreen].bounds.size.height

#import "XYMScanViewController.h"
#import "XYMScanView.h"
#import <AVFoundation/AVFoundation.h>
#import "ScanResultViewController.h"
#import "SBJSON.h"
#import "IBHttpTool.h"
#import "JNSYAutoSize.h"
#import "JNSYUserInfo.h"
#import "Common.h"
@interface XYMScanViewController ()<XYMScanViewDelegate>
{
    int line_tag;
    UIView *highlightView;
    NSString *scanMessage;
    BOOL isRequesting;
}

@property (nonatomic,weak) XYMScanView *scanV;

@end

@implementation XYMScanViewController

- (void)viewWillAppear:(BOOL)animated {
    
    [super viewWillAppear:animated];
    
    [self.navigationController setNavigationBarHidden:NO animated:YES];
    
    //返回按钮
    self.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"" style:UIBarButtonItemStylePlain target:self action:nil];
    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
    self.navigationController.navigationBar.translucent = YES;
    
    
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName:[UIColor whiteColor],NSFontAttributeName:[UIFont systemFontOfSize:18]}];
    
    self.title = @"扫描二维码";
    
    self.view.backgroundColor = [UIColor whiteColor];
}


- (void)viewDidLoad {
    
    [super viewDidLoad];;

    XYMScanView *scanV = [[XYMScanView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight)];
    scanV.delegate = self;
    [self.view addSubview:scanV];
    _scanV = scanV;

}

//获取到二维码信息
-(void)getScanDataString:(NSString*)scanDataString{

    NSLog(@"二维码内容：%@",scanDataString);
    
    //获取药品信息
    [self getMedicineInfo:scanDataString];
    
    
    ScanResultViewController *scanResultVC = [[ScanResultViewController alloc]init];
    scanResultVC.view.backgroundColor = [UIColor whiteColor];
    scanResultVC.view.frame = CGRectMake(0, 0, ScreenWidth, ScreenHeight);
    scanResultVC.scanDataString = scanDataString;
    [self.navigationController pushViewController:scanResultVC animated:YES];
}

//查询药品信息
- (void)getMedicineInfo:(NSString *)scanData {
    
    NSDictionary *dic =@{
                         @"code":scanData
                         };
    NSString *action = @"MedicinesScanState";
    
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
            
            
            
            
        }else {
            NSString *msg = resultdic[@"msg"];
            [JNSYAutoSize showMsg:msg];
        }

    } failure:^(NSError *error) {
        NSLog(@"%@",error);
    }];
    
    
}



@end
