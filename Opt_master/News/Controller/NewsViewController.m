//
//  NewsViewController.m
//  Opt_master
//
//  Created by 瑞宁科技02 on 16/7/7.
//  Copyright © 2016年 reining. All rights reserved.
//

#import "NewsViewController.h"
#import "NewsDetailViewController.h"
#import "AreaSelectViewController.h"
#import "LocationViewController.h"
#import "NewsCell.h"
#import "HttpTool.h"
#import <CoreLocation/CoreLocation.h>
#import "NewsModel.h"
#import <StoreKit/StoreKit.h>

#define CURRENT_VERSION [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"]
#define BUNDLE_IDENTIFIER [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleIdentifier"]
int    currentPagerOrder = 1;
int    currentCollectionPagerOrder1 = 1;

@interface NewsViewController ()<UITableViewDelegate ,UITableViewDataSource,CLLocationManagerDelegate,UIAlertViewDelegate>
@property (nonatomic ,strong)UITableView *tableView;
@property (nonatomic ,strong)UITableView *attentiontableView;
@property (nonatomic ,strong) UISegmentedControl  *segement;
@property (nonatomic ,strong) UIScrollView *scrollview;
@property (nonatomic ,strong) MBProgressHUD *hud;
// 地理位置解码编码器
@property (nonatomic ,strong) CLGeocoder *geo;
@property (nonatomic ,strong)CLLocationManager *locationManager;
@property (nonatomic ,copy) NSString *locationCity;
@property (nonatomic ,strong)AreaModel *locationModel;
@property (nonatomic ,strong)CLLocation *loc;
@property (nonatomic ,strong)CLLocation *currLocationl;
@property (nonatomic ,strong)NSMutableArray *dataArray;
@property (nonatomic ,strong)NSMutableArray *topicArray;

@property (nonatomic ,strong)NewsModel *model;
@end

@implementation NewsViewController
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
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES animated:animated];
    //获取UserDefault
    NSUserDefaults *userDefault     = [NSUserDefaults standardUserDefaults];
    NSString *name                  = [userDefault objectForKey:@"cityName"];
    [self.loactionBtn setTitle:name forState:UIControlStateNormal];
    if (self.loactionBtn.titleLabel.text == nil) {
        LocationViewController *detail = [[LocationViewController alloc] init];
        [self presentViewController:detail animated:YES completion:nil];
    }
    //定位服务开启
    if ([CLLocationManager locationServicesEnabled]) {
        [self.locationManager startUpdatingLocation];
    }
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:nil object:self];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"passCityName" object:self];


}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    [self createNavBar];
    [self initTableView];
    [self getNetWork];
    [self setupMJRefreshHeader];
    [self refreshMoreData ];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(tongzhi:) name:@"tongzhi" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(passCityName:) name:@"passCityName" object:nil];
    //初始化定位服务
    self.locationManager = [[CLLocationManager alloc] init];
    //设置定位的精确度和更新频率
    self.locationManager.desiredAccuracy = kCLLocationAccuracyBest;
    self.locationManager.distanceFilter = 10.f;
    self.locationManager.delegate = self;
    //授权状态是没有做过选择
    if ([CLLocationManager authorizationStatus] == kCLAuthorizationStatusNotDetermined) {
        [self.locationManager requestAlwaysAuthorization];
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
#pragma mark - request
- (void)requestDataWithPage:(int)page{
    NSString *strUrl = [NSString stringWithFormat:@"%@%d",URL_NEWS_LIST,page];

    [[HttpTool shareManager] GET:strUrl parameters:nil success:^(NSURLSessionDataTask *task, id responseObject) {
        NSMutableArray *messages = responseObject[@"rows"];
        if (page == 1) {
            [self.dataArray removeAllObjects];
        }
        
        for (NSDictionary *dict  in messages) {
            NSError* err=nil;
            _model = [[NewsModel alloc]initWithDictionary:dict error:&err];
            [self.dataArray addObject:_model];
        }
        [self.tableView reloadData];
        [self.attentiontableView reloadData];
        [self.tableView.mj_header endRefreshing];
        [self.tableView.mj_footer endRefreshing];
        [self.attentiontableView.mj_header endRefreshing];
        [self.attentiontableView.mj_footer endRefreshing];
        
//        if (messages.count == 0) {
//            [self hudWithTitle:@"没有更多数据"];
//        }
        [self.hud hideAnimated:YES];
        
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        [self.hud hideAnimated:YES];
        [self.tableView.mj_header endRefreshing];
        [self.tableView.mj_footer endRefreshing];

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
    [header beginRefreshing];
    self.tableView.mj_header = header;
    
    
    MJRefreshNormalHeader *header1 = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(loadNewDatas)];
    header1.lastUpdatedTimeLabel.hidden = YES;
    [header1 setTitle:@"下拉刷新数据" forState:MJRefreshStateIdle];
    [header1 setTitle:@"正在刷新..." forState:MJRefreshStateRefreshing];
    [header1 setTitle:@"全部加载完成" forState:MJRefreshStateNoMoreData];
    header1.stateLabel.font = [UIFont systemFontOfSize:12];
    header1.stateLabel.textColor = [UIColor grayColor];
    [header beginRefreshing];
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
        currentPagerOrder = currentPagerOrder+1;
        [self requestDataWithPage:currentPagerOrder];
    }else{
        [self hudWithTitle:ERROR_NETWORK];
        [self.tableView.mj_header endRefreshing];
        [self.tableView.mj_footer endRefreshing];
    }
}


- (void)loadNewDatas{
    currentPagerOrder = 1;
    [self getNetWork];
    
}
- (void)getNetWork{
    Reachability *ability = [Reachability reachabilityForInternetConnection];
    if (ability.currentReachabilityStatus == ReachableViaWiFi || ability.currentReachabilityStatus == ReachableViaWWAN) {
        [self requestDataWithPage:currentPagerOrder];
        [self requestDataWithPage:currentCollectionPagerOrder1 category:@"news"];

    }else{
        [self hudWithTitle:ERROR_NETWORK];
        [self.tableView.mj_header endRefreshing];
        [self.tableView.mj_footer endRefreshing];
        
    }
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
                [self.topicArray addObject:_model];
            }
            [self.attentiontableView reloadData];
            
        }        

        [self.attentiontableView.mj_header endRefreshing];
        [self.attentiontableView.mj_footer endRefreshing];
        
        
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        NSLog(@"error = %@",error);
//        [self ];
        [self.attentiontableView.mj_header endRefreshing];
        [self.attentiontableView.mj_footer endRefreshing];
        
    }];
}



- (void)hudWithTitle:(NSString *)title
{
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
    hud.mode = MBProgressHUDModeText;
    hud.label.text = title;
    [hud hideAnimated:YES afterDelay:1.f];
}
#pragma mark - UI
-(void)createNavBar{
    UIView *navBar = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kWidth, 64)];
    navBar.backgroundColor = PRIMARY_COLOR;
    [self.view addSubview:navBar];
    _segement=[[UISegmentedControl alloc]initWithItems:@[@"精选",@"收藏"]];
    _segement.frame=CGRectMake(90, 25, kWidth-180, 30);
    _segement.tintColor=[UIColor whiteColor];
    _segement.selectedSegmentIndex=0;
    [navBar addSubview:_segement];
    [_segement addTarget:self action:@selector(changevalue:) forControlEvents:(UIControlEventValueChanged)];
    
    self.loactionBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    _loactionBtn.frame = CGRectMake(0, 20, 60, 44);
    [_loactionBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    _loactionBtn.titleLabel.font = GZFontWithSize(14);
    [_loactionBtn addTarget:self action:@selector(back:) forControlEvents:UIControlEventTouchUpInside];
    [navBar addSubview:_loactionBtn];
    
    UIImageView *arrowImage = [[UIImageView alloc] initWithFrame:CGRectMake(CGRectGetMaxX(_loactionBtn.frame)-3, 38, 13, 10)];
    [arrowImage setImage:[UIImage imageNamed:@"icon_homepage_downArrow"]];
    [navBar addSubview:arrowImage];
}
- (void)initTableView{
    self.scrollview=[[UIScrollView alloc]initWithFrame:CGRectMake(0, 64, kWidth, kHeight)];
    _scrollview.directionalLockEnabled=YES;
    _scrollview.contentSize=CGSizeMake(kWidth*2, kHeight);
    _scrollview.delegate=self;
    _scrollview.pagingEnabled = YES;
    [self.view addSubview:self.scrollview];
    
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, self.view.bounds.size.height-49-64) style:UITableViewStylePlain];
    self.tableView.backgroundColor = BG;
    self.tableView.dataSource =self;
    self.tableView.delegate = self;
    self.tableView.tag = 200;
    self.tableView.contentInset = UIEdgeInsetsMake(0, 0, 0, 0);
    self.tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    self.tableView.scrollIndicatorInsets=self.tableView.contentInset;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    self.attentiontableView = [[UITableView alloc] initWithFrame:CGRectMake(kWidth, 0, self.view.bounds.size.width, self.view.bounds.size.height-49-64) style:UITableViewStylePlain];
    self.attentiontableView.backgroundColor = BG;
    self.attentiontableView.dataSource =self;
    self.attentiontableView.delegate = self;
    self.attentiontableView.tag = 201;
    self.attentiontableView.contentInset = UIEdgeInsetsMake(0, 0, 0, 0);
    self.attentiontableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    self.attentiontableView.scrollIndicatorInsets=self.tableView.contentInset;
    self.attentiontableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.scrollview addSubview:self.attentiontableView];
    [self.scrollview addSubview:self.tableView];
    
}
// 修改状态栏
- (UIStatusBarStyle)preferredStatusBarStyle{
    return UIStatusBarStyleLightContent;
}
#pragma mark - action
- (void)back:(UIButton *)btn{
    LocationViewController *detail = [[LocationViewController alloc] init];
    [self presentViewController:detail animated:YES completion:nil];
}

- (void)passCityName:(NSNotification *)notice{
    [self.loactionBtn setTitle:notice.userInfo[@"city"] forState:UIControlStateNormal];
    
}
- (void)tongzhi:(NSNotification *)text{
    [self.loactionBtn setTitle:text.userInfo[@"city"] forState:UIControlStateNormal];
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


#pragma mark - delegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    if (tableView.tag == 200) {
        return _dataArray.count;
    }
    if (tableView.tag == 201) {
        return _topicArray.count;
    }
    return 0;

}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
   if (tableView.tag == 200) {
        NewsCell *cell = [NewsCell cellWithTableView:tableView];
       
       if (self.dataArray.count == 0) {
           
       }else{
        cell.model = self.dataArray[indexPath.row];
       }
        return cell;
    }
    if(tableView.tag == 201){
        NewsCell *cell = [NewsCell cellWithTableView:tableView];
        if (self.topicArray.count == 0) {

        }else{
            cell.model = self.topicArray[indexPath.row];
        }
        return cell;
    }
    return nil;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 120;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    NewsDetailViewController *detail = [[NewsDetailViewController alloc] init];
    NewsModel *model = _dataArray[indexPath.row];
    detail.url = model.content;
    detail.itemId = model.id;
    self.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:detail animated:YES];
    self.hidesBottomBarWhenPushed = NO;

}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    CGFloat x=_scrollview.contentOffset.x;
    NSInteger a=x/_scrollview.frame.size.width;
    _segement.selectedSegmentIndex=a;
}

#pragma mark - 定位delegate
-(void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray<CLLocation *> *)locations{
    // 1.既然已经定位到了用户当前的经纬度了,那么可以让定位管理器 停止定位了
    [self.locationManager stopUpdatingLocation];
    // 2.然后,取出第一个位置,根据其经纬度,通过CLGeocoder反向解析,获得该位置所在的城市名称,转成城市对象,用工具保存
    self.loc = [locations firstObject];
    _currLocationl = [locations lastObject];
    // 3.CLGeocoder反向通过经纬度,获得城市名
    // 获取当前所在的城市名
    CLGeocoder *geocoder = [[CLGeocoder alloc] init];
    //根据经纬度反向地理编译出地址信息
    [geocoder reverseGeocodeLocation:self.loc completionHandler:^(NSArray *array, NSError *error){
        if (array.count > 0){
            CLPlacemark *placemark = [array objectAtIndex:0];
            //将获得的所有信息显示到label上
            self.locationCity = [NSString stringWithFormat:@"%@",placemark.locality];
            NSUserDefaults *userLocation = [NSUserDefaults standardUserDefaults];
            [userLocation setValue:self.locationCity forKey:@"city"];
            [self.tableView reloadData];
        }
    }];
    
}
//定位失败的方法
-(void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error{
    NSLog(@"=====%@", error);
}

//授权状态改变的方法
-(void)locationManager:(CLLocationManager *)manager didChangeAuthorizationStatus:(CLAuthorizationStatus)status{
    NSLog(@"---%d", status);
}

@end
