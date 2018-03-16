//
//  JNSYLabAndFldTableViewCell.h
//  JieNiuSongYao
//
//  Created by rongfeng on 2017/5/11.
//  Copyright © 2017年 China Zhou. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface JNSYLabAndFldTableViewCell : UITableViewCell<UITextFieldDelegate>

@property (nonatomic, strong)UILabel *LeftLab;
@property (nonatomic, strong)UITextField *RightFld;
@property (nonatomic, strong)UIImageView *BottomLineView;
@end
