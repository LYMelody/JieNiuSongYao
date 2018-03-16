//
//  JNSYMedicineDetailViewController.m
//  JieNiuSongYao
//
//  Created by rongfeng on 2017/6/1.
//  Copyright © 2017年 China Zhou. All rights reserved.
//

#import "JNSYMedicineDetailViewController.h"
#import "Common.h"
#import "Masonry.h"
#import "JNSYMedicineDescriptionViewController.h"
#import "JNSYEvateViewController.h"
#import "JNSYAutoSize.h"
#import "CNPPopupController.h"
#import "MedicineInfoView.h"
#import "SDCycleScrollView.h"
#import "JNSYAutoSize.h"
#import "JNSYUserInfo.h"
#import "SBJSON.h"
#import "IBHttpTool.h"
#import "MBProgressHUD.h"
#import "JNShopCarCountView.h"
#import "UIImageView+WebCache.h"
@interface JNSYMedicineDetailViewController ()<UIGestureRecognizerDelegate,CNPPopupControllerDelegate,SDCycleScrollViewDelegate,UITextFieldDelegate>

@property (nonatomic, strong)CNPPopupController *popCtr;

@end

@implementation JNSYMedicineDetailViewController {
    
    UIImageView *MedicineInfoBackImg;
    UILabel *CollectLab;
    MedicineInfoView *medicineInfoView;
    UIButton *CollectBtn;
    NSInteger MedicineCount;
    JNShopCarCountView *CountView;
}

- (void)viewWillAppear:(BOOL)animated {
    
    [super viewWillAppear:animated];
    
    self.title = @"药品详情";
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    [self.navigationController setNavigationBarHidden:YES animated:YES];
    
    self.navigationController.interactivePopGestureRecognizer.delegate = self;
}


- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    //药品展示图片
//    UIImageView *MedicineImgView = [[UIImageView alloc] init];
//    MedicineImgView.backgroundColor = [UIColor grayColor];
//    
//    [self.view addSubview:MedicineImgView];
    
    NSArray *imgaeArray = [NSArray arrayWithObjects:[UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:self.medicineModel.medicinesPic1]]],[UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:self.medicineModel.medicinesPic2]]],[UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:self.medicineModel.medicinesPic3]]],[UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:self.medicineModel.medicinesPic4]]],[UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:self.medicineModel.medicinesPic5]]], nil];
    
    SDCycleScrollView *ADScrollView = [SDCycleScrollView cycleScrollViewWithFrame:CGRectMake(0, 64, KscreenWidth, [JNSYAutoSize AutoHeight:160]) shouldInfiniteLoop:YES imageNamesGroup:imgaeArray];
    
    ADScrollView.delegate = self;
    ADScrollView.pageControlStyle = SDCycleScrollViewPageContolStyleAnimated;
    [self.view addSubview:ADScrollView];
    
    ADScrollView.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    self.automaticallyAdjustsScrollViewInsets = NO;
    ADScrollView.autoScrollTimeInterval = 5;
    [self.view addSubview:ADScrollView];
    
    [ADScrollView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.equalTo(self.view);
        make.height.mas_equalTo([self AutoHeight:220]);
    }];
    
    
    //药品简单信息
    MedicineInfoBackImg = [[UIImageView alloc] init];
    MedicineInfoBackImg.backgroundColor = [UIColor clearColor];
    MedicineInfoBackImg.userInteractionEnabled = YES;
    [self.view addSubview:MedicineInfoBackImg];
    
    [MedicineInfoBackImg mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(ADScrollView.mas_bottom);
        make.right.left.equalTo(self.view);
        make.height.mas_equalTo([self AutoHeight:70]);
    }];
    
    //创建药品基本信息
    [self CreateMedicineShortInfoViews];
    
    
    //分割线
    UIImageView *SeprateLine = [[UIImageView alloc] init];
    SeprateLine.backgroundColor = ColorTableBack;
    [self.view addSubview:SeprateLine];
    
    [SeprateLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(MedicineInfoBackImg.mas_bottom);
        make.left.right.equalTo(self.view);
        make.height.mas_equalTo([JNSYAutoSize AutoHeight:3]);
    }];
    
    
    //self.segmentControl.frame = CGRectMake(0, [self AutoHeight:303], KscreenWidth, 44);
    //返回按钮
    UIButton *BackBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [BackBtn setImage:[UIImage imageNamed:@"buy_view_back"] forState:UIControlStateNormal];
    [BackBtn addTarget:self action:@selector(BackAction) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:BackBtn];
    
    [BackBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view).offset([self AutoHeight:30]);
        make.left.equalTo(self.view).offset(10);
        make.width.height.mas_equalTo([self AutoHeight:30]);
    }];
    
    //药品详情
    JNSYMedicineDescriptionViewController *MedicinDes = [[JNSYMedicineDescriptionViewController alloc] init];
    MedicinDes.title = @"详情";
    MedicinDes.MedicineName = self.medicineModel.medicinesName;
    MedicinDes.MedicineBelong = self.medicineModel.medicinesBrand;
    MedicinDes.MedicineType = self.medicineModel.medicinesSpecifications;
    MedicinDes.MedicineNum = self.medicineModel.medicinesLicense;
    MedicinDes.MedicineUsage = self.medicineModel.medicinesUsage;
    MedicinDes.MedicineContent = self.medicineModel.medicinesComponent;
    MedicinDes.MedicineFunction = self.medicineModel.medicinesFunction;
    self.tag = 101;
    
    //药品评价
    JNSYEvateViewController *MedicineEvateVc = [[JNSYEvateViewController alloc] init];
    MedicineEvateVc.title = @"评价";
    MedicineEvateVc.tag = 100;
    MedicineEvateVc.table.frame = CGRectMake(0, [JNSYAutoSize AutoHeight:3], KscreenWidth, KscreenHeight - [JNSYAutoSize AutoHeight:385]);
    
    self.viewControllers = @[MedicinDes,MedicineEvateVc];
    
    self.segmentType = XHSegmentTypeFilled;
    self.scrollView.scrollEnabled = NO;
    
    //咨询按钮
    UIButton *ConsultBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [ConsultBtn setTitle:@"咨询药师" forState:UIControlStateNormal];
    [ConsultBtn setBackgroundColor:[UIColor colorWithRed:0 green:183/255.0 blue:238/255.0 alpha:1]];
    ConsultBtn.titleLabel.font = [UIFont systemFontOfSize:14];
    [ConsultBtn addTarget:self action:@selector(ConsultBtnAction) forControlEvents:UIControlEventTouchUpInside];
    
    [self.view addSubview:ConsultBtn];
    
    [ConsultBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.bottom.equalTo(self.view);
        make.height.mas_equalTo([JNSYAutoSize AutoHeight:50]);
        make.width.mas_equalTo(KscreenWidth/2.0 - 20);
    }];
    
    //加入购物车
    UIButton *ShopCarBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    ShopCarBtn.titleLabel.font = [UIFont systemFontOfSize:14];
    [ShopCarBtn setTitle:@"加入购物车" forState:UIControlStateNormal];
    [ShopCarBtn setBackgroundColor:ColorTabBarback];
    [ShopCarBtn addTarget:self action:@selector(ShopCarBtnAction) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:ShopCarBtn];
    
    [ShopCarBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(ConsultBtn.mas_right);
        make.bottom.equalTo(self.view);
        make.height.mas_equalTo([JNSYAutoSize AutoHeight:50]);
        make.width.mas_equalTo((KscreenWidth - (KscreenWidth/2.0 - 20))/2.0);
    }];
    
    //立即购买
    UIButton *BuyBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    BuyBtn.titleLabel.font = [UIFont systemFontOfSize:14];
    [BuyBtn setTitle:@"立即购买" forState:UIControlStateNormal];
    [BuyBtn setBackgroundColor:[UIColor colorWithRed:1 green:60/255.0 blue:0 alpha:1]];
    [BuyBtn addTarget:self action:@selector(BuyBtnAction) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:BuyBtn];
    
    [BuyBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(ShopCarBtn.mas_right);
        make.right.bottom.equalTo(self.view);
        make.height.mas_equalTo([JNSYAutoSize AutoHeight:50]);
    }];
}


- (void)CreateMedicineShortInfoViews {
    
    //药品名称
    UILabel *MedicineNameLab = [[UILabel alloc] init];
    MedicineNameLab.font = [UIFont systemFontOfSize:14];
    MedicineNameLab.textAlignment = NSTextAlignmentLeft;
    MedicineNameLab.text = self.medicineModel.medicinesName;
    MedicineNameLab.textColor = [UIColor blackColor];
    
    [MedicineInfoBackImg addSubview:MedicineNameLab];

    [MedicineNameLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(MedicineInfoBackImg).offset(8);
        make.left.equalTo(MedicineInfoBackImg).offset(20);
        make.height.mas_equalTo([JNSYAutoSize AutoHeight:15]);
        make.width.mas_equalTo(200);
    }];
    
    
    //药品含量
    UILabel *ContentLab = [[UILabel alloc] init];
    ContentLab.font = [UIFont systemFontOfSize:12];
    ContentLab.textColor = ColorText;
    ContentLab.text = self.medicineModel.medicinesSpecifications;
    ContentLab.textAlignment = NSTextAlignmentLeft;
    
    [MedicineInfoBackImg addSubview:ContentLab];
    
    [ContentLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(MedicineNameLab.mas_bottom).offset(4);
        make.left.equalTo(MedicineNameLab);
        make.height.mas_equalTo([JNSYAutoSize AutoHeight:15]);
        make.width.mas_equalTo(120);
    }];
    
    //药品归属
    UILabel *BelongLab = [[UILabel alloc] init];
    BelongLab.textAlignment = NSTextAlignmentLeft;
    BelongLab.text = self.medicineModel.medicinesBrand;
    BelongLab.textColor = ColorText;
    BelongLab.font = [UIFont systemFontOfSize:12];
    [MedicineInfoBackImg addSubview:BelongLab];
    
    [BelongLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(ContentLab);
        make.left.equalTo(ContentLab.mas_right).offset(0);
        make.height.mas_equalTo([JNSYAutoSize AutoHeight:15]);
        make.width.mas_equalTo(150);
    }];
    
    //药品价格
    UILabel *PriceLab = [[UILabel alloc] init];
    PriceLab.textColor = [UIColor redColor];
    NSString *price = [NSString stringWithFormat:@"￥%@",self.medicineModel.medicinesPriceDiscount];
    PriceLab.text = [price substringToIndex:(price.length - 2)];
    PriceLab.textAlignment = NSTextAlignmentLeft;
    PriceLab.font = [UIFont systemFontOfSize:12];
    [MedicineInfoBackImg addSubview:PriceLab];
    
    [PriceLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(ContentLab.mas_bottom).offset(4);
        make.left.equalTo(ContentLab);
        make.height.mas_equalTo([JNSYAutoSize AutoHeight:15]);
        make.width.mas_equalTo(150);
    }];
    
    //药品非折扣价
    UILabel *PrePriceLab = [[UILabel alloc] init];
    PrePriceLab.textAlignment = NSTextAlignmentLeft;
    PrePriceLab.textColor = ColorText;
    PrePriceLab.font = [UIFont systemFontOfSize:12];
    NSString *prePrice = [NSString stringWithFormat:@"￥%@",self.medicineModel.medicinesPrice];
    prePrice = [prePrice substringToIndex:(prePrice.length - 2)];
    NSMutableAttributedString *attrStr = [[NSMutableAttributedString alloc] initWithString:prePrice];
    [attrStr setAttributes:@{
                            NSStrikethroughStyleAttributeName:[NSNumber numberWithInteger:NSUnderlineStyleSingle],
                            NSBaselineOffsetAttributeName:@(NSUnderlineStyleSingle)
                            }range:NSMakeRange(0, prePrice.length)];
    
    [MedicineInfoBackImg addSubview:PrePriceLab];
    PrePriceLab.attributedText = attrStr;
    [PrePriceLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(PriceLab);
        make.left.equalTo(BelongLab);
        make.height.mas_equalTo([JNSYAutoSize AutoHeight:15]);
        make.width.mas_equalTo(100);
    }];
    
    //收藏
    CollectBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    //CollectBtn.backgroundColor = [UIColor grayColor];
    [CollectBtn setImage:[UIImage imageNamed:@"收藏"] forState:UIControlStateNormal];
    [CollectBtn setImage:[UIImage imageNamed:@"已收藏"] forState:UIControlStateSelected];
    [CollectBtn addTarget:self action:@selector(CollectBtnAction:) forControlEvents:UIControlEventTouchUpInside];
    [MedicineInfoBackImg addSubview:CollectBtn];
    
    
    
    [CollectBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(MedicineNameLab);
        make.right.equalTo(self.view).offset(-20);
        make.height.mas_equalTo([JNSYAutoSize AutoHeight:20]);
        make.width.mas_equalTo(30);
    }];
    
    CollectLab = [[UILabel alloc] init];
    CollectLab.text = @"收藏";
    CollectLab.textColor = ColorText;
    CollectLab.font = [UIFont systemFontOfSize:11];
    CollectLab.textAlignment = NSTextAlignmentCenter;
    [MedicineInfoBackImg addSubview:CollectLab];
    
    [CollectLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(CollectBtn.mas_bottom).offset(2);
        make.centerX.equalTo(CollectBtn);
        make.height.mas_equalTo([JNSYAutoSize AutoHeight:8]);
        make.width.mas_equalTo(60);
    }];
    
    
    if ([self.medicineModel.isCollect isEqualToString:@"1"]) {
        CollectBtn.selected = YES;
        CollectLab.text = @"已收藏";
    }else {
        CollectBtn.selected = NO;
        CollectLab.text = @"收藏";
    }
}

//添加、取消收藏
- (void)collection:(NSString *)medicinesId action:(NSString *)action {
    
    NSDictionary *dic = @{
                          @"medicinesId":medicinesId
                          };
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
          
            //提示
            MBProgressHUD *HUD = [[MBProgressHUD alloc] initWithFrame:CGRectMake(0, 0, 100, 60)];
            if ([action isEqualToString:@"ShopMedicinesCollectDelState"]) { //取消收藏
                HUD.labelText = @"收藏已取消!";
            }else if ([action isEqualToString:@"ShopMedicinesCollectAddState"]) { //收藏
                HUD.labelText = @"收藏成功!";
            }
            HUD.center = self.view.center;
            [self.view addSubview:HUD];
            HUD.mode = MBProgressHUDModeText;
//            [HUD showAnimated:YES];
//            [HUD hideAnimated:YES afterDelay:1.5];
            [HUD show:YES];
            [HUD hide:YES afterDelay:1.5];
            //改变按钮状态
            CollectBtn.selected = !CollectBtn.selected;
            if (CollectBtn.isSelected) {
                CollectLab.text = @"已收藏";
            }else {
                CollectLab.text = @"收藏";
            }
            
        }else {
            NSString *msg = resultdic[@"msg"];
            [JNSYAutoSize showMsg:msg];
        }
    } failure:^(NSError *error) {
        NSLog(@"%@",error);
    }];
}



//点击收藏、取消收藏
- (void)CollectBtnAction:(UIButton *)sender {
    
    [self collection:[NSString stringWithFormat:@"%@",self.medicineModel.medicinesId] action:sender.isSelected?@"ShopMedicinesCollectDelState":@"ShopMedicinesCollectAddState"];
    
    NSLog(@"收藏");
}

//咨询按钮
- (void)ConsultBtnAction {
    
    NSLog(@"咨询");
    
}
//加入购物车
- (void)ShopCarBtnAction {
    NSLog(@"加入购物车");
    
    //药品信息
    UIImageView *headView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, KscreenWidth - 100, [JNSYAutoSize AutoHeight:55])];
   // headView.backgroundColor = [UIColor grayColor];
    
    medicineInfoView = [[MedicineInfoView alloc] initWithFrame:CGRectMake(0, 0, KscreenWidth - 100, [JNSYAutoSize AutoHeight:55])];
    [medicineInfoView.MedcineImg sd_setImageWithURL:[NSURL URLWithString:self.medicineModel.medicinesPic1]];
    medicineInfoView.NameLab.text = self.medicineModel.medicinesName;
    medicineInfoView.contentLab.text = self.medicineModel.medicinesSpecifications;
    medicineInfoView.BelongLab.text = self.medicineModel.medicinesBrand;
    NSString *price = [NSString stringWithFormat:@"￥%@",self.medicineModel.medicinesPrice];
    medicineInfoView.PriceLab.text = [price substringToIndex:(price.length - 2)];
    NSString *prePrice = [NSString stringWithFormat:@"￥%@",self.medicineModel.medicinesPriceDiscount];
    prePrice = [prePrice substringToIndex:(prePrice.length - 2)];
    NSMutableAttributedString *attrStr = [[NSMutableAttributedString alloc] initWithString:prePrice];
    [attrStr setAttributes:@{
                             NSStrikethroughStyleAttributeName:[NSNumber numberWithInteger:NSUnderlineStyleSingle],
                             NSBaselineOffsetAttributeName:@(NSUnderlineStyleSingle)
                             }range:NSMakeRange(0, prePrice.length)];
    medicineInfoView.PrePriceLab.attributedText = attrStr;
    
    [headView addSubview:medicineInfoView];
    
    //购买数量
    UIImageView *NumberImg = [[UIImageView alloc] initWithFrame:CGRectMake(0, [JNSYAutoSize AutoHeight:50], KscreenWidth - 100, [JNSYAutoSize AutoHeight:34])];
    //NumberImg.backgroundColor = [UIColor orangeColor];
    NumberImg.userInteractionEnabled = YES;
    
    UILabel *AddLab = [[UILabel alloc] init];
    AddLab.text = @"购买数量";
    AddLab.font = [UIFont systemFontOfSize:13];
    AddLab.textAlignment = NSTextAlignmentLeft;
    [NumberImg addSubview:AddLab];
    
    [AddLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(NumberImg);
        make.height.mas_equalTo([JNSYAutoSize AutoHeight:40]);
        make.left.equalTo(NumberImg).offset([JNSYAutoSize AutoHeight:50] + 5);
        make.width.mas_equalTo(60);
    }];
    
    
    CountView = [[JNShopCarCountView alloc] init];
    MedicineCount = 1;
    [CountView.editTextField addTarget:self action:@selector(textFieldChange:) forControlEvents:UIControlEventEditingChanged];
    [CountView configureShopCarCountViewWithProductCount:1 productStock:999];
    __weak typeof(JNShopCarCountView) *weakCountView = CountView;
    
    CountView.shopCarCountViewEditBlock = ^(NSInteger count) {
        
        __strong typeof(JNShopCarCountView) *strongCountView = weakCountView;
        if (count >= 999) {
            count = 999;
        }
        MedicineCount = count;
        [strongCountView configureShopCarCountViewWithProductCount:count productStock:999];
    };
    
    [NumberImg addSubview:CountView];
    
    [CountView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(NumberImg);
        make.left.equalTo(AddLab.mas_right).offset(10);
        make.height.mas_equalTo([JNSYAutoSize AutoHeight:25]);
        make.width.mas_equalTo(90);
    }];
    
    //操作按钮
    UIImageView *ButtonImg = [[UIImageView alloc] initWithFrame:CGRectMake(0, 115, KscreenWidth - 100, [JNSYAutoSize AutoHeight:30])];
    //ButtonImg.backgroundColor = [UIColor redColor];
    ButtonImg.userInteractionEnabled = YES;
    
    UIButton *CancelBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [CancelBtn setTitle:@"取消" forState:UIControlStateNormal];
    CancelBtn.titleLabel.font = [UIFont systemFontOfSize:13];
    [CancelBtn setBackgroundColor:[UIColor colorWithRed:0 green:183/255.0 blue:238/255.0 alpha:1]];
    CancelBtn.layer.cornerRadius = 3;
    CancelBtn.layer.masksToBounds = YES;
    [CancelBtn addTarget:self action:@selector(CancleBtnAction) forControlEvents:UIControlEventTouchUpInside];
    [ButtonImg addSubview:CancelBtn];
    
    [CancelBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(ButtonImg);
        make.height.mas_equalTo([JNSYAutoSize AutoHeight:30]);
        make.left.equalTo(ButtonImg).offset([JNSYAutoSize AutoHeight:50] + 5);
        make.width.mas_equalTo((ButtonImg.frame.size.width - 60)/2.0);
    }];
    
    
    UIButton *SureBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [SureBtn setTitle:@"确认" forState:UIControlStateNormal];
    SureBtn.titleLabel.font = [UIFont systemFontOfSize:13];
    [SureBtn setBackgroundColor:[UIColor colorWithRed:255/255.0 green:160/255.0 blue:0/255.0 alpha:1]];
    SureBtn.layer.cornerRadius = 3;
    SureBtn.layer.masksToBounds = YES;
    [SureBtn addTarget:self action:@selector(SureBtnAction) forControlEvents:UIControlEventTouchUpInside];
    [ButtonImg addSubview:SureBtn];
    [SureBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(CancelBtn);
        make.left.equalTo(CancelBtn.mas_right).offset(5);
        make.bottom.equalTo(CancelBtn);
        make.width.mas_equalTo((ButtonImg.frame.size.width - 60)/2.0);
    }];
    
    
    
    self.popCtr = [[CNPPopupController alloc] initWithContents:@[headView,NumberImg,ButtonImg]];
    
    self.popCtr.delegate = self;
    self.popCtr.theme = [CNPPopupTheme defaultTheme];
    self.popCtr.theme.popupStyle = CNPPopupStyleCentered;
    self.popCtr.theme.contentVerticalPadding = 10;
    //self.popCtr.theme.backgroundColor = ColorTableBack;
    [self.popCtr presentPopupControllerAnimated:YES];
    
}

//取消购物车
- (void)CancleBtnAction {
    
    [self.popCtr dismissPopupControllerAnimated:YES];
    NSLog(@"取消");
}

//确认加入购物车
- (void)SureBtnAction {
    
    NSDictionary *dic = @{
                          @"medicinesId":[NSString stringWithFormat:@"%@",self.medicineModel.medicinesId],
                          @"medicinesCount":CountView.editTextField.text
                          };
    NSString *action = @"OrderCartAddState";
    
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
            [self.popCtr dismissPopupControllerAnimated:YES];
            //提示
            MBProgressHUD *HUD = [[MBProgressHUD alloc] initWithFrame:CGRectMake(0, 0, 100, 60)];
            HUD.labelText = @"成功加入购物车!";
            HUD.center = self.view.center;
            [self.view addSubview:HUD];
            HUD.mode = MBProgressHUDModeText;
//            [HUD showAnimated:YES];
//            [HUD hideAnimated:YES afterDelay:1.5];
            [HUD show:YES];
            [HUD hide:YES afterDelay:1.5];
            
        }else {
            NSString *msg = resultdic[@"msg"];
            [JNSYAutoSize showMsg:msg];
        }
    } failure:^(NSError *error) {
        NSLog(@"%@",error);
    }];
    
}
//点击购买
- (void)BuyBtnAction {
    
    NSLog(@"购买成功");
}

- (CGFloat)AutoHeight:(CGFloat)height {
    
    if (KscreenHeight < 667) {
        height = height * 320 / 375;
    }else if (KscreenHeight == 667) {
        height = height;
    }else if (KscreenHeight > 667) {
        height = height * 414 / 375;
    }
    
    return height;
}

//textfield响应方法
- (void)textFieldChange:(UITextField *)textfiled {
    
    if (textfiled.text.length > 3) {
        textfiled.text = [textfiled.text substringToIndex:3];
    }
    
    
}

- (void)BackAction {
    
    [self.navigationController popViewControllerAnimated:YES];
    
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
