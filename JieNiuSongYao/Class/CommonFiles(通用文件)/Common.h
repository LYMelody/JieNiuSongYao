//
//  Common.h
//  JieNiuSongYao
//
//  Created by rongfeng on 2017/5/9.
//  Copyright © 2017年 China Zhou. All rights reserved.
//

#ifndef Common_h
#define Common_h

#define JNSYTestUrl @"http://api.sytest.hzjieniu.com/api/action"
#define TOKEN @"63b407c3d510bf14851ce46df94662b5"
#define KEY @"UBKKWNA216MXCGVJWG5W69VOORNWKV82"


#define KscreenWidth [UIScreen mainScreen].bounds.size.width
#define KscreenHeight [UIScreen mainScreen].bounds.size.height

#define leftDistance 16.0
#define rightDistance 16.0

#define IsPlus KscreenHeight > 667
#define IsMidScreen    (KscreenHeight<=667 && KscreenHeight > 568)
#define IsSmallScreen (KscreenHeight<=568)
#define BundleID [[[NSBundle mainBundle] infoDictionary] objectForKey:(NSString *)kCFBundleVersionKey]


#define ColorTableViewCellSeparate  [UIColor colorWithRed:233/255.0 green:233/255.0 blue:233/255.0 alpha:1]
#define ColorTabBarback [UIColor colorWithRed:255/255.0 green:151/255.0 blue:2/255.0 alpha:1]
#define ColorTableBack [UIColor colorWithRed:240/255.0 green:239/255.0 blue:244/255.0 alpha:1]
#define ColorText [UIColor colorWithRed:74/255.0 green:74/255.0 blue:74/255.0 alpha:1]
#define GreenColor [UIColor colorWithRed:0.25 green:0.46 blue:0.02 alpha:1.0]


//高的地图
#define GaoDeKey @"2a230b3e1107085a64adbe795e7159ab"

//环信IM
/*测试*/
#define HXAPPKEY @"1128170425178918#jnsyim"
#define APNSCertName @"JNSYTest_PushCer"

/*正式*/
#define HXAPPKEYNEW @"1141170630178283#jieniusongyao"
#define APNSCertNameNew @""






#endif /* Common_h */
