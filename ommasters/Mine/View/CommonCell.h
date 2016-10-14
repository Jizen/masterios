//
//  CommonCell.h
//  Opt_master
//
//  Created by 瑞宁科技02 on 16/7/11.
//  Copyright © 2016年 reining. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MyQueationModel.h"
#import "QuestionModel.h"
@interface CommonCell : UITableViewCell


@property (nonatomic ,strong)QuestionModel *myQueationModel;
/**
 *  title
 */
@property (nonatomic ,strong)UILabel *leftlabel;

/**
 *  解决状态
 */
@property (nonatomic ,strong)UILabel *statusLabel;

/**
 *  时间
 */
@property (nonatomic ,strong)UILabel *timeLabel;



+ (instancetype)cellWithTableView:(UITableView *)tableView;
@end
