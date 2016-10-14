//
//  LocationViewController.m
//  Opt_master
//
//  Created by 瑞宁科技02 on 16/7/27.
//  Copyright © 2016年 reining. All rights reserved.
//

#import "LocationViewController.h"
#import "AppDelegate.h"
#import "AreaModel.h"
#import "DBUtil.h"
#import "NewsViewController.h"
#import "MainTabbarViewController.h"
#import <CoreLocation/CoreLocation.h>

//模拟定位城市
#define DEFAULT_CITY @"北京市111"

//记录的城市最大数量
#define RECORD_MAX_COUNT 5

//存入userDefault的key
#define RECORD_CITY @"record_city"

@interface LocationViewController ()<UISearchBarDelegate,CLLocationManagerDelegate,UITableViewDelegate,UITableViewDataSource,UIAlertViewDelegate>
@property (nonatomic, strong) NSMutableDictionary *cities;//城市列表
@property (nonatomic, strong) NSMutableArray *keys;//城市首字母
@property(nonatomic,strong)UITableView *tableView;

@property (nonatomic, strong) UISearchBar *searchBar;//搜索框
@property(nonatomic, assign) BOOL isSearch;//是否是search状态
@property(nonatomic, strong) NSMutableArray * searchArray;//中间数组,搜索结果

@property (nonatomic ,strong) AreaModel *model;

@property (nonatomic ,strong)CLLocationManager *locationManager;

// 地理位置解码编码器
@property (nonatomic ,strong) CLGeocoder *geo;

@property (nonatomic ,copy) NSString *locationCity;
@property (nonatomic ,strong)AreaModel *locationModel;
@property (nonatomic ,strong)CLLocation *loc;
@property (nonatomic ,strong)CLLocation *currLocationl;

@property (nonatomic ,strong)UILabel *lebal;
@property (nonatomic ,strong) MBProgressHUD *hud;

@end

@implementation LocationViewController
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    //定位服务开启
    if ([CLLocationManager locationServicesEnabled]) {
        [self.locationManager startUpdatingLocation];
    }
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    [self createNavBar];
    [self initializeData];
//    [self setupProgressHud];
    [self.view addSubview:self.searchBar];
    [self.view addSubview:self.tableView];
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
    self.hud.label.text=@"正在定位...";
    _hud.frame = self.view.bounds;
    _hud.minSize = CGSizeMake(100, 100);
    _hud.mode = MBProgressHUDModeIndeterminate;
    [self.view addSubview:_hud];
    [_hud showAnimated:YES];
}
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
            self.locationModel = [DBUtil getCityWithName:self.locationCity];

            self.lebal.text= [NSString stringWithFormat:@"当前定位城市:%@",self.locationCity];
            
            NSLog(@"定位城市 = %@",self.locationCity);

            self.locationModel = [DBUtil getCityWithName:DEFAULT_CITY];
    
            [self initializeData];
            [self.tableView reloadData];
            [self.hud removeFromSuperview];

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


#pragma mark - 初始化数据

- (void)initializeData
{
    self.isSearch = NO;
    self.searchArray = [NSMutableArray array];
    self.cities = [NSMutableDictionary dictionaryWithDictionary:[DBUtil getAllCity]];
    self.keys = [NSMutableArray arrayWithArray:[[self.cities allKeys] sortedArrayUsingSelector:@selector(compare:)]];
    //历史记录
    NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
    NSArray *recordStrings = [userDefault objectForKey:RECORD_CITY];
    NSMutableArray *recordCity = [NSMutableArray array];
    for(NSString *cityName in recordStrings)
    {
        AreaModel *model = [DBUtil getCityWithName:cityName];
        if(model)
        {
            [recordCity addObject:model];
        }
    }
    [self.cities setObject:recordCity forKey:@"历"];
    [self.keys insertObject:@"历" atIndex:0];
    //获取UserDefault
    NSUserDefaults *userLocation     = [NSUserDefaults standardUserDefaults];
    NSString *name                  = [userLocation objectForKey:@"city"];
    //定位城市
    self.locationModel = [DBUtil getCityWithName:name];
    if(self.locationModel)
    {
        [self.cities setObject:[NSArray arrayWithObject:self.locationModel] forKey:@"定"];
    }
    [self.keys insertObject:@"定" atIndex:0];
    
    [self.tableView reloadData];

}

#pragma mark - lazy
- (UISearchBar *)searchBar
{
    if(!_searchBar)
    {
        _searchBar = [[UISearchBar alloc] initWithFrame:CGRectMake(0, 64, CGRectGetWidth(self.view.bounds), 44)];
        _searchBar.barStyle     = UIBarStyleDefault;
        _searchBar.translucent  = YES;
        _searchBar.delegate     = self;
        _searchBar.placeholder  = @"城市/拼音";
        _searchBar.keyboardType = UIKeyboardTypeDefault;
    }
    
    return _searchBar;
}

- (UITableView *)tableView
{
    if(!_tableView)
    {
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 64+44, CGRectGetWidth(self.view.bounds), CGRectGetHeight(self.view.bounds) - 44) style:UITableViewStylePlain];
        _tableView.autoresizingMask = (UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight);
        _tableView.backgroundColor = [UIColor clearColor];
        _tableView.delegate = self;
        _tableView.dataSource = self;
    }
    
    return _tableView;
}
#pragma mark -UI
-(void)createNavBar{
    
    UIView *navBar = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kWidth, 64)];
    navBar.backgroundColor = Navigation_COLOR;
    [self.view addSubview:navBar];
    
    UILabel *titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(kWidth/2-100, 30, 200, 20)];
    titleLabel.textAlignment = NSTextAlignmentCenter;
    titleLabel.text = @"城市选择";
    titleLabel.textColor = [UIColor blackColor];
    [navBar addSubview:titleLabel];
    
    UIButton *backBtn = [UIButton buttonWithType:UIButtonTypeSystem];
    backBtn.frame = CGRectMake(0, 20, 60, 44);
    [backBtn setTitleColor:PRIMARY_COLOR forState:UIControlStateNormal];
    [backBtn setTitle:@"取消" forState:UIControlStateNormal];
    backBtn.titleLabel.font = GZFontWithSize(18);
    [backBtn addTarget:self action:@selector(CancelAnswerForQuestion) forControlEvents:UIControlEventTouchUpInside];
    [navBar addSubview:backBtn];
}

#pragma mark - action
- (void)CancelAnswerForQuestion{
    //获取UserDefault
    NSUserDefaults *userDefault     = [NSUserDefaults standardUserDefaults];
    NSString *name                  = [userDefault objectForKey:@"cityName"];
    if (name == nil) {
        UIAlertView *alertView =[[UIAlertView alloc]initWithTitle:nil message:@"请选择所在城市" delegate:self cancelButtonTitle:@"知道了" otherButtonTitles:nil, nil];
        [alertView show];

    }else{
    [self dismissViewControllerAnimated:YES completion:nil];
    }
}
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    [alertView dismissWithClickedButtonIndex:0 animated:YES];
}
- (void)hudWithTitle:(NSString *)title
{
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
    hud.mode = MBProgressHUDModeText;
    hud.label.text = title;
    [hud hideAnimated:YES afterDelay:1.f];
}
- (void)answerForQuestion{
    AppDelegate *appdelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
    [appdelegate isLaunchedWithIndex:1];
    
}
- (void)backViewAction{
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - UITableViewDelegate
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (self.isSearch) {
        return 0.0;
    }
    return 30.0;
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    if (self.isSearch) {
        return nil;
    }
    //简单写下，未复用
    UIView *bgView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, 30.0)];
    bgView.backgroundColor = [UIColor colorWithRed:230.0/255.0 green:230.0/255.0 blue:230.0/255.0 alpha:1.0];
    
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(13, 0, [UIScreen mainScreen].bounds.size.width - 13, 30.0)];
    titleLabel.backgroundColor = [UIColor clearColor];
    titleLabel.textColor = [UIColor blackColor];
    titleLabel.font = [UIFont systemFontOfSize:14];
    
    NSString *key = [_keys objectAtIndex:section];
    if ([key rangeOfString:@"定"].location != NSNotFound) {
        titleLabel.text = @"定位城市";
    }
    else if ([key rangeOfString:@"历"].location != NSNotFound) {
        titleLabel.text = @"历史记录";
    }
    else
        titleLabel.text = key;
    
    [bgView addSubview:titleLabel];
    
    return bgView;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{

    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    
//    AreaModel *model = nil;
    if (self.isSearch) {
        self.model = [self.searchArray objectAtIndex:indexPath.row];
    }
    else
    {
        NSString *key = [_keys objectAtIndex:indexPath.section];
        self.model = [[_cities objectForKey:key] objectAtIndex:indexPath.row];
    }


    NSDictionary *dict =[[NSDictionary alloc] initWithObjectsAndKeys:self.model.areaName,@"city", nil];

    NSNotification *notification =[NSNotification notificationWithName:@"tongzhi" object:nil userInfo:dict];
    //通过通知中心发送通知
    [[NSNotificationCenter defaultCenter] postNotification:notification];
    [self dismissViewControllerAnimated:YES completion:nil];
    NSUserDefaults *user = [NSUserDefaults standardUserDefaults];
    [user setValue:self.model.areaName forKey:@"cityName"];
    [user synchronize];

    //更新历史记录
    NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
    NSMutableArray *cityStrings = [NSMutableArray arrayWithArray:[userDefault objectForKey:RECORD_CITY]];
    if([cityStrings containsObject:self.model.areaName])
    {
        [cityStrings removeObject:self.model.areaName];
        [cityStrings insertObject:self.model.areaName atIndex:0];
    }
    else
    {
        [cityStrings insertObject:self.model.areaName atIndex:0];
        if(cityStrings.count > RECORD_MAX_COUNT)
        {
            [cityStrings removeLastObject];
        }
    }
    [userDefault setObject:cityStrings forKey:RECORD_CITY];
    [userDefault synchronize];
    
    if(self.selectedCityBlock)
    {
        self.selectedCityBlock(self.model);
    }
    
}

#pragma mark - UITableViewDataSource
- (NSArray *)sectionIndexTitlesForTableView:(UITableView *)tableView
{
    if (self.isSearch) {
        return [NSArray array];
    }
    return self.keys;
}

- (NSInteger)tableView:(UITableView *)tableView sectionForSectionIndexTitle:(NSString *)title atIndex:(NSInteger)index
{
    return index;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    if (self.isSearch) {
        return 1;
    }
    
    return [_keys count];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (self.isSearch) {
        return self.searchArray.count;
    }
    
    NSString *key = [_keys objectAtIndex:section];
    NSArray *citySection = [_cities objectForKey:key];
    return [citySection count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] ;
        cell.backgroundColor = [UIColor whiteColor];
        cell.contentView.backgroundColor = [UIColor whiteColor];
        cell.selectionStyle = UITableViewCellSelectionStyleDefault;
        
        [cell.textLabel setTextColor:[UIColor blackColor]];
        cell.textLabel.font = [UIFont systemFontOfSize:15.0];
    }
    
    AreaModel *model = nil;
    if (self.isSearch) {
        model = [self.searchArray objectAtIndex:indexPath.row];
    }
    else
    {
        NSString *key = [_keys objectAtIndex:indexPath.section];
        model = [[_cities objectForKey:key] objectAtIndex:indexPath.row];
    }
    cell.textLabel.text = model.areaName;
    
    return cell;
}
#pragma mark UISearchBarDelegate
- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText
{
    [self.searchArray removeAllObjects];
    
    if (searchText.length == 0) {
        self.isSearch = NO;
        self.tableView.tableFooterView = nil;
    }else{
        self.isSearch = YES;
        self.tableView.tableFooterView = [UIView new];
        [self.searchArray addObjectsFromArray:[DBUtil getCitysWithKey:searchText]];
    }
    [self.tableView reloadData];
}

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar
{
    [searchBar resignFirstResponder];
}
@end
