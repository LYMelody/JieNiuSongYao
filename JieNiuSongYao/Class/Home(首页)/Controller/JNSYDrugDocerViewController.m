//
//  JNSYDrugDocerViewController.m
//  JieNiuSongYao
//
//  Created by rongfeng on 2017/5/31.
//  Copyright © 2017年 China Zhou. All rights reserved.
//

#import "JNSYDrugDocerViewController.h"
#import "Common.h"
#import "JNSYAutoSize.h"
#import "JNSYUserInfo.h"
#import "SBJSON.h"
#import "IBHttpTool.h"
#import "JNSYDocersCell.h"
#import "JNSYMessageViewController.h"
@interface JNSYDrugDocerViewController ()<UITableViewDelegate,UITableViewDataSource>

@end

@implementation JNSYDrugDocerViewController {
    
    UITableView *table;
    NSArray *docerList;
    
}

- (void)viewWillAppear:(BOOL)animated {
    
    [super viewWillAppear:animated];
    
    self.title = @"药师服务";
    self.view.backgroundColor = [UIColor whiteColor];
    
    [self.navigationController setNavigationBarHidden:NO animated:YES];
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    docerList = [[NSArray alloc] init];
    
    //返回按钮
    self.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"" style:UIBarButtonItemStylePlain target:self action:nil];
    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
    
    table = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, KscreenWidth, KscreenHeight - 64) style:UITableViewStylePlain];
    table.delegate = self;
    table.dataSource = self;
    table.tableFooterView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 0, CGFLOAT_MIN)];
    table.tableHeaderView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 0, CGFLOAT_MIN)];
    table.backgroundColor = ColorTableBack;
    table.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:table];
    
    [self getDocersInfo];
    
}


- (void)getDocersInfo {
    
    
    NSDictionary *dic = @{
                          @"lng":[NSString stringWithFormat:@"%f",self.location.coordinate.longitude],
                          @"lat":[NSString stringWithFormat:@"%f",self.location.coordinate.latitude],
                          @"page":@"1",
                          @"size":@"10"
                          };
    NSString *action = @"SearchPharmacistsState";
    NSDictionary *requestDic = @{
                                 @"action":action,
                                 @"token":[JNSYUserInfo getUserInfo].userToken,
                                 @"data":dic
                                 };
    NSString *params = [requestDic JSONFragment];
    
    [IBHttpTool postWithURL:JNSYTestUrl params:params success:^(id result) {
       
        NSDictionary *resultdic = [result JSONValue];
        NSString *code = resultdic[@"code"];
        if([code isEqualToString:@"000000"]) {
            
            docerList = resultdic[@"pharmacistsList"];
            [table reloadData];
            
        }else {
            
            NSString *msg = resultdic[@"msg"];
            [JNSYAutoSize showMsg:msg];
        }
    } failure:^(NSError *error) {
        NSLog(@"%@",error);
    }];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return docerList.count*2 - 1;
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *identy = @"identy";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identy];
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc] init];
        
        if (indexPath.row %2 == 1) {
            
            cell.backgroundColor = ColorTableBack;
        }else {
            
            JNSYDocersCell *DocerCell = [[JNSYDocersCell alloc] init];
            DocerCell.consultBlock = ^{
                
                NSString *imName = docerList[(indexPath.row ) / 2][@"imUser"];
                
                if([imName hasPrefix:@"ys"] || [imName hasPrefix:@"YS"]) {
                    
                    imName = [imName substringFromIndex:2];
                    
                }
                
                if ([JNSYUserInfo getUserInfo].isLoggedIn) {
                    
                    //环信会话
                    JNSYMessageViewController *messageVc = [[JNSYMessageViewController alloc] initWithConversationChatter:imName conversationType:EMConversationTypeChat];
                    messageVc.title = docerList[(indexPath.row ) / 2][@"pharmacistsName"];;
                    messageVc.imageURL = docerList[(indexPath.row ) / 2][@"pharmacistsPic1"];;
                    messageVc.hidesBottomBarWhenPushed = YES;
                    [self.navigationController pushViewController:messageVc animated:YES];
                    
                }else {
                    
                    [JNSYAutoSize showMsg:@"请先登录捷牛送药!"];
                    
                }
            };
            [DocerCell configDocerInfo:docerList[(indexPath.row ) / 2]];
            cell = DocerCell;
            
        }
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    
    if (indexPath.row%2 == 1) {
        return 5;
    }
    
    return 130;
    
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
