//
//  JNSYAccountMessageViewController.m
//  JieNiuSongYao
//
//  Created by rongfeng on 2017/5/15.
//  Copyright © 2017年 China Zhou. All rights reserved.
//

#import "JNSYAccountMessageViewController.h"
#import "Common.h"
#import "JNSYAutoSize.h"
#import "JNSYUserInfo.h"
#import "IBHttpTool.h"
#import "SBJSON.h"
#import "JNSYHeaderTableViewCell.h"
#import "JNSYMeCommonCell.h"
#import "JNSYHeaderEditorViewController.h"
#import "JNSYNickNameViewController.h"
#import "JNSYSexSelectViewController.h"
#import "JNSYBornDateViewController.h"
#import "UIImageView+WebCache.h"


@interface JNSYAccountMessageViewController ()<UITableViewDelegate,UITableViewDataSource>


@end

@implementation JNSYAccountMessageViewController {
    NSUserDefaults *User;
    UITableView *table;
}

- (void)viewWillAppear:(BOOL)animated {
    
    [super viewWillAppear:animated];
    self.title = @"个人信息";
    self.view.backgroundColor = [UIColor whiteColor];
        //返回按钮
//    self.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"" style:UIBarButtonItemStylePlain target:self action:nil];
//    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
    [self.navigationController setNavigationBarHidden:NO animated:YES];
    self.tabBarController.tabBar.hidden = YES;
    
    User = [NSUserDefaults standardUserDefaults];
    //获取个人信息
    [self getAccountMsg];
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    table = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, KscreenWidth, KscreenHeight) style:UITableViewStylePlain];
    table.delegate = self;
    table.dataSource = self;
    table.backgroundColor = ColorTableBack;
    table.separatorStyle = UITableViewCellSeparatorStyleNone;
    table.showsVerticalScrollIndicator = NO;
    table.tableFooterView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 0, CGFLOAT_MIN)];
    
    
    [self.view addSubview:table];
    
    
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return 4;
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    
    static NSString *identy = @"identy";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identy];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] init];
        if (indexPath.row == 0) {
            JNSYHeaderTableViewCell *Cell = [[JNSYHeaderTableViewCell alloc] init];
            if ([JNSYUserInfo getUserInfo].picHeader) {
                [Cell.headImg sd_setImageWithURL:[NSURL URLWithString:[JNSYUserInfo getUserInfo].picHeader]];
            }else {
                Cell.headImg.image = [UIImage imageNamed:@"头像"];
            }
            cell = Cell;
            
        }else if (indexPath.row == 1) {
            JNSYMeCommonCell *Cell = [[JNSYMeCommonCell alloc] init];
            Cell.leftLab.text = @"昵称";
            NSString *NickName = [User objectForKey:@"NickName"];
            NickName = [JNSYUserInfo getUserInfo].userName;
            if (NickName) {
                Cell.rightLab.text = NickName;
            }else {
                Cell.rightLab.text = @"捷牛送药";
            }
            Cell.leftLab.textColor = [UIColor blackColor];
            Cell.leftLab.font = [UIFont systemFontOfSize:15];
            cell = Cell;
            
        }else if (indexPath.row == 2) {
            JNSYMeCommonCell *Cell = [[JNSYMeCommonCell alloc] init];
            Cell.leftLab.text = @"性别";
            Cell.leftLab.textColor = [UIColor blackColor];
            Cell.leftLab.font = [UIFont systemFontOfSize:15];
            Cell.rightLab.text = [[JNSYUserInfo getUserInfo].userSex integerValue]?@"男":@"女";
            cell = Cell;
            
        }else if (indexPath.row == 3) {
            JNSYMeCommonCell *Cell = [[JNSYMeCommonCell alloc] init];
            Cell.leftLab.text =@"出生年月";
            Cell.leftLab.textColor = [UIColor blackColor];
            Cell.leftLab.font = [UIFont systemFontOfSize:15];
            NSString *birthDay = [User objectForKey:@"BirthDay"];
            
            if (birthDay) {
                Cell.rightLab.text = birthDay;
            }else {
                Cell.rightLab.text = @"";
            }
            
            cell = Cell;
        }
        
    }
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    
    if (indexPath.row == 0) {
        return 70;
    }else
    {
        return 44;
    }
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    
    if (indexPath.row == 0) {
        JNSYHeaderEditorViewController *Vc = [[JNSYHeaderEditorViewController alloc] init];
        
//        Vc.changeHeadeImgBlock = ^{
//            [table reloadData];
//        };
        
//        if (_changeHeaderImgBlock) {
//            _changeHeaderImgBlock();
//        }
        self.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:Vc animated:YES];
        
    }else if (indexPath.row == 1) {
        JNSYNickNameViewController *NickVc = [[JNSYNickNameViewController alloc] init];
//        NickVc.changeNickBlock = ^{
//            [table reloadData];
//        };
        NickVc.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:NickVc animated:YES];
        
    }else if (indexPath.row == 2) {
        JNSYSexSelectViewController *SexvC = [[JNSYSexSelectViewController alloc] init];
//        SexvC.ChangeSexBlock = ^{
//            [tableView reloadData];
//        };
        SexvC.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:SexvC animated:YES];
    }else if (indexPath.row == 3) {
        
        JNSYBornDateViewController *BornDate = [[JNSYBornDateViewController alloc] init];
//        BornDate.changeBirthBlock = ^{
//            [table reloadData];
//        };
        BornDate.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:BornDate animated:YES];
        
    }

}


- (void)getAccountMsg {
    
    //时间戳
    NSString *timeSp = [JNSYAutoSize getTimeNow];
    
    NSDictionary *dic = @{
                          @"timestamp":timeSp
                          };
    NSString *action = @"UserBaseDetailState";
    
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
            
            [JNSYUserInfo getUserInfo].userCode = resultdic[@"userCode"];
            [JNSYUserInfo getUserInfo].userPhone = resultdic[@"userPhone"];
            [JNSYUserInfo getUserInfo].userName = resultdic[@"userName"];
            [JNSYUserInfo getUserInfo].shopStates = resultdic[@"shopStates"];
            [JNSYUserInfo getUserInfo].userAccount = resultdic[@"userAccount"];
            [JNSYUserInfo getUserInfo].userCert = resultdic[@"userKey"];
            [JNSYUserInfo getUserInfo].userSex = resultdic[@"sex"];
            [JNSYUserInfo getUserInfo].birthday = resultdic[@"birthday"];
            [JNSYUserInfo getUserInfo].addressInfo = resultdic[@"addressInfo"];
            [JNSYUserInfo getUserInfo].picHeader = resultdic[@"picHeader"];
            [JNSYUserInfo getUserInfo].lastIp = resultdic[@"lastIp"];
            [JNSYUserInfo getUserInfo].lastTime = resultdic[@"lastTime"];
            
            [table reloadData];
            
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
