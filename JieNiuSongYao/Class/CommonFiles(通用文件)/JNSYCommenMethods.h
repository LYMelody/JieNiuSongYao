//
//  JNSYCommenMethods.h
//  JieNiuSongYao
//
//  Created by rongfeng on 2017/6/29.
//  Copyright © 2017年 China Zhou. All rights reserved.
//

#import <Foundation/Foundation.h>


typedef void(^UploadImgBlock)(NSString *httpPath);

@interface JNSYCommenMethods : NSObject

@property(nonatomic,copy)UploadImgBlock uploadImgBlock;





+ (void)UpLoadUserPicHeader:(NSString *)picHeader userSex:(NSString *)userSex birthday:(NSString *)birthday userName:(NSString *)userName;


+ (NSString *)UpLoadUserPicHeaderImg:(NSString *)fileBase64;
    

@end
