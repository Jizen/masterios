//
//  AnswerModel.h
//  Opt_master
//
//  Created by 瑞宁科技02 on 16/7/14.
//  Copyright © 2016年 reining. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AnswerModel.h"
#import "JSONModel.h"
@interface AnswerModel : JSONModel
/**
 content = 14;
 createdby = 14;
 createdon = 14;
 id = 14;
 topicid = 14;
 */


/**
 *  详情
 */
@property (nonatomic ,copy)NSString *content;

/**
 *  创建者
 */
@property (nonatomic ,copy)NSString *createdby;


/**
 *  创建时间
 */
@property (nonatomic ,copy)NSString *createdon;


/**
 *  id
 */
@property (nonatomic ,copy)NSString *id;



/**
 *  问题id
 */
@property (nonatomic ,copy)NSString *topicid;
@property (nonatomic ,strong)NSDictionary *author;

//
//
///**
// *  故障状态
// */
//@property (nonatomic ,strong)UIImageView *headImage;
//
///**
// *  故障信息
// */
//@property (nonatomic ,strong)UILabel *nameLabel;
//
///**
// *  故障信息
// */
//@property (nonatomic ,copy)NSString *contentLabel;
//
//
///**
// *  故障信息
// */
//@property (nonatomic ,strong)UILabel *timeLabel;

//数据模型
//@property (nonatomic,strong) AnswerModel *homeModel;

//我们最后得到cell的高度的方法
-(CGFloat)rowHeightWithCellModel:(AnswerModel *)homeModel;

@end
