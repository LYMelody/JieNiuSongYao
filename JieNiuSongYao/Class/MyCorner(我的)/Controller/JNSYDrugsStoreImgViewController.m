//
//  JNSYDrugsStoreImgViewController.m
//  JieNiuSongYao
//
//  Created by rongfeng on 2017/5/11.
//  Copyright © 2017年 China Zhou. All rights reserved.
//

#import "JNSYDrugsStoreImgViewController.h"
#import "Common.h"
#import "Masonry.h"
#import "JNSYListHeaderTableViewCell.h"
#import "JNSYDrugsStoreImgTableViewCell.h"
#import "JNSYCerSelectTableViewCell.h"
#import "JNSYImageSelectTableViewCell.h"
#import "SJAvatarBrowser.h"
#import "LSActionSheet.h"
#import "JNSYAutoSize.h"
#import "JNSYUserInfo.h"
#import "SBJSON.h"
#import "IBHttpTool.h"
#import "MBProgressHUD.h"
#import "GTMBase64.h"
#import "JNSYCommintFedBackViewController.h"
@interface JNSYDrugsStoreImgViewController ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic, assign)CGFloat CerRowHeight;


@end

@implementation JNSYDrugsStoreImgViewController {
    
    UIActionSheet *sheet;
    
    NSInteger currentTag;
    
    UITableView *table;
    
    BOOL isHidden;
    BOOL isHiddenTwo;
    BOOL isHiddenThree;
    BOOL isHiddenFour;
    
    
    UIImage *ImgOne;
    UIImage *ImgTwo;
    UIImage *ImgThree;
    UIImage *ImgFour;
    UIImage *ImgFive;
    
    CGFloat rowheight;
    CGFloat rowheightThree;
    CGFloat rowheightFour;
    
    NSInteger CellCount;
    
    BOOL isSelected;
    
    NSString *httpPathOne;
    NSString *httpPathTwo;
    NSString *httpPathThree;
    NSString *httpPathFour;
    NSString *httpPathFive;

}

- (void)viewWillAppear:(BOOL)animated {
    
    [super viewWillAppear:animated];
    
    self.title = @"药店入驻";
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    //返回按钮
    self.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"" style:UIBarButtonItemStylePlain target:self action:nil];
    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
    

}


- (void)viewDidLoad {
    [super viewDidLoad];
    
    table = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, KscreenWidth, KscreenHeight) style:UITableViewStylePlain];
    table.delegate = self;
    table.dataSource = self;
    table.backgroundColor = ColorTableBack;
    table.separatorStyle = UITableViewCellSelectionStyleNone;
    table.showsVerticalScrollIndicator = NO;
    
    UIImageView *tableFootView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, KscreenWidth, 100)];
    tableFootView.userInteractionEnabled = YES;
    UIButton *CommitBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [CommitBtn setTitle:@"提交申请" forState:UIControlStateNormal];
    CommitBtn.layer.cornerRadius = 5;
    CommitBtn.layer.masksToBounds = YES;
    CommitBtn.titleLabel.font = [UIFont systemFontOfSize:13];
    [CommitBtn setBackgroundColor:ColorTabBarback];
    [CommitBtn addTarget:self action:@selector(CommitBtnAction) forControlEvents:UIControlEventTouchUpInside];
    [tableFootView addSubview:CommitBtn];
    
    [CommitBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.bottom.left.right.equalTo(tableFootView).with.insets(UIEdgeInsetsMake(25, 50, 40, 50));
    }];
    
    table.tableFooterView = tableFootView;
    [self.view addSubview:table];

    
    _CerRowHeight = 40;
    rowheight = 40;
    rowheightThree = 40;
    rowheightFour = 40;
    
    
    isHidden = YES;
    isHiddenTwo = YES;
    isHiddenThree = YES;
    isHiddenFour = YES;
    
    
    currentTag = 0;
    CellCount = 9;
    isSelected = YES;
}


//提交信息
- (void)CommitBtnAction {
    
   
    
    
    if(httpPathFive == nil) {
        [JNSYAutoSize showMsg:@"店铺图片未上传"];
        
        return;
    }else if (httpPathOne == nil) {
        [JNSYAutoSize showMsg:@"营业执照副本未上传"];
        
        return;
    }else if (httpPathTwo == nil) {
        [JNSYAutoSize showMsg:@"药品经营许可证未上传"];
       
        return;
    }
    
    NSDictionary *dic = nil;
    
    if (isSelected) {   //非五证合一 传五张照片
        
        if (httpPathThree == nil) {
            [JNSYAutoSize showMsg:@"医疗器械经营许可证未上传"];
            
            return;
        }else if (httpPathFour == nil) {
            [JNSYAutoSize showMsg:@"医疗器械经营备案证未上传"];
           
            return;
        }
        
        dic = @{
                              @"shopName":self.drugStoreName,
                              @"shopPhone":self.conectPhone,
                              @"shopAccount":self.conectName,
                              @"shopCert":self.cert,
                              @"shopBank":self.bankNo,
                              @"shopEmail":self.conectEmail,
                              @"shopAdCode":self.area,
                              @"shopAddress":self.detailAddress,
                              @"lng":self.longitude,
                              @"lat":self.latitude,
                              @"picComp1":httpPathFive,
                              @"picComp2":httpPathOne,
                              @"picComp3":httpPathTwo,
                              @"picComp4":httpPathThree,
                              @"picComp5":httpPathFour
                              };
        
    }else {
        
        dic = @{
                @"shopName":self.drugStoreName,
                @"shopPhone":self.conectPhone,
                @"shopAccount":self.conectName,
                @"shopCert":self.cert,
                @"shopBank":self.bankNo,
                @"shopEmail":self.conectEmail,
                @"shopAdCode":self.area,
                @"shopAddress":self.detailAddress,
                @"lng":self.longitude,
                @"lat":self.latitude,
                @"picComp1":httpPathFive,
                @"picComp2":httpPathOne,
                @"picComp3":httpPathTwo,
                };
        
    }
    
    
    MBProgressHUD *HUD = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    
    
    NSString *action = @"ShopSubmitState";
    
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
            
            //[HUD hide:YES];
            [HUD hide:YES];
//            HUD.label.text = @"恭喜！药店入驻成功";
//            HUD.mode = MBProgressHUDModeText;
//            [HUD showAnimated:YES];
//            [HUD hideAnimated:YES afterDelay:1.5];
//            
//            [self performSelector:@selector(back) withObject:nil afterDelay:1.5];
            //跳转提交成功页面
            JNSYCommintFedBackViewController *FedBackVc = [[JNSYCommintFedBackViewController alloc] init];
            FedBackVc.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:FedBackVc animated:YES];
            
            
            
        }else {
            NSString *msg = resultdic[@"msg"];
            [JNSYAutoSize showMsg:msg];
            [HUD hide:YES];
        }

    } failure:^(NSError *error) {
        NSLog(@"%@",error);
        [HUD hide:YES];
    }];
    
    NSLog(@"提交");
}


- (void)back {
    
    [self.navigationController popToRootViewControllerAnimated:YES];
    
}


#pragma mark tableView Deleage && datasource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return CellCount;
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
     NSString *identy = [NSString stringWithFormat:@"cell-%ld",(long)indexPath.row];
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identy];
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identy];
        
        if (indexPath.row == 0) {
            JNSYListHeaderTableViewCell *Cell = [[JNSYListHeaderTableViewCell alloc] init];
            Cell.leftLab.text = @"店面图片";
            cell = Cell;
        }else if (indexPath.row == 1) {
            JNSYDrugsStoreImgTableViewCell *Cell = [[JNSYDrugsStoreImgTableViewCell alloc] init];
            
            Cell.selectPictureBlock = ^{
                [self showActionSheet];
                currentTag = 1;
            };
            
            Cell.mangifyBlock = ^(UIImageView *MagnifyImg) {
                [SJAvatarBrowser showImage:MagnifyImg];
            };
            if (ImgFive) {
                Cell.StoreImgView.image = ImgFive;
            }
            cell = Cell;
        }else if (indexPath.row == 2) {
            cell.backgroundColor = ColorTableBack;
        }else if (indexPath.row == 3) {
            
            JNSYListHeaderTableViewCell *Cell = [[JNSYListHeaderTableViewCell alloc] init];
            Cell.leftLab.text = @"证件信息";
            cell = Cell;
        }else if (indexPath.row == 4) {   //是否是五证合一
            JNSYCerSelectTableViewCell *Cell = [[JNSYCerSelectTableViewCell alloc] init];
            Cell.BtnOne.selected = !isSelected;
            Cell.BtnTwo.selected = isSelected;
            Cell.changeStatusYesBlock = ^(BOOL isSelect) {
                isSelected = !isSelect;
                CellCount = 7;
                [table reloadData];
            };
            Cell.changeStatusNoBlock = ^(BOOL isSelect) {
                isSelected = isSelect;
                CellCount = 9;
                [table reloadData];
            };
            cell = Cell;
        }else if (indexPath.row == 5) {
            
            JNSYImageSelectTableViewCell *Cell = [[JNSYImageSelectTableViewCell alloc] init];
            Cell.leftLab.text = @"营业执照副本";
            Cell.CerImgView.hidden = isHidden;
            Cell.delectBtn.hidden = isHidden;
            Cell.CerImgView.image = ImgOne;
            //__weak typeof(self) WeakSelf = self;
            Cell.changeRowHeightBlock = ^{
                currentTag = 5;
                [self showActionSheet];
            };
            Cell.delectImageBlock = ^{
                _CerRowHeight = 40;
                isHidden = YES;
                ImgOne = nil;
                httpPathOne = nil;
                [tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
            };
            
            Cell.magnifyBlock = ^(UIImageView *ImageToMagnify) {
                [SJAvatarBrowser showImage:ImageToMagnify];
            };
            cell = Cell;
        }else if (indexPath.row == 6) {
            
            JNSYImageSelectTableViewCell *Cell = [[JNSYImageSelectTableViewCell alloc] init];
            Cell.leftLab.text = @"药品经营许可证";
            Cell.CerImgView.hidden = isHiddenTwo;
            Cell.delectBtn.hidden = isHiddenTwo;
            Cell.CerImgView.image = ImgTwo;
            //__weak typeof(self) WeakSelf = self;
            Cell.changeRowHeightBlock = ^{
                currentTag = 6;
                [self showActionSheet];
            };
            Cell.delectImageBlock = ^{
                rowheight = 40;
                isHiddenTwo = YES;
                ImgTwo = nil;
                httpPathTwo = nil;
                [tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
            };
            
            Cell.magnifyBlock = ^(UIImageView *ImageToMagnify) {
                [SJAvatarBrowser showImage:ImageToMagnify];
            };
            cell = Cell;
            
            
        }else if (indexPath.row == 7) {
            
            JNSYImageSelectTableViewCell *Cell = [[JNSYImageSelectTableViewCell alloc] init];
            Cell.leftLab.text = @"医疗器械经营许可证";
            Cell.CerImgView.hidden = isHiddenThree;
            Cell.delectBtn.hidden = isHiddenThree;
            Cell.CerImgView.image = ImgThree;
            //__weak typeof(self) WeakSelf = self;
            Cell.changeRowHeightBlock = ^{
                currentTag = 7;
                [self showActionSheet];
            };
            Cell.delectImageBlock = ^{
                rowheightThree = 40;
                isHiddenThree = YES;
                ImgThree = nil;
                httpPathThree = nil;
                [tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
            };
            
            Cell.magnifyBlock = ^(UIImageView *ImageToMagnify) {
                [SJAvatarBrowser showImage:ImageToMagnify];
            };
            cell = Cell;
            
        }else if (indexPath.row == 8) {
            JNSYImageSelectTableViewCell *Cell = [[JNSYImageSelectTableViewCell alloc] init];
            Cell.leftLab.text = @"医疗器械经营备案凭证";
            Cell.CerImgView.hidden = isHiddenFour;
            Cell.delectBtn.hidden = isHiddenFour;
            Cell.CerImgView.image = ImgFour;
            //__weak typeof(self) WeakSelf = self;
            Cell.changeRowHeightBlock = ^{
                currentTag = 8;
                [self showActionSheet];
            };
            Cell.delectImageBlock = ^{
                rowheightFour = 40;
                isHiddenFour = YES;
                ImgFour = nil;
                httpPathFour = nil;
                [tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
            };
            
            Cell.magnifyBlock = ^(UIImageView *ImageToMagnify) {
                [SJAvatarBrowser showImage:ImageToMagnify];
            };
            cell = Cell;
            
            
        }
    
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
    
}


- (void)showActionSheet {
    
    [LSActionSheet showWithTitle:nil destructiveTitle:nil otherTitles:@[@"拍照",@"从手机相册选择"] block:^(int index) {
        NSLog(@"-----%d",index);
        
        UIImagePickerControllerSourceType source = UIImagePickerControllerSourceTypePhotoLibrary;
        if (index == 0) {
            NSLog(@"拍照");
            if([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
                source = UIImagePickerControllerSourceTypeCamera;
            }else {
                NSLog(@"对不起，您的相机不可使用");
                [self alert:@"对不起，您的相机不可使用"];
                return;
            }
        }else if (index == 1){
            if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypePhotoLibrary]) {
                source = UIImagePickerControllerSourceTypePhotoLibrary;
            }else {
                NSLog(@"对不起，您的相册不可使用");
                [self alert:@"对不起，您的相册不可使用"];
                return;
            }
            NSLog(@"从相册中选择相片");
        }else {   //取消
            return;
        }
        
        UIImagePickerController *picker = [[UIImagePickerController alloc] init];
        picker.delegate = self;
        picker.allowsEditing = YES;
        picker.sourceType = source;
        
        [self presentViewController:picker animated:YES completion:nil];
    }];
    
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.row == 1) {
        return 160;
    }else if (indexPath.row == 2) {
        return 5;
    }else if (indexPath.row == 4) {
        return 50;
    }else if (indexPath.row == 5 ){
        return _CerRowHeight;
    }else if (indexPath.row == 6) {
        return rowheight;
    }else if (indexPath.row == 7) {
        return rowheightThree;
    }else if (indexPath.row == 8) {
        return rowheightFour;
    }
    else {
        return 40;
    }
    
}

#pragma mark ActionSheetDeleage


- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info {
    
    [picker dismissViewControllerAnimated:YES completion:nil];
    NSLog(@"dfsdfsdfsdfds");
    UIImage *image = info[UIImagePickerControllerEditedImage];
    NSLog(@"%ld",(long)currentTag);
    
    NSData *imagedata = UIImagePNGRepresentation(image);
    
    NSString *encodedImagStr = [GTMBase64 stringByEncodingData:imagedata];
    
    NSString *imageBase64 = [NSString stringWithFormat:@"%@%@",@"data:image/png;base64,",encodedImagStr];
    //上传图片
    [self UploadPicRequest:imageBase64];
    
    if (currentTag == 5) {
        ImgOne = image;
        isHidden = NO;
        _CerRowHeight = 120;
    }else if (currentTag == 6) {
        ImgTwo = image;
        isHiddenTwo = NO;
        rowheight = 120;
    }else if (currentTag == 7) {
        ImgThree = image;
        isHiddenThree = NO;
        rowheightThree = 120;
    }else if (currentTag == 8) {
        ImgFour = image;
        isHiddenFour = NO;
        rowheightFour = 120;
    }else if (currentTag == 1) {
        ImgFive = image;
    }
//    //选取图片后设置图片背景 调整行高
//    NSIndexPath *path = [NSIndexPath indexPathForRow:currentTag inSection:0];
//    [table reloadRowsAtIndexPaths:@[path] withRowAnimation:UITableViewRowAnimationAutomatic];

}

//上传图片
- (void)UploadPicRequest:(NSString *)imgStr {
    
    MBProgressHUD *HUD = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    
    NSDictionary *dic = @{
                          @"fileBase64":imgStr
                          };
    NSString *action = @"FileUploadState";
    
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
            
            NSString *httpPath = resultdic[@"httpPath"];
            
            //[HUD hideAnimated:YES afterDelay:0.6];
            [HUD hide:YES afterDelay:0.6];
            
            if (currentTag == 5) {
                httpPathOne = httpPath;
                
                
                
            }else if (currentTag == 6) {
                httpPathTwo = httpPath;
            }else if (currentTag == 7) {
                httpPathThree = httpPath;
            }else if (currentTag == 8) {
                httpPathFour = httpPath;
            }else if (currentTag == 1) {
                httpPathFive = httpPath;
            }
            
            //选取图片后设置图片背景 调整行高
            NSIndexPath *path = [NSIndexPath indexPathForRow:currentTag inSection:0];
            [table reloadRowsAtIndexPaths:@[path] withRowAnimation:UITableViewRowAnimationAutomatic];
            
        }else {
            NSString *msg = resultdic[@"msg"];
            [JNSYAutoSize showMsg:msg];
            [HUD hide:YES];
        }
    } failure:^(NSError *error) {
        NSLog(@"%@",error);
        [HUD hide:YES];
    }];

}

- (void)alert:(NSString *)msg {
    
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:msg delegate:self cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
    
    [alert show];
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
