//
//  CertificateImageViewCell.h
//  Opt_master
//
//  Created by 瑞宁科技02 on 16/9/20.
//  Copyright © 2016年 reining. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CertificateImageViewCell : UITableViewCell
@property (nonatomic ,strong)UIImageView *leftImage;
@property (nonatomic ,strong)UIImageView *rightImage;


+ (instancetype)cellWithTableView:(UITableView *)tableView;
@end
