//
//  JNSYReceivePlaceViewController.m
//  JieNiuSongYao
//
//  Created by rongfeng on 2017/5/16.
//  Copyright © 2017年 China Zhou. All rights reserved.
//

#import "JNSYReceivePlaceViewController.h"
#import "Common.h"
#import "Masonry.h"
#import "JNSYReceivePlaceTableViewCell.h"
#import "JNSYPlaceAddAndEditorViewController.h"
#import "JNSYAutoSize.h"
#import "JNSYUserInfo.h"
#import "SBJSON.h"
#import "IBHttpTool.h"
#import "MBProgressHUD.h"

@interface JNSYReceivePlaceViewController ()<UITableViewDelegate,UITableViewDataSource,UIAlertViewDelegate>

@end

@implementation JNSYReceivePlaceViewController {
    
    JNSYPlaceAddAndEditorViewController *PlaceVc;
    UIAlertView *AlertView;
    NSMutableArray *placeList;
    UITableView *table;
    NSString *_currentAddress;
}

- (void)viewWillAppear:(BOOL)animated {
    
    [super viewWillAppear:animated];
    
    self.title = @"收货地址";
    self.view.backgroundColor = [UIColor whiteColor];
    [self.navigationController setNavigationBarHidden:NO animated:YES];
    
    //返回按钮
    self.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"" style:UIBarButtonItemStylePlain target:self action:nil];
    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
    
    //获取地址列表
    [self getPlaceList];
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    table = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, KscreenWidth, KscreenHeight - 46) style:UITableViewStylePlain];
    table.delegate = self;
    table.dataSource = self;
    table.backgroundColor = ColorTableBack;
    table.separatorStyle = UITableViewCellSeparatorStyleNone;
    table.showsVerticalScrollIndicator = NO;
    table.tableFooterView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 0, CGFLOAT_MIN)];
    
    [self.view addSubview:table];
    
    
    UIButton *AddBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [AddBtn setBackgroundImage:[UIImage imageNamed:@"ADD"] forState:UIControlStateNormal];
    [AddBtn addTarget:self action:@selector(ADDaction) forControlEvents:UIControlEventTouchUpInside];
    
    [self.view addSubview:AddBtn];
    
    [AddBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.equalTo(self.view);
        make.height.mas_equalTo(46);
    }];
    
    
    
    
    AlertView = [[UIAlertView alloc] initWithTitle:nil message:@"确认删除该地址" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
}

//添加新地址
- (void)ADDaction {
    
    NSLog(@"添加新地址");
    
    JNSYPlaceAddAndEditorViewController *AddPlaceVc = [[JNSYPlaceAddAndEditorViewController alloc] init];
    AddPlaceVc.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:AddPlaceVc animated:YES];
    
    
}

//获取地址列表
- (void)getPlaceList {
    
    NSString *timestamp = [JNSYAutoSize getTimeNow];
    
    NSDictionary *dic = @{
                          @"timestamp":timestamp
                          };
    
    NSString *action = @"UserAddressListState";
    
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
            
            NSArray *addressArray = resultdic[@"addressList"];
            
            placeList = [[NSMutableArray alloc] initWithArray:addressArray];
            
            [table reloadData];
            
        }else {
            NSString *msg = resultdic[@"msg"];
            [JNSYAutoSize showMsg:msg];
        }
        
    } failure:^(NSError *error) {
        
        //[JNSYAutoSize showMsg:error];
    }];

}

//设置地址为默认地址
- (void)setDefaultPlace:(NSDictionary *)placeInfo {
    
    NSLog(@"设置默认地址");
    
    MBProgressHUD *HUD = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    
    NSDictionary *dic = @{
                          @"addressId":[NSString stringWithFormat:@"%@",placeInfo[@"addressId"]],
                          @"addressAccount":placeInfo[@"addressAccount"],
                          @"addressPhone":placeInfo[@"addressPhone"],
                          @"addressInfo":placeInfo[@"addressInfo"],
                          @"addressDefault":@"1",
                          @"longitude":@"",
                          @"latitude":@""
                          };
    NSString *action = @"UserAddressEditState";
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
            
            //[HUD hideAnimated:YES afterDelay:1];
            [HUD hide:YES afterDelay:1];
            //更新地址列表
            [self getPlaceList];
            
        }else {
            NSString *msg = resultdic[@"msg"];
            [JNSYAutoSize showMsg:msg];
           // [HUD hideAnimated:YES];
            [HUD hide:YES];
        }
        
    } failure:^(NSError *error) {
        //[HUD hideAnimated:YES];
        [HUD hide:YES];
    }];
}

//删除地址
- (void)delectPlace:(NSString *)addressId {
    
    MBProgressHUD *HUD = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    
    NSDictionary *dic = @{
                         @"addressId":addressId
                        };
    NSString *action = @"UserAddressDelState";
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
            
           // [HUD hideAnimated:YES afterDelay:1];
            
            [HUD hide:YES afterDelay:1];
            
            //更新地址列表
            [self getPlaceList];
            
        }else {
            NSString *msg = resultdic[@"msg"];
            [JNSYAutoSize showMsg:msg];
            //[HUD hideAnimated:YES];
            [HUD hide:YES];
        }
    } failure:^(NSError *error) {
       // [HUD hideAnimated:YES];
        [HUD hide:YES];
    }];
    
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return (placeList.count*2 - 1) ;
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *identy = @"identy";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identy];
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc] init];
        if (indexPath.row % 2 == 1) {
            cell.backgroundColor = ColorTableBack;
        }else {
            JNSYReceivePlaceTableViewCell *Cell = [[JNSYReceivePlaceTableViewCell alloc] init];
            Cell.NameLab.text = placeList[(indexPath.row + 1)/2][@"addressAccount"];
            NSString *phone = placeList[(indexPath.row + 1)/2][@"addressPhone"];
            if (phone.length >= 7) {
                Cell.PhoneLab.text = [phone stringByReplacingCharactersInRange:NSMakeRange(3, 4) withString:@"****"];
            }else {
                Cell.PhoneLab.text = phone;
            }
            
            Cell.PlaceLab.text = placeList[(indexPath.row + 1)/2][@"addressInfo"];
            
            NSString *isDefault = [NSString stringWithFormat:@"%@",placeList[(indexPath.row + 1)/2][@"addressDefault"]];
            
            if ([isDefault isEqualToString:@"1"]) { //是否是默认地址
                Cell.SetDefaultBtn.selected = YES;
            }else {
                 Cell.SetDefaultBtn.selected = NO;
            }
            //编辑地址
            Cell.editorPlaceBlock = ^{
                PlaceVc = [[JNSYPlaceAddAndEditorViewController alloc] init];
                
                PlaceVc.placeInfoDic = placeList[(indexPath.row + 1)/2];
                PlaceVc.tag = 2;  //设置tag值
                PlaceVc.hidesBottomBarWhenPushed = YES;
                [self.navigationController pushViewController:PlaceVc animated:YES];
            };
            //删除地址
            Cell.delectPlaceBlock = ^{
                _currentAddress =  [NSString stringWithFormat:@"%@",placeList[(indexPath.row + 1)/2][@"addressId"]];
                [AlertView show];
            };
            
            //点击设置为默认地址
            Cell.setDefaultBlock = ^{
                
                if ([isDefault isEqualToString:@"1"]) {
                    NSLog(@"已是默认地址");
                }else {
                    [self setDefaultPlace:placeList[(indexPath.row + 1)/2]];
                }
            
            };
            
            cell = Cell;
        }
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}



- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    
    
    if (buttonIndex == 1) {
        [self delectPlace:_currentAddress];
    }
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.row %2 == 1) {
        return 10;
    }else {
        return 105;
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
