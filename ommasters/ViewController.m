//
//  ViewController.m
//  Opt_master
//
//  Created by 瑞宁科技02 on 16/7/7.
//  Copyright © 2016年 reining. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()<UIGestureRecognizerDelegate>
@property (nonatomic ,strong)UIView *topView;

@end

@implementation ViewController
- (void)viewWillAppear:(BOOL)animated {
    
    [super viewWillAppear:YES];    
    self.navigationController.interactivePopGestureRecognizer.delegate =  self;


    
}
- (void)viewDidLoad {
    [super viewDidLoad];
    _topView = [[UIView alloc] initWithFrame:CGRectMake(0, -64, self.view.frame.size.width, 64)];
    _topView.backgroundColor = UIColorARGB(1, 252, 252, 252);
    [self.view addSubview:_topView];
    


}
// 26000+37950

- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer {
    if (self.navigationController.viewControllers.count <= 1 ) {
        return NO;
    }
    
    return YES;
}

@end
