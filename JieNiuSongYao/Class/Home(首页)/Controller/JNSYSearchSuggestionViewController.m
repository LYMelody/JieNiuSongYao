//
//  JNSYSearchSuggestionViewController.m
//  JieNiuSongYao
//
//  Created by rongfeng on 2017/5/25.
//  Copyright © 2017年 China Zhou. All rights reserved.
//

#import "JNSYSearchSuggestionViewController.h"
#import "Common.h"
#import "Masonry.h"
#import "JNSYSearchSuggestionTableViewCell.h"
@interface JNSYSearchSuggestionViewController ()<UITableViewDataSource,UITableViewDelegate>

@end

@implementation JNSYSearchSuggestionViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.table = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, KscreenWidth, KscreenHeight) style:UITableViewStylePlain];
    _table.delegate = self;
    _table.dataSource = self;
    _table.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:_table];
    
    
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return 10;
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *identy = @"identy";
    
    JNSYSearchSuggestionTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identy];
    if (cell == nil) {
        
        cell = [[JNSYSearchSuggestionTableViewCell alloc] init];
        cell.titleLab.text = @"感冒药";
        
        
    }
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    return 44;
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    
    JNSYSearchSuggestionTableViewCell *Cell = [tableView cellForRowAtIndexPath:indexPath];
    NSString *text = Cell.titleLab.text;
    
    if (_selectSearchTextBlock) {
        _selectSearchTextBlock(text);
    }
    
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    
    if (self.hiddenKeyBoardBlock) {
        _hiddenKeyBoardBlock();
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
