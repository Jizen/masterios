//
//  AppDelegate.h
//  Opt_master
//
//  Created by 瑞宁科技02 on 16/7/7.
//  Copyright © 2016年 reining. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreLocation/CoreLocation.h>

@interface AppDelegate : UIResponder <UIApplicationDelegate>
@property (strong, nonatomic) CLLocationManager     * locationManager;

@property (nonatomic ,copy)NSString *cityName;
@property (strong, nonatomic) UIWindow *window;
- (void)isLaunchedWithIndex:(long)viewControllerIndex;

+ (AppDelegate *)appDelegate;

@end

