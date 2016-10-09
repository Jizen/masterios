//
//  MineViewCell.h
//  Opt_master
//
//  Created by 瑞宁科技02 on 16/7/7.
//  Copyright © 2016年 reining. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CertModel.h"
@interface MineViewCell : UITableViewCell
@property (nonatomic ,strong)CertModel *certModel;

/**
 *  左侧图片
 */
@property (nonatomic ,strong)UIImageView *statusImage;

/**
 *  左侧文字
 */
@property (nonatomic ,strong)UILabel *messageLabel;

/**
 *  右侧文字
 */
@property (nonatomic ,strong)UILabel *stateLabel;
+ (instancetype)cellWithTableView:(UITableView *)tableView;
@end
