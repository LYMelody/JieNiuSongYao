//
//  JNSYNickNameViewController.m
//  JieNiuSongYao
//
//  Created by rongfeng on 2017/5/15.
//  Copyright © 2017年 China Zhou. All rights reserved.
//

#import "JNSYNickNameViewController.h"
#import "Common.h"
#import "Masonry.h"
#import "JNSYUserInfo.h"
#import "JNSYAutoSize.h"
#import "IBHttpTool.h"
#import "SBJSON.h"
#import "JNSYCommenMethods.h"
@interface JNSYNickNameViewController ()<UITextFieldDelegate>

@end

@implementation JNSYNickNameViewController {
    
    NSUserDefaults *User;
    
}

- (void)viewWillAppear:(BOOL)animated {
    
    [super viewWillAppear:animated];
    self.title = @"昵称";
    self.view.backgroundColor = [UIColor whiteColor];
    [self.navigationController setNavigationBarHidden:NO animated:YES];
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    User = [NSUserDefaults standardUserDefaults];
    
    UIImageView *BackImg = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, KscreenWidth, KscreenHeight)];
    BackImg.backgroundColor = ColorTableBack;
    BackImg.userInteractionEnabled = YES;
    [self.view addSubview:BackImg];
    
    UILabel *lab = [[UILabel alloc] init];
    lab.frame = CGRectMake(0, 0, 70, 30);
    lab.font = [UIFont systemFontOfSize:15];
    lab.text = @"昵称";
    lab.textAlignment = NSTextAlignmentCenter;
    
    UITextField *Text = [[UITextField alloc] init];
    Text.backgroundColor = [UIColor whiteColor];
    Text.font = [UIFont systemFontOfSize:15];
    Text.placeholder = @"请输入昵称";
    Text.leftView = lab;
    Text.leftViewMode = UITextFieldViewModeAlways;
    Text.clearButtonMode = UITextFieldViewModeAlways;
    Text.delegate = self;
    
    NSString *NickName = [User objectForKey:@"NickName"];
    NickName = [JNSYUserInfo getUserInfo].userName;
    if (NickName) {
        Text.text = NickName;
    }else {
        Text.text = @"捷牛送药";
    }
    
    //[Text becomeFirstResponder];
    [BackImg addSubview:Text];
    
    [Text mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view).offset(10+64);
        make.left.right.equalTo(self.view);
        make.height.mas_equalTo(40);
    }];
    
    
}

- (void)KeepAction {
    
    NSLog(@"keep");
    
}

- (void)textFieldDidEndEditing:(UITextField *)textField {
    
    if (textField.text.length <= 0) {
        
        NSLog(@"没有输入昵称，请重新输入");
    }else {
        
        
        [JNSYCommenMethods UpLoadUserPicHeader:nil userSex:nil birthday:nil userName:textField.text];
        
        [User setObject:textField.text forKey:@"NickName"];
        [User synchronize];
        
        if (_changeNickBlock) {
            _changeNickBlock();
        }
        
        NSLog(@"昵称:%@",textField.text);
    }
    
}

- (void)upDateUserNickName {
    
    
    
    
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
