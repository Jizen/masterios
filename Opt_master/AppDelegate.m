//
//  AppDelegate.m
//  Opt_master
//
//  Created by 瑞宁科技02 on 16/7/7.
//  Copyright © 2016年 reining. All rights reserved.
//

#import "AppDelegate.h"
#import "MainTabbarViewController.h"
#import "LoginViewController.h"
#import "SCGuideViewController.h"
#import "NewsViewController.h"
#import "AreaModel.h"
#import "DBUtil.h"
#import "IanAdsStartView.h"
#import "IANWebViewController.h"
#import "JWLaunchAd.h"
#import "LBLaunchImageAdView.h"
#import "UMMobClick/MobClick.h"
//#import "UMMob"
#define DEFAULT_CITY @"北京市"
#define BUNDLE_IDENTIFIER [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleIdentifier"]
static AppDelegate *_appDelegate;
#define mainScreenSize [[UIScreen mainScreen] currentMode].size

@interface AppDelegate ()<CLLocationManagerDelegate,UIAlertViewDelegate>
@property (strong, nonatomic) UIImageView *splashView;
@property (nonatomic ,strong)AreaModel *locationModel;
@property (nonatomic ,strong)CLLocation *loc;
@property (nonatomic ,strong)CLLocation *currLocationl;

// 地理位置解码编码器
@property (nonatomic ,strong) CLGeocoder *geo;

@property (nonatomic ,copy) NSString *locationCity;
@property (nonatomic ,strong)UILabel *lebal;
@property (nonatomic ,copy)NSString *messge;
@property (nonatomic ,copy)NSString *imageurl;
@property (nonatomic ,copy)NSString *redirecturl;

@end

@implementation AppDelegate
//com.facebook.Facebook   com.reining.Opt-master
- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    
    [self.window makeKeyAndVisible];
    
    [[HttpTool shareManager] GET:URL_AD parameters:nil success:^(NSURLSessionDataTask *task, id responseObject) {
        NSDictionary *data=responseObject[@"data"];
        self.redirecturl = data[@"redirecturl"];
        self.imageurl = data[@"imageurl"];
        
        NSUserDefaults *u = [NSUserDefaults standardUserDefaults];
        [u setObject:data[@"imageurl"] forKey:@"imageurl"];
        if ([responseObject[@"code"] isEqualToNumber:@200]) {
            
        }
        
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        
    }];

    [self setNavigation];
    [self isFirst];
    [self showad];
    [self allowLocation];
    [self addLuanchImage];

    [MobClick setLogEnabled:YES];  // 打开友盟sdk调试，注意Release发布时需要注释掉此行,减少io消耗
    [MobClick setAppVersion:XcodeAppVersion]; //参数为NSString * 类型,自定义app版本信息，如果不设置，默认从CFBundleVersion里取

    
    UMConfigInstance.appKey = @"57f9a972e0f55abc5000201a";
    UMConfigInstance.channelId = @"App Store";
    [MobClick startWithConfigure:UMConfigInstance];//配置以上参数后调用此方法初始化SDK！
    [MobClick profileSignInWithPUID:@"playerID"];
    [MobClick setEncryptEnabled:YES];
    return YES;
}


- (void)showad{
    
    NSUserDefaults *user = [NSUserDefaults standardUserDefaults];
    NSString *ss = [user objectForKey:@"imageurl"];
    NSString *userDefaultKey = @"download_key";
    if ([[[NSUserDefaults standardUserDefaults] stringForKey:userDefaultKey] isEqualToString:@"1"]) {
        IanAdsStartView *startView = [IanAdsStartView startAdsViewWithBgImageUrl:ss withClickImageAction:^{

            
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:self.redirecturl]];
            
            [[HttpTool shareManager]POST:@"advertisement/addcount?id=1" parameters:nil success:^(NSURLSessionDataTask *task, id responseObject) {
                
            } failure:^(NSURLSessionDataTask *task, NSError *error) {
                
            }];

        }];
        
        [startView startAnimationTime:4 WithCompletionBlock:^(IanAdsStartView *startView){
            NSLog(@"广告结束后，执行事件");
        }];
    } else { // 第一次先下载广告
        [IanAdsStartView downloadStartImage:ss];
        
        [[NSUserDefaults standardUserDefaults] setValue:@"1" forKey:userDefaultKey];
        [[NSUserDefaults standardUserDefaults] synchronize];
    }
    
}
- (void)addLaunchAD{
    NSUserDefaults *user = [NSUserDefaults standardUserDefaults];
    NSString *ss = [user objectForKey:@"imageurl"];
    [self loadImageWithURL:ss];
    
}

- (void)loadImageWithURL:(NSString *)url{
    //初始化启动页广告(初始化后,自动添加至视图,不用手动添加)
    JWLaunchAd *launchAd = [JWLaunchAd initImageWithURL:CGRectMake(0, 0,self.window.bounds.size.width, self.window.bounds.size.height) strUrl:url adDuration:4.0 options:JWWebImageDefault result:^(UIImage *image, NSURL *url) {
        
    }];
    
    //是否隐藏跳过按钮（默认显示）
    launchAd.hideSkip = NO;
    //广告点击事件
    launchAd.clickBlock = ^(){
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:self.redirecturl]];
        
        [[HttpTool shareManager]POST:@"advertisement/addcount?id=1" parameters:nil success:^(NSURLSessionDataTask *task, id responseObject) {
            
        } failure:^(NSURLSessionDataTask *task, NSError *error) {
            
        }];
    };

}

- (void)checkVersion{
    NSString *strUrl = [NSString stringWithFormat:@"%@",URL_VERSION];
    [[HttpTool shareManager] GET:strUrl parameters:nil success:^(NSURLSessionDataTask *task, id responseObject) {
        NSDictionary *data = responseObject[@"data"];
        self.messge = data[@"description"];
        NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
        [userDefault setObject:data[@"updateurl"] forKey:@"updateurl"];
        NSArray *versionArray =[CURRENT_VERSION componentsSeparatedByString:@"."];
        NSString *cureentVersion = [versionArray componentsJoinedByString:@""];
        int version = [data[@"version"] intValue];
        if (version < [cureentVersion intValue]) {
        }else{
            if ([data[@"isforced"] isEqualToNumber:@1]) {
                UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"提示" message:self.messge delegate:self cancelButtonTitle:nil otherButtonTitles:@"更新",nil];
                alertView.tag = 300;
                [alertView show];
            }else{
                [NSTimer scheduledTimerWithTimeInterval:4 target:self selector:@selector(show) userInfo:nil repeats:NO];
            }
        };
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
    }];
    
}
- (void)show{
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"提示" message:self.messge delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"更新",nil];
    alertView.tag = 301;

    [alertView show];
}


- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (alertView.tag == 301) {

        if (buttonIndex == 0) {
            
        } else {
            [self openAPPStore];
        }
    }
    if (alertView.tag == 300) {
        if (buttonIndex == 0) {
            [self openAPPStore];
        }
    }
}

- (void)openAPPStore {
    NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
    NSString *url = [userDefault objectForKey:@"updateurl"];
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:url]];
    
}

// 导航栏样式
- (void)setNavigation
{
    UINavigationBar *appearance                      = [UINavigationBar appearance];
    appearance.barTintColor                          = UIColorARGB(1, 252, 252, 252);
    appearance.translucent                           = YES;
    appearance.frame = CGRectMake(0, 0, 0, 0);
    [appearance setTintColor:PRIMARY_COLOR];
    [appearance setTitleTextAttributes:
     @{NSFontAttributeName:[UIFont systemFontOfSize:18],
       NSForegroundColorAttributeName:[UIColor blackColor]}];
    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleLightContent;
    
}

+ (AppDelegate *)appDelegate {
    return _appDelegate;
}
// 是否是第一次登陆
- (void)isFirst{
    //判断是否登陆，由登陆状态判断启动页面
    //获取UserDefault
    NSUserDefaults *userDefault     = [NSUserDefaults standardUserDefaults];
    NSString *name                  = [userDefault objectForKey:@"name"];
    //如果用户未登陆则把根视图控制器改变成登陆视图控制器
    if (name.length == 0) {

        
        NSUserDefaults* defs1 = [NSUserDefaults standardUserDefaults];
        int aa=[[defs1 objectForKey:@"ishelp"] intValue];
        if (aa!=5) {
            [defs1 setObject:@"5" forKey:@"ishelp"];
            
            LoginViewController *loginVC    = [[LoginViewController alloc] init];
            
            UINavigationController *loginNC = [[UINavigationController alloc] initWithRootViewController:loginVC];
            // 这个是初始化 是加入引导页
            self.window.rootViewController  = [[SCGuideViewController alloc] initWithViewController:loginNC];

        }else{
            

            LoginViewController *loginVC    = [[LoginViewController alloc] init];
            
            UINavigationController *loginNC = [[UINavigationController alloc] initWithRootViewController:loginVC];
            // 这个是初始化 是加入引导页
            self.window.rootViewController  = loginNC;
            
            
        }
        
    }else{

        [self isLaunchedWithIndex:0];
    }
    
}
// 允许获取自身位置
-(void)allowLocation
{
    self.locationManager = [[CLLocationManager alloc] init];
    
    if ([[UIDevice currentDevice].systemVersion floatValue] >= 8.0) {
        
        [self.locationManager requestWhenInUseAuthorization];
    }
}

-(void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray<CLLocation *> *)locations{
    
    // 1.既然已经定位到了用户当前的经纬度了,那么可以让定位管理器 停止定位了
    [self.locationManager stopUpdatingLocation];
    // 2.然后,取出第一个位置,根据其经纬度,通过CLGeocoder反向解析,获得该位置所在的城市名称,转成城市对象,用工具保存
    self.loc = [locations firstObject];
    _currLocationl = [locations lastObject];
    
    // 3.CLGeocoder反向通过经纬度,获得城市名
    // 获取当前所在的城市名
    CLGeocoder *geocoder = [[CLGeocoder alloc] init];
    //根据经纬度反向地理编译出地址信息
    [geocoder reverseGeocodeLocation:self.loc completionHandler:^(NSArray *array, NSError *error){
        if (array.count > 0){
            CLPlacemark *placemark = [array objectAtIndex:0];
            //将获得的所有信息显示到label上
            self.locationCity = [NSString stringWithFormat:@"%@",placemark.locality];
            self.locationModel = [DBUtil getCityWithName:self.locationCity];
            
            self.lebal.text= [NSString stringWithFormat:@"当前定位城市:%@",self.locationCity];
            
            self.locationModel = [DBUtil getCityWithName:DEFAULT_CITY];
            
            
        }
    }];
}

- (void)isLaunchedWithIndex:(long)viewControllerIndex
{
    for (UIView *view in self.window.subviews) {
        [view removeFromSuperview];
    }
    
    MainTabbarViewController *tabbarController = [[MainTabbarViewController alloc] init];
    tabbarController.selectedIndex       = 0;
    self.window.rootViewController       = tabbarController;
}
// 启动页动画效果
- (void)addLuanchImage{
    // 192.168.0.98
    self.splashView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, kWidth, kHeight)];
    _splashView.image = [UIImage imageNamed:@"启动页白色.png"];
    
    [self.window addSubview:_splashView];
    [self.window bringSubviewToFront:_splashView];
    
    
    
    
    [self performSelector:@selector(showWord) withObject:nil afterDelay:0];
    
    [self performSelector:@selector(showCompany) withObject:nil afterDelay:0];
    

}



-(void)showWord
{
    
    UILabel  *label = [[UILabel alloc]initWithFrame:CGRectMake(0, 350, 300, 29)];
    label.centerX = kWidth/2;
    label.textColor = [UIColor whiteColor];
    label.text = @"连接IT运维知识与价值";
    label.textAlignment = NSTextAlignmentCenter;
    label.font = GZFontWithSize(25);
    [_splashView addSubview:label];
    label.alpha = 0.0;
    
    [UIView animateWithDuration:0.5 delay:0.0f options:UIViewAnimationOptionCurveLinear
                     animations:^
     {
         label.alpha = 1.0;
         label.frame = CGRectMake(0, 300, 300, 29);
         label.centerX = kWidth/2;
         
     }
                     completion:^(BOOL finished)
     {
         // 完成后执行code
         [NSThread sleepForTimeInterval:1.0f];
         [_splashView removeFromSuperview];
     }
     ];
}

-(void)showCompany
{
    
    UILabel  *label = [[UILabel alloc]init];
    label.textColor = [UIColor whiteColor];
    label.text = @"Copyright © 2016 Yunwei Master";
    label.textAlignment = NSTextAlignmentCenter;
    label.font = GZFontWithSize(12);
    [_splashView addSubview:label];
    label.sd_layout
    .bottomSpaceToView(_splashView,DEFUALT_MARGIN_SIDES)
    .centerXEqualToView(_splashView)
    .widthIs(300)
    .heightIs(20);
    
    label.alpha = 0.0;
    [UIView animateWithDuration:0 delay:0.0f options:UIViewAnimationOptionCurveLinear
                     animations:^
     {
         label.alpha = 1.0;
         
     }
                     completion:^(BOOL finished)
     {
         // 完成后执行code
         [NSThread sleepForTimeInterval:1.0f];
         [_splashView removeFromSuperview];
     }
     ];
}


- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.


}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
//    [self showad];
    [self checkVersion];


}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}



@end
