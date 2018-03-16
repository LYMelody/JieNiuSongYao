//
//  JNSYScoreViewController.m
//  JieNiuSongYao
//
//  Created by rongfeng on 2017/5/18.
//  Copyright © 2017年 China Zhou. All rights reserved.
//

#import "JNSYScoreViewController.h"
#import "Common.h"
#import "Masonry.h"
#import "UICountingLabel.h"
#import "wendu_yuan2.h"
#import "UIColor+Hex.h"
#import "JNSYJiFenDetailTableViewCell.h"
#import "JNSYListHeaderTableViewCell.h"
#import "CNPPopupController.h"

@interface JNSYScoreViewController ()<UITableViewDelegate,UITableViewDataSource,CNPPopupControllerDelegate>

@property (nonatomic, strong)wendu_yuan2 *progressView;
@property (nonatomic, strong)UICountingLabel *pointLab;
@property (nonatomic, assign)int point;
@property (nonatomic, strong)UIButton *JiFenBtn;
@property (nonatomic, strong)UILabel *JiFenRuleLab;
@property (nonatomic, strong)UIImageView *avaiableImg;
@property (nonatomic, strong)UILabel *avaibleLab;
@property (nonatomic, strong)UILabel *LostScoreLab;
@property (nonatomic, strong)UIImageView *avaiableBackImg;
@property (nonatomic, strong)CNPPopupController *popupController;
@end

@implementation JNSYScoreViewController



- (void)viewWillAppear:(BOOL)animated {
    
    [super viewWillAppear:animated];
    
    self.title = @"我的积分";
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    self.navigationController.navigationBar.subviews[0].subviews[0].hidden = YES;
    self.navigationController.navigationBar.translucent = NO;
    
    [self.navigationController setNavigationBarHidden:NO animated:YES];
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //self.navigationController.navigationBar.clipsToBounds = YES;
    
    //[self.navigationController.navigationBar setBackgroundImage:[[UIImage alloc] init] forBarMetrics:UIBarMetricsDefault];
    
    //[self.navigationController.navigationBar setShadowImage:[[UIImage alloc] init]];
    
    UIImageView *HeaderImgView = [[UIImageView alloc] init];
    HeaderImgView.userInteractionEnabled = YES;
    HeaderImgView.backgroundColor = ColorTabBarback;

    [self.view  addSubview:HeaderImgView];
    
    [HeaderImgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view);
        make.left.right.equalTo(self.view);
        make.height.mas_equalTo((KscreenHeight-64)/3*1.0);
    }];
    
    [HeaderImgView addSubview:self.progressView];
    
    //圆形进度条
    [_progressView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(HeaderImgView).offset(10);
        make.centerX.equalTo(HeaderImgView);
        make.height.width.mas_equalTo((KscreenHeight-64)/3*1.0 - 10);
    }];
    self.progressView.progress = 600.0/1000.0;
    self.point = 600;
    [HeaderImgView bringSubviewToFront:self.progressView];
    
    [self.progressView addSubview:self.pointLab];
    
    [self.pointLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.progressView).mas_offset(-5);
        make.centerX.equalTo(self.progressView);
        make.width.mas_equalTo(self.progressView.mas_width);
        make.height.mas_equalTo(40);
    }];
    
    //积分规则
    [HeaderImgView addSubview:self.JiFenBtn];
    
    [self.JiFenBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.progressView).offset(-7);
        make.left.equalTo(self.progressView.mas_right).offset(5);
        make.width.height.mas_equalTo(30);
    }];
    
    [HeaderImgView addSubview:self.JiFenRuleLab];
    
    [self.JiFenRuleLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.JiFenBtn);
        make.left.equalTo(self.JiFenBtn.mas_right).offset(-5);
        make.height.mas_equalTo(30);
        make.width.mas_equalTo(80);
    }];
    
    //可使用积分
    
    [self.progressView addSubview:self.avaiableBackImg];
    
    [self.avaiableBackImg mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.progressView);
        make.bottom.equalTo(self.pointLab.mas_top).offset(0);
        make.height.mas_equalTo(20);
        make.width.mas_equalTo(100);
    }];
    
    
    [self.avaiableBackImg addSubview:self.avaiableImg];
    
    [self.avaiableImg mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.avaiableBackImg);
        make.centerX.equalTo(self.avaiableBackImg).offset(-30);
        make.width.height.mas_equalTo(15);
    }];
    
    [self.avaiableBackImg addSubview:self.avaibleLab];
    
    [self.avaibleLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.avaiableImg).offset(-2);
        make.left.equalTo(self.avaiableImg.mas_right).offset(5);
        make.width.mas_equalTo(80);
        make.height.mas_equalTo(20);
    }];
    
    //失效积分
    
    [self.progressView addSubview:self.LostScoreLab];
    
    [self.LostScoreLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.pointLab.mas_bottom).offset(10);
        make.centerX.equalTo(self.pointLab);
        //make.left.equalTo(self.avaiableBackImg).offset(-10);
        make.width.mas_equalTo(120);
        make.height.mas_equalTo(30);
    }];
    
    
    //积分明细
    
    UITableView *table = [[UITableView alloc] initWithFrame:CGRectMake(0, (KscreenHeight - 64)/3*1.0 , KscreenWidth, KscreenHeight - ((KscreenHeight - 64)/3*1.0) - 64) style:UITableViewStylePlain];
    table.delegate = self;
    table.dataSource = self;
    table.backgroundColor = ColorTableBack;
    table.separatorStyle = UITableViewCellSeparatorStyleNone;
    table.showsVerticalScrollIndicator = NO;
    
    [self.view addSubview:table];
    
    [self startAnimation];

}


- (void)startAnimation {
    
    self.pointLab.method = UILabelCountingMethodLinear;
    self.pointLab.format = @"%d";
    [self.pointLab countFrom:1 to:self.point withDuration:1.5];
    
    [self.progressView start];
    
    
}

- (void)JiFenBtnAction {
    
    NSLog(@"积分规则");
    
    NSMutableParagraphStyle *paragraphStyle = NSMutableParagraphStyle.new;
    paragraphStyle.lineBreakMode = NSLineBreakByWordWrapping;
    paragraphStyle.alignment = NSTextAlignmentCenter;
    
    NSAttributedString *title = [[NSAttributedString alloc] initWithString:@"积分规则" attributes:@{NSFontAttributeName : [UIFont boldSystemFontOfSize:15], NSParagraphStyleAttributeName : paragraphStyle}];
    
    
    UILabel *lab = [[UILabel alloc] init];
    lab.attributedText = title;
    
    UIImageView *LineView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 200, 0.5)];
    LineView.backgroundColor = [UIColor grayColor];
    
    UIImageView *img = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 260, 300)];
    
    UITextView *text = [[UITextView alloc] initWithFrame:CGRectMake(0, 0, 260, 300)];
    text.editable = NO;
    text.textColor = ColorText;
    text.font = [UIFont systemFontOfSize:13];
    text.textAlignment = NSTextAlignmentCenter;
    text.text = @"世人都晓神仙好，只有功名忘不了！\n古今将相在何方？荒冢一堆草没了！\n世人都晓神仙好，只有金银忘不了！\n终朝只恨聚无多，及到多时眼闭了！\n世人都晓神仙好，只有姣妻忘不了！\n君生日日说恩情，君死又随人去了！\n世人都晓神仙好，只有儿孙忘不了！\n痴心父母古来多，孝顺儿孙谁见了？\n";
    [img addSubview:text];
    
    self.popupController = [[CNPPopupController alloc] initWithContents:@[lab,LineView,img]];
    self.popupController.theme = [CNPPopupTheme defaultTheme];
    self.popupController.theme.popupStyle = CNPPopupStyleCentered;
    self.popupController.delegate = self;
    [self.popupController presentPopupControllerAnimated:YES];
    
}


#pragma mark tableviewDelegate&&DataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return 18;
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *identy = @"identy";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identy];
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc] init];
        if (indexPath.row == 0) {
            cell.backgroundColor = ColorTableBack;
        }else if (indexPath.row == 1 ) {
            JNSYListHeaderTableViewCell *Cell = [[JNSYListHeaderTableViewCell alloc] init];
            Cell.leftLab.text = @"积分明细";
            cell = Cell;
        }else {
            JNSYJiFenDetailTableViewCell *Cell = [[JNSYJiFenDetailTableViewCell alloc] init];
            Cell.MesageLab.text = @"线上支付订单送积分(订单：20170519112309)";
            Cell.timeLab.text = @"2017-05-19 11:30:30";
            Cell.ScoreLab.text = @"+100";
            cell = Cell;
        }
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.row == 0) {
        return 5;
    }else if (indexPath.row == 1) {
        return 40;
    }
    else {
        return 44;
    }
    
}

#pragma mark setters
- (wendu_yuan2 *)progressView {
    
    if (_progressView == nil) {
        _progressView = [[wendu_yuan2 alloc] init];
        _progressView.backgroundColor = [UIColor clearColor];
    }
    return _progressView;
    
}

- (UICountingLabel *)pointLab {
    
    if (_pointLab == nil) {
        _pointLab = [[UICountingLabel alloc] init];
        _pointLab.textAlignment = NSTextAlignmentCenter;
        _pointLab.font = [UIFont systemFontOfSize:35];
        _pointLab.textColor = [UIColor whiteColor];
    }
    return _pointLab;
    
}

- (UIButton *)JiFenBtn {
    
    if (_JiFenBtn == nil) {
        _JiFenBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_JiFenBtn setImage:[UIImage imageNamed:@"积分规则"] forState:UIControlStateNormal];
        [_JiFenBtn addTarget:self action:@selector(JiFenBtnAction) forControlEvents:UIControlEventTouchUpInside];
    }
    return _JiFenBtn;
    
}

- (UILabel *)JiFenRuleLab {
    
    if (_JiFenRuleLab == nil) {
        _JiFenRuleLab = [[UILabel alloc] init];
        _JiFenRuleLab.textColor = [UIColor whiteColor];
        _JiFenRuleLab.textAlignment = NSTextAlignmentLeft;
        _JiFenRuleLab.font = [UIFont systemFontOfSize:12];
        _JiFenRuleLab.text = @"积分规则";
    }
    
    return _JiFenRuleLab;
    
}

-(UIImageView *)avaiableBackImg {
    
    if (_avaiableBackImg == nil) {
        _avaiableBackImg = [[UIImageView alloc] init];
        _avaiableBackImg.backgroundColor = [UIColor clearColor];
    }
    
    return _avaiableBackImg;
    
}

- (UIImageView *)avaiableImg {
    
    if (_avaiableImg == nil) {
        _avaiableImg = [[UIImageView alloc] init];
        _avaiableImg.image = [UIImage imageNamed:@"积分"];
    }
    return _avaiableImg;
}

- (UILabel *)avaibleLab {
    
    if (_avaibleLab == nil) {
        _avaibleLab = [[UILabel alloc] init];
        _avaibleLab.textAlignment = NSTextAlignmentLeft;
        _avaibleLab.textColor = [UIColor whiteColor];
        _avaibleLab.font = [UIFont systemFontOfSize:11];
        _avaibleLab.text = @"可使用积分";
    }
    
    return _avaibleLab;
    
}

- (UILabel *)LostScoreLab {
    
    if (_LostScoreLab == nil) {
        _LostScoreLab = [[UILabel alloc] init];
        _LostScoreLab.textColor = [UIColor whiteColor];
        _LostScoreLab.font = [UIFont systemFontOfSize:11];
        _LostScoreLab.textAlignment = NSTextAlignmentCenter;
        _LostScoreLab.numberOfLines = 0;
        _LostScoreLab.text = @"200积分将在\n2017-12-31失效";
    }
    return _LostScoreLab;
    
}


- (void)viewWillDisappear:(BOOL)animated {
    
    [super viewWillDisappear:animated];
    
    self.navigationController.navigationBar.translucent = YES;
    
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
