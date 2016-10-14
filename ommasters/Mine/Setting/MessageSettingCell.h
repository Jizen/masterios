//
//  MessageSettingCell.h
//  Opt_master
//
//  Created by 瑞宁科技02 on 16/7/19.
//  Copyright © 2016年 reining. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MessageSettingCell : UITableViewCell
/**
 *  故障信息
 */
@property (nonatomic ,strong)UILabel *alertLabel;


/**
 *  故障信息
 */
@property (nonatomic ,strong)UILabel *messageLabel;

/**
 *  开关
 */
@property (nonatomic ,strong)UISwitch *mySwitch;
+ (instancetype)cellWithTableView:(UITableView *)tableView;
@end
