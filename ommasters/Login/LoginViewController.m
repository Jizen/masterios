//
//  LoginViewController.m
//  Opt_master
//
//  Created by 瑞宁科技02 on 16/7/7.
//  Copyright © 2016年 reining. All rights reserved.
//

#import "LoginViewController.h"
#import "LoginView.h"
#import "AppDelegate.h"
#import "RegistViewController.h"
#import "RegEx.h"
#import "RKAlertView.h"
#import "ZPAlertView.h"

@interface LoginViewController ()<UIScrollViewDelegate,UITextFieldDelegate>
@property (nonatomic ,strong) LoginView               *loginView;
@property (strong, nonatomic) UINavigationController *mainNavigationController;
@property (strong, nonatomic) UIWindow *window;
@property (nonatomic ,strong)RKAlertView *RkalertView;
@property (nonatomic ,strong) UIActivityIndicatorView *activityView;
@property (nonatomic ,copy) NSString *mybaseurl;
@end

@implementation LoginViewController


#pragma mark - basic
-(void)loadView{
    self.loginView = [[LoginView alloc] initWithFrame:CGRectMake(0, 64, kWidth, kHeight)];
    self.view      = _loginView;
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.navigationController.navigationBarHidden = YES;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationController.interactivePopGestureRecognizer.delegate =  self;
    self.view.backgroundColor = [UIColor whiteColor];
    [self addAction];
    [self createNavBar];
    self.loginView.name.rightTextField.delegate = self;
    self.loginView.password.rightTextField.delegate = self;
    self.loginView.password.rightTextField.secureTextEntry = YES;
    self.loginView.name.rightTextField.keyboardType = UIKeyboardTypeNumberPad;
    
    UITapGestureRecognizer *tapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(keyboardHide:)];
    //设置成NO表示当前控件响应后会传播到其他控件上，默认为YES。
    tapGestureRecognizer.cancelsTouchesInView = NO;
    //将触摸事件添加到当前view
    [self.view addGestureRecognizer:tapGestureRecognizer];
    
    UITapGestureRecognizer *doubleTapGestureRecognizer = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(doubleTap:)];
    [doubleTapGestureRecognizer setNumberOfTapsRequired:2];
    [self.loginView.logoImage addGestureRecognizer:doubleTapGestureRecognizer];
    
}

// 双击logo 显示设置服务器地址
- (void)doubleTap:(UIGestureRecognizer*)gestureRecognizer
{
    
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"提示" message:@"设置服务端地址" preferredStyle:UIAlertControllerStyleAlert];
    //添加普通输入框
    [alert addTextFieldWithConfigurationHandler:^(UITextField * _Nonnull textField) {
        
        NSString *myurl = [[NSUserDefaults standardUserDefaults] objectForKey:@"mybaseurl"];
        if (myurl.length == 0) {
            textField.text = BASE_URL;
        }else{
            textField.text = myurl;
        }
        textField.clearButtonMode = UITextFieldViewModeAlways;
    }];
    
    //添加取消按钮 UIAlertActionStyleCancel - 文字是蓝色的 只能使用一次
    [alert addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {}]];
    //添加确定按钮 UIAlertActionStyleDefault - 文字是蓝色的 可以添加多个
    [alert addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            NSUserDefaults *user = [NSUserDefaults standardUserDefaults];
            NSString *url = alert.textFields.firstObject.text;


            self.mybaseurl = url;
            [user setValue:url forKey:@"baseUrl"];
            [user setValue:self.mybaseurl forKey:@"mybaseurl"];

            [user synchronize];



    }]];
    [self presentViewController:alert animated:YES completion:nil];
    

}

-(void)keyboardHide:(UITapGestureRecognizer*)tap{
    [self.loginView.name.rightTextField resignFirstResponder];
    [self.loginView.password.rightTextField resignFirstResponder];

}

#pragma mark - UI
-(void)createNavBar{
    UIView *navBar = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kWidth, 64)];
    navBar.backgroundColor = Navigation_COLOR;
    [self.view addSubview:navBar];
    
    UILabel *titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(kWidth/2-50, 30, 100, 20)];
    titleLabel.textAlignment = NSTextAlignmentCenter;
    titleLabel.text = @"登录";
    titleLabel.textColor = [UIColor blackColor];
    [navBar addSubview:titleLabel];
    
    UIView *line = [[UIView alloc] initWithFrame:CGRectMake(0, 63.5, kWidth, 0.5)];
    line.backgroundColor = SEPARATOR_LINE_COLOR;
    [navBar addSubview:line];
}
- (void)addAction{
    [self.loginView.loginbtn addTarget:self action:@selector(loginAction:) forControlEvents:(UIControlEventTouchUpInside)];
    [self.loginView.registBtn addTarget:self action:@selector(registBtnAction:) forControlEvents:(UIControlEventTouchUpInside)];
}
#pragma mark - action
- (void)loginAction:(UIButton *)btn{
    
    
    self.loginView.loginbtn.enabled = NO;
    if (!self.activityView) {
        self.activityView = [[UIActivityIndicatorView alloc]initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
        self.activityView.center = self.view.center;
        [self.view addSubview:self.activityView];
    }
    [self.activityView startAnimating];
    
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    //登陆成功后把用户名和密码存储到UserDefaul
    [userDefaults setObject:self.loginView.name.rightTextField.text forKey:@"name"];
    [userDefaults setObject:self.loginView.password.rightTextField.text forKey:@"password"];
    [userDefaults synchronize];
    //表单提交前的验证
    BOOL isMatch = [RegEx checkTelNumber:self.loginView.name.rightTextField.text];
    if (([self.loginView.name.rightTextField.text  isEqualToString:@""])||([self.loginView.password.rightTextField.text isEqualToString:@""]) ) {
        [self hudWithTitle:@"账号和密码不能为空"];
        return;
    }else if(!isMatch){
        [self hudWithTitle:@"手机号码错误"];
    }else{
        
        NSString *url = [NSString stringWithFormat:@"%@?mobile=%@&password=%@",URL_LOGIN,_loginView.name.rightTextField.text,_loginView.password.rightTextField.text];
        
        [[HttpTool shareManager] POST:url parameters:nil success:^(NSURLSessionDataTask *task, id responseObject) {
            
            NSNumber *code = responseObject[@"code"];
            if ([code isEqualToNumber:@200]) {
                
                NSDictionary *data = responseObject[@"data"];
                NSUserDefaults *user = [NSUserDefaults standardUserDefaults];
                NSString *userid = data[@"id"];
                NSString *avatar = data[@"avatar"];
                NSString *nickname = data[@"nickname"];
                NSString *experience = [NSString stringWithFormat:@"%@",data[@"experience"]] ;
                NSString *vocation = data[@"vocation"];
                NSString *tags = data[@"tags"];
                NSString *authimages = data[@"authimages"];
                NSString *mobile = data[@"mobile"];
                NSString *verifiedon = data[@"verifiedon"];
                NSString *status = data[@"status"];

                
                [user setValue:userid forKey:@"userid"];
                [user setValue:avatar forKey:@"avatar"];
                [user setValue:nickname forKey:@"nickname"];
                [user setValue:experience forKey:@"experience"];
                [user setValue:tags forKey:@"tags"];
                [user setValue:vocation forKey:@"vocation"];
                [user setValue:authimages forKey:@"authimages"];
                [user setValue:mobile forKey:@"mobile"];
                [user setValue:verifiedon forKey:@"verifiedon"];
                [user setValue:status forKey:@"status"];

                NSString *str = [NSString stringWithFormat:@"%@",userid];
                [user setValue:@"7E72FB27FC800C6E906557BAEE4ED1DC" forKey:@"secretKey"];
                [user setValue:str forKey:@"userid"];
                [user synchronize];
                AppDelegate *appdelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
                [appdelegate isLaunchedWithIndex:1];
                
                [self.activityView stopAnimating];

            }else{
                [self hudWithTitle:@"账号密码不正确"];
            }

        } failure:^(NSURLSessionDataTask *task, NSError *error) {
            
            [self hudWithTitle:@"未能连接到服务器"];
            [self.activityView stopAnimating];


        }];
    }
}
- (void)registBtnAction:(UIButton *)btn{
    RegistViewController *registVC = [[RegistViewController alloc] init];
    [self.navigationController pushViewController:registVC animated:YES];
}

#pragma mark - delegate
-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}

#pragma mark - public
- (void)hudWithTitle:(NSString *)title
{
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
    hud.mode = MBProgressHUDModeText;
    hud.label.text = title;
    [hud hideAnimated:YES afterDelay:1.f];
}
- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer {

    return NO;
}


@end
