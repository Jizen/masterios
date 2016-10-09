//
//  NewsModel.h
//  Opt_master
//
//  Created by 瑞宁科技02 on 16/8/5.
//  Copyright © 2016年 reining. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "JSONModel.h"
@interface NewsModel : JSONModel
/*
content = "http://36kr.com/p/5050635.html";
cover = "https://pic.36krcnd.com/avatar/201608/05031143/hx8qhufm9giyg5x0.jpg!feature";
createdby = 34234;
createdon = 342;
id = 2;
readnum = 31642;
source = "36\U6c2a";
summary = "\U636e\U56fd\U5916\U79d1\U6280\U5a92\U4f53 Edsurge \U6d88\U606f\Uff0c\U65e5\U524d\U51fa\U7248\U5de8\U5934\U57f9\U751f\U96c6\U56e2\U4f5c\U51fa\U4e86\U6362\U5e05\U7684\U52a8\U4f5c\Uff1a\U516c\U53f8\U5ba3\U5e03\Uff0cKevin Capitani \U5c06\U63a5\U66ff\U539f\U6765\U7684 Don Kilburn \U6210\U4e3a\U65b0\U4e00\U4efb\U7684\U57f9\U751f\U5317\U7f8e\U5927\U533a\U7684\U603b\U88c1\U3002";
tags = wer;
title = "\U6536\U76ca\U4e0d\U8fbe\U9884\U671f\Uff0c\U6362\U5e05\U80fd\U6539\U53d8\U57f9\U751f\U7684\U547d\U8fd0\U5417\Uff1f";
url = "http://36kr.com/p/5050635.html";
 */

/**
*  详情
*/
@property (nonatomic ,copy)NSString *content;

/**
 *  配图
 */
@property (nonatomic ,copy)NSString *cover;


/**
 *  阅读量
 */
@property (nonatomic ,copy)NSString *readnum;


/**
 *  source
 */
@property (nonatomic ,copy)NSString *source;

/**
 *  摘要
 */
@property (nonatomic ,copy)NSString *summary;


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

@property (nonatomic ,copy)NSString *id;
// <Optional>

@end
