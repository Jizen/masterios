//
//  ExpertsCertificationViewController.m
//  Opt_master
//
//  Created by 瑞宁科技02 on 16/7/25.
//  Copyright © 2016年 reining. All rights reserved.
//

#import "ExpertsCertificationViewController.h"
#import "CertificationDetailViewController.h"
#import "MineViewCell.h"
#import "CertModel.h"

@interface ExpertsCertificationViewController ()<UIWebViewDelegate,UITableViewDelegate,UITableViewDataSource,UIAlertViewDelegate>
@property (nonatomic ,strong)UIWebView *webview;
@property (nonatomic ,strong)UITableView *tableView;
@property (nonatomic ,strong) NSArray *titleArr1;

@property (nonatomic ,strong)NSMutableArray *dataArray;
@property (nonatomic ,strong)CertModel *model;
@property (nonatomic ,strong) NSMutableDictionary *userData;

@end


@implementation ExpertsCertificationViewController

- (NSMutableArray *)dataArray{
    if (!_dataArray) {
        _dataArray = [NSMutableArray array];
    }
    return _dataArray;
}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.hidden = YES;
    [self loadInitDatas];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    [self createNavBar];
    self.titleArr1 = @[@"个人认证",@"证书认证",@"企业认证"];
    self.view.backgroundColor = BG;
    [self initTableView];
    [self setupMJRefreshHeader];
    [self requestData];
}

#pragma mark - ui
- (void)initTableView{
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 64, self.view.bounds.size.width, self.view.bounds.size.height-NaviBarHeight-49) style:UITableViewStylePlain];
    self.tableView.backgroundColor = BG;
    self.tableView.dataSource =self;
    self.tableView.delegate = self;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.contentInset = UIEdgeInsetsMake(0, 0, 0, 0);
    self.tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    self.tableView.scrollIndicatorInsets=self.tableView.contentInset;
    [self.view addSubview:self.tableView];
    
}



- (void)loadInitDatas{
    NSUserDefaults *user = [NSUserDefaults standardUserDefaults];
    NSString *userid = [user valueForKey:@"userid"];
    NSString *strUrl = [NSString stringWithFormat:@"%@%@",URL_USER_SHOW,userid];
    [[HttpTool shareManager] GET:strUrl parameters:nil success:^(NSURLSessionDataTask *task, id responseObject) {
        self.userData = responseObject[@"data"];
        [self.tableView reloadData];
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
    }];
}

- (void)setupMJRefreshHeader{
    
    MJRefreshNormalHeader *header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(requestData)];
    header.lastUpdatedTimeLabel.hidden = YES;
    [header setTitle:@"下拉刷新数据" forState:MJRefreshStateIdle];
    [header setTitle:@"正在刷新..." forState:MJRefreshStateRefreshing];
    [header setTitle:@"全部加载完成" forState:MJRefreshStateNoMoreData];
    header.stateLabel.font = [UIFont systemFontOfSize:12];
    header.stateLabel.textColor = [UIColor grayColor];
    self.tableView.mj_header = header;
    
}
- (void)requestData{
    [self.dataArray removeAllObjects];
    [self loadInitDatas];
    [[HttpTool shareManager] POST:URL_Mycertification_list parameters:nil success:^(NSURLSessionDataTask *task, id responseObject) {
        NSDictionary *data = responseObject[@"data"];
        
        NSLog(@"data === %@",data);
        for (NSDictionary *dict  in data) {
            NSError* err=nil;
            _model = [[CertModel alloc] initWithDictionary:dict error:&err];
            [self.dataArray addObject:_model];
        }
        [self.tableView reloadData];
        [self.tableView.mj_header endRefreshing];
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        [self.tableView.mj_header endRefreshing];
    }];
}

-(void)createNavBar{
    UIView *navBar = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kWidth, 64)];
    navBar.backgroundColor = Navigation_COLOR;
    [self.view addSubview:navBar];
    
    UILabel *titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(kWidth/2-70, 30, 140, 20)];
    titleLabel.textAlignment = NSTextAlignmentCenter;
    titleLabel.text = @"实名认证";
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
- (void)leftAction{
    [self.navigationController popViewControllerAnimated:YES];
}


#pragma mark - delegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == 0) {
        return 3;
    }
    return _dataArray.count;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 45;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    MineViewCell *cell = [MineViewCell cellWithTableView:tableView];
    if (indexPath.section == 0) {
        cell.messageLabel.text = self.titleArr1[indexPath.row];
        cell.imageView.frame =CGRectMake(0,0,44,44);
        if (indexPath.row == 2 ) {
            cell.imageView.image = [UIImage imageNamed:@"company"];
        }else if(indexPath.row == 0){
            cell.imageView.image = [UIImage imageNamed:@"id-1"];
            
            if (self.userData != nil) {
                NSNumber *status=self.userData[@"status"];
                NSLog(@"status = %@",status);
                if ([status isEqualToNumber:@0]) {
                    cell.stateLabel.text = @"审核中";
                    cell.stateLabel.textColor = [UIColor redColor];
                    
                }else if ([status isEqualToNumber:@1]) {
                    cell.stateLabel.text = @"已认证";
                    cell.stateLabel.textColor = [UIColor redColor];
                    
                }else if ([status isEqualToNumber:@2]) {
                    cell.stateLabel.text = @"未通过";
                    cell.stateLabel.textColor = [UIColor redColor];
                    
                }else if (status == nil) {
                    cell.stateLabel.text = @"未认证";
                    cell.stateLabel.textColor = [UIColor redColor];
                }
            }

        }else{
            cell.imageView.image = [UIImage imageNamed:@"expert"];
        }
    }else{
        cell.accessoryType = UITableViewCellAccessoryNone;
        cell.stateLabel.sd_resetLayout
        .centerYEqualToView(cell)
        .leftSpaceToView(cell.messageLabel,0)
        .rightSpaceToView(cell,DEFUALT_MARGIN_SIDES)
        .heightIs(20);

        if (_dataArray.count == 0) {
        }else{
            cell.certModel = self.dataArray[indexPath.row];
        }
        
    }
    return cell;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kWidth, 30)];
    view.backgroundColor = BG;
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(DEFUALT_MARGIN_SIDES, 0, kWidth, 30)];
    label.backgroundColor = BG;
    label.textColor = TXT_COLOR;
    label.font = GZFontWithSize(12);
    if (section == 0 ) {
        label.text = @"申请认证";
    }else{
        label.text = @"我的认证";
    }
    [view addSubview:label];
    return view;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    
    return 30;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0) {
        
        
//        NSString *verifiedon = self.userData[@"verifiedon"];
        NSNumber *status = self.userData[@"status"];

        if (([status isEqualToNumber:@0] || status == nil) && indexPath.row != 0) {
            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"提示" message:@"须先通过个人认证" delegate:self cancelButtonTitle:nil otherButtonTitles:@"确定",nil];
            [alertView show];

        }else{
            
            if ([status isEqualToNumber:@0]) {
                
                if (indexPath.row == 0) {
                    [self hudWithTitle:@"正在审核中..."];

                }else{
                    
                    CertificationDetailViewController *detail = [[CertificationDetailViewController alloc] init];
                    detail.titles = self.titleArr1[indexPath.row];
                    self.hidesBottomBarWhenPushed = YES;
                    
                    [self.navigationController pushViewController:detail animated:YES];
 
                }
            }else if  ([status isEqualToNumber:@1] ) {
                if (indexPath.row == 0) {
                    [self hudWithTitle:@"已经认证完成"];
                    
                }else{
                    
                    CertificationDetailViewController *detail = [[CertificationDetailViewController alloc] init];
                    detail.titles = self.titleArr1[indexPath.row];
                    self.hidesBottomBarWhenPushed = YES;
                    [self.navigationController pushViewController:detail animated:YES];
                }

               
            }else{
                
                if  ([status isEqualToNumber:@2]  && indexPath.row != 0) {
                    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"提示" message:@"须先通过个人认证" delegate:self cancelButtonTitle:nil otherButtonTitles:@"确定",nil];
                    [alertView show];
                }else{
                CertificationDetailViewController *detail = [[CertificationDetailViewController alloc] init];
                detail.titles = self.titleArr1[indexPath.row];
                self.hidesBottomBarWhenPushed = YES;
                [self.navigationController pushViewController:detail animated:YES];
                }
            }


        }
    }
}

- (void)hudWithTitle:(NSString *)title
{
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
    hud.mode = MBProgressHUDModeText;
    hud.label.text = title;
    [hud hideAnimated:YES afterDelay:1.f];
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {

}


//- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
//{
//    if (indexPath.section == 1) {
//        return YES;
//    }
//    return NO;
//}

//- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath
//{
//    return UITableViewCellEditingStyleDelete;// 就是代表删除的
//}
//
//
//- (NSArray<UITableViewRowAction *> *)tableView:(UITableView *)tableView editActionsForRowAtIndexPath:(NSIndexPath *)indexPath
//{
//    if (indexPath.section == 1) {
//
//        UITableViewRowAction *deleteRowAction = [UITableViewRowAction rowActionWithStyle:UITableViewRowActionStyleDestructive title:@"删除" handler:^(UITableViewRowAction * _Nonnull action, NSIndexPath * _Nonnull indexPath) {
////            [self.dataArray removeObjectAtIndex:indexPath.row];
////            [self.tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
//            
//            CertModel *certmodel = self.dataArray[indexPath.row];
//            NSString *certID = certmodel.id;
//            
//            NSString *url = [NSString stringWithFormat:@"%@%@",URL_Mycertification_DEL,certID];
//            [[HttpTool shareManager] POST:url parameters:nil success:^(NSURLSessionDataTask *task, id responseObject) {
//                
//                [self.dataArray removeObjectAtIndex:indexPath.row];
//                [self.tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
//
//                NSLog(@"responseObject =  %@",responseObject);
//            } failure:^(NSURLSessionDataTask *task, NSError *error) {
//                
//            }];
//            
//        }];
//        return @[deleteRowAction];
//
//    }
//    return nil;
//
//}



@end
