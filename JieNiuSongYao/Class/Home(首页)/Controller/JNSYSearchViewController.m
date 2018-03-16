//
//  JNSYSearchViewController.m
//  JieNiuSongYao
//
//  Created by rongfeng on 2017/5/23.
//  Copyright © 2017年 China Zhou. All rights reserved.
//

#import "JNSYSearchViewController.h"
#import "Common.h"
#import "Masonry.h"
#import "JNSYListHeaderTableViewCell.h"
#import "JNSYHistoryTableViewCell.h"
#import "JNSYSearchLabTableViewCell.h"
#import "JNSYSearchResultViewController.h"
#import "JNSYSearchSuggestionViewController.h"
#import "JNSYAutoSize.h"
#import "JNSYUserInfo.h"
#import "SBJSON.h"
#import "IBHttpTool.h"
#import "MBProgressHUD.h"
#import "JNSYMedicineModel.h"
#import "JNSYMedicineDetailViewController.h"
@interface JNSYSearchViewController ()<UISearchBarDelegate,UITableViewDelegate,UITableViewDataSource,UIAlertViewDelegate>

@property (nonatomic, strong)JNSYSearchResultViewController *SearchResultView;

@property (nonatomic, strong)JNSYSearchSuggestionViewController *SearchSuggestionVc;

@property (nonatomic, strong)UISearchBar *SearchBar;

@property (nonatomic, strong)UITableView *table;

@end

@implementation JNSYSearchViewController {
    
//    UISearchBar *SearchBar;
//    UITableView *table;
    
}

- (JNSYSearchResultViewController *)SearchResultView {
    if (_SearchResultView == nil) {
        _SearchResultView = [[JNSYSearchResultViewController alloc] init];
        _SearchResultView.view.frame = CGRectMake(0, 64, KscreenWidth, KscreenHeight - 64);
        
        __weak typeof(self) WeakSelf = self;
        
        _SearchResultView.hiddenKeyBoardBlock = ^{
            
            __strong typeof(self) StrongSelf = WeakSelf;
            [StrongSelf.SearchBar resignFirstResponder];
        };
        
        [self.view addSubview:_SearchResultView.view];
        UINavigationController *Nav = [[UINavigationController alloc] initWithRootViewController:_SearchResultView];
        
        [self addChildViewController:Nav];
        
    }
    
    return _SearchResultView;
    
    
}

- (JNSYSearchSuggestionViewController *)SearchSuggestionVc {
    
    if (_SearchSuggestionVc == nil) {
        _SearchSuggestionVc = [[JNSYSearchSuggestionViewController alloc] init];
        _SearchSuggestionVc.view.frame = CGRectMake(0, 64, KscreenWidth, KscreenHeight - 64);
        
        
        __weak typeof(self) WeakSelf = self;
        
        
        _SearchSuggestionVc.selectSearchTextBlock = ^(NSString *text) {
            
            
            __strong typeof(self) StrongSelf = WeakSelf;
            
            //保存搜索记录
            [StrongSelf.SearchHistoryArray addObject:text];
            
            //跳转搜索结果
            
            [StrongSelf keyWordSearch:text];
            
            StrongSelf.table.hidden = YES;
            StrongSelf.SearchResultView.view.hidden = NO;
            StrongSelf.SearchSuggestionVc.view.hidden = YES;
            
            [StrongSelf.view bringSubviewToFront:StrongSelf.SearchResultView.view];
            
            [StrongSelf.SearchBar resignFirstResponder];
            
            
        };
        
        
        _SearchSuggestionVc.hiddenKeyBoardBlock = ^{
            __strong typeof(self) StrongSelf = WeakSelf;
            [StrongSelf.SearchBar resignFirstResponder];
        };
        
        
        [self.view addSubview:_SearchSuggestionVc.view];
        
        UINavigationController *Nav = [[UINavigationController alloc] initWithRootViewController:_SearchSuggestionVc];
        
        [self addChildViewController:Nav];
    }
    
    return _SearchSuggestionVc;
    
}

- (void)viewWillAppear:(BOOL)animated {
    
    [super viewWillAppear:animated];
    
    
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault animated:YES];
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    //self.navigationController.navigationBar.hidden = YES;
    [self.navigationController setNavigationBarHidden:YES animated:YES];
    //返回按钮
    self.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"" style:UIBarButtonItemStylePlain target:self action:nil];
    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];

    
    [self requestHotAndHistoryList];
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    //热门搜索和搜索历史
//    self.hotSearchArray =[[NSMutableArray alloc] initWithArray:@[@"王者农药",@"部落冲突",@"红楼梦",@"贾瑞",@"王熙凤",@"贾宝玉",@"林黛玉",@"《白鹿原电视剧》",@"《红楼梦》（87版）",@"兴业银行葵花药业",@"《全球通史》",@"《中国通史》",@"《Object-C》",@"swift",@"C"]];
//    
//    self.SearchHistoryArray = [[NSMutableArray alloc] initWithArray:@[@"平安药房",@"感冒药",@"捷牛送药",@"张药师",@"999牌平炎平"]];
    
    [self setUpViews];
    
    
}


- (void)setUpViews {
    
    
    UIImageView *titleView = [[UIImageView alloc] init];
    titleView.userInteractionEnabled = YES;
    titleView.backgroundColor = [UIColor whiteColor];
    titleView.frame = CGRectMake(0, 0 , KscreenWidth, 64);
    
    [self.view addSubview:titleView];
    
    
    UIButton *rightBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [rightBtn setTitle:@"取消" forState:UIControlStateNormal];
    rightBtn.titleLabel.font = [UIFont systemFontOfSize:13];
    [rightBtn setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
    [rightBtn addTarget:self action:@selector(CancelAction) forControlEvents:UIControlEventTouchUpInside];
    
    [titleView addSubview:rightBtn];
    
    [rightBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.equalTo(titleView).offset(20);
        make.right.equalTo(titleView).offset(-10);
        make.width.mas_equalTo(40);
        make.height.mas_equalTo(40);
    }];
    
    _SearchBar = [[UISearchBar alloc] init];
    _SearchBar.placeholder = @"输入药品、药店";
    _SearchBar.barStyle = UIBarStyleDefault;
    _SearchBar.layer.borderColor = ColorTabBarback.CGColor;
    _SearchBar.layer.borderWidth = 1.5;
    _SearchBar.layer.cornerRadius = 12;
    _SearchBar.layer.masksToBounds = YES;
    _SearchBar.barTintColor = [UIColor whiteColor];
    _SearchBar.delegate = self;
    
    [titleView addSubview:_SearchBar];
    //设为第一响应者
    [_SearchBar becomeFirstResponder];
    
    [_SearchBar mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(titleView).offset(26);
        make.left.equalTo(titleView).offset(20);
        make.bottom.equalTo(titleView.mas_bottom).offset(-10);
        make.right.equalTo(rightBtn.mas_left).offset(-8);
    }];
    
    
    
    _table = [[UITableView alloc] initWithFrame:CGRectMake(0, 64, KscreenWidth, KscreenHeight - 64) style:UITableViewStylePlain];
    _table.delegate = self;
    _table.dataSource = self;
    _table.backgroundColor = ColorTableBack;
    _table.separatorStyle = UITableViewCellSeparatorStyleNone;
    _table.showsVerticalScrollIndicator = NO;
    _table.tableFooterView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 0, CGFLOAT_MIN)];
    [self.view addSubview:_table];
    
    UITapGestureRecognizer *TapHideenKeyBoard = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(TapHideenKeyBoardAction)];
    TapHideenKeyBoard.numberOfTouchesRequired = 1;
    //[table addGestureRecognizer:TapHideenKeyBoard];
}




#pragma mark UITableViewDeleage&&UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return 5;
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *identy = @"identy";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identy];
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc] init];
        
        if (indexPath.row == 0) {
            cell.backgroundColor = ColorTableBack;
        }else if (indexPath.row == 1) {
            JNSYListHeaderTableViewCell *Cell = [[JNSYListHeaderTableViewCell alloc] init];
            Cell.leftLab.text = @"热门搜索";
            Cell.bottomLine.hidden = YES;
            cell = Cell;
        }else if (indexPath.row == 2) {
            JNSYSearchLabTableViewCell *Cell = [[JNSYSearchLabTableViewCell alloc] init];
            Cell.titleArray = [[NSMutableArray alloc] initWithArray:self.hotSearchArray];
            [Cell setUpViews];
            [Cell changeCellHeight];
            Cell.labClickBlock = ^(NSString *text) {
                NSLog(@"%@",text);
                _SearchBar.text = text;
                [_SearchBar resignFirstResponder];
                self.SearchResultView.view.hidden = NO;
                _table.hidden = YES;
                [self.view bringSubviewToFront:self.SearchResultView.view];
                //self.ch
            };
            cell = Cell;
            
        }else if (indexPath.row == 3) {
            JNSYHistoryTableViewCell *Cell = [[JNSYHistoryTableViewCell alloc] init];
            Cell.leftLab.text = @"历史搜索";
            Cell.delectBlock = ^{
                NSLog(@"删除");
                
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:@"确认删除全部历史记录?" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确认", nil];
                [alert show];
                
            };
            
            cell = Cell;
            
        }else if (indexPath.row == 4) {
            JNSYSearchLabTableViewCell *Cell = [[JNSYSearchLabTableViewCell alloc] init];
            
            Cell.titleArray = [[NSMutableArray alloc] initWithArray:self.SearchHistoryArray];
            [Cell setUpViews];
            [Cell changeCellHeight];
            Cell.labClickBlock = ^(NSString *text) {
                NSLog(@"%@",text);
                _SearchBar.text = text;
                
            };
            cell = Cell;
        }else {
            
        }
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    
    if (indexPath.row == 0) {
        return 6;
    }else if (indexPath.row == 1 || indexPath.row == 3) {
        return 40;
    }else if(indexPath.row == 2){
        
        UITableViewCell *cell = [self tableView:tableView cellForRowAtIndexPath:indexPath];
        NSLog(@"%f",cell.frame.size.height);
        return cell.frame.size.height;
    }else if (indexPath.row == 4) {
        UITableViewCell *cell = [self tableView:tableView cellForRowAtIndexPath:indexPath];
        return cell.frame.size.height;
    }else {
        return 40;
    }
}


#define NetRequest

//搜索热门和历史搜索
- (void)requestHotAndHistoryList {
    
    NSDictionary *dic = @{
                          @"imei":[JNSYAutoSize getDiviceIMEI]
                          };
    NSString *action = @"SearchHistoryState";
    NSDictionary *requestDic = @{
                                 @"action":action,
                                 @"token":[JNSYUserInfo getUserInfo].userToken,
                                 @"data":dic
                                 };
    NSString *params = [requestDic JSONFragment];
    
    [IBHttpTool postWithURL:JNSYTestUrl params:params success:^(id result) {
        NSLog(@"%@",result);
        NSDictionary *resultdic = [result JSONValue];
        NSString *code = resultdic[@"code"];
        NSLog(@"%@,%@",resultdic,code);
        if([code isEqualToString:@"000000"]) {
            //获取热门搜索
            NSString *hots = resultdic[@"hots"];
            NSString *history = resultdic[@"history"];
            self.hotSearchArray = [[NSMutableArray alloc] initWithArray:[hots componentsSeparatedByString:@","]];
            self.SearchHistoryArray = [[NSMutableArray alloc] initWithArray:[history componentsSeparatedByString:@","]];
            
            [_table reloadData];
            
        }else {
            NSString *msg = resultdic[@"msg"];
            [JNSYAutoSize showMsg:msg];
        }

    } failure:^(NSError *error) {
        NSLog(@"%@",error);
    }];
    
}

//搜索关键字
- (void)keyWordSearch:(NSString *)keyWord {
    
    NSDictionary *dic = @{
                          @"searchValue":keyWord,
                          @"lng":self.longtilute,
                          @"lat":self.latitude,
                          @"imei":[JNSYAutoSize getDiviceIMEI]
                          };
    NSString *action = @"SearchState";
    
    NSDictionary *requestDic = @{
                                 @"action":action,
                                 @"token":[JNSYUserInfo getUserInfo].userToken,
                                 @"data":dic
                                 };
    NSString *params = [requestDic JSONFragment];
    
    [IBHttpTool postWithURL:JNSYTestUrl params:params success:^(id result) {
        NSLog(@"%@",result);
        NSDictionary *resultdic = [result JSONValue];
        NSString *code = resultdic[@"code"];
        NSLog(@"%@,%@",resultdic,code);
        if([code isEqualToString:@"000000"]) {
            
            self.SearchResultView.DrugArray = resultdic[@"medicinesList"];
            self.SearchResultView.DrugStoreArray = resultdic[@"shopList"];
            
            if((self.SearchResultView.DrugArray.count == 0) && (self.SearchResultView.DrugStoreArray.count == 0)) {
        
                self.SearchResultView.table.hidden = YES;
        
            }else {
        
                self.SearchResultView.table.hidden = NO;
            }
            
            
            [self.SearchResultView.table reloadData];
            
        }else {
            NSString *msg = resultdic[@"msg"];
            [JNSYAutoSize showMsg:msg];
        }

    } failure:^(NSError *error) {
        NSLog(@"%@",error);
    }];
    
}





#define otherMethods

- (void)TapHideenKeyBoardAction {
    
    [self.SearchBar resignFirstResponder];
}


- (void)CancelAction {
    
    
    NSLog(@"取消");
    
    [self dismissViewControllerAnimated:YES completion:nil];
}


- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    
    
    [self.SearchBar resignFirstResponder];
    
}


#define mark SearchBarDeleage

- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText {
    
    if ([searchText isEqualToString:@""]) {
        self.SearchResultView.view.hidden = YES;
        self.SearchSuggestionVc.view.hidden = YES;
        
        _table.hidden = NO;
        
    }else {
        NSLog(@"%@",searchText);
        self.SearchSuggestionVc.view.hidden = NO;
        _table.hidden = YES;
        
        [self.view bringSubviewToFront:self.SearchSuggestionVc.view];
        
        [self.SearchSuggestionVc.table reloadData];
        
    }
    
    [_table reloadData];
}

- (void)searchBarTextDidBeginEditing:(UISearchBar *)searchBar {
    
    
    
}

- (void)searchBarTextDidEndEditing:(UISearchBar *)searchBar {
    
    
    
}

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar {
    
    //获取搜索列表
    [self keyWordSearch:searchBar.text];
    
    
    _table.hidden = YES;
    self.SearchResultView.view.hidden = NO;
    self.SearchSuggestionVc.view.hidden = YES;
    
    [self.view bringSubviewToFront:self.SearchResultView.view];
    
    [searchBar resignFirstResponder];
}


//#define  mark  UIAlertViewDeleage

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    
    if (buttonIndex == 1) {
        [self.SearchHistoryArray removeAllObjects];
        [_table reloadData];
    }else {
        
    }
    
}


- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    
    //[self.view endEditing:YES];
    
    [_SearchBar resignFirstResponder];
    
}

- (void)viewWillDisappear:(BOOL)animated {
    
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent animated:YES];
    
}

- (UIStatusBarStyle)preferredStatusBarStyle {
    
    return UIStatusBarStyleDefault;
    
}

- (BOOL)prefersStatusBarHidden {
    
    return NO;
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
