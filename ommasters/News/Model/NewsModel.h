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

/**
 *  url
 */
@property (nonatomic ,copy)NSString *url;

@property (nonatomic ,copy)NSString *id;

@end
