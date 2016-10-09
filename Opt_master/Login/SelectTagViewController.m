//
//  SelectTagViewController.m
//  Opt_master
//
//  Created by 瑞宁科技02 on 16/7/18.
//  Copyright © 2016年 reining. All rights reserved.
//

#import "SelectTagViewController.h"
#import "ZHBtnSelectView.h"
#import "ZHCustomBtn.h"
#import "AppDelegate.h"
#import "GBTagListView.h"
#import "FXJSortView.h"
#import "TagModel.h"

#import "UIView+SDAutoLayout.h"

#define ScreenWidth   [UIScreen mainScreen].bounds.size.width
#define ScreenHeight  [UIScreen mainScreen].bounds.size.height
@interface SelectTagViewController ()<ZHBtnSelectViewDelegate>
{
    
    NSMutableArray*strArray;//保存标签数据的数组
    NSArray*strArray1;//保存标签数据的数组
    GBTagListView*_tempTag;
    
}
@property (nonatomic ,strong)NSMutableArray *array;

@property (nonatomic,weak)ZHCustomBtn *currentBtn;
@property (nonatomic,weak)ZHBtnSelectView *btnView;
//@property (nonatomic,strong)NSMutableArray *titleArr;
@property (nonatomic ,strong)UILabel *topLabel;
@property (nonatomic ,strong)  GBTagListView *tagList;
@property (nonatomic ,strong) TagModel *model;

@property (nonatomic ,strong) NSMutableArray *seclectArray;
@property (nonatomic ,strong) FXJSortView *sortView;
@end

@implementation SelectTagViewController
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


#pragma mark - UI
-(void)createNavBar{
    UIView *navBar = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kWidth, 64)];
    navBar.backgroundColor = Navigation_COLOR;
    [self.view addSubview:navBar];
    
    UILabel *titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(kWidth/2-50, 30, 100, 20)];
    titleLabel.textAlignment = NSTextAlignmentCenter;
    titleLabel.text = @"标签管理";
    titleLabel.textColor = [UIColor blackColor];
    [navBar addSubview:titleLabel];
    
    UIButton *backBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    backBtn.frame = CGRectMake(0, 20, 60, 44);
    [backBtn setTitleColor:PRIMARY_COLOR forState:UIControlStateNormal];
    [backBtn setImage:[UIImage imageNamed:@"return"] forState:(UIControlStateNormal)];
    [backBtn addTarget:self action:@selector(leftAction) forControlEvents:UIControlEventTouchUpInside];
    [navBar addSubview:backBtn];
    
    UIButton *backBtn1 = [UIButton buttonWithType:UIButtonTypeCustom];
    backBtn1.frame = CGRectMake(kWidth - 50, 30, 40, 20);
    [backBtn1 setTitleColor:PRIMARY_COLOR forState:UIControlStateNormal];
    [backBtn1 setTitle:@"保存" forState:(UIControlStateNormal)];
    backBtn1.titleLabel.font = GZFontWithSize(18);
    [backBtn1 addTarget:self action:@selector(clearAll) forControlEvents:UIControlEventTouchUpInside];
    [navBar addSubview:backBtn1];
    
    UIView *line = [[UIView alloc] initWithFrame:CGRectMake(0, 63.5, kWidth, 0.5)];
    line.backgroundColor = SEPARATOR_LINE_COLOR;
    [navBar addSubview:line];
}
- (void)setupView{
    
    self.title = @"标签管理";
    self.view.backgroundColor = [UIColor whiteColor];
    self.topLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, DEFUALT_MARGIN_SIDES+64, kWidth, 30)];
    self.topLabel.textAlignment = NSTextAlignmentCenter;
    self.topLabel.text = @"我们将根据您选择的话题定制首页推荐内容";
    self.topLabel.textColor = TXT_COLOR;
    self.topLabel.font = GZFontWithSize(12);
    [self.view addSubview:self.topLabel];
    
    
    
    [self.tagList setTagWithTagArray:self.secondTitleArr];
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
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"保存"  style:(UIBarButtonItemStyleDone) target:self action:@selector(clearAll)];
    
    
}


#pragma mark - action
- (void)leftAction{
    [self.navigationController popViewControllerAnimated:YES];
}
- (void)clearAll{
    
    NSDictionary  *topic = @{@"tags":self.sortView.newtitleArr};

    [[HttpTool shareManager] POST:URL_USER_UPDATE_TAGS parameters:topic success:^(NSURLSessionDataTask *task, id responseObject) {
        NSNumber *code = responseObject[@"code"];
        
        if ([code isEqualToNumber:@200]) {
            NSDictionary *data = responseObject[@"data"];
            NSUserDefaults *user = [NSUserDefaults standardUserDefaults];
            NSString *tags = data[@"tags"];
            [user setValue:tags forKey:@"tags"];
            [user synchronize];
            [self.navigationController popViewControllerAnimated:YES];
        }else{
            [self hudWithTitle:@"修改失败"];
        }
        
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


@end
