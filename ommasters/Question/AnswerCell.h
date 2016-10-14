//
//  AnswerCell.h
//  Opt_master
//
//  Created by 瑞宁科技02 on 16/7/14.
//  Copyright © 2016年 reining. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AnswerModel.h"
@interface AnswerCell : UITableViewCell
/**
 *  头像
 */
@property (nonatomic ,strong)UIImageView *headImage;

/**
 *  姓名
 */
@property (nonatomic ,strong)UILabel *nameLabel;

/**
 *  回答内容
 */
@property (nonatomic ,strong)UILabel *contentLabel;

/**
 *  时间
 */
@property (nonatomic ,strong)UILabel *timeLabel;

@property (nonatomic ,strong)UIView *bottomLine;

+ (instancetype)cellWithTableView:(UITableView *)tableView;


@property (nonatomic, strong, readwrite) NSMutableAttributedString *changeLineSpaceString;

@property (nonatomic ,strong)AnswerModel *model;

+ (CGFloat)cellForHeightWithModel:(AnswerModel *)model;
+ (CGFloat)cellForHeight;

@end
