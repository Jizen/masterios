//
//  passwordViewController.m
//  cts
//
//  Created by 牛清旭 on 15/11/2.
//  Copyright © 2015年 reining. All rights reserved.
//

#import "passwordViewController.h"
#import "ModfiyPasswordView.h"
@interface passwordViewController ()<UITextFieldDelegate>
@property (nonatomic ,strong)UIButton *confirm;
@property (nonatomic ,strong)ModfiyPasswordView *oldPwd;
@property (nonatomic ,strong)ModfiyPasswordView *confirmNewPwd;
@property (nonatomic ,strong)ModfiyPasswordView *changePwd;
@end

@implementation passwordViewController

#pragma mark - basic
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.navigationController.navigationBarHidden = YES;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    [self createNavBar];
    self.view.backgroundColor = BG;
    [self setupView];
    
    UITapGestureRecognizer *tapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(keyboardHide:)];
    //设置成NO表示当前控件响应后会传播到其他控件上，默认为YES。
    tapGestureRecognizer.cancelsTouchesInView = NO;
    //将触摸事件添加到当前view
    [self.view addGestureRecognizer:tapGestureRecognizer];
    
}

-(void)keyboardHide:(UITapGestureRecognizer*)tap{
    [self.oldPwd.nameTextfield resignFirstResponder];
    [self.oldPwd.nameTextfield resignFirstResponder];
    [self.confirmNewPwd.nameTextfield resignFirstResponder];

}
#pragma mark - UI
- (void)setupView{
    self.oldPwd = [[ModfiyPasswordView alloc] initWithFrame:CGRectMake(0, DEFUALT_MARGIN_SIDES+64, kWidth, 45)];
    self.oldPwd.nameLabel.text = @"旧密码";
    self.changePwd = [[ModfiyPasswordView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(self.oldPwd.frame)+DEFUALT_MARGIN_SIDES, kWidth, 45)];
    self.changePwd.nameLabel.text = @"新密码";
    self.confirmNewPwd = [[ModfiyPasswordView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(self.changePwd.frame)+DEFUALT_MARGIN_SIDES, kWidth, 45)];
    self.confirmNewPwd.nameLabel.text = @"确认密码";
    self.oldPwd.nameTextfield.delegate = self;
    self.changePwd.nameTextfield.delegate = self;
    self.confirmNewPwd.nameTextfield.delegate = self;

    [self.view addSubview:self.oldPwd];
    [self.view addSubview:self.changePwd];
    [self.view addSubview:self.confirmNewPwd];
    [self.view addSubview:self.confirm];
    [self.confirm mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.confirmNewPwd.mas_bottom).with.offset(DEFUALT_MARGIN_SIDES);
        make.centerX.equalTo(self.view);
        make.left.equalTo(self.view).with.offset(3*DEFUALT_MARGIN_SIDES);
        make.right.equalTo(self.view).with.offset(-3*DEFUALT_MARGIN_SIDES);
        make.height.equalTo(@40);
        
    }];


}
-(void)createNavBar{
    UIView *navBar = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kWidth, 64)];
    navBar.backgroundColor = Navigation_COLOR;
    [self.view addSubview:navBar];
    
    UILabel *titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(kWidth/2-50, 30, 100, 20)];
    titleLabel.textAlignment = NSTextAlignmentCenter;
    titleLabel.text = @"密码设置";
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

#pragma mark --  Action
- (void)commitAction{
    [self.navigationController popViewControllerAnimated:YES];
    
    NSString *URL = [NSString stringWithFormat:@"/%@password?password=%@&newpassword=%@",URL_USER_CHANGEPWD,_oldPwd.nameTextfield.text,_changePwd.nameTextfield.text];
    
    
    [[HttpTool  shareManager] POST:URL parameters:nil success:^(NSURLSessionDataTask *task, id responseObject) {
        NSLog(@"11111111= %@",responseObject);

    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        NSLog(@"1222222= %@",error);

    }];

}
- (void)leftAction{
    [self.navigationController popViewControllerAnimated:YES];
}


#pragma mark - Delegate

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
    
}
- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar
{
    [searchBar setShowsCancelButton:NO animated:YES];
    [searchBar resignFirstResponder];
}
- (void)hudWithTitle:(NSString *)title
{
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
    hud.mode = MBProgressHUDModeText;
    hud.label.text = title;
    [hud hideAnimated:YES afterDelay:1.f];
}
#pragma mark - lazy
- (UIButton *)confirm{
    if (!_confirm) {
        _confirm = [UIButton buttonWithType:(UIButtonTypeCustom)];
        _confirm.backgroundColor = PRIMARY_COLOR;
        [_confirm setTitle:@"提交更改" forState:(UIControlStateNormal)];
        [_confirm addTarget:self action:@selector(commitAction) forControlEvents:(UIControlEventTouchUpInside)];
        _confirm.layer.cornerRadius = BTN_CORNER_RADIUS;
        _confirm.titleLabel.font = GZFontWithSize(18);
        _confirm.layer.masksToBounds = YES;
        [self.view addSubview:_confirm];
    }
    return _confirm;
}

@end
