//
//  AreaSelectViewController.m
//  AreaSelect
//
//  Created by xhw on 16/3/16.
//  Copyright © 2016年 xhw. All rights reserved.
//

#import "AreaSelectViewController.h"
#import "AreaSelectView.h"
#import "JobViewController.h"
#import "AppDelegate.h"
@interface AreaSelectViewController()

@property (nonatomic,strong)AreaSelectView *areaSelectView;

@end

@implementation AreaSelectViewController
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.navigationController.navigationBarHidden = YES;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    [self createNavBar];

    self.areaSelectView = [[AreaSelectView alloc] initWithFrame:CGRectMake(0, 64, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height - TOP_OFFSET)];
    self.areaSelectView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:self.areaSelectView ];
    
    if(self.selectedCityBlock)
    {
        self.areaSelectView.selectedCityBlock = self.selectedCityBlock;
    }

    
}

-(void)createNavBar{
    
    UIView *navBar = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kWidth, 64)];
    navBar.backgroundColor = Navigation_COLOR;
    [self.view addSubview:navBar];
    
    UILabel *titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(kWidth/2-100, 30, 200, 20)];
    titleLabel.textAlignment = NSTextAlignmentCenter;
    titleLabel.text = @"城市选择";
    titleLabel.textColor = [UIColor blackColor];
    [navBar addSubview:titleLabel];
    
    UIButton *backBtn1 = [UIButton buttonWithType:UIButtonTypeSystem];
    backBtn1.frame = CGRectMake(kWidth - 60, 20, 60, 44);
    [backBtn1 setTitleColor:PRIMARY_COLOR forState:UIControlStateNormal];
    [backBtn1 setTitle:@"进入" forState:UIControlStateNormal];
    backBtn1.titleLabel.font = GZFontWithSize(18);
    [backBtn1 addTarget:self action:@selector(answerForQuestion) forControlEvents:UIControlEventTouchUpInside];
    [navBar addSubview:backBtn1];
}
- (void)CancelAnswerForQuestion{
    [self.navigationController popViewControllerAnimated:YES];
}
- (void)answerForQuestion{
    AppDelegate *appdelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
    [appdelegate isLaunchedWithIndex:1];

}
- (void)backViewAction{
    [self.navigationController popViewControllerAnimated:YES];
}
@end
