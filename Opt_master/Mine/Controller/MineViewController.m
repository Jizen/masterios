//
//  MineViewController.m
//  Opt_master
//
//  Created by 瑞宁科技02 on 16/7/7.
//  Copyright © 2016年 reining. All rights reserved.
//

#import "MineViewController.h"
#import "MyQuestionController.h"
#import "MyAnswerViewController.h"
#import "MyTagViewController.h"
#import "MyCollectionViewController.h"
#import "MineViewCell.h"
#import "MineheaderViewCell.h"
#import "MyInformationViewController.h"
#import "SettingViewController.h"
#import "SelectTagViewController.h"
#import "ExpertsCertificationViewController.h"
#import "UIImageView+WebCache.h"
#import "MineModel.h"
#import "TagModel.h"
#import "AYCheckManager.h"
#import "NQXImageBrowswe.h"
#import "LoginViewController.h"
#define HeadImgHeight 200


static CGFloat const headViewHeight = 256;

@interface MineViewController ()
@property (strong, nonatomic) UIImageView *HeadImgView; //!< 头部图像
@property (nonatomic ,strong) NSArray *imageArr1;
@property (nonatomic ,strong) NSArray *titleArr1;
@property (nonatomic ,strong) NSArray *imageArr2;
@property (nonatomic ,strong) NSArray *titleArr2;
@property (nonatomic ,strong) UIImageView *headImage;
@property (nonatomic ,strong) UILabel *nameLabel;
@property (nonatomic ,strong) MineModel *mineModel;
@property (nonatomic ,strong) TagModel *model;
@property (nonatomic ,strong) NSMutableArray *array;
@property (nonatomic ,strong) NSMutableDictionary *userData;
@property (nonatomic ,strong)UIButton *logOutButton;

@end

@implementation MineViewController
#pragma mark - lazy
-(NSMutableArray *)array{
    if (!_array) {
        _array =[NSMutableArray array];
    }
    return _array;
}
- (UIImageView *)headImage{
    if (!_headImage) {
        _headImage = [[UIImageView alloc] init];
        _headImage.userInteractionEnabled = YES;
    }
    return _headImage;
}

- (UILabel *)nameLabel{
    if (!_nameLabel) {
        _nameLabel = [[UILabel alloc] init];
        _nameLabel.textColor = [UIColor whiteColor];
        _nameLabel.textAlignment = NSTextAlignmentCenter;
    }
    return _nameLabel;
}
#pragma mark - basic
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES animated:YES];
    NSUserDefaults *user = [NSUserDefaults standardUserDefaults];
    NSString *avatar = [user valueForKey:@"avatar"];
    NSString *nickname = [user valueForKey:@"nickname"];
    
    NSString *headUrl =[NSString stringWithFormat:@"%@",avatar] ;
    [self.headImage sd_setImageWithURL:[NSURL URLWithString:headUrl] placeholderImage:[UIImage imageNamed:@"head"]];
    self.nameLabel.text = nickname;
    [self loadNewDatas];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupTopView];
    [self requestTags];
    [self loadNewDatas];
    
    
    // 与图像高度一样防止数据被遮挡
    self.tableView.tableHeaderView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kWidth, HeadImgHeight)];
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    UIImageView *backImage = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, kWidth, 200)];
    backImage.image =[ UIImage imageNamed:@"bg"];
//    [self.view addSubview:backImage];
    
     [self.view insertSubview:backImage atIndex:1]; //atIndex决定你的图片显示在标签栏的哪一层
    self.view.backgroundColor = BG;
    self.tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.imageArr1 = @[@"my-question",@"my-answer"];
    self.titleArr1 = @[@"我的提问",@"我的回答"];
    self.imageArr2 = @[@"interest",@"collect"];
    self.titleArr2 = @[@"我的收藏",@"我的标签"];
    

    
}

- (void)setupMJRefreshHeader{

    MJRefreshNormalHeader *header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(loadNewDatas)];
    header.lastUpdatedTimeLabel.hidden = YES;
    [header setTitle:@"下拉刷新数据" forState:MJRefreshStateIdle];
    [header setTitle:@"正在刷新..." forState:MJRefreshStateRefreshing];
    [header setTitle:@"全部加载完成" forState:MJRefreshStateNoMoreData];
    header.stateLabel.font = [UIFont systemFontOfSize:12];
    header.stateLabel.textColor = [UIColor grayColor];
    [header beginRefreshing];
    self.tableView.mj_header = header;
    
}

- (void)loadNewDatas{
    
    
    NSUserDefaults *user = [NSUserDefaults standardUserDefaults];
    NSString *userid = [user valueForKey:@"userid"];
    NSString *strUrl = [NSString stringWithFormat:@"%@%@",URL_USER_SHOW,userid];
    [[HttpTool shareManager] GET:strUrl parameters:nil success:^(NSURLSessionDataTask *task, id responseObject) {
        
        self.userData = responseObject[@"data"];
        [self.tableView.mj_header endRefreshing];
        [self.tableView reloadData];
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        [self.tableView.mj_header endRefreshing];
    }];

}

- (void)checkVersion{
//    AYCheckManager *checkManger = [AYCheckManager sharedCheckManager];
//    checkManger.countryAbbreviation = @"cn";
//    checkManger.openAPPStoreInsideAPP = YES;
//    [checkManger checkVersion];
//    [checkManger checkVersionWithAlertTitle:@"发现新版本" nextTimeTitle:@"下次提示" confimTitle:@"前往更新"];
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    [manager POST:@"http://itunes.apple.com/lookup?id=414478124" parameters:nil success:^(AFHTTPRequestOperation * _Nonnull operation, id  _Nonnull responseObject) {
        NSArray *array = responseObject[@"results"];
        NSDictionary *dict = [array lastObject];
        NSLog(@"当前版本为：%@", dict[@"version"]);
    } failure:^(AFHTTPRequestOperation * _Nullable operation, NSError * _Nonnull error) {
    }];
}
#pragma mark - UI
- (UIStatusBarStyle)preferredStatusBarStyle{
    return UIStatusBarStyleLightContent;
}
- (void)setupTopView{
    self.HeadImgView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, kWidth, HeadImgHeight)];
    _HeadImgView.backgroundColor = PRIMARY_COLOR;

    [self.tableView addSubview:self.HeadImgView];
    [self.HeadImgView addSubview:self.headImage];
    [self.HeadImgView addSubview:self.nameLabel];
    self.HeadImgView.userInteractionEnabled = YES;
    UITapGestureRecognizer *headTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(headImageAction:)];
    [self.HeadImgView addGestureRecognizer:headTap];
    
    self.headImage.sd_layout
    .centerXEqualToView(self.HeadImgView)
    .topSpaceToView(self.HeadImgView,50)
    .widthIs(80)
    .heightIs(80);
    self.headImage.sd_cornerRadiusFromHeightRatio = @(0.5); // 设置view0的圆角半径为自身高度的0.5倍

    
    self.nameLabel.sd_layout
    .centerXEqualToView(self.HeadImgView)
    .topSpaceToView(self.headImage,10)
    .widthIs(300)
    .heightIs(20);

}



- (void)setupLogOutButton{
    // 退出按钮
    self.logOutButton = [UIButton buttonWithType:(UIButtonTypeSystem)];
    self.logOutButton.layer.cornerRadius = BTN_CORNER_RADIUS;
    self.logOutButton.layer.masksToBounds = YES;
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 40+DEFUALT_MARGIN_SIDES)];
    self.tableView.tableFooterView = view;
    [view addSubview:_logOutButton];
    
    self.logOutButton.sd_layout
    .centerXEqualToView(self.tableView.tableFooterView)
    .topSpaceToView(view,DEFUALT_MARGIN_SIDES)
    .leftSpaceToView(view,3*DEFUALT_MARGIN_SIDES)
    .rightSpaceToView(view,3*DEFUALT_MARGIN_SIDES)
    .heightIs(40);
    [self.logOutButton setTitle:@"退出此账号" forState:(UIControlStateNormal)];
    [self.logOutButton setTitleColor:[UIColor whiteColor] forState:(UIControlStateNormal)];
    self.logOutButton.titleLabel.font = GZFontWithSize(18);
    self.logOutButton.layer.cornerRadius = BTN_CORNER_RADIUS;
    self.logOutButton.backgroundColor = PRIMARY_COLOR;
    self.logOutButton.layer.masksToBounds = YES;
    [self.logOutButton addTarget:self action:@selector(clickLogOutButtonAction:) forControlEvents:(UIControlEventTouchUpInside)];
}
- (void)clickLogOutButtonAction:(UIButton *)sender{
    
    LoginViewController *loginVC = [[LoginViewController alloc] init];
    self.hidesBottomBarWhenPushed = YES;
    loginVC.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"" style:(UIBarButtonItemStyleDone) target:self action:@selector(leftAction2)];
    [self.navigationController pushViewController:loginVC animated:YES];
    //    [self clearAllUserDefaultsData];
    
    NSUserDefaults *user = [NSUserDefaults standardUserDefaults];
    [user setValue:@"" forKey:@"name"];
    [user synchronize];
    
    
}


#pragma mark - action
- (void)clickSettingButton{
    SettingViewController *settingVC = [[SettingViewController alloc] init];
    self.hidesBottomBarWhenPushed=YES;
    [self.navigationController pushViewController:settingVC animated:YES];
    self.hidesBottomBarWhenPushed=NO;
}
- (void)headImageAction:(UITapGestureRecognizer *)tag{
    SettingViewController *settingVC = [[SettingViewController alloc] init];
    self.hidesBottomBarWhenPushed=YES;
    [self.navigationController pushViewController:settingVC animated:YES];
    self.hidesBottomBarWhenPushed=NO;
}


- (void)requestTags{
    NSString *url = [NSString stringWithFormat:@"%@",URL_TAG_LIST];
    [[HttpTool shareManager] POST:url parameters:nil success:^(NSURLSessionDataTask *task, id responseObject) {
        for (NSDictionary *dict  in responseObject) {
            NSError* err=nil;
            _model = [[TagModel alloc]initWithDictionary:dict error:&err];
            [self.array addObject:_model.title];
            
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
#pragma mark - Delegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 4;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == 2||section == 3) {
        return 1;
    }
    return 2;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{

    MineViewCell *cell = [MineViewCell cellWithTableView:tableView];
    if (indexPath.section == 0) {
        cell.messageLabel.text = self.titleArr1[indexPath.row];
        cell.imageView.frame =CGRectMake(0,0,44,44);
        if (indexPath.row == 0 ) {
            cell.imageView.image = [UIImage imageNamed:@"my-question"];
        }else{
            cell.imageView.image = [UIImage imageNamed:@"my-answer"];
        }
    }else{
        cell.messageLabel.text = self.titleArr2[indexPath.row];
        if (indexPath.row == 0 ) {
            cell.imageView.image = [UIImage imageNamed:@"interest"];
        }else{
            cell.imageView.image = [UIImage imageNamed:@"collect"];
        }
    }
    if (indexPath.section == 3) {
        cell.messageLabel.text = @"设置";
        cell.imageView.image = [UIImage imageNamed:@"set-up"];

    }
    if (indexPath.section == 2) {
        cell.messageLabel.text = @"实名认证";

        NSNumber *status = self.userData[@"status"];

        
        if (status == nil ) {
            cell.stateLabel.text = @"未认证";
        }else  if ([status isEqualToNumber:@0] ) {
            cell.stateLabel.text = @"审核中";
        }else if ([status isEqualToNumber:@2]){
            cell.stateLabel.text = @"未通过";
        }else if ([status isEqualToNumber:@1]){
            cell.stateLabel.text = @"已认证";
        }
        
        
        cell.imageView.image = [UIImage imageNamed:@"expert"];
        
        
    }
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        if (indexPath.row == 0) {
            MyQuestionController *detail = [[MyQuestionController alloc] init];
            self.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:detail animated:YES];
            self.hidesBottomBarWhenPushed = NO;
        }else if (indexPath.row == 1){
            MyAnswerViewController *detail = [[MyAnswerViewController alloc] init];
            self.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:detail animated:YES];
            self.hidesBottomBarWhenPushed = NO;
        }
    }else if(indexPath.section == 1){
        if (indexPath.row == 1) {
            SelectTagViewController *detail = [[SelectTagViewController alloc] init];
            
            NSUserDefaults *user = [NSUserDefaults standardUserDefaults];
            NSString *tag = [user valueForKey:@"tags"];

            NSArray *tags;
            if (tag.length == 0) {
                
            }else{
             tags = [tag componentsSeparatedByString:@","];
            }
            detail.titleArr = [NSMutableArray arrayWithArray:tags];
            self.hidesBottomBarWhenPushed = YES;
            detail.secondTitleArr = self.array;
            [self.navigationController pushViewController:detail animated:YES];
            self.hidesBottomBarWhenPushed = NO;
        }else if (indexPath.row == 0){
            MyCollectionViewController *detail = [[MyCollectionViewController alloc] init];
            self.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:detail animated:YES];
            self.hidesBottomBarWhenPushed = NO;
        }
    }else if (indexPath.section == 3){
        SettingViewController *detail = [[SettingViewController alloc] init];
        detail.mineModel = self.mineModel;
        detail.imageStr = [NSString stringWithFormat:@"%@/%@",BASE_URL,self.mineModel.avatar];
        self.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:detail animated:YES];
        self.hidesBottomBarWhenPushed = NO;
    }
    if (indexPath.section == 2) {
        ExpertsCertificationViewController *expertVC = [[ExpertsCertificationViewController alloc] init];
        self.hidesBottomBarWhenPushed=YES;
        [self.navigationController pushViewController:expertVC animated:YES];
        self.hidesBottomBarWhenPushed = NO;
    }
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kWidth, 10)];
    view.backgroundColor = BG;
    return view;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 10;
}
- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kWidth, 10)];
    view.backgroundColor = BG;
    return view;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    if (section == 4) {
        return 100;

    }
    return 0;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 45;
}
- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    CGFloat offsetY = scrollView.contentOffset.y;
    if (offsetY < 0) {
        self.HeadImgView.frame = CGRectMake(offsetY/2, offsetY, kWidth - offsetY, HeadImgHeight - offsetY);  // 修改头部的frame值就行了
        CGRect f = self.headImage.frame;
        f.origin.y= offsetY ;
        f.size.height=  -offsetY;
        f.origin.y= offsetY;
        
        //改变头部视图的fram
        self.headImage.frame= f;
        CGRect avatarF = CGRectMake(f.size.width/2-40, (f.size.height-headViewHeight)+56, 80, 80);
        self.headImage.frame = avatarF;


    }
    
    
    /**
     * 处理头部视图
     */
//    if(offsetY < -headViewHeight) {
    
//        CGRect f = self.headImage.frame;
//        f.origin.y= offsetY ;
//        f.size.height=  -offsetY;
//        f.origin.y= offsetY;
//        
//        //改变头部视图的fram
//        self.headImage.frame= f;
//        CGRect avatarF = CGRectMake(f.size.width/2-40, (f.size.height-headViewHeight)+56, 80, 80);
//        self.headImage.frame = avatarF;
//    }
    

}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    [self loadNewDatas];

}

@end
