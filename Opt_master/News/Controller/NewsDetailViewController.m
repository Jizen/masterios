//
//  NewsDetailViewController.m
//  Opt_master
//
//  Created by 瑞宁科技02 on 16/7/7.
//  Copyright © 2016年 reining. All rights reserved.
//

#import "NewsDetailViewController.h"
#import <WebKit/WebKit.h>
#import "NJKWebViewProgress.h"
#import "NJKWebViewProgressView.h"
@interface NewsDetailViewController ()<UIWebViewDelegate,WKNavigationDelegate,NJKWebViewProgressDelegate>
{
    NJKWebViewProgressView *_webViewProgressView;
    NJKWebViewProgress *_webViewProgress;
}
@property (nonatomic,strong) WKWebView *webView;


@property (nonatomic, strong) UIProgressView *progressView;
@property (nonatomic, assign) NSUInteger loadCount;
@property (nonatomic ,strong) UIButton *backBtn1;
@property (nonatomic ,strong) UIButton *shareBtn;
@end

@implementation NewsDetailViewController
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.navigationController.navigationBarHidden = YES;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"资讯详情";
    self.view.backgroundColor = [UIColor whiteColor];

    [self createNavBar];
//    [self statusShow];
    
    NSLog(@"iiiii = %d",self.iscollect);
    self.backBtn1.selected = self.iscollect;

    WKWebView *webView = [[WKWebView alloc] initWithFrame:CGRectMake(0, 64, kWidth, kHeight)];
    webView.navigationDelegate = self;
    [webView loadRequest:[NSURLRequest requestWithURL:
                          [NSURL URLWithString:self.url]]];
    
    [webView setAllowsBackForwardNavigationGestures:true];
    [self.view addSubview:webView];

    
    // 发送请求
    NSURL *url = [NSURL URLWithString:self.url];
    // 请求
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    
    // 发送异步请求
    [NSURLConnection sendAsynchronousRequest:request queue:[NSOperationQueue currentQueue] completionHandler:^(NSURLResponse * _Nullable response, NSData * _Nullable data, NSError * _Nullable connectionError) {

        if (!connectionError) {
            [self.webView loadRequest:request];
        }else{
            NSLog(@"连接错误%@",connectionError);
        }
    }];
    
    self.progressView = [[UIProgressView alloc] init];
    self.progressView.frame =CGRectMake(0,65,kWidth,30);
    self.progressView.tintColor = PRIMARY_COLOR;
    [self.view addSubview:self.progressView];
    
    //通过监听estimatedProgress可以获取它的加载进度 还可以监听它的title ,URL, loading
    [self.webView addObserver:self forKeyPath:@"estimatedProgress" options:NSKeyValueObservingOptionNew context:nil];


}

-(void)createNavBar{
    
    UIView *navBar = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kWidth, 64)];
    navBar.backgroundColor = Navigation_COLOR;
    [self.view addSubview:navBar];
    
    UIBlurEffect *effect = [UIBlurEffect effectWithStyle:UIBlurEffectStyleDark];
    UIVisualEffectView *effectView = [[UIVisualEffectView alloc] initWithEffect:effect];
    [navBar addSubview:effectView];
    
    UILabel *titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(kWidth/2-50, 30, 100, 20)];
    titleLabel.textAlignment = NSTextAlignmentCenter;
    titleLabel.text = @"资讯详情";
    titleLabel.textColor = [UIColor blackColor];
    [navBar addSubview:titleLabel];
    
    UIButton *backBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    backBtn.frame = CGRectMake(0, 20, 60, 44);
    [backBtn setImageEdgeInsets:UIEdgeInsetsMake(0, 0, 0, 10)];
    [backBtn setTitleColor:PRIMARY_COLOR forState:UIControlStateNormal];
    [backBtn setImage:[UIImage imageNamed:@"return"] forState:(UIControlStateNormal)];
    [backBtn addTarget:self action:@selector(leftAction) forControlEvents:UIControlEventTouchUpInside];
    [navBar addSubview:backBtn];
    
    self.backBtn1 = [UIButton buttonWithType:UIButtonTypeCustom];
    self.backBtn1.frame = CGRectMake(kWidth - 50, 20, 50, 44);
    [self.backBtn1 setTitleColor:PRIMARY_COLOR forState:UIControlStateNormal];
    [self.backBtn1 setImage:[UIImage imageNamed:@"collect-h"] forState:(UIControlStateSelected)];
    [self.backBtn1 setImage:[UIImage imageNamed:@"collection"] forState:(UIControlStateNormal)];
    
    [self.backBtn1 addTarget:self action:@selector(answerForQuestion:) forControlEvents:UIControlEventTouchUpInside];
    [navBar addSubview:self.backBtn1];
    
    
    self.shareBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    self.shareBtn.frame = CGRectMake(kWidth - 100, 20, 60, 44);
    [self.shareBtn setTitle:@"分享" forState:(UIControlStateNormal)];
    [self.shareBtn setTitleColor:PRIMARY_COLOR forState:UIControlStateNormal];
    [self.shareBtn setImage:[UIImage imageNamed:@"collect-h"] forState:(UIControlStateSelected)];
    [self.shareBtn setImage:[UIImage imageNamed:@"collection"] forState:(UIControlStateNormal)];
    
    [self.shareBtn addTarget:self action:@selector(shareBtnAction:) forControlEvents:UIControlEventTouchUpInside];
    [navBar addSubview:self.shareBtn];
    
    UIView *line = [[UIView alloc] initWithFrame:CGRectMake(0, 63.5, kWidth, 0.5)];
    line.backgroundColor = SEPARATOR_LINE_COLOR;
    [navBar addSubview:line];
}

- (void)leftAction{
    [self.navigationController popViewControllerAnimated:YES];
}
- (void)shareBtnAction:(UIButton *)btn{
    
}
- (void)answerForQuestion:(UIButton *)button{
    button.selected = !button.selected;
    if (button.selected == YES) {
        [self hudWithTitle:@"收藏成功"];
    }else{
        [self hudWithTitle:@"取消收藏"];
    }
    NSString *url = [NSString stringWithFormat:@"%@=%@",URL_NEWS_STATE_CHANGE,self.itemId];
    
    [[HttpTool shareManager] GET:url parameters:nil success:^(NSURLSessionDataTask *task, id responseObject) {
        NSLog(@"responseObject = %@",responseObject);
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        NSLog(@"error = %@",error);
    }];
}

- (void)statusShow{
    
    ///favorite/show
    NSString *url = [NSString stringWithFormat:@"%@=%@",URL_NEWS_STATE_SHOW,self.itemId];
    
    [[HttpTool shareManager] GET:url parameters:nil success:^(NSURLSessionDataTask *task, id responseObject) {
        NSLog(@"responseObject === %@",responseObject);
        NSNumber *code = responseObject[@"code"];
        NSLog(@"cccc = %@",code);
        if ([code isEqualToNumber:@403]) {
            self.backBtn1.selected = YES;
        }
        
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        NSLog(@"erro r = %@",error);
    }];
    
}
- (void)hudWithTitle:(NSString *)title
{
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
    hud.mode = MBProgressHUDModeText;
    hud.label.text = title;
    [hud hideAnimated:YES afterDelay:1.f];
}



- (void)webViewDidFinishLoad:(UIWebView *)webView
{
    
    
    [[NSUserDefaults standardUserDefaults] setInteger:0 forKey:@"WebKitCacheModelPreferenceKey"];
    [[NSUserDefaults standardUserDefaults] setBool:NO forKey:@"WebKitDiskImageCacheEnabled"];//自己添加的，原文没有提到。
    [[NSUserDefaults standardUserDefaults] setBool:NO forKey:@"WebKitOfflineWebApplicationCacheEnabled"];//自己添加的，原文没有提到。
    [[NSUserDefaults standardUserDefaults] synchronize];
}
#pragma mark - Delegate
-(void)webViewProgress:(NJKWebViewProgress *)webViewProgress updateProgress:(float)progress
{
    [_webViewProgressView setProgress:progress animated:YES];

}


- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context {
    
    if ([keyPath isEqualToString:@"loading"]) {
        
    } else if ([keyPath isEqualToString:@"title"]) {
        self.title = self.webView.title;
    } else if ([keyPath isEqualToString:@"URL"]) {
        
    } else if ([keyPath isEqualToString:@"estimatedProgress"]) {
        
        self.progressView.progress = self.webView.estimatedProgress;
    }
    
    if (object == self.webView && [keyPath isEqualToString:@"estimatedProgress"]) {
        CGFloat newprogress = [[change objectForKey:NSKeyValueChangeNewKey] doubleValue];
        if (newprogress == 1) {
            self.progressView.hidden = YES;
            [self.progressView setProgress:0 animated:NO];
        }else {
            self.progressView.hidden = NO;
            [self.progressView setProgress:newprogress animated:YES];
        }
    }
}

- (void)setLoadCount:(NSUInteger)loadCount {
    _loadCount = loadCount;
    
    if (loadCount == 0) {
        self.progressView.hidden = YES;
        [self.progressView setProgress:0 animated:NO];
    }else {
        self.progressView.hidden = NO;
        CGFloat oldP = self.progressView.progress;
        CGFloat newP = (1.0 - oldP) / (loadCount + 1) + oldP;
        if (newP > 0.95) {
            newP = 0.95;
        }
        [self.progressView setProgress:newP animated:YES];
        
    }
}
// 页面开始加载时调用
- (void)webView:(WKWebView *)webView didStartProvisionalNavigation:(WKNavigation *)navigation {
    self.loadCount ++;
}
// 内容返回时
- (void)webView:(WKWebView *)webView didCommitNavigation:(WKNavigation *)navigation {
    self.loadCount --;
}
//失败
- (void)webView:(WKWebView *)webView didFailNavigation: (null_unspecified WKNavigation *)navigation withError:(NSError *)error {
    self.loadCount --;
    NSLog(@"%@",error);
}
@end
