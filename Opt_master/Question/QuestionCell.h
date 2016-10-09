//
//  QuestionCell.h
//  Opt_master
//
//  Created by 瑞宁科技02 on 16/7/11.
//  Copyright © 2016年 reining. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "QuestionModel.h"
#import "SDWeiXinPhotoContainerView.h"

//图片点击
@protocol ImageDelegate <NSObject>

-(void)checkImage:(NSString*)imgname;

@end
@interface QuestionCell : UITableViewCell

@property (weak, nonatomic) id<ImageDelegate>myDelegate;

@property (nonatomic ,strong)QuestionModel *model;


@property (nonatomic ,strong)UIView *views;


/**
 *  问题
 */
@property (nonatomic ,strong)UILabel *questionLabel;

/**
 *  标签图片
 */
@property (nonatomic ,strong)UIImageView *tagImage;

/**
 *  标签
 */
@property (nonatomic ,strong)UILabel *tagLabel;

/**
 *  时间
 */
@property (nonatomic ,strong)UILabel *timeLabel;

/**
 *  分割线
 */
@property (nonatomic ,strong)UIView *sepLine;

/**
 *  头像
 */
@property (nonatomic ,strong)UIImageView *headImage;

/**
 *  昵称
 */
@property (nonatomic ,strong)UILabel *nameLabel;

/**
 *  回答图片
 */
@property (nonatomic ,strong)UIImageView *answerImage;

/**
 *  回答个数
 */
@property (nonatomic ,strong)UILabel *numberLabel;

/**
 *  竖线
 */

@property (nonatomic ,strong)UIView *verticalLine;

/**
 *  竖线
 */

@property (nonatomic ,strong)UIView *verticalLineOne;
/**
 *  回答按钮
 */
@property (nonatomic ,strong)UIButton *answerBtn;


@property (nonatomic ,strong)UIView *backView;

@property (nonatomic ,strong)UIImageView *picture;
@property (nonatomic ,strong)SDWeiXinPhotoContainerView *picContainerView;


+ (instancetype)cellWithTableView:(UITableView *)tableView;

@end
