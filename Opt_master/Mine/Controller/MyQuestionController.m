//
//  MyQuestionController.m
//  Opt_master
//
//  Created by 瑞宁科技02 on 16/7/7.
//  Copyright © 2016年 reining. All rights reserved.
//

#import "MyQuestionController.h"
#import "CommonCell.h"
#import "QuestionDetailViewController.h"
#import "LCBlur.h"
#import "MyQueationModel.h"
#import "QuestionModel.h"
@interface MyQuestionController ()<UITableViewDataSource,UITableViewDelegate>
@property (nonatomic ,strong)UITableView *tableView;
@property (nonatomic,strong)UINavigationBar * NavigationBar;
@property (nonatomic,strong)UINavigationItem *ZJNavigationItem;
@property (nonatomic ,strong)NSMutableArray *dataArray;
@property (nonatomic ,strong)QuestionModel *model;
@end

@implementation MyQuestionController
#pragma mark - lazy
- (NSMutableArray *)dataArray{
    if (!_dataArray) {
        _dataArray = [NSMutableArray array];
    }
    return _dataArray;
}

#pragma mark - basic
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.navigationController.navigationBarHidden = YES;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor=[UIColor whiteColor];
    [self createNavBar];
    self.title = @"我的提问";
    [self initTableView];
    [self requestDataWithPage:1];
}
#pragma mark - UI
-(void)createNavBar{
    
    UIView *navBar = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kWidth, 64)];
    navBar.backgroundColor = Navigation_COLOR;

    
    [self.view addSubview:navBar];
    
    UILabel *titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(kWidth/2-50, 30, 100, 20)];
    titleLabel.textAlignment = NSTextAlignmentCenter;
    titleLabel.text = @"我的提问";
    titleLabel.textColor = [UIColor blackColor];
    [navBar addSubview:titleLabel];
    
    UIButton *backBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    backBtn.frame = CGRectMake(0, 20, 60, 44);
    [backBtn setImageEdgeInsets:UIEdgeInsetsMake(0, 0, 0, 10)];
    [backBtn setTitleColor:PRIMARY_COLOR forState:UIControlStateNormal];
    [backBtn setImage:[UIImage imageNamed:@"return"] forState:(UIControlStateNormal)];
    [backBtn addTarget:self action:@selector(leftAction) forControlEvents:UIControlEventTouchUpInside];
    [navBar addSubview:backBtn];
    
    UIView *line = [[UIView alloc] initWithFrame:CGRectMake(0, 63.5, kWidth, 0.5)];
    line.backgroundColor = SEPARATOR_LINE_COLOR;
    [navBar addSubview:line];
}
- (void)initTableView{
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 64, self.view.bounds.size.width, self.view.bounds.size.height-NaviBarHeight) style:UITableViewStylePlain];
    self.tableView.backgroundColor = BG;
    self.tableView.dataSource =self;
    self.tableView.delegate = self;
    self.tableView.contentInset = UIEdgeInsetsMake(0, 0, 0, 0);
    self.tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    self.tableView.scrollIndicatorInsets=self.tableView.contentInset;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:self.tableView];
}
#pragma mark - action
- (void)leftAction{
    [self.navigationController popViewControllerAnimated:YES];
}
- (void)requestDataWithPage:(int)page{
    
    NSString *url = [NSString stringWithFormat:@"%@%d",URL_MY_TOPIC,page];
    [[HttpTool shareManager] GET:url parameters:nil success:^(NSURLSessionDataTask *task, id responseObject) {
        NSLog(@"%@",responseObject);
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
        NSData *data = error.userInfo[@"com.alamofire.serialization.response.error.data"] ;
        NSString *errorStr = [[ NSString alloc ] initWithData:data encoding:NSUTF8StringEncoding];
        NSLog(@"eerrore = %@",error);
        
        NSLog(@"eerrore = %@",errorStr);
    }];
    

}



#pragma mark - delegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _dataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
     CommonCell  *cell = [CommonCell cellWithTableView:tableView];
    cell.myQueationModel =  _dataArray[indexPath.row];
    return cell;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 70;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    QuestionDetailViewController *detailVC = [[QuestionDetailViewController alloc] init];
    QuestionModel *model = _dataArray[indexPath.row];
    detailVC.itemID = model.id;
    detailVC.model = model;
    self.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:detailVC animated:YES];
}
@end
