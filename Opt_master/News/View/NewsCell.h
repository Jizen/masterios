//
//  NewsCell.h
//  Opt_master
//
//  Created by 瑞宁科技02 on 16/7/7.
//  Copyright © 2016年 reining. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NewsModel.h"
#import "CompareTime.h"
@interface NewsCell : UITableViewCell

@property (nonatomic ,strong)  CompareTime *compareTool;

/**
 *  头像
 */
@property (nonatomic ,strong)UIImageView *headImage;

/**
 *  姓名
 */
@property (nonatomic ,strong)UILabel *nameLabel;

/**
 *  时间
 */
@property (nonatomic ,strong)UILabel *timeLabel;

/**
 *  资讯标题
 */
@property (nonatomic ,strong)UILabel *titleLabel;


@property (nonatomic ,strong)UILabel *testLabel;

/**
 *  资讯标题
 */
@property (nonatomic ,strong)UILabel *contentLabel;


/**
 *  配图
 */
@property (nonatomic ,strong)UIImageView *picImage;

/**
 *  来源
 */
@property (nonatomic ,strong)UILabel *originLabel;


/**
 *  浏览量
 */
@property (nonatomic ,strong)UILabel *browseLabel;

/**
 *  浏览眼
 */
@property (nonatomic ,strong)UIImageView *browseImage;

/**
 *  标签图片
 */
@property (nonatomic ,strong)UIImageView *tagImage;

/**
 *  tag标签
 */
@property (nonatomic ,strong)UILabel *tagLabel;



@property (nonatomic ,strong)NewsModel *model;


+ (instancetype)cellWithTableView:(UITableView *)tableView;
@end
