//
//  JNSYBindCardListViewController.m
//  JieNiuSongYao
//
//  Created by rongfeng on 2017/7/3.
//  Copyright © 2017年 China Zhou. All rights reserved.
//

#import "JNSYBindCardListViewController.h"
#import "Common.h"
#import "JNSYUserInfo.h"
#import "JNSYAutoSize.h"
#import "JNSYBindCardDetailCell.h"
#import "SBJSON.h"
#import "IBHttpTool.h"
#import "MBProgressHUD.h"
@interface JNSYBindCardListViewController ()<UITableViewDelegate,UITableViewDataSource>

@end

@implementation JNSYBindCardListViewController {
    
    UITableView *table;
    NSMutableArray *CardList;
}

- (void)viewWillAppear:(BOOL)animated {
    
    [super viewWillAppear:animated];
    
    self.title = @"会员卡详情";
    self.view.backgroundColor = [UIColor whiteColor];
    
    CardList = [NSMutableArray arrayWithObjects:@"1", nil];
    
    
    [self getBindCardList];
}


- (void)viewDidLoad {
    [super viewDidLoad];
   
    table = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, KscreenWidth, KscreenHeight) style:UITableViewStylePlain];
    table.delegate = self;
    table.dataSource = self;
    table.separatorStyle = UITableViewCellSeparatorStyleNone;
    table.backgroundColor = ColorTableBack;
    [self.view addSubview:table];
    
}

//获取绑定银行卡列表
- (void)getBindCardList {
    
    NSString *timestamp = [JNSYAutoSize getTimeNow];
    
    NSDictionary *dic = @{
                          @"timestamp":timestamp
                          };
    
    NSString *action = @"UserCardListState";
    
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
        //刷新视图
        [table reloadData];
    } failure:^(NSError *error) {
        
        
    }];
    
}

//解除银行卡绑定
- (void)UnBindCard {
    
    MBProgressHUD *HUD = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    
    NSString *timestamp = [JNSYAutoSize getTimeNow];
    
    NSDictionary *dic = @{
                          @"timestamp":timestamp
                          };
    
    NSString *action = @"UserCardUnbindState";
    
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
            //去掉最后一条
            [CardList removeLastObject];
            [JNSYUserInfo getUserInfo].branderCardFlg = @"0";
            //取消HUD
            [HUD hide:YES];
            HUD.labelText = @"解除绑定成功!";
            //HUD.label.text = @"解除绑定成功!";
            HUD.mode = MBProgressHUDModeText;
           // [HUD showAnimated:YES];
            //[HUD hideAnimated:YES afterDelay:1.5];
            
            [HUD show:YES];
            [HUD hide:YES afterDelay:1.5];
            
            [self performSelector:@selector(back) withObject:nil afterDelay:1.5];
            
        }else {
            NSString *msg = resultdic[@"msg"];
            [JNSYAutoSize showMsg:msg];
        }
        //刷新视图
        [table reloadData];
    } failure:^(NSError *error) {
        
        
    }];
    
}

//返回上一级
- (void)back {
    
    [self.navigationController popViewControllerAnimated:YES];
    
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return CardList.count;
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *identy = @"identy";
    
    JNSYBindCardDetailCell *cell = [tableView dequeueReusableCellWithIdentifier:identy];
    
    if (cell == nil) {
        cell = [[JNSYBindCardDetailCell alloc] init];
        cell.CardNameLab.text = @"广发银行";
        cell.CardNumLab.text = [NSString stringWithFormat:@"已绑定(尾号%@)",[[JNSYUserInfo getUserInfo].branderCardNo substringFromIndex:([JNSYUserInfo getUserInfo].branderCardNo.length - 4)]];
        __weak typeof(self) weakSelf = self;
        cell.unBindCardBlock = ^{
            __strong typeof(self) strongSelf = weakSelf;
            //解除绑定
            [strongSelf UnBindCard];
            NSLog(@"解除绑定!");
        };
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
    
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    return 80;
    
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
