//
//  NameViewController.h
//  cts
//
//  Created by 瑞宁科技02 on 15/11/3.
//  Copyright © 2015年 reining. All rights reserved.
//

#import <UIKit/UIKit.h>

// 1
typedef void(^passValueBlock)(NSString *name);

// first ： 协议
@protocol NameViewControllerDelegate <NSObject>

-(void)PassValueWithString:(NSString *)aString;

@end
@interface NameViewController : UIViewController
//  second ：声明代理
@property(nonatomic ,assign)id<NameViewControllerDelegate>delegate;

@property(nonatomic ,copy)NSString *name;

@property(nonatomic ,copy)NSString *headUrl;

@property(nonatomic ,strong)NSNumber *sexNum;
// 2
@property(nonatomic ,copy)passValueBlock passValue;

@property (nonatomic ,copy)NSString *titleStr;
@property (nonatomic ,copy)NSString *leftStr;

@end
