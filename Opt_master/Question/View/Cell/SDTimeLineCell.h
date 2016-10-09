//
//  SDTimeLineCell.h
//  GSD_WeiXin(wechat)
//
//  Created by gsd on 16/2/25.
//  Copyright © 2016年 GSD. All rights reserved.
//

/*
 
 *********************************************************************************
 *
 * GSD_WeiXin
 *
 * QQ交流群: 362419100(2群) 459274049（1群已满）
 * Email : gsdios@126.com
 * GitHub: https://github.com/gsdios/GSD_WeiXin
 * 新浪微博:GSD_iOS
 *
 * 此“高仿微信”用到了很高效方便的自动布局库SDAutoLayout（一行代码搞定自动布局）
 * SDAutoLayout地址：https://github.com/gsdios/SDAutoLayout
 * SDAutoLayout视频教程：http://www.letv.com/ptv/vplay/24038772.html
 * SDAutoLayout用法示例：https://github.com/gsdios/SDAutoLayout/blob/master/README.md
 *
 *********************************************************************************
 
 */

#import <UIKit/UIKit.h>
#import "SDWeiXinPhotoContainerView.h"
@protocol SDTimeLineCellDelegate <NSObject>

- (void)didClickLikeButtonInCell:(UITableViewCell *)cell;
- (void)didClickcCommentButtonInCell:(UITableViewCell *)cell;

@end

@class QuestionModel;

@interface SDTimeLineCell : UITableViewCell

@property (nonatomic, weak) id<SDTimeLineCellDelegate> delegate;

@property (nonatomic, strong) QuestionModel *model;

@property (nonatomic, strong) NSIndexPath *indexPath;

@property (nonatomic, copy) void (^moreButtonClickedBlock)(NSIndexPath *indexPath);

@property (nonatomic, copy) void (^didClickCommentLabelBlock)(NSString *commentId, CGRect rectInWindow, NSIndexPath *indexPath);



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
@end
