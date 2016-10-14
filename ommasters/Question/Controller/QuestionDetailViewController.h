//
//  QuestionDetailViewController.h
//  Opt_master
//
//  Created by 瑞宁科技02 on 16/7/7.
//  Copyright © 2016年 reining. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ViewController.h"
#import "QuestionModel.h"
@interface QuestionDetailViewController : ViewController
@property (nonatomic ,strong)UIButton *answerBtn;
@property (nonatomic ,assign)CGFloat bottomViewH;
@property (nonatomic ,assign)int page;

// topicID 
@property (nonatomic ,copy)NSString *itemID;

@property (nonatomic ,strong)QuestionModel *model;
@end
