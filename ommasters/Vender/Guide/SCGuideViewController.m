//
//  SCGuideViewController.m
//  SCGuide
//
//  Created by show class on 15/11/30.
//  Copyright © 2015年 show class. All rights reserved.
//

#import "SCGuideViewController.h"
#import "CALayer+Transition.h"
#import "UIView+Uitls.h"

@interface SCGuideViewController () <UIScrollViewDelegate>

@property (nonatomic, strong) UIScrollView *pageScroll;
@property (nonatomic, strong) UIViewController *con;

@end

@implementation SCGuideViewController

- (id)initWithViewController:(UIViewController *)controller
{
    if (self = [super init]) {
        _con = controller;
    }
    return self;
}

- (void)loadView
{
    [super loadView];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
//    NSArray *imageNameArray = [NSArray arrayWithObjects:@"guide_1", @"guide_2", @"guide_3",@"guide_4", nil];
    NSArray *imageNameArray = [NSArray arrayWithObjects:@"引导页01.png", @"引导页02.png", @"引导页03.png", nil];

    _pageScroll = [[UIScrollView alloc] initWithFrame:[UIScreen mainScreen].bounds];
    _pageScroll.bounces = NO;
    _pageScroll.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    _pageScroll.showsHorizontalScrollIndicator = NO;
    _pageScroll.delegate = self;
    _pageScroll.pagingEnabled = YES;
    _pageScroll.contentSize = CGSizeMake(self.view.frame.size.width * imageNameArray.count, self.view.frame.size.height);
    [self.view addSubview:_pageScroll];
    
    
    NSString *imageName = nil;
    for (int i = 0; i < imageNameArray.count; i++) {
        imageName = [imageNameArray objectAtIndex:i];
        UIImageView *imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:imageName]];
        imageView.frame = [UIScreen mainScreen].bounds;
        imageView.origin = CGPointMake(i * imageView.width, 0);
        imageView.contentMode = UIViewContentModeScaleToFill;
        imageView.userInteractionEnabled = YES;
        [self.pageScroll addSubview:imageView];
        
        UIButton *enterBtn = nil;
        if (i == imageNameArray.count - 1) {
            
            enterBtn = [[UIButton alloc] initWithFrame:(CGRect){
                .origin = {.x = (self.view.width - 447/2) / 2, .y = self.view.height - 70},
                .size = {.width = 447/2 , .height = 78/2}
            }];
//            enterBtn = [UIButton buttonWithType:(UIButtonType)];
//            [enterBtn setBackgroundImage:[UIImage imageNamed:@"sign-in"] forState:UIControlStateNormal];
//            [enterBtn setBackgroundImage:[UIImage imageNamed:@"sign-in"] forState:UIControlStateHighlighted];
            enterBtn.backgroundColor = PRIMARY_COLOR;
            enterBtn.layer.masksToBounds = YES;
            enterBtn.layer.cornerRadius = BTN_CORNER_RADIUS;
            [enterBtn setTitle:@"点击进入" forState:(UIControlStateNormal)];
            [enterBtn setTitleColor:[UIColor whiteColor] forState:(UIControlStateNormal)];
            [enterBtn addTarget:self action:@selector(enter) forControlEvents:UIControlEventTouchUpInside];
            [imageView addSubview:enterBtn];
        }
        
    }
    [_pageScroll setContentOffset:CGPointMake(0.f, 0.f)];
}

- (BOOL)prefersStatusBarHidden
{
    return YES; // 返回NO表示要显示，返回YES将hiden
}

- (void)enter
{
    [self transition:TransitionAnimTypeReveal];
}


- (void)transition:(TransitionAnimType)type
{
    [UIApplication sharedApplication].delegate.window.rootViewController = _con;
    [[UIApplication sharedApplication].delegate.window.layer transitionWithAnimType:type subType:TransitionSubtypesFromRight curve:TransitionCurveLinear duration:0.6f];
}

@end
