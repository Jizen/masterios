//
//  MineheaderViewCell.h
//  Opt_master
//
//  Created by 瑞宁科技02 on 16/7/11.
//  Copyright © 2016年 reining. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MineModel.h"
@interface MineheaderViewCell : UITableViewCell
/**
 *  头像
 */
@property (nonatomic ,strong)UIImageView *headImage;

/**
 *  姓名
 */
@property (nonatomic ,strong)UILabel *nameLabel;

/**
 *  故障信息
 */
@property (nonatomic ,strong)UILabel *messageLabel;

@property (nonatomic ,strong)MineModel *mineModel;
+ (instancetype)cellWithTableView:(UITableView *)tableView;
@end
