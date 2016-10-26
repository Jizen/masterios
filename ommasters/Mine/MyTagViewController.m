//
//  MyTagViewController.m
//  Opt_master
//
//  Created by 瑞宁科技02 on 16/7/7.
//  Copyright © 2016年 reining. All rights reserved.
//

#import "MyTagViewController.h"
#import "AreaSelectViewController.h"
#import "AppDelegate.h"
#import "GBTagListView.h"
#import "LocationViewController.h"
#import "TagModel.h"
#import "FXJSortView.h"

#define ScreenWidth   [UIScreen mainScreen].bounds.size.width
#define ScreenHeight  [UIScreen mainScreen].bounds.size.height
@interface MyTagViewController ()
{
    NSArray*strArray;//保存标签数据的数组
    GBTagListView*_tempTag;
}
@property (nonatomic ,strong)NSMutableArray *array;
@property (nonatomic ,strong)UILabel *topLabel;
@property (nonatomic ,strong) TagModel *model;
@property (nonatomic ,strong) GBTagListView *tagList;
@property (nonatomic ,strong) FXJSortView *sortView;
@property (nonatomic ,strong) NSMutableArray *seclectArray;


@end

@implementation MyTagViewController
#pragma mark - lazy
-(NSMutableArray *)array{
    if (!_array) {
        _array =[NSMutableArray array];
    }
    return _array;
}

- (NSMutableArray *)seclectArray{
    if (!_seclectArray) {
        _seclectArray = [NSMutableArray array];
    }
    return _seclectArray;
}
#pragma mark - basic
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.navigationController.navigationBarHidden = YES;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupView];
    [self createNavBar];
}
#pragma mark -UI
-(void)createNavBar{
    
    UIView *navBar = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kWidth, 64)];
    navBar.backgroundColor = Navigation_COLOR;
    [self.view addSubview:navBar];
    
    UILabel *titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(kWidth/2-100, 30, 200, 20)];
    titleLabel.textAlignment = NSTextAlignmentCenter;
    titleLabel.text = @"您想关注哪些话题";
    titleLabel.textColor = [UIColor blackColor];
    [navBar addSubview:titleLabel];
    
    UIButton *backBtn = [UIButton buttonWithType:UIButtonTypeSystem];
    backBtn.frame = CGRectMake(0, 20, 80, 44);
    [backBtn setImageEdgeInsets:UIEdgeInsetsMake(0, 0, 0, 10)];
    [backBtn setTitleColor:PRIMARY_COLOR forState:UIControlStateNormal];
    [backBtn setTitle:@"上一步" forState:UIControlStateNormal];
    backBtn.titleLabel.font = GZFontWithSize(18);
    [backBtn addTarget:self action:@selector(CancelAnswerForQuestion) forControlEvents:UIControlEventTouchUpInside];
    [navBar addSubview:backBtn];
    
    UIButton *backBtn1 = [UIButton buttonWithType:UIButtonTypeSystem];
    backBtn1.frame = CGRectMake(kWidth - 60, 20, 60, 44);
    [backBtn1 setTitleColor:PRIMARY_COLOR forState:UIControlStateNormal];
    [backBtn1 setTitle:@"进入" forState:UIControlStateNormal];
    backBtn1.titleLabel.font = GZFontWithSize(18);
    [backBtn1 addTarget:self action:@selector(clearAll) forControlEvents:UIControlEventTouchUpInside];
    [navBar addSubview:backBtn1];
    
    UIView *line = [[UIView alloc] initWithFrame:CGRectMake(0, 63.5, kWidth, 0.5)];
    line.backgroundColor = SEPARATOR_LINE_COLOR;
    [navBar addSubview:line];
}

- (void)setupView{
    
    self.title = @"您想关注哪些话题";
    self.view.backgroundColor = [UIColor whiteColor];
    self.topLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, DEFUALT_MARGIN_SIDES+64, kWidth, 30)];
    self.topLabel.textAlignment = NSTextAlignmentCenter;
    self.topLabel.text = @"我们将根据您选择的话题定制首页推荐内容";
    self.topLabel.textColor = TXT_COLOR;
    self.topLabel.font = GZFontWithSize(12);
    [self.view addSubview:self.topLabel];

    self.tagList=[[GBTagListView alloc]initWithFrame:CGRectMake(0, DEFUALT_MARGIN_SIDES+50+64, ScreenWidth, 0)];
    //注意如果要自定义tag的颜色和整体的背景色定义方法一定要写在setTagWithTagArray方法之前
    self.tagList.canTouch=YES;
    self.tagList.signalTagColor=[UIColor whiteColor];
    [self.tagList setTagWithTagArray:strArray];
    
    [self.tagList setDidselectItemBlock:^(NSArray *arr) {

        strArray = arr.mutableCopy;
    }];
//    [self.view addSubview:self.tagList];
    
    
    self.sortView = [[FXJSortView alloc]init];
    NSMutableSet *mutableSet1 = [NSMutableSet setWithArray:_titleArr];
    NSMutableSet *mutableSet2 = [NSMutableSet setWithArray:self.secondTitleArr];
    //集合元素相减
    [mutableSet2 minusSet:mutableSet1];
    NSArray *allObj = [mutableSet2 allObjects];
    
    [self.sortView firstTitleBtns:_titleArr];
    [self.sortView  NextSection];
    [self.sortView secondTitleBtns:allObj];
    [self.view addSubview:self.sortView];
    self.sortView.sd_layout.spaceToSuperView(UIEdgeInsetsMake(DEFUALT_MARGIN_SIDES+50+64, 0,0 , 0));
    

}


#pragma mark - action
- (void)CancelAnswerForQuestion{
    [self.navigationController popViewControllerAnimated:YES];
}
- (void)clearAll{
    NSDictionary  *topic = @{ @"tags":self.sortView.newtitleArr};
    NSLog(@"=== %@",self.sortView.newtitleArr);
    [[HttpTool shareManager] POST:URL_USER_UPDATE_TAGS parameters:topic success:^(NSURLSessionDataTask *task, id responseObject) {
        NSLog(@"上传标签修改资料结果= %@",responseObject);
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        NSLog(@"err == %@",error);
    }];

    AppDelegate *appdelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
    [appdelegate isLaunchedWithIndex:1];
}

@end
