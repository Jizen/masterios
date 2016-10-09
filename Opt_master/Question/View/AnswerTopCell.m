//
//  AnswerTopCell.m
//  Opt_master
//
//  Created by 瑞宁科技02 on 16/8/19.
//  Copyright © 2016年 reining. All rights reserved.
//

#import "AnswerTopCell.h"
#import "LSCoreToolCenter.h"
#import "CalculateHeight.h"
#import "UILabel+extension.h"
#import "CompareTime.h"
static CGFloat cellHeight;

@implementation AnswerTopCell

+ (instancetype)cellWithTableView:(UITableView *)tableView
{
    static NSString *identifier = @"AnswerTopCell";
    // 1.缓存中取
    AnswerTopCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    // 2.创建
    if (!cell) {
        cell = [[AnswerTopCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
//    cell.
    return cell;
}

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        // 添加子控件
        [self setUpSubViews];
        // 添加约束
        [self addConstraint];
    }
    return self;
}
- (void)setUpSubViews{
    [self.contentView  addSubview:self.questionTitleLabel];
    [self.contentView  addSubview:self.questionContentLabel];
    [self.contentView  addSubview:self.picContainerView];
    [self.contentView  addSubview:self.timeLabel];
    [self.contentView  addSubview:self.number];
    [self.contentView  addSubview:self.sepLine];
    [self.contentView  addSubview:self.tagImage];
    [self.contentView  addSubview:self.tagLabel];
    [self.contentView  addSubview:self.bottomView];
    
}

- (void)addConstraint{

    _questionTitleLabel.sd_layout
    .leftSpaceToView(self.contentView,DEFUALT_MARGIN_SIDES)
    .topSpaceToView(self.contentView,DEFUALT_MARGIN_SIDES)
    .rightSpaceToView(self.contentView ,DEFUALT_MARGIN_SIDES)
    .autoHeightRatio(0);
    
    _questionContentLabel.sd_layout
    .leftSpaceToView(self.contentView,DEFUALT_MARGIN_SIDES)
    .topSpaceToView(_questionTitleLabel,DEFUALT_MARGIN_SIDES)
    .rightSpaceToView(self.contentView ,DEFUALT_MARGIN_SIDES)
    .autoHeightRatio(0);
    
    
    _picContainerView.sd_layout
    .leftEqualToView(_questionContentLabel); // 已经在内部实现宽度和高度自适应所以不需要再设置宽度高度，top值是具体有无图片在setModel方法中设置

    _timeLabel.sd_layout
    .leftEqualToView(self.questionContentLabel)
    .topSpaceToView(_picContainerView, DEFUALT_MARGIN_SIDES)
    .heightIs(15);
    [self.timeLabel setSingleLineAutoResizeWithMaxWidth:[UIScreen mainScreen].bounds.size.width];
    

    _number.sd_layout
    .rightSpaceToView(self.contentView,DEFUALT_MARGIN_SIDES)
    .topEqualToView(_timeLabel)
    .leftSpaceToView(self.contentView,DEFUALT_MARGIN_SIDES)
    .heightIs(15);
    
    _sepLine.sd_layout
    .topSpaceToView(_timeLabel,DEFUALT_MARGIN_SIDES)
    .leftSpaceToView(self.contentView,DEFUALT_MARGIN_SIDES)
    .rightSpaceToView(self.contentView,DEFUALT_MARGIN_SIDES)
    .heightIs(0.5);
    
    _tagImage.sd_layout
    .topSpaceToView(_sepLine,DEFUALT_MARGIN_SIDES)
    .leftSpaceToView(self.contentView,DEFUALT_MARGIN_SIDES)
    .widthIs(12)
    .heightIs(12);
    
    _tagLabel.sd_layout
    .topSpaceToView(_sepLine,DEFUALT_MARGIN_SIDES)
    .leftSpaceToView(_tagImage,DEFUALT_MARGIN_SIDES)
    .rightSpaceToView(self.contentView,DEFUALT_MARGIN_SIDES)
    .heightIs(12);
    
    


}

- (void)setModel:(QuestionModel *)model{
    _model = model;
    self.questionTitleLabel.text = [NSString stringWithFormat:@"%@：%@",@"问",model.title];
    
    NSMutableAttributedString *attributedString1 = [[NSMutableAttributedString alloc] initWithString:self.questionTitleLabel.text]; // 改变特定范围颜色大小要用的
    
    NSRange r = NSMakeRange(0, 1);
    NSMutableParagraphStyle *paragraphStyle1 = [[NSMutableParagraphStyle alloc] init];
    [paragraphStyle1 setLineSpacing:4];
    [attributedString1 addAttribute:NSParagraphStyleAttributeName value:paragraphStyle1 range:NSMakeRange(0, [model.title length])];
    self.questionTitleLabel.isAttributedContent = YES;
    [self.questionTitleLabel sizeToFit];
    [attributedString1 addAttribute:NSForegroundColorAttributeName value:PRIMARY_COLOR range:r];
    [self.questionTitleLabel setAttributedText:attributedString1];
    
    
    self.questionContentLabel.text = model.content;
    self.questionContentLabel.numberOfLines = 0;

    // 设置label的行间距
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:model.content];
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    [paragraphStyle setLineSpacing:4];
    [attributedString addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, [model.content length])];
    self.questionContentLabel.isAttributedContent = YES;
    [self.questionContentLabel setAttributedText:attributedString];
    [self.questionContentLabel sizeToFit];
    

    NSDate *currentTime = [NSDate dateWithTimeIntervalSince1970:[model.createdon intValue]];
    NSString *time2 = [CompareTime comparesCurrentTime:currentTime ];
    self.timeLabel.text = time2;
    
    self.tagLabel.text = model.tags;
    self.number.text = [NSString stringWithFormat:@"%@人回答",model.replynum];
    
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
    
    self.picContainerView.sd_layout.topSpaceToView(_questionContentLabel, picContainerTopMargin);
    
    [self setupAutoHeightWithBottomView:self.tagLabel bottomMargin:15];

    
}

- (SDWeiXinPhotoContainerView *)picContainerView{
    if (!_picContainerView) {
        _picContainerView = [[SDWeiXinPhotoContainerView alloc] init];
    }
    return _picContainerView;
}
- (UILabel *)question{
    if (!_question) {
        _question = [[UILabel alloc] init];
        _question.text = @"问:";
        _question.textColor = PRIMARY_COLOR;
    }
    return _question;
}
- (UILabel *)questionTitleLabel{
    if (!_questionTitleLabel) {
        _questionTitleLabel =[[UILabel alloc] init];
        _questionTitleLabel.font = GZFontWithSize(16);
        _questionTitleLabel.textColor = TXT_MAIN_COLOR;
        _questionTitleLabel.numberOfLines = 2;
    }
    return _questionTitleLabel;
}

- (UILabel *)questionContentLabel{
    if (!_questionContentLabel) {
        _questionContentLabel =[[UILabel alloc] init];
        _questionContentLabel.textColor = TXT_MAIN_COLOR;
        _questionContentLabel.font = GZFontWithSize(15);
        _questionContentLabel.numberOfLines = 0;
    }
    return _questionContentLabel;
}

- (UILabel *)timeLabel{
    if (!_timeLabel) {
        _timeLabel =[[UILabel alloc] init];
        _timeLabel.textColor = TXT_COLOR;
        _timeLabel.font = GZFontWithSize(12);
        _timeLabel.textAlignment = NSTextAlignmentLeft;
    }
    return _timeLabel;
}
-(UIView *)sepLine{
    if (!_sepLine) {
        _sepLine =[[UIView alloc] init];
        _sepLine.backgroundColor = SEPARATOR_LINE_COLOR;
    }
    return _sepLine;
}
-(UIImageView *)tagImage{
    if (!_tagImage) {
        _tagImage = [[UIImageView alloc] init];
        _tagImage.image =[ UIImage imageNamed:@"tag-three"];
    }
    return _tagImage;
}

- (UILabel *)tagLabel{
    if (!_tagLabel) {
        _tagLabel = [[UILabel alloc] init];
        _tagLabel.textColor = TXT_COLOR;
        _tagLabel.font = GZFontWithSize(12);
    }
    return _tagLabel;
}

- (UILabel *)number{
    if (!_number) {
        _number = [[UILabel alloc] init];
        _number.textColor = TXT_COLOR;
        _number.font = GZFontWithSize(12);
        _number.textAlignment = NSTextAlignmentRight;
    }
    return _number;
}

- (UIView *)bottomView{
    if (!_bottomView) {
        _bottomView = [[UIView alloc] init];
        _bottomView.backgroundColor = BG;
    }
    return _bottomView;
}

@end
