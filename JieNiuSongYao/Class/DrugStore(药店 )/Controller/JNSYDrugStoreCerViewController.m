//
//  JNSYDrugStoreCerViewController.m
//  JieNiuSongYao
//
//  Created by rongfeng on 2017/5/31.
//  Copyright © 2017年 China Zhou. All rights reserved.
//

#import "JNSYDrugStoreCerViewController.h"
#import "Common.h"
#import "Masonry.h"
#import "JNSYDrugDocerInfoTableViewCell.h"
#import "JNSYListHeaderTableViewCell.h"
#import "JNSYSearchLabTableViewCell.h"
#import "JNSYDouleLabTableViewCell.h"
#import "JNSYDrugDocCerImgTableViewCell.h"
#import "JNSYAutoSize.h"
#import "JNSYUserInfo.h"
#import "SBJSON.h"
#import "IBHttpTool.h"
#import "UIImageView+WebCache.h"
#import "SJAvatarBrowser.h"
#import "JNSYMapViewController.h"
@interface JNSYDrugStoreCerViewController ()<UITableViewDelegate,UITableViewDataSource>

@end

@implementation JNSYDrugStoreCerViewController {
    
    UITableView *table;
    
    
}

- (void)viewWillAppear:(BOOL)animated {
    
    [super viewWillAppear:animated];
    
    self.title = @"药店资质";
    self.view.backgroundColor = [UIColor whiteColor];
    
    NSLog(@"%@",self.shopId);
    
    
}

//获取药店详情
- (void)getDrugStoreInfo:(NSString *)shopiD {
    
    if (shopiD == nil || [shopiD isEqualToString:@""]) {
        
        [JNSYAutoSize showMsg:@"shopId为空!"];
        return;
    }
    
    
    NSDictionary *dic = @{
                          @"shopId":shopiD
                          };
    NSString *action = @"ShopInfoState";
    NSDictionary *requestDic = @{
                                 @"action":action,
                                 @"token":[JNSYUserInfo getUserInfo].userToken,
                                 @"data":dic
                                 };
    NSString *params = [requestDic JSONFragment];
    
    [IBHttpTool postWithURL:JNSYTestUrl params:params success:^(id result) {
        
        NSDictionary *resultdic = [result JSONValue];
        NSString *code = resultdic[@"code"];
        NSLog(@"%@,%@",resultdic,code);
        if([code isEqualToString:@"000000"]) {
            
            self.ShopInfoDic = resultdic;
            
            [table reloadData];
            
        }else {
            NSString *msg = resultdic[@"msg"];
            [JNSYAutoSize showMsg:msg];
        }
        
    } failure:^(NSError *error) {
        NSLog(@"%@",error);
    }];
}


- (void)viewDidLoad {
    [super viewDidLoad];
    
   
    //返回按钮
    self.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"" style:UIBarButtonItemStylePlain target:self action:nil];
    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
    
    table = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, KscreenWidth, KscreenHeight - 110) style:UITableViewStylePlain];
    table.delegate = self;
    table.dataSource = self;
    table.separatorStyle = UITableViewCellSeparatorStyleNone;
    table.backgroundColor = ColorTableBack;
    table.showsVerticalScrollIndicator = NO;
    
    [self.view addSubview:table];
    
    [self getDrugStoreInfo:self.shopId];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return 12;
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *identy = @"identy";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identy];
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc] init];
        if (indexPath.row == 0 || indexPath.row == 2 || indexPath.row == 6) {
            cell.backgroundColor = ColorTableBack;
        }else if (indexPath.row == 1) {
            JNSYDrugDocerInfoTableViewCell *Cell = [[JNSYDrugDocerInfoTableViewCell alloc] init];
            [Cell.HeaderImg sd_setImageWithURL:[NSURL URLWithString:self.ShopInfoDic[@"picComp1"]]];
            Cell.NameLab.text = [NSString stringWithFormat:@"联系人:%@",self.ShopInfoDic[@"shopAccount"]];
            Cell.TimeLab.text = [NSString stringWithFormat:@"营业时间:%@-%@",self.ShopInfoDic[@"startTime"],self.ShopInfoDic[@"endTime"]];
            Cell.PhoneLab.text = @"联系电话：18868888888";
            Cell.PlaceLab.text = [NSString stringWithFormat:@"地址:%@",self.ShopInfoDic[@"shopAddress"]];
            
            Cell.tapToMapViewBlock = ^(NSString *place) {
                
                JNSYMapViewController *mapView = [[JNSYMapViewController alloc] init];
                mapView.hidesBottomBarWhenPushed = YES;
                mapView.lat = self.ShopInfoDic[@"lat"];
                mapView.lng = self.ShopInfoDic[@"lng"];
                mapView.storeName = self.ShopInfoDic[@"shopName"];
                mapView.place = self.ShopInfoDic[@"shopAddress"];
                [self.navigationController pushViewController:mapView animated:YES];
            };
            
            
            cell = Cell;
        }else if (indexPath.row == 3){
            JNSYListHeaderTableViewCell *Cell = [[JNSYListHeaderTableViewCell alloc] init];
            Cell.leftLab.text = @"特色服务";
            cell = Cell;
        }else if (indexPath.row == 4) {
            JNSYSearchLabTableViewCell *Cell = [[JNSYSearchLabTableViewCell alloc] init];
            
            NSArray *array = [self.ShopInfoDic[@"shopService"] componentsSeparatedByString:@","];
            Cell.titleArray = [[NSMutableArray alloc] initWithArray:array];
            Cell.backgroundColor = [UIColor whiteColor];
            [Cell setUpViews];
            [Cell changeCellHeight];
            cell = Cell;
        }else if (indexPath.row == 5) {
            JNSYDouleLabTableViewCell *Cell = [[JNSYDouleLabTableViewCell alloc] init];
            Cell.LabOne.text = [NSString stringWithFormat:@"药师服务：%@分",self.ShopInfoDic[@"shopScore"]];
            Cell.LabTwo.text = [NSString stringWithFormat:@"订单服务：%@分",self.ShopInfoDic[@"shopScore"]];
            cell = Cell;
        }else if (indexPath.row == 6) {
            
        }else if (indexPath.row == 7) {
            JNSYListHeaderTableViewCell *Cell = [[JNSYListHeaderTableViewCell alloc] init];
            Cell.leftLab.text = @"药师资质";
            cell = Cell;
        }else if (indexPath.row == 8) {
            JNSYDrugDocCerImgTableViewCell *Cell = [[JNSYDrugDocCerImgTableViewCell alloc] init];
            Cell.magOutImgBlock = ^(UIImageView *img) {
                if (img.image) {
                    [SJAvatarBrowser showImage:img];
                }
                
            };
            Cell.TopLab.text = @"企业营业执照副本复印件";
            [Cell.CerImgView sd_setImageWithURL:[NSURL URLWithString:self.ShopInfoDic[@"picComp2"]]];
            cell = Cell;
        }else if (indexPath.row == 9) {
            JNSYDrugDocCerImgTableViewCell *Cell = [[JNSYDrugDocCerImgTableViewCell alloc] init];
            Cell.magOutImgBlock = ^(UIImageView *img) {
                if (img.image) {
                    [SJAvatarBrowser showImage:img];
                }
            };
            Cell.TopLab.text = @"医疗器械经营备案凭证";
            [Cell.CerImgView sd_setImageWithURL:[NSURL URLWithString:self.ShopInfoDic[@"picComp4"]]];
            cell = Cell;
        }else if (indexPath.row == 10) {
            JNSYDrugDocCerImgTableViewCell *Cell = [[JNSYDrugDocCerImgTableViewCell alloc] init];
            Cell.magOutImgBlock = ^(UIImageView *img) {
                if (img.image) {
                    [SJAvatarBrowser showImage:img];
                }
            };
            Cell.TopLab.text = @"药品经营许可证";
             [Cell.CerImgView sd_setImageWithURL:[NSURL URLWithString:self.ShopInfoDic[@"picComp3"]]];
            cell = Cell;
        }else if (indexPath.row == 11) {
            JNSYDrugDocCerImgTableViewCell *Cell = [[JNSYDrugDocCerImgTableViewCell alloc] init];
            Cell.magOutImgBlock = ^(UIImageView *img) {
                if (img.image) {
                    [SJAvatarBrowser showImage:img];
                }
            };
            Cell.TopLab.text = @"医疗器械经营许可证";
            [Cell.CerImgView sd_setImageWithURL:[NSURL URLWithString:self.ShopInfoDic[@"picComp5"]]];
            cell = Cell;
        }
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.row == 0 || indexPath.row == 2 || indexPath.row == 6) {
        return 3;
    }else if (indexPath.row == 1) {
        return 100;
    }else if (indexPath.row == 5) {
        return 60;
    }else if (indexPath.row == 8 || indexPath.row == 9 || indexPath.row == 10 || indexPath.row == 11) {
        return [JNSYAutoSize AutoHeight:160];
    }else if (indexPath.row == 4) {
        UITableViewCell *cell = [self tableView:tableView cellForRowAtIndexPath:indexPath];
        return cell.frame.size.height - 14;
    }
    else {
        return 44;
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
