//
//  JNSYAboutUsViewController.m
//  JieNiuSongYao
//
//  Created by rongfeng on 2017/5/31.
//  Copyright © 2017年 China Zhou. All rights reserved.
//

#import "JNSYAboutUsViewController.h"
#import "Common.h"
#import "Masonry.h"
#import "JNSYAutoSize.h"
@interface JNSYAboutUsViewController ()

@end

@implementation JNSYAboutUsViewController


- (void)viewWillAppear:(BOOL)animated {
    
    [super viewWillAppear:animated];
    
    self.title = @"关于我们";
    
    self.view.backgroundColor = ColorTableBack;
    
    [self.navigationController setNavigationBarHidden:NO animated:YES];
    
    //self.navigationController.navigationBar.translucent = YES;
}


- (void)viewWillDisappear:(BOOL)animated {
    
    [super viewWillDisappear:animated];
    
    //self.navigationController.navigationBar.translucent = NO;
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.extendedLayoutIncludesOpaqueBars = NO;
    self.edgesForExtendedLayout = UIRectEdgeNone;
    
    UIScrollView *ScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, KscreenWidth, KscreenHeight - 64)];
    ScrollView.contentSize = CGSizeMake(KscreenWidth, (2272/640*KscreenWidth + [JNSYAutoSize AutoHeight:209]));
    [self.view addSubview:ScrollView];
    
    UIImageView *ImgView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"AboutUS"]];
    ImgView.userInteractionEnabled = YES;
    ImgView.backgroundColor = [UIColor orangeColor];
    ImgView.contentMode = UIViewContentModeScaleAspectFill;
    [ScrollView addSubview:ImgView];
    
    [ImgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(ScrollView);
        make.top.equalTo(ScrollView).offset([JNSYAutoSize AutoHeight:104]);
        make.width.mas_equalTo(KscreenWidth);
        make.height.mas_equalTo(2272/640*KscreenWidth);
    }];
    
    
    NSLog(@"%f,%f",ScrollView.frame.origin.y,ImgView.frame.origin.y);
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
