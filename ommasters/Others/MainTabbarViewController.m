//
//  MainTabbarViewController.m
//  Opt_master
//
//  Created by 瑞宁科技02 on 16/7/7.
//  Copyright © 2016年 reining. All rights reserved.
//

#import "MainTabbarViewController.h"
#import "NewsViewController.h"
#import "MineViewController.h"
#import "QuestionController.h"
@interface MainTabbarViewController ()

@end

@implementation MainTabbarViewController

- (void)viewDidLoad {
    
    [super viewDidLoad];
    [self tabBarViewController];
    self.tabBar.translucent = NO;
}
- (void)tabBarViewController{
    
    NewsViewController *new =[[NewsViewController alloc] init];
    [self setupChildVC: new title:@"资讯" image:@"information" selectedImage:@"information-h"];
    [new.loactionBtn setTitle:self.city forState:(UIControlStateNormal)];
    
    [self setupChildVC: [[QuestionController alloc] init] title:@"问答" image:@"question-1" selectedImage:@"question-h-0"];
    [self setupChildVC: [[MineViewController alloc] init] title:@"我的" image:@"mine" selectedImage:@"mine-h"];

}

- (void)setupChildVC:(UIViewController *)vc title:(NSString *)title image:(NSString *)image selectedImage:(NSString *)selectedImage
{
    // 包装一个导航控制器
    UINavigationController *nav  = [[UINavigationController alloc] initWithRootViewController:vc];
    vc.title = title;
    [self addChildViewController:nav ];

    NSMutableDictionary *textArrays = [NSMutableDictionary dictionary];
    textArrays[NSForegroundColorAttributeName] = PRIMARY_COLOR;
    [nav.tabBarItem setTitleTextAttributes:textArrays forState:UIControlStateNormal];

    nav.tabBarItem.title         = title;
    nav.tabBarItem.image         = [[UIImage imageNamed:image] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    nav.tabBarController.tabBar.tintColor = PRIMARY_COLOR;
    nav.tabBarItem.selectedImage = [[UIImage imageNamed:selectedImage] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
}





@end
