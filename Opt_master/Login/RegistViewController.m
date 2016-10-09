//
//  RegistViewController.m
//  Opt_master
//
//  Created by 瑞宁科技02 on 16/7/7.
//  Copyright © 2016年 reining. All rights reserved.
//

#import "RegistViewController.h"
#import "RegistView.h"
#import "AppDelegate.h"
#import "MyTagViewController.h"
#import "JobViewController.h"
#import "JKCountDownButton.h"
#import "AreaSelectViewController.h"
#import "AreaSelectView.h"
#import "JobViewController.h"
#import "RegEx.h"
#import "IdenCodeViewController.h"

@interface RegistViewController ()<UITextFieldDelegate>
{
    
    IdenCodeViewController *codeVC;
}

@property (nonatomic ,strong)RegistView *registView;
@property (nonatomic ,strong)UIButton *vertify;

@end

@implementation RegistViewController
#pragma mark - basic
- (void)loadView{
    self.registView = [[RegistView alloc] initWithFrame:[UIScreen mainScreen].bounds];
    self.view      = _registView;
}
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.navigationController.navigationBarHidden = YES;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    [self addAction];
    [self createNavBar];
    codeVC = [[IdenCodeViewController alloc]init];
    
    self.registView.name.name.delegate = self;
    self.registView.password.name.delegate = self;
    self.registView.phone.name.delegate = self;
    self.registView.vertifyCode.name.delegate = self;
    UITapGestureRecognizer *tapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(keyboardHide:)];
    //设置成NO表示当前控件响应后会传播到其他控件上，默认为YES。
    tapGestureRecognizer.cancelsTouchesInView = NO;
    //将触摸事件添加到当前view
    [self.view addGestureRecognizer:tapGestureRecognizer];
}

-(void)keyboardHide:(UITapGestureRecognizer*)tap{
    [self.registView.name.name resignFirstResponder];
    [self.registView.password.name resignFirstResponder];
    [self.registView.phone.name resignFirstResponder];
    [self.registView.vertifyCode.name resignFirstResponder];

}
-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}
#pragma mark - UI
-(void)createNavBar{
    UIView *navBar = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kWidth, 64)];
    navBar.backgroundColor = Navigation_COLOR;
    [self.view addSubview:navBar];
    
    UILabel *titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(kWidth/2-50, 30, 100, 20)];
    titleLabel.textAlignment = NSTextAlignmentCenter;
    titleLabel.text = @"注册";
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


- (void)addAction{
    [self.registView addSubview:self.vertify];
    self.vertify.sd_layout
    .bottomSpaceToView(self.registView.phone,-25)
    .leftSpaceToView(self.registView.phone,0)
    .widthIs(90)
    .heightIs(30);
    
    UIView *line = [[UIView alloc] init];
    line.backgroundColor = SEPARATOR_LINE_COLOR;
    [self.registView.phone addSubview:line];
    line.sd_layout
    .bottomSpaceToView(self.registView.phone.line,5)
    .rightSpaceToView(self.vertify,0)
    .widthIs(0.5)
    .heightIs(25);
    
    UIView *line2 = [[UIView alloc] init];
    line2.backgroundColor = SEPARATOR_LINE_COLOR;
    [self.registView.phone addSubview:line2];
    line2.sd_layout
    .bottomEqualToView(self.registView.phone.line)
    .leftSpaceToView(self.registView.phone.line,0)
    .widthIs(90)
    .heightIs(0.55);
    
    self.registView.password.name.secureTextEntry = YES;
    
    [self.vertify setTitle:@"获取验证码" forState:(UIControlStateNormal)];
    [self.vertify addTarget:self action:@selector(sendCodeActionReg:) forControlEvents:(UIControlEventTouchUpInside)];
    [self.registView.registBtn addTarget:self action:@selector(loginAction:) forControlEvents:(UIControlEventTouchUpInside)];

}
#pragma mark - action
- (void)leftAction{
    [self.navigationController popViewControllerAnimated:YES];
}
-(void)sendCodeActionReg:(JKCountDownButton *)btn
{
    //表单提交前的验证
    BOOL isMatch = [RegEx checkTelNumber:self.registView.phone.name.text];
    if(!isMatch){
        [self hudWithTitle:@"手机号码错误"];
       
    }else{
        // /user/smscode
        NSString *url = [NSString stringWithFormat:@"/user/smscode/%@",self.registView.phone.name.text];
        [[HttpTool shareManager] GET:url parameters:nil success:^(NSURLSessionDataTask *task, id responseObject) {
            NSLog(@"判断手机号是否存在== %@",responseObject);
            NSNumber *code = responseObject[@"code"];
            if ([code isEqualToNumber:@403]) {
                [self hudWithTitle:@"该手机号已被注册！"];
            }else{
                [self sendingCodeWithBtn:btn];
            }

        } failure:^(NSURLSessionDataTask *task, NSError *error) {

        }];
    }
}
- (void)hudWithTitle:(NSString *)title
{
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
    hud.mode = MBProgressHUDModeText;
    hud.label.text = title;
    [hud hideAnimated:YES afterDelay:1.f];
}
#pragma mark - action
-(void)sendingCodeWithBtn:(JKCountDownButton *)sender
{
    sender.enabled = NO;
    [sender startWithSecond:60];
    sender.titleLabel.text = @"获取验证码";
    [sender setTitle:@"获取验证码" forState:(UIControlStateNormal)];
    [sender setTitleColor:[UIColor lightGrayColor] forState:(UIControlStateNormal)];
    NSString *url = [NSString stringWithFormat:@"/user/exist/mobile?mobile=%@",self.registView.phone.name.text];
    [[HttpTool shareManager] POST:url parameters:nil success:^(NSURLSessionDataTask *task, id responseObject) {
        
        NSNumber *code = responseObject[@"code"];
        if ([code isEqualToNumber:@403]) {
             [self hudWithTitle:@"该手机号已经注册！"];
        }else{
           
            
            [sender didChange:^NSString *(JKCountDownButton *countDownButton, int second) {
                NSString *title = [NSString stringWithFormat:@"%d秒后重发",second];
                return title;
            }];
            [sender didFinished:^NSString *(JKCountDownButton *countDownButton, int second) {
                countDownButton.enabled = YES;
                return @"点击重新获取";
            }];
            
            [codeVC identyCode];
            

        }
        
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        
    }];


}

- (void)loginAction:(UIButton *)btn{
    
    BOOL isMatch = [RegEx checkTelNumber:self.registView.phone.name.text];
    if (self.registView.name.name.text.length == 0 ) {
        [self hudWithTitle:@"昵称不能为空"];
    }else if ( self.registView.phone.name.text.length == 0 || !isMatch){
        [self hudWithTitle:@"请输入正确手机号"];
    }else if ( self.registView.vertifyCode.name.text.length == 0){
        [self hudWithTitle:@"请输入验证码"];

    }else if ( self.registView.password.name.text.length == 0 ){
        [self hudWithTitle:@"请输入密码"];
        
    }else{

        NSDictionary *json = @{@"mobile":_registView.phone.name.text,@"password":_registView.password.name.text};
        
        [[HttpTool shareManager] POST:URL_REGIST parameters:json success:^(NSURLSessionDataTask *task, id responseObject) {
            
            NSLog(@"%@",responseObject);
            JobViewController *detail = [[JobViewController alloc] init];
            detail.mobile = _registView.phone.name.text;
            self.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:detail animated:YES];
        } failure:^(NSURLSessionDataTask *task, NSError *error) {
            NSLog(@"error = %@",error);
        }];
        


    }


}

- (UIButton *)vertify{
    if (!_vertify) {
        _vertify = [JKCountDownButton buttonWithType:(UIButtonTypeCustom)];
        [_vertify setTitleColor:PRIMARY_COLOR forState:(UIControlStateNormal)];
        _vertify.titleLabel.textColor = PRIMARY_COLOR;
        _vertify.titleLabel.font = GZFontWithSize(14);
    }
    return _vertify;
}
@end
