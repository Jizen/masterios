//
//  MyQueationModel.h
//  Opt_master
//
//  Created by 瑞宁科技02 on 16/8/11.
//  Copyright © 2016年 reining. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "JSONModel.h"
@interface MyQueationModel : JSONModel
/**
 *   "id": 73,
 "title": "question1",
 "content": "啦；说的房间看到疯狂； 那时的风口浪尖啊多少分啊的时间浪费啦；是短发啊罗杰斯地方；阿三地方啊顺利健康地方了阿斯顿阿斯顿发交流；阿道夫阿萨德减肥啦分啊睡觉地方阿道夫家啊三大纪律发空间啊说的肌肤 啊说的房间。。。。",
 "images": "images",
 "tags": "测试标签",
 "replynum": 0,
 "createdon": 1470900409,
 "createdby": 1000006

 */

/**
 *  标题
 */
@property (nonatomic ,copy)NSString *title;






/**
 *  创建时
 */
@property (nonatomic ,copy)NSString *createdon;



/**
 *  id
 */
@property (nonatomic ,copy)NSString *id;


@end
