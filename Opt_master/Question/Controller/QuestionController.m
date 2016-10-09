//
//  QuestionController.m
//  Opt_master
//
//  Created by 瑞宁科技02 on 16/9/6.
//  Copyright © 2016年 reining. All rights reserved.
//

#import "QuestionController.h"
#import "UITableView+SDAutoTableViewCellHeight.h"
#import "SubmitQuestionViewController.h"
#import "PersonalViewController.h"
#import "UIView+SDAutoLayout.h"
#import "QuestionTableViewCell.h"
#import "QuestionDetailViewController.h"
#import "AnswerViewController.h"
#define kTimeLineTableViewCellId @"SDTimeLineCell"
#import "SDTimeLineCell.h"
int    questioncurrentPage = 1;

@interface QuestionController ()<UITableViewDelegate,UITableViewDataSource,UISearchBarDelegate>
@property (nonatomic ,strong)UISearchBar *searchBar;
@property (nonatomic ,strong)UIView *backView;
@property (nonatomic ,strong)NSMutableArray *dataArray;
@property (nonatomic ,strong)QuestionModel *model;
@property (nonatomic ,strong)QuestionModel *questionModel;
@property (nonatomic ,strong) NSNumber *number;
@property (nonatomic ,strong)UITableView *tableView;
@end

@implementation QuestionController
- (NSMutableArray *)dataArray
{
    if (!_dataArray) {
        _dataArray = [NSMutableArray new];
    }
    return _dataArray;
}

#pragma mark - basic
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.navigationController.navigationBarHidden = YES;
    [self requestDataWithPage:1];
    //获取通知中心单例对象
    NSNotificationCenter * center = [NSNotificationCenter defaultCenter];
    //添加当前类对象为一个观察者，name和object设置为nil，表示接收一切通知
    [center addObserver:self selector:@selector(notice:) name:@"refresh" object:nil];
    
}


- (void)notice:(NSNotification *)notice{
    [self setupMJRefreshHeader];
    [self requestDataWithPage:1];
    
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.view.backgroundColor = [UIColor whiteColor];
    self.edgesForExtendedLayout = UIRectEdgeTop;

    [self createNavBar];
    [self initTableView];
    [self getNetWork];
    [self setupMJRefreshHeader];
    [self refreshMoreData ];
    [self requestDataWithPage:1];
    
    // 注册cell
    [self.tableView registerClass:[QuestionTableViewCell class] forCellReuseIdentifier:kTimeLineTableViewCellId];

}
- (void)answerForQuestion{
    [self.backView removeFromSuperview];
    [self.searchBar setShowsCancelButton:NO animated:YES];
    [self.searchBar resignFirstResponder];
    self.tableView.scrollEnabled = YES;
    SubmitQuestionViewController *detail = [[SubmitQuestionViewController alloc] init];
    UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:detail];
    [self presentViewController:nav animated:YES completion:nil];
}
- (void)initTableView{
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 64, self.view.bounds.size.width, self.view.bounds.size.height-49-64) style:UITableViewStylePlain];
    self.tableView.backgroundColor = BG;
    self.tableView.dataSource =self;
    self.tableView.delegate = self;
    self.tableView.contentInset = UIEdgeInsetsMake(0, 0, 0, 0);
    self.tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    self.tableView.scrollIndicatorInsets=self.tableView.contentInset;
    [self.view addSubview:self.tableView];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
}

#pragma mark - UI
-(void)createNavBar{
    UIView *navBar = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kWidth, 64)];
    navBar.backgroundColor = Navigation_COLOR;

    [self.view addSubview:navBar];
    
    UILabel *titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(kWidth/2-50, 30, 100, 20)];
    titleLabel.textAlignment = NSTextAlignmentCenter;
    titleLabel.text = @"问答";
    titleLabel.textColor = [UIColor blackColor];
    [navBar addSubview:titleLabel];
    
    UIButton *backBtn = [UIButton buttonWithType:UIButtonTypeSystem];
    backBtn.frame = CGRectMake(kWidth - 50, 20, 40, 44);
    [backBtn setTitleColor:PRIMARY_COLOR forState:UIControlStateNormal];
    [backBtn setTitle:@"提问" forState:UIControlStateNormal];
    backBtn.titleLabel.font = GZFontWithSize(18);
    [backBtn addTarget:self action:@selector(answerForQuestion) forControlEvents:UIControlEventTouchUpInside];
    [navBar addSubview:backBtn];

    
    UIView *line = [[UIView alloc] initWithFrame:CGRectMake(0, 63.5, kWidth, 0.5)];
    line.backgroundColor = SEPARATOR_LINE_COLOR;
    [navBar addSubview:line];
}
//- (void)answerForQuestionAction{
////    UIView *topback = [[UIView alloc] initWithFrame:CGRectMake(60, 20, self.view.frame.size.width, 44)];
//
//    self.searchBar = [[UISearchBar alloc]initWithFrame:CGRectMake(60, 20, self.view.frame.size.width-120, 44)];
//    //修改搜索框背景
//    _searchBar.backgroundColor = BG;
//    _searchBar.backgroundImage = [self imageWithColor:[UIColor clearColor] size:_searchBar.bounds.size];
//    self.searchBar.delegate = self;
//    self.searchBar.placeholder = @"请输入问题关键字";
//    self.searchBar.searchBarStyle = UISearchBarStyleProminent;
////    [topback addSubview:self.searchBar];
//    [self.view addSubview:self.searchBar];
//}

#pragma mark - request

- (void)setupMJRefreshHeader{
    [self.dataArray removeAllObjects];
    MJRefreshNormalHeader *header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(loadNewDatas)];
    header.lastUpdatedTimeLabel.hidden = YES;
    [header setTitle:@"下拉刷新数据" forState:MJRefreshStateIdle];
    [header setTitle:@"正在刷新..." forState:MJRefreshStateRefreshing];
    [header setTitle:@"全部加载完成" forState:MJRefreshStateNoMoreData];
    header.stateLabel.font = [UIFont systemFontOfSize:12];
    header.stateLabel.textColor = [UIColor grayColor];
    self.tableView.mj_header = header;
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
    
}
//上拉加载更多数据
- (void)loadMore
{
    Reachability *ability = [Reachability reachabilityForInternetConnection];
    if (ability.currentReachabilityStatus == ReachableViaWiFi || ability.currentReachabilityStatus == ReachableViaWWAN) {
        questioncurrentPage = questioncurrentPage+1;
        [self requestDataWithPage:questioncurrentPage];
    }else{
        [self hudWithTitle:ERROR_NETWORK];
        [self.tableView.mj_header endRefreshing];
        [self.tableView.mj_footer endRefreshing];
    }
}


- (void)loadNewDatas{
    questioncurrentPage = 1;
    [self getNetWork];
}
- (void)getNetWork{
    Reachability *ability = [Reachability reachabilityForInternetConnection];
    if (ability.currentReachabilityStatus == ReachableViaWiFi || ability.currentReachabilityStatus == ReachableViaWWAN) {
        [self requestDataWithPage:questioncurrentPage];
    }else{
        [self hudWithTitle:ERROR_NETWORK];
        [self.tableView.mj_header endRefreshing];
        [self.tableView.mj_footer endRefreshing];
        
    }
}


- (void)requestDataWithPage:(int)page{
    NSString *strUrl = [NSString stringWithFormat:@"%@%d",URL_TOPIC_LIST,page];
    [[HttpTool shareManager] GET:strUrl parameters:nil success:^(NSURLSessionDataTask *task, id responseObject) {
        
        NSLog(@"responseObject ====== %@",responseObject);
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
        [self.tableView.mj_header endRefreshing];
        [self.tableView.mj_footer endRefreshing];
        
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        [self.tableView.mj_header endRefreshing];
        [self.tableView.mj_footer endRefreshing];
    }];
    
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
    return self.dataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
        QuestionTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([QuestionTableViewCell class])];
        cell.indexPath = indexPath;
        QuestionModel *item = nil;
        if (indexPath.row < [_dataArray count]) {
            item = [_dataArray objectAtIndex:indexPath.row];
        }
        cell.model = item;
        [cell.answerBtn addTarget:self action:@selector(answerBtnAction:) forControlEvents:(UIControlEventTouchUpInside)];
        cell.answerBtn.tag = indexPath.row;
        cell.backView.tag = indexPath.row+1000;
        
        UITapGestureRecognizer *headImageTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(headImageTapAction:)];
        
        [cell.backView addGestureRecognizer:headImageTap];
        cell.tag = indexPath.row;
    

        return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if (section == 0) {
        return 50;
    }
    return 0;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
        id model = self.dataArray[indexPath.row];
        return [self.tableView cellHeightForIndexPath:indexPath model:model keyPath:@"model" cellClass:[QuestionTableViewCell class] contentViewWidth:[self cellContentViewWith]];
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

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    if (section == 0) {
        UIView *topback = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 49)];
        topback.backgroundColor = BG;
        [self.tableView.tableHeaderView addSubview:topback];
        self.searchBar = [[UISearchBar alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 50)];
        //修改搜索框背景
        _searchBar.backgroundColor = BG;
        _searchBar.backgroundImage = [self imageWithColor:[UIColor clearColor] size:_searchBar.bounds.size];
        self.searchBar.delegate = self;
        self.searchBar.placeholder = @"请输入问题关键字";
        self.searchBar.searchBarStyle = UISearchBarStyleProminent;
        [topback addSubview:self.searchBar];
        return topback;
    }else{
        return nil;
    }
}
- (UIImage *)imageWithColor:(UIColor *)color size:(CGSize)size
{
    CGRect rect = CGRectMake(0, 0, size.width, size.height);
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(context, [color CGColor]);
    CGContextFillRect(context, rect);
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return image;
}
- (void)searchBarTextDidBeginEditing:(UISearchBar *)searchBar{
    _searchBar.showsCancelButton = YES;
    for(UIView *view in  [[[searchBar subviews] objectAtIndex:0] subviews]) {
        if([view isKindOfClass:[NSClassFromString(@"UINavigationButton") class]]) {
            UIButton * cancel =(UIButton *)view;
            [cancel setTitle:@"取消" forState:UIControlStateNormal];
            [cancel setTintColor:PRIMARY_COLOR];
            
        }
    }
    
}
//- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
//    return 5;
//}
- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    
    
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kWidth, 5)];
    view.backgroundColor = BG;
    return view;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [self searchBarCancelButtonClicked:_searchBar];
    if (indexPath.row < _dataArray.count) {
        QuestionDetailViewController *detail = [[QuestionDetailViewController alloc] init];
        detail.model = self.dataArray[indexPath.row];
        self.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:detail animated:YES];
        self.hidesBottomBarWhenPushed = NO;
    }
    
    
    
}

#pragma mark - action
- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar{
    [searchBar setShowsCancelButton:NO animated:YES];
    _searchBar.text = @"";
    [searchBar resignFirstResponder];
    [self.backView removeFromSuperview];
    self.tableView.scrollEnabled = YES;
    
    
}
- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar{
    [searchBar setShowsCancelButton:NO animated:YES];
    [searchBar resignFirstResponder];
    [self.backView removeFromSuperview];
    self.tableView.scrollEnabled = YES;
    
    
}
- (void)headImageTapAction:(UITapGestureRecognizer *)tap{
    NSInteger tag =  [tap view].tag;
    QuestionModel *model = [[QuestionModel alloc] init];
    if (_dataArray.count != 0) {
        model = _dataArray[tag-1000];

    }
    PersonalViewController *personalVC = [[PersonalViewController alloc] init];
    personalVC.userid = [model.createdby intValue];
    self.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:personalVC animated:YES];
    self.hidesBottomBarWhenPushed = NO;
}

- (void)answerBtnAction:(UIButton *)btn{
    AnswerViewController *thirdCtr=[[AnswerViewController alloc]init];
    if (btn.tag < _dataArray.count) {
        [_questionModel removeObserver:self forKeyPath:@"replynum"];
        _questionModel = _dataArray[btn.tag];
        
        thirdCtr.question = _questionModel.title;
        thirdCtr.itemID = _questionModel.id;
        thirdCtr.model =  _questionModel;
        thirdCtr.passValue = ^(NSString *sts){
            _questionModel.replynum = sts;
            
        };
    }
    _number = [NSNumber numberWithInteger:btn.tag];
    
    [_questionModel addObserver:self forKeyPath:@"replynum" options:NSKeyValueObservingOptionNew|NSKeyValueObservingOptionOld context:nil];
    
    UINavigationController *nav=[[UINavigationController alloc]initWithRootViewController:thirdCtr];
    [self presentViewController:nav animated:YES completion:nil];
    
}
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context{
    
    if([keyPath isEqualToString:@"replynum"] ){
        NSLog(@"change = %@",change);
        
        // 赋值sts 是修改过后的 状态 判断 和change 里面的new 是否一样 一样说明修改状态成功,就需要去对应的数组里面移除 元素
        if ([_questionModel.replynum isEqualToString:change[@"new"]]) {
            [self.dataArray replaceObjectAtIndex:[_number intValue] withObject:_questionModel];
            [self.tableView reloadData];
        }else{
        }
    }
}


- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    [self searchBarCancelButtonClicked:_searchBar];

//    CGFloat sectionHeaderHeight = 5;
//    if (scrollView.contentOffset.y<=sectionHeaderHeight && scrollView.contentOffset.y>=0) {
//        scrollView.contentInset = UIEdgeInsetsMake(-scrollView.contentOffset.y, 0, 0, 0);
//    } else if (scrollView.contentOffset.y>=sectionHeaderHeight) {
//        scrollView.contentInset = UIEdgeInsetsMake(-sectionHeaderHeight, 0, 0, 0);
//    }
}

- (void)dealloc
{
    [self.questionModel removeObserver:self forKeyPath:@"replynum"];
    
    [[NSNotificationCenter defaultCenter]removeObserver:self];
}


@end
