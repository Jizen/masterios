//
//  QuestionTopView.h
//  Opt_master
//
//  Created by 瑞宁科技02 on 16/7/14.
//  Copyright © 2016年 reining. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "QuestionModel.h"
@interface QuestionTopView : UIView
@property (nonatomic ,strong)QuestionModel *model;
+ (CGFloat)cellForHeight;

+ (CGFloat)cellForHeightWithModel:(QuestionModel *)model;
/**
 *  问
 */
@property (nonatomic ,strong)UILabel *question;
/**
 *  问题标题
 */
@property (nonatomic ,strong)UILabel *questionTitleLabel;

/**
 *  问题描述
 */
@property (nonatomic ,strong)UILabel *questionContentLabel;

/**
 *  时间
 */
@property (nonatomic ,strong)UILabel *timeLabel;

/**
 *  时间
 */
@property (nonatomic ,strong)UILabel *number;

/**
 *  分割线
 */
@property (nonatomic ,strong)UIView *sepLine;

/**
 *  标签图片
 */
@property (nonatomic ,strong)UIImageView *tagImage;

/**
 *  标签
 */
@property (nonatomic ,strong)UILabel *tagLabel;

@property (nonatomic ,strong)UIView *bottomView;

@property (nonatomic, strong, readwrite) NSMutableAttributedString *changeLineSpaceString;

@end
