//
//  QuestionModel.h
//  Opt_master
//
//  Created by 瑞宁科技02 on 16/8/8.
//  Copyright © 2016年 reining. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "JSONModel.h"
/**
 *   content = 23;
 createdby = 423;
 createdon = 223;
 id = 19;
 images = 234;
 replynum = 234;
 tags = 234;
 title = "\U4e3a\U70ed\U60c5";
 */
@interface QuestionModel : JSONModel


/**
 *  详情
 */
@property (nonatomic ,copy)NSString *content;

/**
 *  头像
 */
@property (nonatomic ,copy)NSString *images;


/**
 *  回答数
 */
@property (nonatomic ,copy)NSString *replynum;


/**
 *  创建者
 */
@property (nonatomic ,copy)NSString *createdby;




/**
 *  title
 */
@property (nonatomic ,copy)NSString *title;


/**
 *  时间
 */
@property (nonatomic ,copy)NSString *createdon;


/**
 *  标签
 */
@property (nonatomic ,copy)NSString *tags;

/**
 *  ID
 */
@property (nonatomic ,copy)NSString * id;

@property (nonatomic ,strong)NSDictionary *author;

@end
