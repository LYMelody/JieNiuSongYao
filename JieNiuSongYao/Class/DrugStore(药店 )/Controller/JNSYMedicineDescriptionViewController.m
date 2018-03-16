//
//  JNSYMedicineDescriptionViewController.m
//  JieNiuSongYao
//
//  Created by rongfeng on 2017/6/1.
//  Copyright © 2017年 China Zhou. All rights reserved.
//

#import "JNSYMedicineDescriptionViewController.h"
#import "Common.h"
#import "Masonry.h"
#import "JNSYAutoSize.h"
@interface JNSYMedicineDescriptionViewController ()

@end

@implementation JNSYMedicineDescriptionViewController


- (void)viewWillAppear:(BOOL)animated {
    
    [super viewWillAppear:animated];
    
    self.title = @"详情";
    
    self.view.backgroundColor = ColorTableBack;
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    UIScrollView *ScrollView = [[UIScrollView alloc] init];
    ScrollView.showsVerticalScrollIndicator = NO;
    ScrollView.backgroundColor = ColorTableBack;
    ScrollView.contentSize = CGSizeMake(KscreenWidth, KscreenHeight - ([JNSYAutoSize AutoHeight:(220 + 70 + 40 + 20 )]));
    [self.view addSubview:ScrollView];
    
    [ScrollView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view).offset([JNSYAutoSize AutoHeight:3]);
        make.left.right.equalTo(self.view);
        make.bottom.equalTo(self.view).offset([JNSYAutoSize AutoHeight:-50]);
    }];
    
    
    
    UIImageView *InfoBackImg = [[UIImageView alloc] init];
    InfoBackImg.backgroundColor = [UIColor whiteColor];

    [ScrollView addSubview:InfoBackImg];
    
    [InfoBackImg mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(ScrollView);
        make.right.left.equalTo(self.view);
        make.bottom.equalTo(self.view).offset([JNSYAutoSize AutoHeight:-50]);
    }];
    

    NSString *Name = [NSString stringWithFormat:@"商品名称：%@",self.MedicineName];
    NSString *Belong = [NSString stringWithFormat:@"品       牌：%@",self.MedicineBelong];
    NSString *Type = [NSString stringWithFormat:@"规       格：%@",self.MedicineType];
    NSString *Num = [NSString stringWithFormat:@"批准文号：%@",self.MedicineNum];
    NSString *Usage = [NSString stringWithFormat:@"用法用量：%@",self.MedicineUsage];
    NSString *Content = [NSString stringWithFormat:@"成       分：%@",self.MedicineContent];
    NSString *Fuction = [NSString stringWithFormat:@"功能主治：%@",self.MedicineFunction];
    
    
    UITextView *textView = [[UITextView alloc] init];
    textView.text = [NSString stringWithFormat:@"%@\n\n%@\n\n%@\n\n%@\n\n%@\n\n%@\n\n%@\n\n",Name,Belong,Type,Num,Usage,Content,Fuction];
    textView.font = [UIFont systemFontOfSize:12];
    textView.editable = NO;
    [InfoBackImg addSubview:textView];
    
    [textView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(InfoBackImg).offset([JNSYAutoSize AutoHeight:20]);
        make.left.equalTo(InfoBackImg).offset(20);
        make.right.equalTo(InfoBackImg).offset(-10);
        make.bottom.equalTo(InfoBackImg);
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
