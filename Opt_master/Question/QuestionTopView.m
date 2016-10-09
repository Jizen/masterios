//
//  QuestionTopView.m
//  Opt_master
//
//  Created by 瑞宁科技02 on 16/7/14.
//  Copyright © 2016年 reining. All rights reserved.
//

#import "QuestionTopView.h"
#import "LSCoreToolCenter.h"
#import "CalculateHeight.h"
#import "UILabel+extension.h"
#import "CompareTime.h"
static CGFloat cellHeight;

@implementation QuestionTopView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setupView];
        [self addConstraint];
    }
    return self;
}

- (void)setupView{
    [self addSubview:self.question];
    [self addSubview:self.questionTitleLabel];
    [self addSubview:self.questionContentLabel];
    [self addSubview:self.timeLabel];
    [self addSubview:self.number];
    [self addSubview:self.sepLine];
    [self addSubview:self.tagImage];
    [self addSubview:self.tagLabel];
    [self addSubview:self.bottomView];
    
    
//    _question
//    .whc_LeftSpace(DEFUALT_MARGIN_SIDES)
//    .whc_TopSpace(DEFUALT_MARGIN_SIDES)
//    .whc_Size(CGSizeMake(30, 20));
//    
//    _questionTitleLabel
//    .whc_LeftSpaceToView(DEFUALT_MARGIN_SIDES,_question)
//    .whc_TopSpace(DEFUALT_MARGIN_SIDES)
//    .whc_RightSpace(DEFUALT_MARGIN_SIDES)
//    .whc_Height(20);
//    
//    _questionContentLabel
//    .whc_LeftSpace(DEFUALT_MARGIN_SIDES)
//    .whc_TopSpaceToView(DEFUALT_MARGIN_SIDES,_questionContentLabel)
//    .whc_RightSpace(DEFUALT_MARGIN_SIDES)
//    .whc_heightAuto();
//    
//    _timeLabel
//    .whc_LeftSpace(DEFUALT_MARGIN_SIDES)
//    .whc_RightSpace(DEFUALT_MARGIN_SIDES)
//    .whc_TopSpaceToView(DEFUALT_MARGIN_SIDES,_questionContentLabel)
//    .whc_Height(20);
//    
//    
//    self.whc_CellBottomOffset = 10;
//    
//    self.whc_CellBottomView = _timeLabel;
//
}

#pragma mark -  自适应高度
+ (CGFloat)heightForString:(NSString *)str {
    CGRect rectFrame = [str boundingRectWithSize:CGSizeMake(kWidth-2*DEFUALT_MARGIN_SIDES, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:15.f]} context:nil];
    return rectFrame.size.height;
}

+ (CGFloat)cellForHeight{
    
    return cellHeight;
    
}

+ (CGFloat)cellForHeightWithModel:(QuestionModel *)model{
    if (model.content.length == 0) {
        return [self heightForString:model.content]+95;

    }
    return 112;
}



+ (CGFloat)labelheight:(NSString *)detlabel
{
    
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    
    paragraphStyle.lineSpacing = 20;// 字体的行间距
    
    NSDictionary *attributes = @{
                                 
                                 NSFontAttributeName:[UIFont systemFontOfSize:15],
                                 
                                 NSParagraphStyleAttributeName:paragraphStyle
                                 
                                 };
    
    CGSize size = CGSizeMake(kWidth-2*DEFUALT_MARGIN_SIDES, 1000);
    
    CGSize contentactually = [detlabel boundingRectWithSize:size options:(NSStringDrawingUsesLineFragmentOrigin|NSStringDrawingUsesFontLeading) attributes:attributes context:nil].size;
    
    return contentactually.height;
    
}





- (void)setModel:(QuestionModel *)model{
    _model = model;
    self.questionTitleLabel.text = model.title;
    self.questionContentLabel.text = model.content;

//    // label根据文字自适应高度
    self.questionContentLabel.numberOfLines = 0;
    self.questionContentLabel.lineBreakMode = NSLineBreakByWordWrapping;
    CGSize size = [self.questionContentLabel sizeThatFits:CGSizeMake(self.questionContentLabel.frame.size.width, MAXFLOAT)];
    CGRect frame = self.questionContentLabel.frame;
    frame.size.height = size.height;
    self.questionContentLabel.frame = frame;
    // 设置label的行间距
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:model.content];
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    [paragraphStyle setLineSpacing:8];
    [attributedString addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, [model.content length])];
    [self.questionContentLabel setAttributedText:attributedString];
    [self.questionContentLabel sizeToFit];
    self.questionContentLabel.isAttributedContent = YES;
    
    CGSize sss = [self.questionContentLabel multipleLinesSizeWithLineSpacing:8 andText:model.content];
    
    cellHeight  = sss.height +120;

    
    NSDate *currentTime = [NSDate dateWithTimeIntervalSince1970:[model.createdon intValue]];
    NSString *time2 = [CompareTime comparesCurrentTime:currentTime ];
    self.timeLabel.text = time2;
    
    self.tagLabel.text = model.tags;
    self.number.text = [NSString stringWithFormat:@"%@人回答",model.replynum];
    
}
- (void)addConstraint{
    __weak __typeof(self) weakSelf = self;

    self.question.sd_layout
    .topSpaceToView(weakSelf,DEFUALT_MARGIN_SIDES)
    .leftSpaceToView(weakSelf,DEFUALT_MARGIN_SIDES)
    .widthIs(30)
    .heightIs(20);
    
    self.questionTitleLabel.sd_layout
    .topSpaceToView(weakSelf,DEFUALT_MARGIN_SIDES)
    .leftSpaceToView(self.question,0)
    .rightSpaceToView(weakSelf,DEFUALT_MARGIN_SIDES)
    .heightIs(20);
    
//    self.questionContentLabel.sd_layout
//    .topSpaceToView(_question,5)
//    .leftSpaceToView(weakSelf,DEFUALT_MARGIN_SIDES)
//    .rightSpaceToView(weakSelf,DEFUALT_MARGIN_SIDES)
//    .autoHeightRatio(0);
    
    self.questionContentLabel.frame = CGRectMake(DEFUALT_MARGIN_SIDES, CGRectGetMaxY(self.questionTitleLabel.frame)+2*DEFUALT_MARGIN_SIDES, kWidth-2*DEFUALT_MARGIN_SIDES, 20);
    
    self.timeLabel.sd_layout
    .topSpaceToView(self.questionContentLabel,10)
    .leftSpaceToView(weakSelf,DEFUALT_MARGIN_SIDES)
    .rightSpaceToView(weakSelf,DEFUALT_MARGIN_SIDES)
    .heightIs(10);
    
    self.number.sd_layout
    .topEqualToView(self.timeLabel)
    .rightSpaceToView(weakSelf,DEFUALT_MARGIN_SIDES)
    .widthIs(100)
    .heightIs(10);
    
    self.sepLine.sd_layout
    .topSpaceToView(self.timeLabel,DEFUALT_MARGIN_SIDES)
    .leftSpaceToView(weakSelf,DEFUALT_MARGIN_SIDES)
    .rightSpaceToView(weakSelf,DEFUALT_MARGIN_SIDES)
    .heightIs(0.5);
    
    self.tagImage.sd_layout
    .topSpaceToView(self.sepLine,DEFUALT_MARGIN_SIDES)
    .leftSpaceToView(weakSelf,DEFUALT_MARGIN_SIDES)
    .widthIs(12)
    .heightIs(12);
    
    self.tagLabel.sd_layout
    .topSpaceToView(self.sepLine,DEFUALT_MARGIN_SIDES)
    .leftSpaceToView(self.tagImage,5)
    .rightSpaceToView(weakSelf,DEFUALT_MARGIN_SIDES)
    .heightIs(12);
    
    self.bottomView.sd_layout
    .bottomEqualToView(weakSelf)
    .leftSpaceToView(weakSelf,0)
    .rightSpaceToView(weakSelf,0)
    .heightIs(10);
    
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
        _questionTitleLabel.textColor = TXT_MAIN_COLOR;
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
