//
//  JNSYAutoSize.m
//  JieNiuSongYao
//
//  Created by rongfeng on 2017/6/1.
//  Copyright © 2017年 China Zhou. All rights reserved.
//

#import "JNSYAutoSize.h"
#import "Common.h"
#import <CommonCrypto/CommonDigest.h>
@implementation JNSYAutoSize

//适配高度
+ (CGFloat)AutoHeight:(CGFloat)height {
    
    
    
    if (KscreenHeight < 667) {
        height = height * 320 / 375;
    }else if (KscreenHeight == 667) {
        height = height;
    }else if (KscreenHeight > 667) {
        height = height * 414 / 375;
    }
    
    return height;
}

//提示消息
+ (void)showMsg:(NSString *)msg {
    
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:msg delegate:self cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
    
    [alert show];
}

//获取设备“IMEI”
+ (NSString *)getDiviceIMEI {
    
    NSString *imsi = [[[UIDevice currentDevice] identifierForVendor] UUIDString];
    NSString *UUID = [self md5HexDigest:imsi];
    NSString *UUID16 = [[UUID substringFromIndex:8] substringToIndex:16];
 
    return UUID16;
}

//隐私信息打*处理
+ (NSString*)rePlaceString:(NSString*)string{
    if (![string isKindOfClass:[NSString class]]) {
        return @"";
    }else{
        NSMutableString *mutString = [NSMutableString stringWithString:string];
        NSInteger length = [mutString length];
        if (length>=6) {
            [mutString replaceCharactersInRange:NSMakeRange(3, length-7) withString:@"****"];
        }else{
            
        }
        
        return (NSString*)mutString;
    }
}

//获取时间戳
+ (NSString *)getTimeNow {
    
    //时间戳
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"YYYY-MM-DD HH:mm:ss"];
    NSTimeZone *timezone = [NSTimeZone timeZoneWithName:@"Asia/Shanghai"];
    [formatter setTimeZone:timezone];
    NSDate *datenow = [NSDate date];
    NSString *timeSp = [NSString stringWithFormat:@"%.0f",[datenow timeIntervalSince1970]];
    
    return timeSp;
    
}

//MD5加密
+ (NSString *)md5HexDigest:(NSString*)password
{
    const char *original_str = [password UTF8String];
    unsigned char result[CC_MD5_DIGEST_LENGTH];
    CC_MD5(original_str, strlen(original_str), result);
    NSMutableString *hash = [NSMutableString string];
    for (int i = 0; i < 16; i++)
    {
        [hash appendFormat:@"%02X", result[i]];
    }
    NSString *mdfiveString = [hash lowercaseString];
    return mdfiveString;
}


@end
