//
//  JNSYDrugDocersViewController.m
//  JieNiuSongYao
//
//  Created by rongfeng on 2017/5/31.
//  Copyright © 2017年 China Zhou. All rights reserved.
//

#import "JNSYDrugDocersViewController.h"
#import "Common.h"
#import "Masonry.h"
#import "JNSYAutoSize.h"
#import "JNSYMeCommonCell.h"
#import "JNSYSearchLabTableViewCell.h"
#import "JNSYDrugDocCerImgTableViewCell.h"
#import "JNSYDoctorShotInfoTableViewCell.h"
#import "NewPagedFlowView.h"
#import "PGIndexBannerSubiew.h"
#import "JNSYEvateViewController.h"
#import "JNSYAutoSize.h"
#import "JNSYUserInfo.h"
#import "SBJSON.h"
#import "IBHttpTool.h"
#import "UIImageView+WebCache.h"
#import "JNSYMessageViewController.h"

#define HEIGHT KscreenWidth*9/16      //KscreenWidth*9/16


@interface JNSYDrugDocersViewController ()<UITableViewDelegate,UITableViewDataSource,NewPagedFlowViewDelegate,NewPagedFlowViewDataSource,UIAlertViewDelegate>

@property(nonatomic, strong)NSMutableArray *DocerList;

@property(nonatomic, copy)NSString *pharmacistsPic1;

@end

@implementation JNSYDrugDocersViewController {
    
    NSString *MsgStr;
    UITableView *table;
    NewPagedFlowView *pageFlowView;
    NSInteger currentPage;
    
    NSInteger NumOne;
    NSInteger NumTwo;
    NSInteger NumThree;
    NSInteger Numfour;
    NSInteger totalComment;
    
}

- (void)viewWillAppear:(BOOL)animated {
    
    [super viewWillAppear:animated];
    
    self.title = @"驻店药师";
    self.view.backgroundColor = [UIColor whiteColor];
    
    
    
    [table reloadData];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    [self setUpUI];
    
    currentPage = 0;
    
    
    
    
    table = [[UITableView alloc] initWithFrame:CGRectMake(0, (KscreenWidth*9/16 + 20), KscreenWidth, KscreenHeight - (HEIGHT + 130)) style:UITableViewStylePlain];
    table.delegate = self;
    table.dataSource = self;
    table.separatorStyle = UITableViewCellSeparatorStyleNone;
    table.showsVerticalScrollIndicator = NO;
    table.backgroundColor = ColorTableBack;
    
    [self.view addSubview:table];
    
    
    self.DocerList = [[NSMutableArray alloc] init];
    
    //获取药师列表
    [self getDocersList:self.shopId];
    
    

}

//获取药师列表
- (void)getDocersList:(NSString *)shopId {
    
    
    NSDictionary *dic = @{
                          @"shopId":shopId,
                          @"page":@"1",
                          @"size":@"5"
                          };
    NSString *action = @"ShopPharmacistsListState";
    
    NSDictionary *requestdic = @{
                          @"action":action,
                          @"token":[JNSYUserInfo getUserInfo].userToken,
                          @"data":dic
                          };
    NSString *params = [requestdic JSONFragment];
    
    [IBHttpTool postWithURL:JNSYTestUrl params:params success:^(id result) {
        NSLog(@"%@",result);
        NSDictionary *resultdic = [result JSONValue];
        NSString *code = resultdic[@"code"];
        NSLog(@"%@,%@",resultdic,code);
        if([code isEqualToString:@"000000"]) {
            
            NSArray *array = resultdic[@"pharmacistsList"];
            self.DocerList = [[NSMutableArray alloc] initWithArray:array];
//            //添加两次
//            [self.DocerList addObjectsFromArray:array];
//            [self.DocerList addObjectsFromArray:array];
            if (self.DocerList.count > 0) {
                [self getSingleDocInfo:[NSString stringWithFormat:@"%@",self.DocerList[0][@"pharmacistsId"]]];
            }
            
            [pageFlowView reloadData];
            
        }else {
            NSString *msg = resultdic[@"msg"];
            [JNSYAutoSize showMsg:msg];
        }

    } failure:^(NSError *error) {
         NSLog(@"%@",error);
    }];
    
}

//获取单个药师信息\

- (void)getSingleDocInfo:(NSString *)pharmacistsId {
    
    NSDictionary *dic = @{
                          @"pharmacistsId":pharmacistsId
                          };
    NSString *action = @"ShopPharmacistsDetailState";
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
            
            
            self.pharmacistsPic1 = resultdic[@"pharmacistsPic1"];
            
            //[table reloadData];
            //获取用户评价信息
            [self getdocerComment:pharmacistsId];
            
            
        }else {
            NSString *msg = resultdic[@"msg"];
            [JNSYAutoSize showMsg:msg];
        }
    } failure:^(NSError *error) {
        NSLog(@"%@",error);
    }];
    
}

//获取药师评论
- (void)getdocerComment:(NSString *)pharmacistsId {
    
    
    NSDictionary *dic = @{
                          @"pharmacistsId":pharmacistsId
                          };
    NSString *action = @"ShopPharmacistsCommentState";
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
            
            NSInteger tagOne = [resultdic[@"stsTag1"] integerValue];
            NSInteger tagTwo = [resultdic[@"stsTag2"] integerValue];
            NSInteger tagThree = [resultdic[@"stsTag3"] integerValue];
            NSInteger tagFour = [resultdic[@"stsTag4"] integerValue];
            NSInteger total = [resultdic[@"stsModerate"] integerValue] + [resultdic[@"stsNegative"] integerValue] + [resultdic[@"stsPositive"] integerValue];
            
            
            NumOne = tagOne;
            NumTwo = tagTwo;
            NumThree = tagThree;
            Numfour = tagFour;
            totalComment = total;
            
            [table reloadData];
            
        }else {
            NSString *msg = resultdic[@"msg"];
            [JNSYAutoSize showMsg:msg];
        }
    } failure:^(NSError *error) {
        NSLog(@"%@",error);
    }];
}


- (void)setUpUI {
    
    pageFlowView = [[NewPagedFlowView alloc] initWithFrame:CGRectMake(0, 5, KscreenWidth, HEIGHT)];
    //pageFlowView.backgroundColor = ColorTableBack;
    pageFlowView.delegate = self;
    pageFlowView.dataSource = self;
    pageFlowView.minimumPageAlpha = 0.1;
    pageFlowView.isCarousel = NO;
    pageFlowView.orientation = NewPagedFlowViewOrientationHorizontal;
    pageFlowView.isOpenAutoScroll = YES;
    
    //初始化pageControl
    UIPageControl *pageControl = [[UIPageControl alloc] initWithFrame:CGRectMake(0, pageFlowView.frame.size.height - 32, KscreenWidth, 8)];
    pageFlowView.pageControl = pageControl;
    //[pageFlowView addSubview:pageControl];
    
    /****************************
     使用导航控制器(UINavigationController)
     如果控制器中不存在UIScrollView或者继承自UIScrollView的UI控件
     请使用UIScrollView作为NewPagedFlowView的容器View,才会显示正常,如下
     *****************************/
    
    UIScrollView *bottomScrollView = [[UIScrollView alloc] initWithFrame:self.view.bounds];
    [bottomScrollView addSubview:pageFlowView];
    //bottomScrollView.backgroundColor = [UIColor redColor];
    [pageFlowView reloadData];
    
    [self.view addSubview:bottomScrollView];
    
    UIImageView *LineView = [[UIImageView alloc] init];
    LineView.backgroundColor = ColorTableBack;
    [bottomScrollView addSubview:LineView];
    
    [LineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(pageFlowView.mas_bottom).offset(8);
        make.left.right.equalTo(self.view);
        make.height.mas_equalTo([JNSYAutoSize AutoHeight:12]);
    }];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return 6;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *identy = @"identy";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identy];
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc] init];
        if (indexPath.row == 0) {
            JNSYMeCommonCell *Cell = [[JNSYMeCommonCell alloc] init];
            Cell.leftLab.text = @"用户评分：4.5分";
            Cell.rightLab.text = [NSString stringWithFormat:@"%ld条评论",(long)totalComment];
            cell = Cell;
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
            
        }else if (indexPath.row == 1) {
            
            JNSYSearchLabTableViewCell *Cell = [[JNSYSearchLabTableViewCell alloc] init];
            Cell.backgroundColor = [UIColor whiteColor];
            Cell.titleArray = [[NSMutableArray alloc] initWithObjects:[NSString stringWithFormat:@"服务态度好%ld",(long)NumOne],[NSString stringWithFormat:@"回复快%ld",(long)NumTwo],[NSString stringWithFormat:@"非常专业%ld",(long)NumThree],[NSString stringWithFormat:@"回答清楚%ld",(long)Numfour], nil];
            [Cell setUpViews];
            [Cell changeCellHeight];
            cell = Cell;
            
        }else if (indexPath.row == 2 || indexPath.row == 4) {
            cell.backgroundColor = ColorTableBack;
        }else if (indexPath.row == 3) {
            JNSYDoctorShotInfoTableViewCell *Cell = [[JNSYDoctorShotInfoTableViewCell alloc] init];
            Cell.TopLab.text = @"药师简介：";
            if (self.DocerList.count > 0) {
                Cell.InfoTextView.text = self.DocerList[currentPage][@"pharmacistsDesc"];
            }
            
            cell = Cell;
        
        }else if (indexPath.row == 5) {
            JNSYDrugDocCerImgTableViewCell *Cell = [[JNSYDrugDocCerImgTableViewCell alloc] init];
            Cell.TopLab.text = @"资格证书";
            [Cell.CerImgView sd_setImageWithURL:[NSURL URLWithString:self.pharmacistsPic1]];
            cell = Cell;
        }else {
            
        }
    }
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    return cell;
    
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.row == 2 || indexPath.row == 4) {
        return 3;
    }else if (indexPath.row == 0) {
        return 44;
    }else if (indexPath.row == 1) {
        UITableViewCell *cell = [self tableView:tableView cellForRowAtIndexPath:indexPath];
        return cell.frame.size.height;
    }else if (indexPath.row == 3) {
        CGFloat height = 0.0;
        height = [self heightForString:(self.DocerList.count > 0)?self.DocerList[currentPage][@"pharmacistsDesc"]:@"" Width:(KscreenWidth - 40)];
        
        return [JNSYAutoSize AutoHeight:(height + 40)];
    }else if (indexPath.row == 5) {
        return [JNSYAutoSize AutoHeight:160];
    }else {
        return 44;
    }
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    
    if (indexPath.row == 0) {  //评论
        JNSYEvateViewController *EvateVc = [[JNSYEvateViewController alloc] init];
        EvateVc.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:EvateVc animated:YES];
    }
    
}

#pragma mark NewPageFlowViewDataSource
- (NSInteger)numberOfPagesInFlowView:(NewPagedFlowView *)flowView {
    
    return self.DocerList.count;
}

- (UIView *)flowView:(NewPagedFlowView *)flowView cellForPageAtIndex:(NSInteger)index {
    
    PGIndexBannerSubiew *bannerView = (PGIndexBannerSubiew *)[flowView dequeueReusableCell];
    if (!bannerView) {
        bannerView = [[PGIndexBannerSubiew alloc] initWithFrame:CGRectMake(0, 0, KscreenWidth, HEIGHT)];
        NSDictionary *Docer = self.DocerList[index];
        if (self.DocerList.count > 0) {
            [bannerView.headerView sd_setImageWithURL:[NSURL URLWithString:Docer[@"pharmacistsPic1"]]];
            bannerView.NameLab.text = Docer[@"pharmacistsName"];
            bannerView.CerNameLab.text = [Docer[@"pharmacistsType"] isEqual:@1]?@"资质名称:执业药师中医证书":@"资质名称:执业药师西医证书";
            bannerView.CerNumLab.text = [NSString stringWithFormat:@"资格证书:%@",Docer[@"pharmacistsMerno"]];
            bannerView.ResignNumLab.text = [NSString stringWithFormat:@"注册证号:%@",Docer[@"pharmacistsCertificate"]];
            bannerView.PhoneLab.text = [NSString stringWithFormat:@"联系电话:%@",Docer[@"pharmacistsPhone"]];
            bannerView.ConnectTimesLab.text = [NSString stringWithFormat:@"咨询人次:%@",Docer[@"advisory"]];
            bannerView.RatingLab.text = [NSString stringWithFormat:@"评分:%@",Docer[@"score"]];
        }
        
        bannerView.backgroundColor = ColorTableBack;
        bannerView.tag = index;
        bannerView.layer.cornerRadius = 4;
        bannerView.layer.masksToBounds = YES;
        
        //环信
        
        
        bannerView.consultActionBlock = ^{
            
            NSString *imName = Docer[@"imUser"];
            NSString *title = Docer[@"pharmacistsName"];
            NSString *imageUrl = Docer[@"pharmacistsPic1"];
            JNSYMessageViewController *messageVc = [[JNSYMessageViewController alloc] initWithConversationChatter:imName conversationType:EMConversationTypeChat];
            messageVc.title = title;
            messageVc.imageURL = imageUrl;
            messageVc.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:messageVc animated:YES];
            
           // NSLog(@"咨询");
        };
        bannerView.phoneCallActionBlock = ^{
            NSLog(@"打电话");
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:[NSString stringWithFormat:@"确认拨打电话:%@",Docer[@"pharmacistsPhone"]] delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确认", nil];
            alert.delegate = self;
            alert.tag = 100;
            [alert show];
        };
    }
    
    return bannerView;
}

- (void)didScrollToPage:(NSInteger)pageNumber inFlowView:(NewPagedFlowView *)flowView {
    
    currentPage = pageNumber;
    
    [self getSingleDocInfo:[NSString stringWithFormat:@"%@",self.DocerList[pageNumber][@"pharmacistsId"]]];
    
    //[table reloadData];
    NSLog(@"刷新");
}


#define mark UIAlertViewDeleage
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    
    if (alertView.tag == 100) {
        if (buttonIndex == 1) {
            
            
            //拨打电话
            NSMutableString *phoneStr = [[NSMutableString alloc] initWithFormat:@"telprompt://%@",[alertView.message substringFromIndex:7]];
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:phoneStr]];
            
        }else {
            
            
        }
    }
    
}

- (float)heightForStr:(UITextView *)textView Width:(float)width {
    
    CGSize sizetofit = [textView sizeThatFits:CGSizeMake(width, MAXFLOAT)];
    if (sizetofit.height < [JNSYAutoSize AutoHeight:30]) {
        return [JNSYAutoSize AutoHeight:30];
    }
    return sizetofit.height;
    
}

- (float)heightForString:(NSString *)str Width:(CGFloat)width {
    
    NSMutableParagraphStyle *style = [[NSMutableParagraphStyle alloc] init];
    [style setLineSpacing:2.0];
    
    NSDictionary *dic = @{
                          NSFontAttributeName:[UIFont systemFontOfSize:13],
                          NSParagraphStyleAttributeName:style
                          };
    //计算文本大小
    CGSize size = [str boundingRectWithSize:CGSizeMake(width, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading attributes:dic context:nil].size;
    //NSLog(@"%f",size.height);
    //
    return size.height + [JNSYAutoSize AutoHeight:10];
    
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
