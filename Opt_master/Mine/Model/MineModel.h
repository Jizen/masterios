//
//  MineModel.h
//  Opt_master
//
//  Created by 瑞宁科技02 on 16/8/9.
//  Copyright © 2016年 reining. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "JSONModel.h"
@interface MineModel : JSONModel



/**
 *  头像
 */
@property (nonatomic ,copy)NSString *avatar;
/**
 *  性别
 */
@property (nonatomic ,copy)NSString *sex;
/**
 *  姓名
 */
@property (nonatomic ,copy)NSString *nickname;
/**
 *  职业
 */
@property (nonatomic ,copy)NSString *vocation;
/**
 *  从业经验
 */
@property (nonatomic ,copy)NSString *experience;


/**
 *  时间
 */
@property (nonatomic ,copy)NSString *tags;
@end
