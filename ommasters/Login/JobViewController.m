//
//  JobViewController.m
//  Opt_master
//
//  Created by 瑞宁科技02 on 16/7/8.
//  Copyright © 2016年 reining. All rights reserved.
//

#import "JobViewController.h"
#import "Image+textField.h"
#import "MyTagViewController.h"
#import "CLAlertView.h"
#import "ImageTextField.h"
#import "JobCell.h"
#import "PickerChoiceView.h"
#import "TagModel.h"

@interface JobViewController ()<UIGestureRecognizerDelegate,UITextFieldDelegate,CLAlertViewDelegate,UITableViewDelegate,UITableViewDataSource,TFPickerDelegate>
@property (nonatomic ,strong)UIImageView *example;
@property (nonatomic ,strong) Image_textField *name;
@property (nonatomic ,strong) Image_textField *year;
@property (nonatomic ,strong)UILabel *topLabel;
@property (nonatomic ,strong) UIButton *nextStep;


//   -----------
@property (nonatomic ,strong) UIImageView *headImage;
@property (nonatomic ,strong) UITextField *profession;
@property (nonatomic ,strong) UIImageView *yearImage;
@property (nonatomic ,strong) UITextField *yearTextField;


@property (nonatomic ,strong) ImageTextField *perfessionView;
@property (nonatomic ,strong) ImageTextField *yearView;


@property (nonatomic ,strong)UITableView *tableView;
@property (nonatomic ,strong)UIView *topView;
@property (nonatomic ,strong) TagModel *model;
@property (nonatomic ,strong)NSMutableArray *array;

@end

@implementation JobViewController
-(NSMutableArray *)array{
    if (!_array) {
        _array =[NSMutableArray array];
    }
    return _array;
}
#pragma mark - basic
- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    [self createNavBar];
    [self initTableView];
    [self requestData];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(test) name:@"test" object:nil];
    UITapGestureRecognizer *tapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(keyboardHide:)];
    //设置成NO表示当前控件响应后会传播到其他控件上，默认为YES。
    tapGestureRecognizer.cancelsTouchesInView = NO;
    //将触摸事件添加到当前view
    [self.view addGestureRecognizer:tapGestureRecognizer];

}
- (void)test{
    [self.perfessionView.name resignFirstResponder];

}
-(void)keyboardHide:(UITapGestureRecognizer*)tap{
    [self.perfessionView.name resignFirstResponder];

}

#pragma mark - Ui
-(void)createNavBar{
    UIView *navBar = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kWidth, 64)];
    navBar.backgroundColor = Navigation_COLOR;
    [self.view addSubview:navBar];
    
    UILabel *titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(kWidth/2-150, 30, 300, 20)];
    titleLabel.textAlignment = NSTextAlignmentCenter;
    titleLabel.text = @"你的职业或者专业是什么？";
    titleLabel.textColor = [UIColor blackColor];
    [navBar addSubview:titleLabel];
    
    UIButton *backBtn1 = [UIButton buttonWithType:UIButtonTypeSystem];
    backBtn1.frame = CGRectMake(kWidth - 80, 20, 80, 44);
    [backBtn1 setTitleColor:PRIMARY_COLOR forState:UIControlStateNormal];
    [backBtn1 setTitle:@"下一步" forState:UIControlStateNormal];
    backBtn1.titleLabel.font = GZFontWithSize(18);
    [backBtn1 addTarget:self action:@selector(nextStepAction:) forControlEvents:UIControlEventTouchUpInside];
    [navBar addSubview:backBtn1];
    
    UIView *line = [[UIView alloc] initWithFrame:CGRectMake(0, 63.5, kWidth, 0.5)];
    line.backgroundColor = SEPARATOR_LINE_COLOR;
    [navBar addSubview:line];

}

#pragma mark - ui
- (void)initTableView{
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 64, self.view.bounds.size.width, self.view.bounds.size.height-NaviBarHeight) style:UITableViewStylePlain];
    self.tableView.backgroundColor = BG;
    self.tableView.dataSource =self;
    self.tableView.delegate = self;
    self.tableView.contentInset = UIEdgeInsetsMake(0, 0, 0, 0);
    self.tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    self.tableView.scrollIndicatorInsets=self.tableView.contentInset;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.scrollEnabled = NO;
    [self.view addSubview:self.tableView];
    
    [self setupTopView];
}

- (void)setupTopView{
    self.topView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kWidth, 60)];
    self.topView.backgroundColor = [UIColor whiteColor];
        
    
    self.perfessionView = [[ImageTextField alloc] init];
    self.perfessionView.name.placeholder = @"您的职业身份";
    self.perfessionView.name.delegate = self;
    self.perfessionView.name.font = GZFontWithSize(17);
    self.perfessionView.name.tag = 102;
    self.perfessionView.leftImage.image = [UIImage imageNamed:@"head-g"];
    
    self.yearView = [[ImageTextField alloc] init];
    self.yearView.name.placeholder = @"从业经验";
    self.yearView.name.delegate = self;
    self.yearView.name.tag = 101;
    self.yearView.name.font = GZFontWithSize(17);
    self.yearView.leftImage.image = [UIImage imageNamed:@"year-green"];
    
    self.yearView.name.userInteractionEnabled = NO;

    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapAction)];
    tap.cancelsTouchesInView = NO;

    [self.yearView addGestureRecognizer:tap];
    
    [self.topView addSubview:self.yearView];
    [self.topView addSubview:self.perfessionView];
    
    self.perfessionView.sd_layout
    .topSpaceToView(self.topView,18)
    .leftSpaceToView(self.topView,0)
    .rightSpaceToView(self.topView,kWidth/2-30)
    .heightIs(30);
    
    self.yearView.sd_layout
    .topSpaceToView(self.topView,18)
    .leftSpaceToView(self.perfessionView,DEFUALT_MARGIN_SIDES)
    .rightSpaceToView(self.topView,DEFUALT_MARGIN_SIDES)
    .heightIs(30);

    
    self.tableView.tableHeaderView = self.topView;
}


- (void)leftAction{
    [self.navigationController popViewControllerAnimated:YES];
}
- (void)tapAction{
    [self.perfessionView.name resignFirstResponder];
    PickerChoiceView *picker = [[PickerChoiceView alloc]initWithFrame:CGRectMake(0, 64, kWidth, kHeight-64)];
    picker.selectLb.text = @"年限";
    picker.delegate = self;
    picker.customArr = @[@"1",@"2",@"3",@"4",@"5",@"6",@"7",@"8",@"9",@"10"];
    [self.view addSubview:picker];

}
#pragma mark - delegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 3;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    JobCell *cell = [JobCell cellWithTableView:tableView];

    if (indexPath.row == 0) {
        cell.jobLabel.text = @"数据库专家";
        cell.yearLabel. text = @"8年";
        cell.headImage.image = [UIImage imageNamed:@"网络安全"];

    }else if (indexPath.row == 1){
        cell.jobLabel.text = @"网络安全专家";
        cell.yearLabel. text = @"5年";
        cell.headImage.image = [UIImage imageNamed:@"bd"];

    }else if (indexPath.row == 2){
        cell.jobLabel.text = @"运维工程师";
        cell.yearLabel. text = @"1年";
        cell.headImage.image = [UIImage imageNamed:@"小白"];

    }
    return cell;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 50;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 50;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kWidth, 50)];
    view.backgroundColor = [UIColor whiteColor];
    
    UIView *view1 = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kWidth, DEFUALT_MARGIN_SIDES)];
    view1.backgroundColor = BG;
    [view addSubview:view1];
    
    UILabel *title = [[UILabel alloc] init];
    title.font = GZFontWithSize(12);
    title.textAlignment = NSTextAlignmentCenter;
    title.text = @"他们是这样描述自己的职业和从业年份的";
    title.textColor = TXT_COLOR;
    [view addSubview:title];
    
    UIView *line = [[UIView alloc] init];
    line.backgroundColor = SEPARATOR_LINE_COLOR;
    [view addSubview:line];
    
    title.sd_layout
    .topSpaceToView(view1,DEFUALT_MARGIN_SIDES)
    .centerXEqualToView(view)
    .leftSpaceToView(view,0)
    .rightSpaceToView(view,0)
    .heightIs(20);
    
    line.sd_layout
    .bottomEqualToView(view)
    .leftSpaceToView(view,50)
    .rightSpaceToView(view,50)
    .heightIs(0.5);
    
    return view;
}
- (void)requestData{
    NSString *url = [NSString stringWithFormat:@"/tag/list"];
    
    [[HttpTool shareManager] POST:url parameters:nil success:^(NSURLSessionDataTask *task, id responseObject) {
        NSLog(@"获取标签接口返回数据 === %@",responseObject);
        
        for (NSDictionary *dict  in responseObject) {
            NSError* err=nil;
            _model = [[TagModel alloc]initWithDictionary:dict error:&err];
            [self.array addObject:_model.title];
            
        }
        
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        NSLog(@"eerrore = %@",error);
        
    }];
    
}
- (void)textFieldDidBeginEditing:(UITextField *)textField{
    if (textField.tag == 101) {
        [self.perfessionView.name resignFirstResponder];
        PickerChoiceView *picker = [[PickerChoiceView alloc]initWithFrame:CGRectMake(0, 64, kWidth, kHeight-64)];
        picker.selectLb.text = @"年限";
        picker.delegate = self;
        picker.customArr = @[@"一年",@"二年",@"三年",@"四年",@"五年",@"六年",@"七年",@"八年",@"九年",@"十年",@"十年以上"];
        [self.view addSubview:picker];
    }

}
- (void)keyboardWillHide:(NSNotification *)aNotification
{
    [self.perfessionView.name resignFirstResponder];

}
- (void)textFieldDidEndEditing:(UITextField *)textField{
    if (textField.tag == 102) {
        [textField resignFirstResponder];

    }
}

#pragma mark -------- TFPickerDelegate

- (void)PickerSelectorIndixString:(NSString *)str{
    _yearView.name.text = [NSString stringWithFormat:@"%@年",str];
}
-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}

- (void)nextStepAction:(UIButton *)btn{
    [self.view endEditing:YES];
    NSUInteger index = self.yearView.name.text.length;
    NSString *string = [self.yearView.name.text substringToIndex:index-1];
    NSDictionary *topic = @{@"vocation":self.perfessionView.name.text,@"experience":string };
    [[HttpTool shareManager] POST:URL_USER_UPDATE parameters:topic success:^(NSURLSessionDataTask *task, id responseObject) {
        NSLog(@"修改资料 结果= %@",responseObject);
        NSNumber *code = responseObject[@"code"];
        if ([code isEqualToNumber:@200]) {
            MyTagViewController *detail = [[MyTagViewController alloc] init];
             detail.secondTitleArr = self.array;
            NSLog(@"标签 === %@",self.array);
            self.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:detail animated:YES];

        }else{

        }
       
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        
    }];

   }


@end
