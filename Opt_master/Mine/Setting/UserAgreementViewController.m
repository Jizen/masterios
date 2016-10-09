//
//  UserAgreementViewController.m
//  cts
//
//  Created by 牛清旭 on 15/11/2.
//  Copyright © 2015年 reining. All rights reserved.
//

#import "UserAgreementViewController.h"

@interface UserAgreementViewController ()<UIWebViewDelegate>
@property (nonatomic ,strong)UILabel *protocolLabel;
@property (nonatomic ,strong)UIWebView *webview;
@property (nonatomic ,strong)UIWebView *myWebView;
@property (nonatomic ,strong)MBProgressHUD *hud;
@property(nonatomic,copy)NSString *webUrl;

@end

@implementation UserAgreementViewController
#pragma mark - basic
- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    [self createNavBar];
    [self setupView];
    [self setupProgressHud];
}
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.navigationController.navigationBarHidden = YES;
}
#pragma mark - UI
-(void)createNavBar{
    UIView *navBar = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kWidth, 64)];
    navBar.backgroundColor = Navigation_COLOR;
    [self.view addSubview:navBar];
    
    UILabel *titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(kWidth/2-70, 30, 140, 20)];
    titleLabel.textAlignment = NSTextAlignmentCenter;
    titleLabel.text = @"关于云维专家";
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

- (void)setupProgressHud
{
    self.hud = [[MBProgressHUD alloc] initWithView:self.view] ;
    self.hud.label.text = @"正在加载...";
    _hud.frame = self.view.bounds;
    _hud.minSize = CGSizeMake(100, 100);
    _hud.mode = MBProgressHUDModeIndeterminate;
    [self.view addSubview:_hud];
    [_hud showAnimated:YES];
}
- (void)setupView{
    self.webview = [[UIWebView alloc] initWithFrame:CGRectMake(0, 64, self.view.frame.size.width, self.view.frame.size.height-64)];
    NSURLRequest *request =[NSURLRequest requestWithURL:[NSURL URLWithString:@"http://www.baidu.com"]];
    [self.view addSubview: _webview];
    self.webview.delegate = self;
    [_webview loadRequest:request];
    
}

#pragma mark - delegate
- (void)webViewDidFinishLoad:(UIWebView *)webView{
    
    [_hud removeFromSuperview];
    
}

-(void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response{
    NSURL *url = [NSURL URLWithString:@"https://123.56.75.224:8000/license"];
    NSHTTPURLResponse *httpResponse = (NSHTTPURLResponse *)response;
    if ((([httpResponse statusCode]/100) == 2)) {
        // self.earthquakeData = [NSMutableData data];
        [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
        
        [ _webview loadRequest:[ NSURLRequest requestWithURL: url]];
        _webview.delegate = self;
    } else {
        NSDictionary *userInfo = [NSDictionary dictionaryWithObject:
                                  NSLocalizedString(@"HTTP Error",
                                                    @"Error message displayed when receving a connection error.")
                                                             forKey:NSLocalizedDescriptionKey];
        NSError *error = [NSError errorWithDomain:@"HTTP" code:[httpResponse statusCode] userInfo:userInfo];
        
        if ([error code] == 404) {
            [_hud removeFromSuperview];
        }
        
    }
}
#pragma mark - action
- (void)leftAction{
    [self.navigationController popViewControllerAnimated:YES];
}
@end
