//
//  JNSYSexSelectViewController.m
//  JieNiuSongYao
//
//  Created by rongfeng on 2017/5/15.
//  Copyright © 2017年 China Zhou. All rights reserved.
//

#import "JNSYSexSelectViewController.h"
#import "Common.h"
#import "Masonry.h"
#import "JNSYCommenMethods.h"
#import "JNSYUserInfo.h"
@interface JNSYSexSelectViewController ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic, retain)NSIndexPath *selectedIndexPath;

@end

@implementation JNSYSexSelectViewController {
    
    NSUserDefaults *User;
    NSString *sex;
    
}


- (void)viewWillAppear:(BOOL)animated {
    
    [super viewWillAppear:animated];
    
    self.title = @"性别";
    
    self.view.backgroundColor = [UIColor whiteColor];
    User = [NSUserDefaults standardUserDefaults];
    sex = [User objectForKey:@"Sex"];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    UITableView *table = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, KscreenWidth, KscreenHeight)];
    table.delegate = self;
    table.dataSource = self;
    table.backgroundColor = ColorTableBack;
    table.tableFooterView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 0, CGFLOAT_MIN)];
    table.showsVerticalScrollIndicator = NO;
    [self.view addSubview:table];
    
    //_selectedIndexPath = [NSIndexPath indexPathWithIndex:0];
    
    }

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return 3;
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *identy = @"identy";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identy];
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc] init];
        
        if (indexPath.row == 1) {
            if ([[JNSYUserInfo getUserInfo].userSex integerValue] == 1) {
                _selectedIndexPath = indexPath;
            }
            cell.textLabel.text = @"男";
        }else if (indexPath.row == 2) {
            if ([[JNSYUserInfo getUserInfo].userSex integerValue] == 0) {
                _selectedIndexPath = indexPath;
            }
            cell.textLabel.text = @"女";
        }else if (indexPath.row == 0) {
            cell.backgroundColor = ColorTableBack;
        }
    }
    if (_selectedIndexPath == indexPath) {
        cell.accessoryType = UITableViewCellAccessoryCheckmark;
    }else {
        cell.accessoryType = UITableViewCellAccessoryNone;
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    int newRow = (int)indexPath.row;
    int oldRow = (int)(_selectedIndexPath != nil) ? (int)_selectedIndexPath.row: -1;
    if (newRow != oldRow) {
        UITableViewCell *Newcell = [tableView cellForRowAtIndexPath:indexPath];
        Newcell.accessoryType = UITableViewCellAccessoryCheckmark;
        
        UITableViewCell *OldCell = [tableView cellForRowAtIndexPath:_selectedIndexPath];
        OldCell.accessoryType = UITableViewCellAccessoryNone;
        
        _selectedIndexPath = indexPath;
        //上传修改性别信息
        [JNSYCommenMethods UpLoadUserPicHeader:nil userSex:((indexPath.row == 1)?@"1":@"0") birthday:nil userName:nil];
        
    }
    
    if (_ChangeSexBlock) {
        _ChangeSexBlock();
    }
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.row == 0) {
        return 10;
    }else {
        return 40;
    }
    
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
