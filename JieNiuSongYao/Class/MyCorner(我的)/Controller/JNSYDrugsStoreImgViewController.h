//
//  JNSYDrugsStoreImgViewController.h
//  JieNiuSongYao
//
//  Created by rongfeng on 2017/5/11.
//  Copyright © 2017年 China Zhou. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface JNSYDrugsStoreImgViewController : UIViewController<UIActionSheetDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate>


@property(nonatomic, copy)NSString *drugStoreName;
@property(nonatomic, copy)NSString *area;
@property(nonatomic, copy)NSString *detailAddress;
@property(nonatomic, copy)NSString *conectName;
@property(nonatomic, copy)NSString *conectPhone;
@property(nonatomic, copy)NSString *conectEmail;
@property(nonatomic, copy)NSString *cert;
@property(nonatomic, copy)NSString *bankNo;
@property(nonatomic, copy)NSString *longitude;
@property(nonatomic, copy)NSString *latitude;

@end
