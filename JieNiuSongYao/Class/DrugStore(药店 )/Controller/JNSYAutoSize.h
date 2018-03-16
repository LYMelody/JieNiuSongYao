//
//  JNSYAutoSize.h
//  JieNiuSongYao
//
//  Created by rongfeng on 2017/6/1.
//  Copyright © 2017年 China Zhou. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface JNSYAutoSize : NSObject

+ (CGFloat)AutoHeight:(CGFloat)height;

+ (void)showMsg:(NSString *)msg;

+ (NSString *)md5HexDigest:(NSString*)password;

+ (NSString *)getDiviceIMEI;

+ (NSString*)rePlaceString:(NSString*)string;

+ (NSString *)getTimeNow;

@end
