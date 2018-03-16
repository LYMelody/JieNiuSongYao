//
//  CommentModel.h
//  JieNiuSongYao
//
//  Created by rongfeng on 2017/6/5.
//  Copyright © 2017年 China Zhou. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CommentModel : NSObject

@property (nonatomic, copy)NSString *UserHeaderImgUrl;
@property (nonatomic, copy)NSString *UserNameStr;
@property (nonatomic, copy)NSString *Rating;
@property (nonatomic, copy)NSString *CommentStr;
@property (nonatomic, copy)NSString *ReplyCommentStr;
@property (nonatomic, copy)NSString *ReplyCommentTimeStr;
@property (nonatomic, copy)NSString *CommentTimeStr;



@end
