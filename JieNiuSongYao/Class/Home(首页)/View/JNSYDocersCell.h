//
//  JNSYDocersCell.h
//  JieNiuSongYao
//
//  Created by rongfeng on 2017/7/31.
//  Copyright © 2017年 China Zhou. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^ConsultBlock)(void);


@interface JNSYDocersCell : UITableViewCell

@property(nonatomic,strong)UIImageView *headerImg;    //头像

@property(nonatomic,strong)UILabel *titleLab;         //名字

@property(nonatomic,strong)UIImageView *statusImg;    //在线状态

@property(nonatomic,strong)UIButton *consultBtn;      //咨询按钮

@property(nonatomic,strong)UILabel *cerNameLab;       //资质名称

@property(nonatomic,strong)UILabel *cerNumLab;        //资质编号

@property(nonatomic,strong)UILabel *cerPhoneLab;      //联系电话

@property(nonatomic,strong)UIButton *phoneBtn;        //电话按钮

@property(nonatomic,strong)UILabel *timesLab;         //咨询人次

@property(nonatomic,strong)UILabel *ratingLab;        //评分

@property(nonatomic,strong)UIImageView *locationImg;  //位置图标

@property(nonatomic,strong)UILabel *locationLab;      //药房信息

@property(nonatomic,strong)UILabel *distanceLab;      //距离

@property(nonatomic,copy)ConsultBlock consultBlock;   //咨询Blcok

- (void)configDocerInfo:(NSDictionary *)infoDic;
    
    
    
    


@end
