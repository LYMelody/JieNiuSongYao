//
//  JNSYEvateViewController.m
//  JieNiuSongYao
//
//  Created by rongfeng on 2017/6/1.
//  Copyright © 2017年 China Zhou. All rights reserved.
//

#import "JNSYEvateViewController.h"
#import "Common.h"
#import "JNSYAutoSize.h"
#import "JNSYEvaluateTableViewCell.h"
#import "CommentModel.h"

@interface JNSYEvateViewController ()<UITableViewDelegate,UITableViewDataSource>

@end

@implementation JNSYEvateViewController {
    
    CommentModel *ModelOne;
    NSMutableArray *CommentArray;
    //UITableView *table;
}


- (void)viewWillAppear:(BOOL)animated {
    
    [super viewWillAppear:animated];
    
    self.title = @"评价";
    self.view.backgroundColor = ColorTableBack;
    
}




- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    //初始化数据
    ModelOne = [[CommentModel alloc] init];
    ModelOne.UserNameStr = @"陈奕迅";
    ModelOne.Rating = @"4.5";
    ModelOne.CommentStr = @"小时候谁都有个叛逆期，我爸呢属于挺不在意那些浮夸的东西，这样一人儿，所以直到我初中，他还是骑着一辆破自行车接我上下学。据他说，我出生的时候，自行车就有二十岁了。他一直不换，也只是破了修。";
    ModelOne.ReplyCommentStr = @"有一天我在一个爸爸的朋友面前一不小心表露出了这种心思。我到现在都记得那个叔叔和我说的话，他同时也是我好朋友的爸爸。他说，你说，是像这样有钱但从来不着家的爸爸好，还是像你爸，每天来接你，又很勤恳做学问的这样一位学者好？";
    ModelOne.ReplyCommentTimeStr = @"2017-6-5 12:23:12";
    
    CommentModel *ModelTwo = [[CommentModel alloc] init];
    ModelTwo.UserNameStr = @"乔布斯";
    ModelTwo.Rating = @"4.0";
    ModelTwo.CommentStr = @"药到病除!又很勤恳做学问的这样一位学者好着一辆破自行车";
    ModelTwo.ReplyCommentStr = @"谢谢!";
    ModelTwo.ReplyCommentTimeStr = @"2015-9-5 11:23:12";
    
    CommentModel *ModelThree = [[CommentModel alloc] init];
    ModelThree.UserNameStr = @"詹姆斯";
    ModelThree.Rating = @"3.0";
    ModelThree.CommentStr = @"JUSt so so!";
    //ModelThree.ReplyCommentStr = @"thranks, james!";
    ModelThree.ReplyCommentTimeStr = @"2018-6-5 12:23:12";
    CommentArray = [[NSMutableArray alloc] initWithObjects:ModelOne,ModelTwo, ModelThree,nil];
    
    //_table = [[UITableView alloc] initWithFrame:CGRectMake(0, [JNSYAutoSize AutoHeight:3], KscreenWidth, KscreenHeight - [JNSYAutoSize AutoHeight:385]) style:UITableViewStylePlain];
    _table = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, KscreenWidth, KscreenHeight) style:UITableViewStylePlain];
    if (self.tag == 100) {
        _table.frame = CGRectMake(0, [JNSYAutoSize AutoHeight:3], KscreenWidth, KscreenHeight - [JNSYAutoSize AutoHeight:385]);
    }
    _table.delegate = self;
    _table.dataSource = self;
    _table.backgroundColor = ColorTableBack;
    _table.showsVerticalScrollIndicator = NO;
    _table.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:_table];
    
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return 3;
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *identy = @"identy";
    
    JNSYEvaluateTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identy];
    if (cell == nil) {
        cell = [[JNSYEvaluateTableViewCell alloc] init];
        cell.commentModel = CommentArray[indexPath.row];
        [cell changeheight];
        //cell.cellheight = cell.frame.size.height;
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    return cell;
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    
    UITableViewCell *cell = [self tableView:tableView cellForRowAtIndexPath:indexPath];
    
   // NSLog(@"%f",cell.frame.size.height);
    
    
    return cell.frame.size.height;
    
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
