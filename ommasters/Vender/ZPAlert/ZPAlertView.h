//
//  ViewController.m
//  ZPTest
//
//  Created by 张平 on 15/10/29.
//  Copyright © 2015年 zhangping. All rights reserved.
//


//【功能描述】loading 页面
//[ZPAlertView showAlertTitle:@"你的标题" andMsg:@"您确定要退订此消息" cancelButtonTitle:@"取消" otherButtonTitles:@"确定" andBlock:^(NSInteger index,id contxt){
//     if (index == 1) {///确定的tag 值
//      ///做你想做的事
//      }
// }];


#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "ZPTextField.h"
#import "GCDiscreetNotificationView.h"

typedef void(^AlertViewBlock) (NSInteger index,id contxt);

@interface ZPAlertView : NSObject

@property (nonatomic, copy) AlertViewBlock Alertblock;

// ADlertView  单利形式

+(id)showAlertTitle:(NSString*)title andMsg:(NSString*)msg cancelButtonTitle:(NSString *)cancelButtonTitle otherButtonTitles:(NSString *)otherButtonTitles andBlock:(AlertViewBlock)block;

@end

@interface AlertView : UIAlertView
@property (nonatomic ,strong)UITextField *textField;
@end