//
//  JNSYCommenMethods.m
//  JieNiuSongYao
//
//  Created by rongfeng on 2017/6/29.
//  Copyright © 2017年 China Zhou. All rights reserved.
//

#import "JNSYCommenMethods.h"
#import "JNSYAutoSize.h"
#import "IBHttpTool.h"
#import "SBJSON.h"
#import "Common.h"
#import "JNSYUserInfo.h"
@implementation JNSYCommenMethods

+ (void)UpLoadUserPicHeader:(NSString *)picHeader userSex:(NSString *)userSex birthday:(NSString *)birthday userName:(NSString *)userName {
    
    NSString *timestamp = [JNSYAutoSize getTimeNow];
    
    NSMutableDictionary *dic = [[NSMutableDictionary alloc] init];
    [dic setObject:timestamp forKey:@"timestamp"];
    
    if (picHeader != nil) {
        
        [dic setObject:picHeader forKey:@"pickHeader"];
    }else if (userSex != nil) {
       
        [dic setObject:userSex forKey:@"sex"];
    }else if (birthday != nil) {
        
        [dic setObject:birthday forKey:@"birthday"];
    }else if (userName != nil) {
    
        [dic setObject:userName forKey:@"userName"];
    }
    
    NSString *action = @"UserBaseDetailEditState";
    
    NSDictionary *requestDic = @{
                                 @"action":action,
                                 @"data":dic,
                                 @"token":[JNSYUserInfo getUserInfo].userToken
                                 };
    NSString *paramas = [requestDic JSONFragment];
    
    [IBHttpTool postWithURL:JNSYTestUrl params:paramas success:^(id result) {
        NSLog(@"%@",result);
        NSDictionary *dic = [result JSONValue];
        NSString *code = dic[@"code"];
        if ([code isEqualToString:@"000000"]) {
            
            
        }else {
            NSString *msg = dic[@"msg"];
            [JNSYAutoSize showMsg:msg];
        }
    } failure:^(NSError *error) {
        NSLog(@"%@",error);
    }];
    
    
}

//上传图片
+ (NSString *)UpLoadUserPicHeaderImg:(NSString *)fileBase64 {
    
    NSString *returnStr = nil;
    
    NSDictionary *Dic = @{
                          @"timestamp":[JNSYAutoSize getTimeNow],
                          @"fileBase64":fileBase64
                          };
    NSString *action = @"UserCardUnbindState";
    
    NSDictionary *requestDic = @{
                                 @"action":action,
                                 @"data":Dic,
                                 @"token":[JNSYUserInfo getUserInfo].userToken
                                 };
    NSString *paramas = [requestDic JSONFragment];
    
    [IBHttpTool postWithURL:JNSYTestUrl params:paramas success:^(id result) {
        NSLog(@"%@",result);
        NSDictionary *dic = [result JSONValue];
        NSString *code = dic[@"code"];
        
        if ([code isEqualToString:@"000000"]) {
            
            NSString *httpPath = dic[@"httpPath"];
            
            [JNSYUserInfo getUserInfo].headerPicHttpPath = httpPath;
            
        }else {
            NSString *msg = dic[@"msg"];
            [JNSYAutoSize showMsg:msg];
        }
    } failure:^(NSError *error) {
        NSLog(@"%@",error);
    }];
    
    returnStr = [JNSYUserInfo getUserInfo].headerPicHttpPath;
    
    return returnStr;
    
}


@end
