//
//  SearchViewController.m
//  Opt_master
//
//  Created by 瑞宁科技02 on 2016/10/10.
//  Copyright © 2016年 reining. All rights reserved.
//

#import "SearchViewController.h"
#import "QuestionTableViewCell.h"
#import "UITableView+SDAutoTableViewCellHeight.h"
#import "QuestionModel.h"
#import "QuestionDetailViewController.h"
#import "PersonalViewController.h"
#import "AnswerViewController.h"


int    searchPage = 1;

@interface SearchViewController ()<UITableViewDelegate,UITableViewDataSource,UISearchBarDelegate>
@property (nonatomic ,strong)UITableView *tableView;
@property (strong, nonatomic) NSMutableArray *dataArray;
@property (nonatomic ,strong)UISearchBar *searchBar;
@property (nonatomic ,strong)QuestionModel *model;
@property (nonatomic ,strong) MBProgressHUD *hud;
@property (nonatomic ,strong)QuestionModel *questionModel;
@property (nonatomic ,strong) NSNumber *number;
@property (nonatomic ,strong)UILabel *noMessageLabel;

@property (nonatomic ,strong)UITextField *searchField;
@end

@implementation SearchViewController
#pragma mark -lazy
- (NSMutableArray *)dataArray
{
    if (!_dataArray) {
        _dataArray = [NSMutableArray new];
    }
    return _dataArray;
}



#pragma mark - basic
- (void)viewWillAppear:(BOOL)animated{
    searchPage = 1;
//    [super viewWillAppear:animated];
//    [self.searchBar becomeFirstResponder];


//    self.navigationController.navigationBarHidden = YES;
}

- (void)viewDidAppear:(BOOL)animated{
    [self.searchBar becomeFirstResponder];

}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    [self createNavBar];

    [self initTableView];
    [self refreshMoreData];

    UITapGestureRecognizer *tapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(keyboardHide:)];
    tapGestureRecognizer.cancelsTouchesInView = NO;
    [self.view addGestureRecognizer:tapGestureRecognizer];
}
- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [self.searchBar resignFirstResponder];
}
- (void)keyboardHide:(UITapGestureRecognizer *)tap{
    [self.searchBar resignFirstResponder];

}

#pragma mark - UI
-(void)createNavBar{
    UIView *navBar = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kWidth, 64)];
    navBar.backgroundColor = Navigation_COLOR;
    [self.view addSubview:navBar];
  
    UIView *topback = [[UIView alloc] initWithFrame:CGRectMake(DEFUALT_MARGIN_SIDES, 27, kWidth-80, 30)];
    topback.layer.borderColor = SEPARATOR_LINE_COLOR.CGColor;
    topback.layer.borderWidth = 1;
    topback.layer.cornerRadius = 4;
    topback.layer.masksToBounds = YES;
    [self.tableView.tableHeaderView addSubview:topback];
    
    
    self.searchBar = [[UISearchBar alloc]initWithFrame:CGRectMake(-5, 4, self.view.frame.size.width-70, 25)];
    _searchBar.backgroundImage = [self imageWithColor:[UIColor whiteColor] size:_searchBar.bounds.size];
    self.searchBar.delegate = self;
    self.searchBar.placeholder = @"请输入问题关键字";
//    [_searchBar becomeFirstResponder];

    self.searchBar.searchBarStyle = UISearchBarStyleDefault;
    [topback addSubview:self.searchBar];
    [navBar addSubview:topback];

    
    UIButton *searchBtn = [UIButton buttonWithType:UIButtonTypeSystem];
    searchBtn.frame = CGRectMake(kWidth - 50, 20, 40, 44);
    [searchBtn setTitleColor:PRIMARY_COLOR forState:UIControlStateNormal];
    [searchBtn setTitle:@"取消" forState:UIControlStateNormal];
    [searchBtn addTarget:self action:@selector(searchForQuestion) forControlEvents:UIControlEventTouchUpInside];
    [navBar addSubview:searchBtn];

    
    UIView *line = [[UIView alloc] initWithFrame:CGRectMake(0, 63.5, kWidth, 0.5)];
    line.backgroundColor = SEPARATOR_LINE_COLOR;
    [navBar addSubview:line];
}

- (void)initTableView{
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 64, self.view.bounds.size.width, self.view.bounds.size.height - 64) style:UITableViewStylePlain];
    self.tableView.backgroundColor = BG;
    self.tableView.dataSource =self;
    self.tableView.delegate = self;
    self.tableView.contentInset = UIEdgeInsetsMake(0, 0, 0, 0);
    self.tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    self.tableView.scrollIndicatorInsets=self.tableView.contentInset;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:self.tableView];
    self.view.backgroundColor = [UIColor whiteColor];
    
}

#pragma mark - action

- (void)searchForQuestion{
    [self.searchBar resignFirstResponder];
    
    [self.navigationController popViewControllerAnimated:YES];


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

- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar{
    [searchBar setShowsCancelButton:NO animated:YES];
    [searchBar resignFirstResponder];
    [self requestDataWithPage:1 condition:searchBar.text];
    self.tableView.scrollEnabled = YES;
    
}
- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar{
    [searchBar resignFirstResponder];
    [self.noMessageLabel removeFromSuperview];
    [self setupProgressHud];

    [self requestDataWithPage:1 condition:searchBar.text];
}



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
    if (self.searchBar.text.length == 0) {
        [self.tableView.mj_footer endRefreshing];
    }else{
        Reachability *ability = [Reachability reachabilityForInternetConnection];
        if (ability.currentReachabilityStatus == ReachableViaWiFi || ability.currentReachabilityStatus == ReachableViaWWAN) {
            searchPage = searchPage +1;
            [self requestDataWithPage:searchPage condition:self.searchBar.text];
        }else{
            [self hudWithTitle:ERROR_NETWORK];
            [self.tableView.mj_header endRefreshing];
            [self.tableView.mj_footer endRefreshing];
        }

    }
    
}

- (void)loadNewDatas{
    searchPage = 1;
    [self getNetWork];
}

- (void)getNetWork{
    Reachability *ability = [Reachability reachabilityForInternetConnection];
    if (ability.currentReachabilityStatus == ReachableViaWiFi || ability.currentReachabilityStatus == ReachableViaWWAN) {
        [self requestDataWithPage:searchPage condition:self.searchBar.text];
    }else{
        [self hudWithTitle:ERROR_NETWORK];
        [self.tableView.mj_footer endRefreshing];
        
    }
}

- (void)requestDataWithPage:(int)page condition:(NSString *)condition{
    
    NSLog(@"con = %d",page);
    if (condition == nil || condition.length == 0) {
        [self hudWithTitle:@"请输入查询的关键字"];
    }else{

        NSString *strUrl = [NSString stringWithFormat:@"%@%d?condition=%@",URL_FUZZY,page,condition];
        [[HttpTool shareManager] POST:[strUrl stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding] parameters:nil success:^(NSURLSessionDataTask *task, id responseObject) {
            NSMutableArray *messages = responseObject[@"rows"];
            

            if (page == 1) {
                [self.dataArray removeAllObjects];
            }
            for (NSDictionary *dict  in messages) {
                NSError* err=nil;
                _model = [[QuestionModel alloc]initWithDictionary:dict error:&err];
                [self.dataArray addObject:_model];
            }
            
            if (self.dataArray.count == 0) {
                self.noMessageLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 15, kWidth, 20)];
                self.noMessageLabel.text = @"没有搜索到结果";
                self.noMessageLabel.textAlignment = NSTextAlignmentCenter;
                self.noMessageLabel.textColor = TXT_COLOR;
                self.noMessageLabel.font = GZFontWithSize(14);
                [self.tableView addSubview:self.noMessageLabel];
            }else{

                [self.noMessageLabel removeFromSuperview];
            }
            [self.tableView reloadData];
            [self.tableView.mj_header endRefreshing];
            [self.tableView.mj_footer endRefreshing];
            
            [self.hud removeFromSuperview];
        } failure:^(NSURLSessionDataTask *task, NSError *error) {
            [self.hud removeFromSuperview];
            [self.tableView.mj_header endRefreshing];
            [self.tableView.mj_footer endRefreshing];

        }];
    
    }
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
        item = [self.dataArray objectAtIndex:indexPath.row];
    }
    cell.model = item;
    [cell.answerBtn addTarget:self action:@selector(answerBtnAction:) forControlEvents:(UIControlEventTouchUpInside)];
    cell.answerBtn.tag = indexPath.row;
    cell.backView.tag = indexPath.row+1000;
    UITapGestureRecognizer *headImageTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(headImageTapAction:)];
    [cell.backView addGestureRecognizer:headImageTap];
    cell.tag = indexPath.row;
    cell.sd_tableView = tableView;
    cell.sd_indexPath = indexPath;
    return cell;
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    id model = self.dataArray[indexPath.row];
    return [self.tableView cellHeightForIndexPath:indexPath model:model keyPath:@"model" cellClass:[QuestionTableViewCell class] contentViewWidth:[self cellContentViewWith]];
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row < _dataArray.count) {
        QuestionDetailViewController *detail = [[QuestionDetailViewController alloc] init];
        detail.model = self.dataArray[indexPath.row];
        self.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:detail animated:YES];
    }
}

#pragma mark - public
- (void)hudWithTitle:(NSString *)title
{
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
    hud.mode = MBProgressHUDModeText;
    hud.label.text = title;
    [hud hideAnimated:YES afterDelay:1.f];
}


- (void)setupProgressHud
{
    self.hud = [[MBProgressHUD alloc] initWithView:self.view] ;
    self.hud.label.text=@"正在搜索...";
    _hud.frame = self.view.bounds;
    _hud.minSize = CGSizeMake(100, 100);
    _hud.mode = MBProgressHUDModeIndeterminate;
    [self.view addSubview:_hud];
    [_hud showAnimated:YES];
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

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context{
    if([keyPath isEqualToString:@"replynum"] ){
        // 赋值sts 是修改过后的 状态 判断 和change 里面的new 是否一样 一样说明修改状态成功,就需要去对应的数组里面移除 元素
        if ([_questionModel.replynum isEqualToString:change[@"new"]]) {
            [self.dataArray replaceObjectAtIndex:[_number intValue] withObject:_questionModel];
            [self.tableView reloadData];
        }else{
        }
    }
}




- (void)dealloc
{
    [self.questionModel removeObserver:self forKeyPath:@"replynum"];
    
    [[NSNotificationCenter defaultCenter]removeObserver:self];
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    [self.searchBar resignFirstResponder];
}
@end
