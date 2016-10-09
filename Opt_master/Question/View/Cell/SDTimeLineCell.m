//
//  SDTimeLineCell.m
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

#import "SDTimeLineCell.h"
//#import "SDTimeLineCellModel.h"
#import "QuestionModel.h"
#import "UIView+SDAutoLayout.h"
#import "SDWeiXinPhotoContainerView.h"
#import "UIImageView+WebCache.h"
#import "CompareTime.h"

const CGFloat contentLabelFontSize = 15;
CGFloat maxContentLabelHeight = 0; // 根据具体font而定

@implementation SDTimeLineCell

{
    UIImageView *_iconView;
    UILabel *_nameLable;
    UILabel *_contentLabel;
    SDWeiXinPhotoContainerView *_picContainerView;
    UILabel *_timeLabel;
    UIButton *_moreButton;
    UIButton *_operationButton;
    BOOL _shouldOpenContentLabel;
}


- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self setup];
        self.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    return self;
}

- (void)setup
{

    
    _nameLable = [UILabel new];
    _nameLable.font = [UIFont systemFontOfSize:14];
    _nameLable.textColor = [UIColor colorWithRed:(54 / 255.0) green:(71 / 255.0) blue:(121 / 255.0) alpha:0.9];
    
    _contentLabel = [UILabel new];
    _contentLabel.font = [UIFont systemFontOfSize:contentLabelFontSize];
    _contentLabel.numberOfLines = 0;
    if (maxContentLabelHeight == 0) {
        maxContentLabelHeight = _contentLabel.font.lineHeight * 3;
    }
    
    _picContainerView = [SDWeiXinPhotoContainerView new];
    _timeLabel = [UILabel new];
    _timeLabel.font = [UIFont systemFontOfSize:13];
    _timeLabel.textColor = [UIColor lightGrayColor];
    
    
    NSArray *views = @[ _nameLable, _contentLabel, _picContainerView, _timeLabel,];
    
    [self.contentView sd_addSubviews:views];
    
    UIView *contentView = self.contentView;
    CGFloat margin = 10;
   

    
    _nameLable.sd_layout
    .leftSpaceToView(contentView, margin)
    .topSpaceToView(contentView, margin + 5)
    .heightIs(18);
    [_nameLable setSingleLineAutoResizeWithMaxWidth:200];
    
    _contentLabel.sd_layout
    .leftEqualToView(_nameLable)
    .topSpaceToView(_nameLable, margin)
    .rightSpaceToView(contentView, margin)
    .autoHeightRatio(0);
    

    
    _picContainerView.sd_layout
    .leftEqualToView(_contentLabel); // 已经在内部实现宽度和高度自适应所以不需要再设置宽度高度，top值是具体有无图片在setModel方法中设置
    
    _timeLabel.sd_layout
    .leftEqualToView(_contentLabel)
    .topSpaceToView(_picContainerView, margin)
    .heightIs(15)
    .widthIs(100);

    
   
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}


- (void)setModel:(QuestionModel *)model{
    _model = model;
    
    NSLog(@"tupian = %@",model.images);
    _nameLable.text = model.title;
    
    NSUserDefaults *user = [NSUserDefaults standardUserDefaults];
    NSString *baseUrl = [user objectForKey:@"baseUrl"];
    NSString *appName = [user objectForKey:@"appname"];
    NSString *headUrl =[NSString stringWithFormat:@"%@%@/%@",baseUrl,appName,model.author[@"avatar"]] ;
    
//    NSString *headUrl = [NSString stringWithFormat:@"%@/%@",BASE_URL_HEAD,model.author[@"avatar"]];
    [self.headImage sd_setImageWithURL:[NSURL URLWithString:headUrl] placeholderImage:[UIImage imageNamed:@"head"]];
    NSDate *currentTime = [NSDate dateWithTimeIntervalSince1970:[model.createdon intValue]];
    NSString *time2 = [CompareTime comparesCurrentTime:currentTime ];
    self.timeLabel.text = time2;
    
    self.tagLabel.text = model.tags;
    self.nameLabel.text = model.author[@"nickname"];
    
    self.numberLabel.text = model.replynum;
    NSArray *tags;
    if ( model.images.length == 0) {
        
    }else{
        tags = [ model.images componentsSeparatedByString:@","];
    }
    
    _picContainerView.picPathStringsArray = tags;
    
    CGFloat picContainerTopMargin = 0;
    if (tags.count) {
        picContainerTopMargin = 10;
    }
    
    _picContainerView.sd_layout.topSpaceToView(_questionLabel, picContainerTopMargin);
    
    [self setupAutoHeightWithBottomView:self.timeLabel bottomMargin:15];
    
}











@end
