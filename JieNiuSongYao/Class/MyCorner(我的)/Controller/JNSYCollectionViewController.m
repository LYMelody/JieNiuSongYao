//
//  JNSYCollectionViewController.m
//  JieNiuSongYao
//
//  Created by rongfeng on 2017/5/18.
//  Copyright © 2017年 China Zhou. All rights reserved.
//

#import "JNSYCollectionViewController.h"
#import "Common.h"
#import "Masonry.h"
#import "JNSYCollectionTableViewCell.h"
@interface JNSYCollectionViewController ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic, strong)NSMutableArray *countArray;

@end

@implementation JNSYCollectionViewController

- (void)viewWillAppear:(BOOL)animated {
    
    [super viewWillAppear:animated];
    
    self.title = @"我的收藏";
    self.view.backgroundColor = [UIColor whiteColor];
    
    [self.navigationController setNavigationBarHidden:NO animated:YES];
}


- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    //[self.navigationController.navigationBar setShadowImage:[[UIImage alloc] init]];
    
    UITableView *table = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, KscreenWidth, KscreenHeight) style:UITableViewStylePlain];
    table.delegate = self;
    table.dataSource = self;
    table.backgroundColor = ColorTableBack;
    table.showsVerticalScrollIndicator = NO;
    table.tableFooterView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 0, CGFLOAT_MIN)];
    table.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:table];
    
    _countArray = [[NSMutableArray alloc] initWithArray:@[@15.9,@22,@19.8,@18.3,@22.5,@17.5,@35.0,@45.9]];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return _countArray.count;
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *identy = @"identy";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identy];
    
    if (cell == nil) {
        JNSYCollectionTableViewCell *Cell = [[JNSYCollectionTableViewCell alloc] init];
        Cell.drugNameLab.text = @"感冒灵";
        Cell.drugCotentLab.text = @"10ml*6支/盒";
        Cell.drugBelongLab.text = @"葵花药业";
        Cell.drugPriceLab.text = [NSString stringWithFormat:@"￥%@",_countArray[indexPath.row]];
        NSString *prePrice = @"￥23";
        NSMutableAttributedString *attribtstr = [[NSMutableAttributedString alloc] initWithString:prePrice];
        [attribtstr setAttributes:@{NSStrikethroughStyleAttributeName:[NSNumber numberWithInteger:NSUnderlineStyleSingle],NSBaselineOffsetAttributeName : @(NSUnderlineStyleSingle)} range:NSMakeRange(0, prePrice.length)];
        Cell.drugPrePriceLab.attributedText = attribtstr;
        Cell.drugStoreLab.text = @"杭州平安大药房";
        Cell.drugStoreDistanceLab.text = @"1.2km";
        
        __weak typeof(self) weakSelf = self;
        
        Cell.delectCollectionBlock = ^{
            
            UIAlertController *alertVc = [UIAlertController alertControllerWithTitle:@"提示" message:@"您确定要删除该收藏吗?" preferredStyle:UIAlertControllerStyleAlert];
            [alertVc addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
                
                [weakSelf.countArray removeObjectAtIndex:indexPath.row];
                
                //[tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
                
                [tableView reloadData];
                
                NSLog(@"删除 %ld",(long)indexPath.row);
            }]];
            
            [alertVc addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
                NSLog(@"取消");
            }]];
            
            NSLog(@"移除收藏");
            
            [self presentViewController:alertVc animated:YES completion:nil];
        };
        
        cell = Cell;
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;

}


- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    return UITableViewCellEditingStyleDelete;
    
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    
    return YES;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    
    //[tableView setEditing:NO];
    
    if (editingStyle == UITableViewCellEditingStyleDelete) {
       
        [_countArray removeObjectAtIndex:indexPath.row];
        
        [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }else {
        
    }
    
}

- (NSString *)tableView:(UITableView *)tableView titleForDeleteConfirmationButtonForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    return @"删除";
    
}


//- (BOOL)tableView:(UITableView *)tableView shouldIndentWhileEditingRowAtIndexPath:(NSIndexPath *)indexPath {
//    
//    return NO;
//}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    return 100;
    
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
