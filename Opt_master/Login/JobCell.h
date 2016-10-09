//
//  JobCell.h
//  Opt_master
//
//  Created by 瑞宁科技02 on 16/7/21.
//  Copyright © 2016年 reining. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface JobCell : UITableViewCell
/**
 *  头像
 */
@property (nonatomic ,strong)UIImageView *headImage;


/**
 *  职业
 */
@property (nonatomic ,strong)UILabel *jobLabel;

/**
 *  年份图片
 */
@property (nonatomic ,strong)UIImageView *yearImage;

/**
 *  年份
 */
@property (nonatomic ,strong)UILabel *yearLabel;


+ (instancetype)cellWithTableView:(UITableView *)tableView;
@end
