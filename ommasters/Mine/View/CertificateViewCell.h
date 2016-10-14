//
//  CertificateViewCell.h
//  Opt_master
//
//  Created by 瑞宁科技02 on 16/9/20.
//  Copyright © 2016年 reining. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CertificateViewCell : UITableViewCell
@property (nonatomic ,strong)UITextField *nameTextfield;
@property (nonatomic ,strong)UILabel *nameLabel;

+ (instancetype)cellWithTableView:(UITableView *)tableView;
@end
