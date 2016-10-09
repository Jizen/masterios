//
//  AnswerViewController.h
//  Opt_master
//
//  Created by 瑞宁科技02 on 16/7/7.
//  Copyright © 2016年 reining. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "QuestionModel.h"
typedef void(^passValueBlock)(NSString *replynum);

@interface AnswerViewController : UIViewController
@property (nonatomic ,copy)NSString *question;
@property (nonatomic ,assign)int page;
@property (nonatomic ,assign)int page1;

@property (nonatomic ,copy)NSString *itemID;
@property (nonatomic ,strong)QuestionModel *model;
@property(nonatomic ,copy)passValueBlock passValue;

@end
