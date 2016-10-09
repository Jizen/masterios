//
//  QuestionDetailViewController.m
//  Opt_master
//
//  Created by 瑞宁科技02 on 16/7/7.
//  Copyright © 2016年 reining. All rights reserved.
//

#import "QuestionDetailViewController.h"
#import "PersonalViewController.h"
#import "MainTabbarViewController.h"
#import "AnswerViewController.h"
#import "QuestionTopView.h"
#import "AnswerCell.h"
#import "ViewController.h"
#import "AnswerModel.h"
#import "UITableView+SDAutoTableViewCellHeight.h"
#import "UIView+SDAutoLayout.h"
#import "QuestionModel.h"
#import "AnswerTopCell.h"
int currentReplyPage = 1;
@interface QuestionDetailViewController ()<UITableViewDelegate,UITableViewDataSource>
{
    BOOL iscollect;
}
@property (nonatomic ,strong)QuestionTopView *topView;
@property (nonatomic ,strong)UITableView *tableView;
@property (strong, nonatomic) NSMutableArray *dataArray;
@property (nonatomic ,strong)AnswerModel *answerModel;
@property (nonatomic ,strong)UIButton *backBtn1;
@property (nonatomic ,strong)QuestionModel *questionModel;
@property (nonatomic ,strong) NSNumber *replynum;
@property (nonatomic ,strong)AnswerTopCell *answerTopCell;


@end

@implementation QuestionDetailViewController
#pragma mark - lazy
-(NSMutableArray *)dataArray{
    
    if (!_dataArray) {
        _dataArray = [NSMutableArray array];
    }
    return _dataArray;
}

- (QuestionTopView *)topView{
    if (!_topView) {
        _topView    = [[QuestionTopView alloc] init];
    }
    return _topView;
}
- (UIButton *)answerBtn{
    if (!_answerBtn) {
        _answerBtn = [UIButton buttonWithType:(UIButtonTypeCustom)];
        _answerBtn.backgroundColor = PRIMARY_COLOR;
        _answerBtn.layer.cornerRadius = BTN_CORNER_RADIUS;
        _answerBtn.layer.masksToBounds = YES;
        [_answerBtn setTitle:@"开始回答" forState:(UIControlStateNormal)];
        [_answerBtn addTarget:self action:@selector(answerBtn:) forControlEvents:(UIControlEventTouchUpInside)];
    }
    return _answerBtn;
}
#pragma mark - basic
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.navigationController.navigationBarHidden = YES;
    [self requestDataWithPage:1];
//    [self.tableView.mj_header beginRefreshing];

}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    // 禁用 iOS7 返回手势
    if ([self.navigationController respondsToSelector:@selector(interactivePopGestureRecognizer)]) {
        self.navigationController.interactivePopGestureRecognizer.enabled = NO;
    }
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    // 开启
    if ([self.navigationController respondsToSelector:@selector(interactivePopGestureRecognizer)]) {
        self.navigationController.interactivePopGestureRecognizer.enabled = YES;
    }
}
- (void)viewDidLoad {
    [super viewDidLoad];
    [self addconstraint];
    [self initTableView];
    [self createNavBar];
    [self setupMJRefreshHeader];
    [self refreshMoreData];
    [self statusShow];
    
    [self.tableView registerClass:[AnswerTopCell class] forCellReuseIdentifier:NSStringFromClass([AnswerTopCell class])];


}
#pragma mark - request
- (void)statusShow{
    NSString *url = [NSString stringWithFormat:@"%@=%@",URL_TOPIC_STATE_SHOW,self.model.id];
    [[HttpTool shareManager] GET:url parameters:nil success:^(NSURLSessionDataTask *task, id responseObject) {
        NSNumber *code = responseObject[@"code"];
        if ([code isEqualToNumber:@403]) {
            self.backBtn1.selected = YES;
        }
        
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
    }];
    
}

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
        currentReplyPage = currentReplyPage+1;
        [self requestDataWithPage:currentReplyPage];
    }else{
        [self hudWithTitle:@"网络异常，请检查网络连接"];
        [self.tableView.mj_header endRefreshing];
        [self.tableView.mj_footer endRefreshing];
    }
}


- (void)loadNewDatas{
    currentReplyPage = 1;
    [self getNetWork];
}
- (void)getNetWork{
    Reachability *ability = [Reachability reachabilityForInternetConnection];
    if (ability.currentReachabilityStatus == ReachableViaWiFi || ability.currentReachabilityStatus == ReachableViaWWAN) {
        [self requestDataWithPage:currentReplyPage];
//        [self requsetDetailDataWithId:self.model.id];

    }else{
//        [self hudWithTitle:@"访问服务器失败"];
        [self.tableView.mj_header endRefreshing];
        [self.tableView.mj_footer endRefreshing];
        
    }
}


- (void)requestDataWithPage:(int)page{
    NSString *strUrl = [NSString stringWithFormat:@"%@%@/page/%d",URL_REPLY_LIST,_model.id,page];
    [[HttpTool shareManager] GET:strUrl parameters:nil success:^(NSURLSessionDataTask *task, id responseObject) {
        NSLog(@"JSON: %@", responseObject);
        NSMutableArray *messages = responseObject[@"rows"];
        if (page == 1) {
            [self.dataArray removeAllObjects];
        }
        for (NSDictionary *dict  in messages) {
            NSError* err=nil;
            _answerModel = [[AnswerModel alloc]initWithDictionary:dict error:&err];
            [self.dataArray addObject:_answerModel];
            
        }
        [self.tableView reloadData];
        [self.tableView.mj_header endRefreshing];
        [self.tableView.mj_footer endRefreshing];


    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        [self.tableView.mj_header endRefreshing];
        [self.tableView.mj_footer endRefreshing];
    }];
}


#pragma mark - ui
- (void)initTableView{
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 64, self.view.bounds.size.width, self.view.bounds.size.height-65- 64) style:UITableViewStylePlain];
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





-(void)createNavBar{
    UIView *navBar = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kWidth, 64)];
    navBar.backgroundColor = Navigation_COLOR;
    [self.view addSubview:navBar];
    
    UILabel *titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(kWidth/2-50, 30, 100, 20)];
    titleLabel.textAlignment = NSTextAlignmentCenter;
    titleLabel.text = @"问答详情";
    titleLabel.textColor = [UIColor blackColor];
    [navBar addSubview:titleLabel];
    
    UIButton *backBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    backBtn.frame = CGRectMake(0, 20, 60, 44);
    [backBtn setImageEdgeInsets:UIEdgeInsetsMake(0, 0, 0, 10)];

    [backBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [backBtn setImage:[UIImage imageNamed:@"return"] forState:(UIControlStateNormal)];
    [backBtn addTarget:self action:@selector(leftAction) forControlEvents:UIControlEventTouchUpInside];
    [navBar addSubview:backBtn];
    
    self.backBtn1 = [UIButton buttonWithType:UIButtonTypeCustom];
    self.backBtn1.frame = CGRectMake(kWidth - 50, 20, 50, 44);
    [self.backBtn1 setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self.backBtn1 setImage:[UIImage imageNamed:@"collect-h"] forState:(UIControlStateSelected)];
    [self.backBtn1 setImage:[UIImage imageNamed:@"collection"] forState:(UIControlStateNormal)];

    [self.backBtn1 addTarget:self action:@selector(answerForQuestion:) forControlEvents:UIControlEventTouchUpInside];
    [navBar addSubview:self.backBtn1];
    
    UIView *line = [[UIView alloc] initWithFrame:CGRectMake(0, 63.5, kWidth, 0.5)];
    line.backgroundColor = SEPARATOR_LINE_COLOR;
    [navBar addSubview:line];
}

- (void)addconstraint{
    [self.view addSubview:self.answerBtn];
    self.answerBtn.sd_layout
    .leftSpaceToView(self.view ,DEFUALT_MARGIN_SIDES)
    .rightSpaceToView(self.view ,DEFUALT_MARGIN_SIDES)
    .bottomSpaceToView(self.view,DEFUALT_MARGIN_SIDES)
    .heightIs(40);
}

#pragma mark - action
- (void)leftAction{
    

    [self dismissViewControllerAnimated:YES completion:nil];
    [self.navigationController popViewControllerAnimated:YES];
}
- (void)answerForQuestion:(UIButton *)button{
    button.selected = !button.selected;
    if (button.selected == YES) {
        [self hudWithTitle:@"收藏成功"];
    }else{
        [self hudWithTitle:@"取消收藏"];
    }
    
    NSString *url = [NSString stringWithFormat:@"%@=%@",URL_TOPIC_STATE_CHANGE,self.model.id];
    
    [[HttpTool shareManager] GET:url parameters:nil success:^(NSURLSessionDataTask *task, id responseObject) {
        NSLog(@"responseObject = %@",responseObject);
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        NSLog(@"error = %@",error);
    }];

}
- (void)answerBtn:(UIButton *)btn{
    AnswerViewController *thirdCtr=[[AnswerViewController alloc]init];
    thirdCtr.question = self.model.title;
    thirdCtr.itemID = self.model.id;
    thirdCtr.model = self.model;

    thirdCtr.passValue = ^(NSString *sts){
       self.topView.model = _model;
        NSLog(@"修改后 = %@",_model.replynum);
        [self.tableView reloadData];
    };

    
    NSLog(@"第一次 = %@",_model.replynum);
    UINavigationController *nav=[[UINavigationController alloc]initWithRootViewController:thirdCtr];
    [self presentViewController:nav animated:YES completion:nil];

}


- (void)headImageTapAction:(UITapGestureRecognizer *)tap{
    NSInteger tag =  [tap view].tag;
    
    NSLog(@"tag == %ld",(long)tag);
    QuestionModel *model = [[QuestionModel alloc] init];
    model = _dataArray[tag];
    PersonalViewController *personalVC = [[PersonalViewController alloc] init];
    personalVC.userid = [model.createdby intValue];
    
    NSLog(@"-----personalVC.userid --%d",personalVC.userid);
    
    self.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:personalVC animated:YES];
}


#pragma mark - delegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == 0) {
        return 1;
    }
    return self.dataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.section == 1) {

        AnswerCell *cell = [AnswerCell cellWithTableView:tableView];
        cell.model = self.dataArray[indexPath.row];
        NSLog(@"self.dataArray === %@",self.dataArray);
        
        
        
        UITapGestureRecognizer *headImageTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(headImageTapAction:)];
        [cell.headImage addGestureRecognizer:headImageTap];
        UITapGestureRecognizer *nameTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(headImageTapAction:)];
        [cell.nameLabel addGestureRecognizer:nameTap];
        cell.headImage.tag = indexPath.row;
        cell.nameLabel.tag = indexPath.row;

    return cell;
        
    }else{
        
        AnswerTopCell *topCell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([AnswerTopCell class])];

        topCell.selectionStyle = UITableViewCellSelectionStyleNone;

        topCell.model = self.model;
        
        return topCell;

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
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{

    if (indexPath.section == 0) {
        return [self.tableView cellHeightForIndexPath:indexPath model:self.model keyPath:@"model" cellClass:[AnswerTopCell class] contentViewWidth:[self cellContentViewWith]];

    }else{
        return [AnswerCell whc_CellHeightForIndexPath:indexPath tableView:tableView];

    }
    

}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    if (section == 1) {
        return 0;
    }
    return DEFUALT_MARGIN_SIDES;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kWidth, DEFUALT_MARGIN_SIDES)];
    view.backgroundColor = BG;
    return view;
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath

{
    cell.separatorInset = UIEdgeInsetsZero;
    cell.layoutMargins = UIEdgeInsetsZero;
    cell.preservesSuperviewLayoutMargins = NO;
    
}

#pragma mark - public
- (void)hudWithTitle:(NSString *)title
{
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
    hud.mode = MBProgressHUDModeText;
    hud.label.text = title;
    [hud hideAnimated:YES afterDelay:1.f];
}
@end
