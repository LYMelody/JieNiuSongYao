//
//  JNSYDrugsEnterViewController.m
//  JieNiuSongYao
//
//  Created by rongfeng on 2017/5/11.
//  Copyright © 2017年 China Zhou. All rights reserved.
//

#import "JNSYDrugsEnterViewController.h"
#import "Common.h"
#import "JNSYLabAndFldTableViewCell.h"
#import "JNSYListHeaderTableViewCell.h"
#import "JNSYLocalMapTableViewCell.h"
#import "Masonry.h"
#import "JNSYAutoSize.h"
#import "JNSYUserInfo.h"
#import "JNSYDrugsStoreImgViewController.h"
#import <MapKit/MapKit.h>
#import <AMapLocationKit/AMapLocationKit.h>
@interface JNSYDrugsEnterViewController ()<UITableViewDelegate,UITableViewDataSource,UITextFieldDelegate,MAMapViewDelegate,AMapLocationManagerDelegate>

@property(nonatomic,strong)AMapLocationManager *locationManager;

@property(nonatomic,copy)AMapLocatingCompletionBlock completionBlock;


@end

@implementation JNSYDrugsEnterViewController {
    
    UITableView *table;
    JNSYLabAndFldTableViewCell *DrugNameCell;
    JNSYLabAndFldTableViewCell *AreaCell;
    JNSYLabAndFldTableViewCell *DetailAddressCell;
    JNSYLabAndFldTableViewCell *ConectNameCell;
    JNSYLabAndFldTableViewCell *ConectPhoneCell;
    JNSYLabAndFldTableViewCell *EmailCell;
    JNSYLabAndFldTableViewCell *CertCell;
    JNSYLabAndFldTableViewCell *BankNumCell;
    JNSYLocalMapTableViewCell *MapCell;
    NSString *drugStoreName;
    NSString *Area;
    NSString *detailAddress;
    NSString *drugConnectName;
    NSString *connectPhone;
    NSString *email;
    NSString *cert;
    NSString *bankNum;
    CLLocation *_Uplocation;
}

- (void)viewWillAppear:(BOOL)animated {
    
    [super viewWillAppear:animated];
    
    self.title = @"药店入驻";
    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
    self.view.backgroundColor = [UIColor whiteColor];
    
    self.tabBarController.tabBar.hidden = YES;
    [self.navigationController setNavigationBarHidden:NO animated:YES];
    //返回按钮
    self.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"" style:UIBarButtonItemStylePlain target:self action:nil];
    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
    
}

- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    //初始化定位
    [self initCompleteBlock];
    [self configLocationManager];
    
    drugStoreName = @"杭州大药房";
    Area = @"浙江省杭州市萧山区";
    detailAddress = @"宁围镇钱江世纪城宝盛世纪中心";
    drugConnectName = @"张药师";
    connectPhone = @"18868825142";
    email = @"111111@qq.com";
    cert = @"23424223424234";
    bankNum = @"234234234232";
    
    UITapGestureRecognizer *TaptoResignKeyBoard = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(TableResignKeyBoard)];
    TaptoResignKeyBoard.numberOfTouchesRequired = 1;
    
    
    table = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, KscreenWidth, KscreenHeight) style:UITableViewStylePlain];
    table.delegate = self;
    table.dataSource = self;
    table.backgroundColor = ColorTableBack;
    table.separatorStyle = UITableViewCellSeparatorStyleNone;
    table.showsVerticalScrollIndicator = NO;
    [table addGestureRecognizer:TaptoResignKeyBoard];
    [self.view addSubview:table];
    
    UIImageView *tableFooterView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, KscreenWidth, 100)];
    tableFooterView.userInteractionEnabled = YES;
    tableFooterView.backgroundColor = ColorTableBack;
    
    UIButton *NextBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [NextBtn setTitle:@"下一步" forState:UIControlStateNormal];
    NextBtn.titleLabel.font = [UIFont systemFontOfSize:13];
    [NextBtn setBackgroundColor:ColorTabBarback];
    NextBtn.layer.cornerRadius = 5;
    NextBtn.layer.masksToBounds = YES;
    [NextBtn addTarget:self action:@selector(NextAction) forControlEvents:UIControlEventTouchUpInside];
    [tableFooterView addSubview:NextBtn];
    
    [NextBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.bottom.left.right.equalTo(tableFooterView).width.insets(UIEdgeInsetsMake(25, 50, 40, 50));
    }];
    
    table.tableFooterView = tableFooterView;
    
}

//下一步
- (void)NextAction {
    
    
    if (drugStoreName == nil || [drugStoreName isEqualToString:@""]) {
        [JNSYAutoSize showMsg:@"药店名称为空"];
        return;
    }else if (Area == nil || [Area isEqualToString:@""]) {
        [JNSYAutoSize showMsg:@"所在地区为空"];
        return;
    }else if (detailAddress == nil || [detailAddress isEqualToString:@""]) {
        [JNSYAutoSize showMsg:@"详细地址为空"];
        return;
    }else if (drugConnectName == nil || [drugConnectName isEqualToString:@""]) {
        [JNSYAutoSize showMsg:@"药店联系人为空"];
        return;
    }else if (connectPhone == nil || [connectPhone isEqualToString:@""]) {
        [JNSYAutoSize showMsg:@"联系人为空"];
        return;
    }else if (email == nil || [email isEqualToString:@""]) {
        [JNSYAutoSize showMsg:@"联系人邮箱为空"];
        return;
    }else if (cert == nil || [cert isEqualToString:@""]) {
        [JNSYAutoSize showMsg:@"身份证号为空"];
        return;
    }else if (bankNum == nil || [bankNum isEqualToString:@""]) {
        [JNSYAutoSize showMsg:@"银行账号为空"];
        return;
    }else if (_Uplocation == nil) {
        [JNSYAutoSize showMsg:@"未获取定位信息，请打开定位权限重新定位"];
        return;
    }
    
    
    NSLog(@"下一步");
    JNSYDrugsStoreImgViewController *Vc = [[JNSYDrugsStoreImgViewController alloc] init];
    Vc.drugStoreName = drugStoreName;
    Vc.area = Area;
    Vc.detailAddress = detailAddress;
    Vc.conectName = drugConnectName;
    Vc.conectPhone = connectPhone;
    Vc.conectEmail = email;
    Vc.cert = cert;
    Vc.bankNo = bankNum;
    Vc.longitude = [NSString stringWithFormat:@"%f",_Uplocation.coordinate.longitude];
    Vc.latitude = [NSString stringWithFormat:@"%f",_Uplocation.coordinate.latitude];
    self.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:Vc animated:YES];
    
}

//初始化定位
- (void)configLocationManager {
    
    self.locationManager = [[AMapLocationManager alloc] init];
    self.locationManager.delegate = self;
    self.locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters;   //定位精度
    
    [self.locationManager requestLocationWithReGeocode:YES completionBlock:self.completionBlock];
}

- (void)initCompleteBlock {
    
    
    __weak typeof(self) weakSelf = self;
    
    self.completionBlock = ^(CLLocation *location, AMapLocationReGeocode *regeocode, NSError *error) {
        if (error != nil && error.code == AMapLocationErrorLocateFailed)
        {
            //定位错误：此时location和regeocode没有返回值，不进行annotation的添加
            NSLog(@"定位错误:{%ld - %@};", (long)error.code, error.localizedDescription);
            return;
        }
        else if (error != nil
                 && (error.code == AMapLocationErrorReGeocodeFailed
                     || error.code == AMapLocationErrorTimeOut
                     || error.code == AMapLocationErrorCannotFindHost
                     || error.code == AMapLocationErrorBadURL
                     || error.code == AMapLocationErrorNotConnectedToInternet
                     || error.code == AMapLocationErrorCannotConnectToHost))
        {
            //逆地理错误：在带逆地理的单次定位中，逆地理过程可能发生错误，此时location有返回值，regeocode无返回值，进行annotation的添加
            NSLog(@"逆地理错误:{%ld - %@};", (long)error.code, error.localizedDescription);
        }
        else if (error != nil && error.code == AMapLocationErrorRiskOfFakeLocation)
        {
            //存在虚拟定位的风险：此时location和regeocode没有返回值，不进行annotation的添加
            NSLog(@"存在虚拟定位的风险:{%ld - %@};", (long)error.code, error.localizedDescription);
            return;
        }
        else
        {
            //没有错误：location有返回值，regeocode是否有返回值取决于是否进行逆地理操作，进行annotation的添加
        }
        
        //根据定位信息，添加annotation
        MAPointAnnotation *annotation = [[MAPointAnnotation alloc] init];
        [annotation setCoordinate:location.coordinate];
        
        //设置全局定位
        _Uplocation = location;
        
        //有无逆地理信息，annotationView的标题显示的字段不一样
        if (regeocode)
        {
            [annotation setTitle:[NSString stringWithFormat:@"%@", regeocode.formattedAddress]];
            [annotation setSubtitle:[NSString stringWithFormat:@"%@-%@-%.2fm", regeocode.citycode, regeocode.adcode, location.horizontalAccuracy]];
        }
        else
        {
            [annotation setTitle:[NSString stringWithFormat:@"纬度:%f;经度:%f;", location.coordinate.latitude, location.coordinate.longitude]];
            [annotation setSubtitle:[NSString stringWithFormat:@"精准度:%.2fm", location.horizontalAccuracy]];
            
        }
        
        __strong typeof(self) strongSelf = weakSelf;
        [strongSelf addAnnotationToMapView:annotation];
        
    };
}

//添加地图图标
- (void)addAnnotationToMapView:(id<MAAnnotation>)annotation {
    
    [MapCell.mapView addAnnotation:annotation];
    [MapCell.mapView selectAnnotation:annotation animated:YES];
    [MapCell.mapView setZoomLevel:15.1 animated:NO];
    [MapCell.mapView setCenterCoordinate:annotation.coordinate animated:YES];
    //选中图标
    [MapCell.mapView selectAnnotation:annotation animated:YES];
}
//设置地图图标
- (MAAnnotationView *)mapView:(MAMapView *)mapView viewForAnnotation:(id<MAAnnotation>)annotation
{
    if ([annotation isKindOfClass:[MAPointAnnotation class]])
    {
        static NSString *pointReuseIndetifier = @"pointReuseIndetifier";
        
        MAPinAnnotationView *annotationView = (MAPinAnnotationView *)[mapView dequeueReusableAnnotationViewWithIdentifier:pointReuseIndetifier];
        if (annotationView == nil)
        {
            annotationView = [[MAPinAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:pointReuseIndetifier];
        }
        
        annotationView.canShowCallout   = YES;
        annotationView.animatesDrop     = YES;
        annotationView.draggable        = NO;
        annotationView.pinColor         = MAPinAnnotationColorPurple;
        
        return annotationView;
    }
    
    return nil;
}



//textFiled deleage
- (void)textFieldDidEndEditing:(UITextField *)textField {
    
    if (textField.tag == 101) { //药店名称
        drugStoreName = textField.text;
    }else if (textField.tag == 102) {
        Area = textField.text;
    }else if (textField.tag == 103) {
        detailAddress = textField.text;
    }else if (textField.tag == 104) {
        drugConnectName = textField.text;
    }else if (textField.tag == 105) {
        connectPhone = textField.text;
    }else if (textField.tag == 106) {
        email = textField.text;
    }else if (textField.tag == 107) {
        cert = textField.text;
    }else if(textField.tag == 108) {
        bankNum = textField.text;
    }
    
}



- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return 11;
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *identy = @"identy";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identy];
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc] init];
        if (indexPath.row == 0) {
            
            JNSYListHeaderTableViewCell *Cell = [[JNSYListHeaderTableViewCell alloc] init];
            Cell.leftLab.text = @"基本信息";
            cell = Cell;
            
        }else if (indexPath.row == 1) {
            DrugNameCell = [[JNSYLabAndFldTableViewCell alloc] init];
            DrugNameCell.LeftLab.text = @"药店名称";
            DrugNameCell.RightFld.placeholder = @"请填写药店完整名称";
            DrugNameCell.RightFld.tag = 101;
            DrugNameCell.RightFld.delegate = self;
            DrugNameCell.RightFld.text = drugStoreName;
            cell = DrugNameCell;
        }else if (indexPath.row == 2) {
            AreaCell = [[JNSYLabAndFldTableViewCell alloc] init];
            AreaCell.LeftLab.text = @"所在地区";
            AreaCell.RightFld.placeholder = @"省份 城市 区县";
            AreaCell.RightFld.tag = 102;
            AreaCell.RightFld.delegate = self;
            AreaCell.RightFld.text = Area;
            cell = AreaCell;
        }else if (indexPath.row == 3) {
            DetailAddressCell = [[JNSYLabAndFldTableViewCell alloc] init];
            DetailAddressCell.LeftLab.text = @"详细地址";
            DetailAddressCell.RightFld.placeholder = @"请填写详细地址，如***路***号";
            DetailAddressCell.RightFld.tag = 103;
            DetailAddressCell.RightFld.delegate = self;
            DetailAddressCell.RightFld.text = detailAddress;
            cell = DetailAddressCell;
        }else if (indexPath.row == 4) {
            MapCell = [[JNSYLocalMapTableViewCell alloc] init];
            MapCell.leftLab.text = @"标注位置";
            MapCell.mapView.delegate = self;
            cell = MapCell;
        }else if (indexPath.row == 5) {
            JNSYListHeaderTableViewCell *Cell = [[JNSYListHeaderTableViewCell alloc] init];
            Cell.leftLab.text = @"联系人信息";
            cell = Cell;
        }else if (indexPath.row == 6) {
            ConectNameCell = [[JNSYLabAndFldTableViewCell alloc] init];
            ConectNameCell.LeftLab.text = @"药店联系人";
            ConectNameCell.RightFld.placeholder = @"请输入联系人姓名";
            ConectNameCell.RightFld.tag = 104;
            ConectNameCell.RightFld.delegate = self;
            ConectNameCell.RightFld.text = drugConnectName;
            cell = ConectNameCell;
        }else if (indexPath.row == 7) {
            ConectPhoneCell = [[JNSYLabAndFldTableViewCell alloc] init];
            ConectPhoneCell.LeftLab.text = @"联系人电话";
            ConectPhoneCell.RightFld.placeholder = @"请输入联系人手机号码";
            ConectPhoneCell.RightFld.tag = 105;
            ConectPhoneCell.RightFld.delegate = self;
            ConectPhoneCell.RightFld.text = connectPhone;
            ConectPhoneCell.RightFld.keyboardType = UIKeyboardTypeNumberPad;
            cell = ConectPhoneCell;
        }else if (indexPath.row == 8) {
            EmailCell = [[JNSYLabAndFldTableViewCell alloc] init];
            EmailCell.LeftLab.text = @"联系人邮箱";
            EmailCell.RightFld.placeholder = @"请输入联系人邮箱";
            EmailCell.RightFld.tag = 106;
            EmailCell.RightFld.delegate = self;
            EmailCell.RightFld.text = email;
            EmailCell.RightFld.keyboardType = UIKeyboardTypeEmailAddress;
            cell = EmailCell;
        }else if (indexPath.row == 9) {
            CertCell = [[JNSYLabAndFldTableViewCell alloc] init];
            CertCell.LeftLab.text = @"身份证号";
            CertCell.RightFld.placeholder = @"请输入联系人身份证号";
            CertCell.RightFld.tag = 107;
            CertCell.RightFld.delegate = self;
            CertCell.RightFld.text = cert;
            cell = CertCell;
        }else if (indexPath.row == 10) {
            BankNumCell = [[JNSYLabAndFldTableViewCell alloc] init];
            BankNumCell.LeftLab.text = @"银行账号";
            BankNumCell.RightFld.placeholder = @"请输入联系人银行账户";
            BankNumCell.RightFld.tag = 108;
            BankNumCell.RightFld.delegate = self;
            BankNumCell.RightFld.text = bankNum;
            BankNumCell.RightFld.keyboardType = UIKeyboardTypeNumberPad;
            cell = BankNumCell;
        }
    }
    cell.selectionStyle = UITableViewCellSeparatorStyleNone;
    return cell;
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.row == 4) {
        return 100;
    }else {
        return 40;
    }
    
}

//收起键盘
- (void)TableResignKeyBoard {
    
    for (UITableViewCell *cell in table.visibleCells) {
        for (UIView *view in cell.contentView.subviews) {
            if ([view isKindOfClass:[UITextField class]]) {
                [view resignFirstResponder];
               
            }else {
                
            }
        }
    }
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    
    [self.view endEditing:YES];
    
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
