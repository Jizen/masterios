//
//  SettingViewController.m
//  Opt_master
//
//  Created by 瑞宁科技02 on 16/7/11.
//  Copyright © 2016年 reining. All rights reserved.
//

#import "SettingViewController.h"
#import "passwordViewController.h"
#import "UserAgreementViewController.h"
#import "MyInformationViewController.h"
#import "UserFeedBackViewController.h"
#import "MessageSettingViewController.h"
#import "ExpertsCertificationViewController.h"
#import "NameViewController.h"
#import "LoginViewController.h"
#import "MineheaderViewCell.h"
#import "PersonalCell.h"
#import "CommonCell.h"
#import "MineViewCell.h"
@interface SettingViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic ,strong)UITableView *tableView;
@property (nonatomic,strong)NSArray *cellArray;
@property (nonatomic,strong)NSArray *imageArray;
@property (nonatomic ,strong)UIButton *logOutButton;
@property (nonatomic ,strong)MineModel *model;
@property (nonatomic ,strong)MineheaderViewCell *mineHeadercell;

@end

@implementation SettingViewController
#pragma mark -basic
- (void)viewWillAppear:(BOOL)animated{

    [super viewWillAppear:animated];
    self.navigationController.navigationBarHidden = YES;
    
    NSUserDefaults *user = [NSUserDefaults standardUserDefaults];
    NSString *avatar = [user valueForKey:@"avatar"];
    NSString *nickname = [user valueForKey:@"nickname"];
    NSString *baseUrl = [user objectForKey:@"baseUrl"];
    NSString *appName = [user objectForKey:@"appname"];
    NSString *headUrl =[NSString stringWithFormat:@"%@%@/%@",baseUrl,appName,avatar] ;
    [self.mineHeadercell.headImage sd_setImageWithURL:[NSURL URLWithString:headUrl] placeholderImage:[UIImage imageNamed:@"head"]];
    self.mineHeadercell.nameLabel.text = nickname;
    [self.tableView reloadData];

}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initTableView];
    [self setupLogOutButton];
    [self createNavBar];
    self.navigationController.navigationBar.backgroundColor = [UIColor clearColor];
    self.navigationController.navigationBar.translucent = YES;
    self.title = @"设置";
    self.view.backgroundColor = [UIColor whiteColor];
    self.cellArray = [NSArray array];
    _cellArray = @[@"问题反馈", @"消息设置",@"密码设置", @"清除缓存",@"关于"];
    _imageArray = @[@"view-four", @"massage-four",@"password-four", @"delete-four",@"about-four"];
}

#pragma mark - UI
-(void)createNavBar{
    UIView *navBar = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kWidth, 64)];
    navBar.backgroundColor = Navigation_COLOR;
    [self.view addSubview:navBar];
    
    UILabel *titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(kWidth/2-50, 30, 100, 20)];
    titleLabel.textAlignment = NSTextAlignmentCenter;
    titleLabel.text = @"设置";
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
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 64, self.view.bounds.size.width, self.view.bounds.size.height) style:UITableViewStylePlain];
    self.tableView.backgroundColor = BG;
    self.tableView.dataSource =self;
    self.tableView.delegate = self;
    self.tableView.contentInset = UIEdgeInsetsMake(0, 0, 0, 0);
    self.tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    self.tableView.scrollIndicatorInsets=self.tableView.contentInset;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:self.tableView];
    
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
#pragma mark -action
- (void)leftAction{
    [self.navigationController popViewControllerAnimated:YES];
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


- (void)clearAllUserDefaultsData
{
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    
    NSDictionary *dic = [userDefaults dictionaryRepresentation];
    for (id  key in dic) {
        [userDefaults removeObjectForKey:key];
    }
    [userDefaults synchronize];
}

- (void)leftAction2{
}

#pragma mark - delegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section ==0) {
        return 1;
    }else{
        return 5;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        self.mineHeadercell = [MineheaderViewCell cellWithTableView:tableView];
        NSUserDefaults *user = [NSUserDefaults standardUserDefaults];
        NSString *avatar = [user valueForKey:@"avatar"];
        NSString *nickname = [user valueForKey:@"nickname"];

        NSString *headUrl =[NSString stringWithFormat:@"%@",avatar] ;
        [self.mineHeadercell .headImage sd_setImageWithURL:[NSURL URLWithString:headUrl] placeholderImage:[UIImage imageNamed:@"head"]];
        self.mineHeadercell .nameLabel.text = nickname;
        return self.mineHeadercell;
    }else{
        MineViewCell *cell = [MineViewCell cellWithTableView:tableView];
        cell.messageLabel.text = _cellArray[indexPath.row];
        cell.imageView.image = [UIImage imageNamed:[NSString stringWithFormat:@"%@",_imageArray[indexPath.row]]];
        
        if (indexPath.row == 4) {
            NSString* version=[[NSString alloc]initWithFormat:@"%@%@",@"v",CURRENT_VERSION];
            cell.stateLabel.text = version;
        }
        return cell;
    }

}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 10;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kWidth, 10)];
    view.backgroundColor = BG;
    UIView *topLine = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kWidth, 0.5)];
    topLine.backgroundColor = BG;
    UIView *bottomLine = [[UIView alloc] initWithFrame:CGRectMake(0, 10, kWidth, 0.5)];
    bottomLine.backgroundColor = BG;
    [view addSubview:topLine];
    [view addSubview:bottomLine];
    return view;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0) {
        MyInformationViewController *informationVC = [[MyInformationViewController alloc] init];
        informationVC.mineModel = self.mineModel;
        self.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:informationVC animated:YES];
    }
    if (indexPath.section == 1) {
        if (indexPath.row == 0) {
            self.hidesBottomBarWhenPushed=YES;
            [self.navigationController pushViewController:[[UserFeedBackViewController alloc]init] animated:YES];

        }else if (indexPath.row == 1){
            MessageSettingViewController *messageSetVC = [[MessageSettingViewController alloc] init];
            self.hidesBottomBarWhenPushed=YES;
            [self.navigationController pushViewController:messageSetVC animated:YES];
        }else if (indexPath.row == 2){
            passwordViewController *passwordVC =[[passwordViewController alloc] init];
            passwordVC.navigationItem.title = @"密码设置";
            self.hidesBottomBarWhenPushed=YES;
            [self.navigationController pushViewController:passwordVC animated:YES];
        }else if (indexPath.row == 3){
            [self hudWithTitle:@"清除缓存成功"];
        }else if (indexPath.row == 4){
            UserAgreementViewController *userVC = [[UserAgreementViewController alloc] init];
            self.hidesBottomBarWhenPushed=YES;
            [self.navigationController pushViewController:userVC animated:YES];
        }

    }

    if (indexPath.section == 3) {
        if (indexPath.row == 0) {
            UserAgreementViewController *userVC = [[UserAgreementViewController alloc] init];
            self.hidesBottomBarWhenPushed=YES;
            [self.navigationController pushViewController:userVC animated:YES];
        }
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0) {
        return 80;
    }
    return 50;
}
#pragma mari - public
- (void)hudWithTitle:(NSString *)title
{
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
    hud.mode = MBProgressHUDModeText;
    hud.label.text = title;
    [hud hideAnimated:YES afterDelay:1.f];
}
// 此方法不让section 悬停顶部
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    CGFloat sectionHeaderHeight = 40;
    if (scrollView.contentOffset.y<=sectionHeaderHeight&&scrollView.contentOffset.y>=0) {
        scrollView.contentInset = UIEdgeInsetsMake(-scrollView.contentOffset.y, 0, 0, 0);
    } else if (scrollView.contentOffset.y>=sectionHeaderHeight) {
        scrollView.contentInset = UIEdgeInsetsMake(-sectionHeaderHeight, 0, 0, 0);
    }
}


@end
