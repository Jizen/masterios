//
//  LocationViewController.h
//  Opt_master
//
//  Created by 瑞宁科技02 on 16/7/27.
//  Copyright © 2016年 reining. All rights reserved.
//

#import "ViewController.h"
#import "AreaModel.h"

#define TOP_OFFSET ([[UIApplication sharedApplication] statusBarFrame].size.height + 44.0)
@interface LocationViewController : ViewController
@property (nonatomic, copy) void(^selectedCityBlock)(AreaModel *);

@end
