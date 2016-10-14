//
//  NewsDetailViewController.h
//  Opt_master
//
//  Created by 瑞宁科技02 on 16/7/7.
//  Copyright © 2016年 reining. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ViewController.h"
@interface NewsDetailViewController : ViewController
@property (nonatomic ,assign)int collect;

@property (nonatomic ,copy)NSString *url;
@property (nonatomic ,copy)NSString *itemId;
@property (nonatomic ,copy)NSString *sharetitle;
@property (nonatomic ,copy)NSString *picture;

@property (nonatomic ,assign)BOOL iscollect;
@end
