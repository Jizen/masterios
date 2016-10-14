//
//  PersonalViewController.m
//  Opt_master
//
//  Created by 瑞宁科技02 on 16/7/18.
//  Copyright © 2016年 reining. All rights reserved.
//

#import "PersonalViewController.h"
#import "MineViewCell.h"
#import "GBTagListView.h"
#import "MineModel.h"
#import "QuestionModel.h"
#import "QuestionTableViewCell.h"
#import "UITableView+SDAutoTableViewCellHeight.h"
#import "NQXImageBrowswe.h"
#define TableViewCellId @"QuestionTableViewCell"

@interface PersonalViewController ()<UITableViewDelegate,UITableViewDataSource,UIGestureRecognizerDelegate>
{
    
    NSArray*strArray;//保存标签数据的数组
    GBTagListView*_tempTag;
    
}
@property (strong, nonatomic) UIImageView *HeadImgView; //!< 头部图像
@property (nonatomic ,strong) UIImageView *headImage;
@property (nonatomic ,strong) UILabel *nameLabel;
@property (nonatomic ,strong) UITableView *tableView;
@property (nonatomic ,strong) UIView *navBar;
@property (nonatomic ,strong) UIButton *backBtn;
@property (nonatomic ,strong) UILabel *titleLabel;
@property (nonatomic ,strong) UIView *line;
@property (nonatomic ,strong) GBTagListView *tagList;
@property (nonatomic ,strong) MineModel *mineModel;
@property (nonatomic ,strong)QuestionModel *model;
@property (nonatomic ,strong)NSMutableArray *dataArray;
@property (nonatomic ,strong) MBProgressHUD *hud;

@end

@implementation PersonalViewController
#pragma mark - lazy
- (NSMutableArray *)dataArray{
    if (!_dataArray) {
        _dataArray = [NSMutableArray array];
    }
    return _dataArray;
}

- (UIImageView *)headImage{
    if (!_headImage) {
        _headImage.userInteractionEnabled = YES;
        _headImage = [[UIImageView alloc] init];
        _headImage.image = [UIImage imageNamed:@"head"];
        
    }
    return _headImage;
}

- (UILabel *)nameLabel{
    if (!_nameLabel) {
        _nameLabel = [[UILabel alloc] init];
        _nameLabel.textAlignment = NSTextAlignmentCenter;
        _nameLabel.textColor = [UIColor whiteColor];
    }
    return _nameLabel;
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.line.hidden = YES;
    [self requestDataWithPage:self.userid];
    [self requestReplyWithPage:1 userid:self.userid];
    NSLog(@"self.userid== %d",self.userid);
    self.navigationController.navigationBarHidden = YES;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    
    [self initTableView];
    [self createNavBar];
    
    
    //    // 与图像高度一样防止数据被遮挡
    self.tableView.tableHeaderView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kWidth, 200)];
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.view.backgroundColor = [UIColor whiteColor];
    self.HeadImgView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, kWidth, 200)];
    self.HeadImgView.backgroundColor = PRIMARY_COLOR;
    
    self.tableView.tableHeaderView = self.HeadImgView;
    [self.HeadImgView addSubview:self.headImage];
    [self.HeadImgView addSubview:self.nameLabel];
    
    self.headImage.sd_layout
    .centerXEqualToView(self.HeadImgView)
    .topSpaceToView(self.HeadImgView,50)
    .widthIs(80)
    .heightIs(80);
    self.headImage.sd_cornerRadiusFromHeightRatio = @(0.5); // 设置view0的圆角半径为自身高度的0.5倍
    
    

    
    self.tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    [self.tableView registerClass:[QuestionTableViewCell class] forCellReuseIdentifier:TableViewCellId];
    
    
}


-(void)viewDidLayoutSubviews {
    if ([self.tableView respondsToSelector:@selector(setSeparatorInset:)]) {
        [_tableView setSeparatorInset:UIEdgeInsetsZero];
        
    }
    if ([_tableView respondsToSelector:@selector(setLayoutMargins:)])  {
        [_tableView setLayoutMargins:UIEdgeInsetsZero];
    }
    
}

-(void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPat{
    if ([cell respondsToSelector:@selector(setLayoutMargins:)]) {
        [cell setLayoutMargins:UIEdgeInsetsZero];
    }
    if ([cell respondsToSelector:@selector(setSeparatorInset:)]){
        [cell setSeparatorInset:UIEdgeInsetsZero];
    }
    if([cell respondsToSelector:@selector(setPreservesSuperviewLayoutMargins:)]){
        [cell setPreservesSuperviewLayoutMargins:NO];
    }
    
}
- (void)setupProgressHud
{
    self.hud = [[MBProgressHUD alloc] initWithView:self.view] ;
    self.hud.label.text=@"正在加载...";
    _hud.frame = self.view.bounds;
    _hud.minSize = CGSizeMake(100, 100);
    _hud.mode = MBProgressHUDModeIndeterminate;
    [self.view addSubview:_hud];
    [_hud showAnimated:YES];
}



-(void)createNavBar{
    self.navBar = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kWidth, 64)];
    _navBar.backgroundColor = [UIColor clearColor];
    [self.view addSubview:_navBar];
    
    
    self.titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(kWidth/2-50, 30, 100, 20)];
    _titleLabel.textAlignment = NSTextAlignmentCenter;
    _titleLabel.text = @"个人中心";
    _titleLabel.hidden = YES;
    _titleLabel.textColor = [UIColor whiteColor];
    [_navBar addSubview:_titleLabel];
    
    self.backBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    _backBtn.frame = CGRectMake(0, 20, 60, 44);
    [_backBtn setImageEdgeInsets:UIEdgeInsetsMake(0, 0, 0, 10)];
    [_backBtn setTitleColor:PRIMARY_COLOR forState:UIControlStateNormal];
    [_backBtn setImage:[UIImage imageNamed:@"return_w"] forState:(UIControlStateNormal)];
    [_backBtn addTarget:self action:@selector(leftAction) forControlEvents:UIControlEventTouchUpInside];
    [_navBar addSubview:_backBtn];
    
    self.line = [[UIView alloc] initWithFrame:CGRectMake(0, 63.5, kWidth, 0.5)];
    _line.backgroundColor = SEPARATOR_LINE_COLOR;
    [_navBar addSubview:_line];
}
- (void)leftAction{
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - ui
- (void)initTableView{
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, self.view.bounds.size.height-_bottomViewH) style:UITableViewStylePlain];
    self.tableView.backgroundColor = BG;
    self.tableView.dataSource =self;
    self.tableView.delegate = self;
    self.tableView.bounces = NO;

    self.tableView.contentInset = UIEdgeInsetsMake(0, 0, 0, 0);
    self.tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    self.tableView.scrollIndicatorInsets=self.tableView.contentInset;
    [self.view addSubview:self.tableView];
    
}

#pragma mark - request
- (void)requestDataWithPage:(int)page{
    NSString *strUrl = [NSString stringWithFormat:@"%@%d",URL_USER_SHOW,page];
    [[HttpTool shareManager] GET:strUrl parameters:nil success:^(NSURLSessionDataTask *task, id responseObject) {

        
        NSDictionary *data = responseObject[@"data"];
        
        NSString *headUrl =[NSString stringWithFormat:@"%@",data[@"avatar"]] ;

        [self.headImage sd_setImageWithURL:[NSURL URLWithString:headUrl] placeholderImage:[UIImage imageNamed:@"head"]];
        self.nameLabel.text = data[@"nickname"];
        self.nameLabel.sd_layout
        .centerXEqualToView(self.HeadImgView)
        .topSpaceToView(self.headImage,10)
        .heightIs(20);
        [self.nameLabel setSingleLineAutoResizeWithMaxWidth:[UIScreen mainScreen].bounds.size.width];
        NSError* err=nil;
        self.mineModel = [[MineModel alloc]initWithDictionary:data error:&err];
        if (_mineModel.tags.length == 0) {
            
        }else{
            strArray = [_mineModel.tags componentsSeparatedByString:@","];
            [_tagList removeFromSuperview];
        }
        
        [self.hud hideAnimated:YES];

        [self.tableView reloadData];
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        
    }];
}
- (void)requestReplyWithPage:(int)page userid:(int)userid {
    
    NSString *url = [NSString stringWithFormat:@"%@%d/page/%d",URL_USER_REPLY,userid,page];
    [[HttpTool shareManager] GET:url parameters:nil success:^(NSURLSessionDataTask *task, id responseObject) {
        
        NSMutableArray *messages = responseObject[@"rows"];
        if (page == 1) {
            [self.dataArray removeAllObjects];
        }
        
        for (NSDictionary *dict  in messages) {
            NSError* err=nil;
            _model = [[QuestionModel alloc]initWithDictionary:dict error:&err];
            [self.dataArray addObject:_model];
        }
        [self.tableView reloadData];
    } failure:^(NSURLSessionDataTask *task, NSError *error) {

    }];
    
    
}

- (void)hudWithTitle:(NSString *)title
{
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
    hud.mode = MBProgressHUDModeText;
    hud.label.text = title;
    [hud hideAnimated:YES afterDelay:1.f];
}
#pragma mark - TableViewCell 代理方法

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == 0) {
        return 1;
    }
    return self.dataArray.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    MineViewCell *cell = [MineViewCell cellWithTableView:tableView];
    cell.imageView.image = [UIImage imageNamed:@"attention"];
    
    if (indexPath.section == 0) {
        UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:(UITableViewCellStyleDefault) reuseIdentifier:@"tagcell"];
        self.tagList=[[GBTagListView alloc]initWithFrame:CGRectMake(0, DEFUALT_MARGIN_SIDES, kWidth- DEFUALT_MARGIN_SIDES, DEFUALT_MARGIN_SIDES)];
        _tagList.signalTagColor=[UIColor whiteColor];
        [_tagList setTagWithTagArray:strArray];
        [_tagList setDidselectItemBlock:^(NSArray *arr) {}];
        [cell addSubview:_tagList];
        
        CGRect size = cell.frame;
        size.size.height = _tagList.frame.size.height;
        cell.frame  = size;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        
        if (_mineModel.tags.length == 0) {
            UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(DEFUALT_MARGIN_SIDES, 0, kWidth, 37)];
            label.textColor = TXT_COLOR;
            label.font = GZFontWithSize(12);
            label.text = @"该用户暂没有感兴趣的标签";
            [cell addSubview:label];
        }else{
        }
        
        
        return cell;
    }
    if (indexPath.section == 1) {

        QuestionTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:TableViewCellId];
        cell.model = self.dataArray[indexPath.row];
        cell.sd_tableView = tableView;
        cell.sd_indexPath = indexPath;
        return cell;

    }
    return cell;
}
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {

    _navBar.backgroundColor = Navigation_COLOR;
    self.line.hidden = NO;

    self.navBar.alpha=scrollView.contentOffset.y/200;
    [_backBtn setImage:[UIImage imageNamed:@"return"] forState:(UIControlStateNormal)];
    _titleLabel.hidden = NO;

    if (scrollView.contentOffset.y < 5) {
        _navBar.backgroundColor = [UIColor clearColor];
        _navBar.alpha = 1;
        [_backBtn setImage:[UIImage imageNamed:@"return_w"] forState:(UIControlStateNormal)];
        _titleLabel.hidden = YES;
        self.line.hidden = YES;


    }

    if (scrollView.contentOffset.y > 50) {
        self.tableView.bounces = YES;
        [self setNeedsStatusBarAppearanceUpdate];
        [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleDefault;


    }else{
        [self setNeedsStatusBarAppearanceUpdate];
        self.tableView.bounces = NO;
        [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleLightContent;

    }



}
- (UIStatusBarStyle)preferredStatusBarStyle{
    if (self.tableView.contentOffset.y > 50) {
        return UIStatusBarStyleDefault;

    }else if (self.tableView.contentOffset.y < 10) {
        return UIStatusBarStyleLightContent;
        
    }else{
    return UIStatusBarStyleLightContent;
    }
}


- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kWidth, 30)];
    view.backgroundColor = BG;
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(DEFUALT_MARGIN_SIDES, 0, kWidth, 30)];
    label.backgroundColor = BG;
    label.textColor = TXT_COLOR;
    label.font = GZFontWithSize(12);
    if (section == 0 ) {
        label.text = @"TA的标签";
    }else{
        label.text = @"TA的回答";
    }
    [view addSubview:label];
    return view;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    
    return 30;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 1) {
    // >>>>>>>>>>>>>>>>>>>>> * cell自适应 * >>>>>>>>>>>>>>>>>>>>>>>>
    id model = self.dataArray[indexPath.row];
    return [self.tableView cellHeightForIndexPath:indexPath model:model keyPath:@"model" cellClass:[QuestionTableViewCell class] contentViewWidth:[self cellContentViewWith]];

    }
    if (_mineModel.tags.length == 0) {
        return 30;
    }else{
    return _tagList.frame.size.height+DEFUALT_MARGIN_SIDES;
    }
}



- (CGFloat)cellContentViewWith
{
    CGFloat width = [UIScreen mainScreen].bounds.size.width;
    
    // 适配ios7
    if ([UIApplication sharedApplication].statusBarOrientation != UIInterfaceOrientationPortrait && [[UIDevice currentDevice].systemVersion floatValue] < 8) {
        width = [UIScreen mainScreen].bounds.size.height;
    }
    return width;
}


@end
