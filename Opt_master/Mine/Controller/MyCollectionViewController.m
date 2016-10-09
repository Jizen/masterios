//
//  MyCollectionViewController.m
//  Opt_master
//
//  Created by 瑞宁科技02 on 16/7/7.
//  Copyright © 2016年 reining. All rights reserved.
//

#import "MyCollectionViewController.h"
#import "NewsDetailViewController.h"
#import "QuestionDetailViewController.h"
#import "QuestionCell.h"
#import "NewsCell.h"
#import "CommonCell.h"
#import "NewsModel.h"
#import "QuestionModel.h"
int    currentCollectionPagerOrder = 1;

@interface MyCollectionViewController ()<UITableViewDataSource,UITableViewDelegate>
@property (nonatomic ,strong)UITableView *tableView;
@property (nonatomic ,strong)UITableView *attentiontableView;
@property (nonatomic ,strong) UISegmentedControl  *segement;
@property (nonatomic ,strong) UIScrollView *scrollview;
@property (nonatomic ,strong)NSMutableArray *dataArray;
@property (nonatomic ,strong)NSMutableArray *topicArray;
@property (nonatomic ,strong)NewsModel *model;
@property (nonatomic ,strong)QuestionModel *questionModel;

@end

@implementation MyCollectionViewController

#pragma mark - lazy
- (NSMutableArray *)dataArray{
    if (!_dataArray) {
        _dataArray = [NSMutableArray array];
    }
    return _dataArray;
}

- (NSMutableArray *)topicArray{
    if (!_topicArray) {
        _topicArray = [NSMutableArray array];
    }
    return _topicArray;
}
#pragma mark - basic
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.navigationController.navigationBarHidden = YES;
    [self getNetWork];

}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    [self createNavBar];
    [self initTableView];
    [self setupMJRefreshHeader];
    [self refreshMoreData ];
}

#pragma mark - UI
-(void)createNavBar{
    UIView *navBar = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kWidth, 64)];
    navBar.backgroundColor = PRIMARY_COLOR;
    [self.view addSubview:navBar];
    _segement=[[UISegmentedControl alloc]initWithItems:@[@"资讯",@"问答"]];
    _segement.frame=CGRectMake(90, 25, kWidth-180, 30);
    _segement.tintColor=[UIColor whiteColor];
    _segement.selectedSegmentIndex=0;
    [navBar addSubview:_segement];
    [_segement addTarget:self action:@selector(changevalue:) forControlEvents:(UIControlEventValueChanged)];
    
    UIButton *backBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    backBtn.frame = CGRectMake(0, 20, 60, 44);
    [backBtn setImageEdgeInsets:UIEdgeInsetsMake(0, 0, 0, 10)];
    [backBtn setTitleColor:PRIMARY_COLOR forState:UIControlStateNormal];
    [backBtn setImage:[UIImage imageNamed:@"return_w"] forState:(UIControlStateNormal)];
    [backBtn addTarget:self action:@selector(leftAction) forControlEvents:UIControlEventTouchUpInside];
    [navBar addSubview:backBtn];
}
- (void)initTableView{
    self.scrollview=[[UIScrollView alloc]initWithFrame:CGRectMake(0, 64, kWidth, kHeight)];
    _scrollview.directionalLockEnabled=YES;
    _scrollview.contentSize=CGSizeMake(kWidth*2, kHeight);
    _scrollview.delegate=self;
    _scrollview.pagingEnabled = YES;
    [self.view addSubview:self.scrollview];
    
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, self.view.bounds.size.height-64) style:UITableViewStylePlain];
    self.tableView.backgroundColor = BG;
    self.tableView.dataSource =self;
    self.tableView.delegate = self;
    self.tableView.tag = 2000;
    self.tableView.contentInset = UIEdgeInsetsMake(0, 0, 0, 0);
    self.tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    self.tableView.scrollIndicatorInsets=self.tableView.contentInset;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    self.attentiontableView = [[UITableView alloc] initWithFrame:CGRectMake(kWidth, 0, self.view.bounds.size.width, self.view.bounds.size.height-64) style:UITableViewStylePlain];
    self.attentiontableView.dataSource =self;
    self.attentiontableView.delegate = self;
    self.attentiontableView.backgroundColor = BG;
    self.attentiontableView.tag = 2001;
    self.attentiontableView.contentInset = UIEdgeInsetsMake(0, 0, 0, 0);
    self.attentiontableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    self.attentiontableView.scrollIndicatorInsets=self.tableView.contentInset;
    self.attentiontableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.scrollview addSubview:self.attentiontableView];
    [self.scrollview addSubview:self.tableView];
    
}
- (UIStatusBarStyle)preferredStatusBarStyle{
    
    return UIStatusBarStyleLightContent;
}

#pragma mark - action
- (void)leftAction{
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - request
- (void)requestDataWithPage:(int)page category:(NSString *)category{
    
    [self.dataArray  removeAllObjects];
    [self.topicArray removeAllObjects];

    NSString *strUrl = [NSString stringWithFormat:@"%@%@/page/%d",URL_MY_COLLECTION,category,page];
    [[HttpTool shareManager] GET:strUrl parameters:nil success:^(NSURLSessionDataTask *task, id responseObject) {
        NSLog(@"rrr === %@",responseObject);
        NSMutableArray *messages = responseObject[@"data"];
        if ([category isEqualToString:@"news"]) {
            for (NSDictionary *dict  in messages) {
                NSError* err=nil;
                _model = [[NewsModel alloc]initWithDictionary:dict error:&err];
                [self.dataArray addObject:_model];
            }
            [self.tableView reloadData];

        }else if ([category isEqualToString:@"topic"]){
            for (NSDictionary *dict  in messages) {
                NSError* err=nil;
                _questionModel = [[QuestionModel alloc]initWithDictionary:dict error:&err];
                [self.topicArray addObject:_questionModel];
            }
            [self.attentiontableView reloadData];
        }

        [self.tableView.mj_header endRefreshing];
        [self.tableView.mj_footer endRefreshing];
        [self.attentiontableView.mj_header endRefreshing];
        [self.attentiontableView.mj_footer endRefreshing];
        
        
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        NSLog(@"error = %@",error);
//        [self hudWithTitle:@"访问服务器失败"];
        [self.tableView.mj_header endRefreshing];
        [self.tableView.mj_footer endRefreshing];
        
    }];
}

- (void)setupMJRefreshHeader{
    [self.dataArray  removeAllObjects];
    [self.topicArray removeAllObjects];
    MJRefreshNormalHeader *header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(loadNewDatas)];
    header.lastUpdatedTimeLabel.hidden = YES;
    [header setTitle:@"下拉刷新数据" forState:MJRefreshStateIdle];
    [header setTitle:@"正在刷新..." forState:MJRefreshStateRefreshing];
    [header setTitle:@"全部加载完成" forState:MJRefreshStateNoMoreData];
    header.stateLabel.font = [UIFont systemFontOfSize:12];
    header.stateLabel.textColor = [UIColor grayColor];
    
    self.tableView.mj_header = header;
//    [self.tableView.mj_header beginRefreshing];

    
    MJRefreshNormalHeader *header1 = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(loadNewDatas)];
    header1.lastUpdatedTimeLabel.hidden = YES;
    [header1 setTitle:@"下拉刷新数据" forState:MJRefreshStateIdle];
    [header1 setTitle:@"正在刷新..." forState:MJRefreshStateRefreshing];
    [header1 setTitle:@"全部加载完成" forState:MJRefreshStateNoMoreData];
    header1.stateLabel.font = [UIFont systemFontOfSize:12];
    header1.stateLabel.textColor = [UIColor grayColor];
    self.attentiontableView.mj_header = header1;
    
}

- (void)refreshMoreData
{
    MJRefreshBackNormalFooter *footer = [MJRefreshBackNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadMore)];
    [footer setTitle:@"上拉加载更多" forState:MJRefreshStateIdle];
    [footer setTitle:@"正在刷新..." forState:MJRefreshStateRefreshing];
    [footer setTitle:@"全部加载完成" forState:MJRefreshStateNoMoreData];
    footer.stateLabel.font = [UIFont systemFontOfSize:12];
    footer.stateLabel.textColor = [UIColor grayColor];
    self.tableView.mj_footer = footer;
    
    MJRefreshBackNormalFooter *footer1 = [MJRefreshBackNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadMore)];
    [footer1 setTitle:@"上拉加载更多" forState:MJRefreshStateIdle];
    [footer1 setTitle:@"正在刷新..." forState:MJRefreshStateRefreshing];
    [footer1 setTitle:@"全部加载完成" forState:MJRefreshStateNoMoreData];
    footer1.stateLabel.font = [UIFont systemFontOfSize:12];
    footer1.stateLabel.textColor = [UIColor grayColor];
    self.attentiontableView.mj_footer = footer1;
    
}
//上拉加载更多数据
- (void)loadMore
{
    Reachability *ability = [Reachability reachabilityForInternetConnection];
    if (ability.currentReachabilityStatus == ReachableViaWiFi || ability.currentReachabilityStatus == ReachableViaWWAN) {
        currentCollectionPagerOrder = currentCollectionPagerOrder+1;
        [self requestDataWithPage:currentCollectionPagerOrder category:@"news"];
        [self requestDataWithPage:currentCollectionPagerOrder category:@"topic"];

    }else{
        [self hudWithTitle:@"网络异常，请检查网络连接"];
        [self.tableView.mj_header endRefreshing];
        [self.tableView.mj_footer endRefreshing];
    }
}


- (void)loadNewDatas{

    currentCollectionPagerOrder = 1;
    [self getNetWork];
}
- (void)getNetWork{
    Reachability *ability = [Reachability reachabilityForInternetConnection];
    if (ability.currentReachabilityStatus == ReachableViaWiFi || ability.currentReachabilityStatus == ReachableViaWWAN) {
        [self requestDataWithPage:currentCollectionPagerOrder category:@"news"];
        [self requestDataWithPage:currentCollectionPagerOrder category:@"topic"];

    }else{
        [self.tableView.mj_header endRefreshing];
        [self.tableView.mj_footer endRefreshing];
        
    }
}

- (void)hudWithTitle:(NSString *)title
{
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
    hud.mode = MBProgressHUDModeText;
    hud.label.text = title;
    [hud hideAnimated:YES afterDelay:1.f];
}
#pragma mark - delegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (tableView.tag == 2000) {
        return _dataArray.count;
    }
    if (tableView.tag == 2001) {
        return _topicArray.count;
    }
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (tableView.tag == 2000) {
        NewsCell *cell = [NewsCell cellWithTableView:tableView];
        cell.model = self.dataArray[indexPath.row];
        return cell;
    }
    if(tableView.tag == 2001){
        CommonCell *cell = [CommonCell cellWithTableView:tableView];
        cell.myQueationModel =  self.topicArray[indexPath.row];
        return cell;
    }
    return nil;

}

- (void)changevalue:(UISegmentedControl*)segment{
    
    switch (segment.selectedSegmentIndex) {
        case 0:
            _scrollview.contentOffset=CGPointMake(0, 0);
            break;
        case 1:
            _scrollview.contentOffset=CGPointMake(kWidth, 0);
            break;
    }
}
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    CGFloat x=_scrollview.contentOffset.x;
    NSInteger a=x/_scrollview.frame.size.width;
    _segement.selectedSegmentIndex=a;

}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (tableView.tag == 2000) {
        return 120;
    }
    return 70;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (tableView.tag == 2000) {
        NewsDetailViewController *detail = [[NewsDetailViewController alloc] init];
        detail.collect = 2;
        NewsModel *model = self.dataArray[indexPath.row];
        detail.itemId = model.id;
        detail.url = model.content;
        self.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:detail animated:YES];
    }else{
        QuestionDetailViewController *detail = [[QuestionDetailViewController alloc] init];
        detail.model = self.topicArray[indexPath.row];
        [detail.answerBtn setTitle:@"追答" forState:(UIControlStateNormal)];
        self.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:detail animated:YES];
    }
}
@end
