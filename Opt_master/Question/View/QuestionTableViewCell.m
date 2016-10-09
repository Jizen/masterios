//
//  QuestionTableViewCell.m
//  Opt_master
//
//  Created by 瑞宁科技02 on 16/9/6.
//  Copyright © 2016年 reining. All rights reserved.
//

#import "QuestionTableViewCell.h"
#import "UIImageView+WebCache.h"
#import "CompareTime.h"
#import "SDWeiXinPhotoContainerView.h"
@implementation QuestionTableViewCell

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
    self.backView = [[UIView alloc] init];
    self.bottomView = [[UIView alloc] init];
    self.bottomView.backgroundColor = BG;
    self.backView.userInteractionEnabled = YES;
    [self addSubview:self.backView];

    
    NSArray *views = @[ self.questionLabel, self.tagImage, self.tagLabel, self.timeLabel,self.picContainerView,self.headImage,self.nameLabel,self.answerImage,self.numberLabel,self.answerBtn,self.bottomView];
    
    [self.contentView sd_addSubviews:views];
    
    [self addConstraint];
}


- (void)addConstraint{
    
    
    
    self.questionLabel.sd_layout
    .topSpaceToView(self.contentView,DEFUALT_MARGIN_SIDES)
    .leftSpaceToView(self.contentView,DEFUALT_MARGIN_SIDES)
    .rightSpaceToView(self.contentView,DEFUALT_MARGIN_SIDES)
    .autoHeightRatio(0);

    self.picContainerView.sd_layout
    
    .leftEqualToView(_questionLabel); // 已经在内部实现宽度和高度自适应所以不需要再设置宽度高度，top值是具体有无图片在setModel方法中设置
    
    self.timeLabel.sd_layout
    .leftEqualToView(self.questionLabel)
    .topSpaceToView(_picContainerView, DEFUALT_MARGIN_SIDES)
    .heightIs(15);
    [self.timeLabel setSingleLineAutoResizeWithMaxWidth:[UIScreen mainScreen].bounds.size.width];
    
    
    self.tagImage.sd_layout
    .centerYEqualToView(self.timeLabel)
    .leftSpaceToView(self.timeLabel,DEFUALT_MARGIN_SIDES)
    .widthIs(12)
    .heightIs(12);
    
    self.tagLabel.sd_layout
    .topEqualToView(self.timeLabel)
    .leftSpaceToView(self.tagImage,5)
    .heightIs(15);
    [self.tagLabel setSingleLineAutoResizeWithMaxWidth:[UIScreen mainScreen].bounds.size.width];
    
    
    
    self.answerBtn.sd_layout
    .topSpaceToView(self.timeLabel,3)
    .rightSpaceToView(self.contentView,0)
    .widthIs(70)
    .heightIs(40);
    
    
    self.headImage.sd_layout
    .centerYEqualToView(self.answerBtn)
    .leftSpaceToView(self.contentView,DEFUALT_MARGIN_SIDES)
    .widthIs(20)
    .heightIs(20);
    self.headImage.sd_cornerRadiusFromHeightRatio = @(0.5); // 设置view0的圆角半径为自身高度的0.5倍
    
    
    
    self.nameLabel.sd_layout
    .centerYEqualToView(self.answerBtn)
    .leftSpaceToView(self.headImage,DEFUALT_MARGIN_SIDES)
    .widthIs(100)
    .heightIs(20);
    
    
    self.numberLabel.sd_layout
    .centerYEqualToView(self.answerBtn)
    .rightSpaceToView(self.answerBtn,5)
    .heightIs(20);
    [self.numberLabel setSingleLineAutoResizeWithMaxWidth:[UIScreen mainScreen].bounds.size.width];
    
    self.answerImage.sd_layout
    .centerYEqualToView(self.answerBtn)
    .rightSpaceToView(self.numberLabel,5)
    .widthIs(14)
    .heightIs(14);
    
    self.bottomView.sd_layout
    .bottomEqualToView(self.contentView)
    .widthIs(kWidth)
    .heightIs(DEFUALT_MARGIN_SIDES);
    
    self.backView.backgroundColor = [UIColor clearColor];
    self.backView.sd_layout
    .topSpaceToView(self.tagLabel,DEFUALT_MARGIN_SIDES)
    .leftEqualToView(self)
    .bottomEqualToView(self)
    .rightEqualToView(self.nameLabel);
}

- (void)setModel:(QuestionModel *)model{
//    [self sd_clearViewFrameCache];

    _model = model;
    
    _questionLabel.text = model.title;
    
    
    NSString *headUrl =[NSString stringWithFormat:@"%@",model.author[@"avatar"]] ;
    
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
    NSLog(@"tttt = %@",tags);
    CGFloat picContainerTopMargin = 0;
    if (tags.count) {
        picContainerTopMargin = 10;
    }

    self.picContainerView.sd_layout.topSpaceToView(_questionLabel, picContainerTopMargin);
    
    [self setupAutoHeightWithBottomView:self.nameLabel bottomMargin:20];
    
}







- (SDWeiXinPhotoContainerView *)picContainerView{
    if (!_picContainerView) {
        _picContainerView = [[SDWeiXinPhotoContainerView alloc] init];
    }
    return _picContainerView;
}




- (UILabel *)questionLabel{
    if (!_questionLabel) {
        _questionLabel = [[UILabel alloc] init];
        _questionLabel.textColor = TXT_MAIN_COLOR;
        _questionLabel.numberOfLines=0;
        _questionLabel.text = @"怎么解决手机总死机问题？";
    }
    return _questionLabel;
}
- (UIImageView *)tagImage{
    if (!_tagImage) {
        _tagImage = [[UIImageView alloc] init];
        _tagImage.image =[UIImage imageNamed:@"tag-three"];
    }
    return _tagImage;
}
- (UILabel *)tagLabel
{
    if (!_tagLabel) {
        _tagLabel = [[UILabel alloc] init];
        _tagLabel.textColor = TXT_COLOR;
        _tagLabel.font = GZFontWithSize(12);
        _tagLabel.text = @"网络·信息安全";
    }
    return _tagLabel;
}

- (UILabel *)timeLabel{
    if (!_timeLabel) {
        _timeLabel = [[UILabel alloc] init];
        _timeLabel.textColor = TXT_COLOR;
        _timeLabel.font = GZFontWithSize(12);
    }
    return _timeLabel;
}

- (UIView *)sepLine{
    if (!_sepLine) {
        _sepLine = [[UIView alloc] init];
        _sepLine.backgroundColor = UIColorARGB(1, 250, 246, 246);
    }
    return _sepLine;
}

- (UIImageView *)headImage{
    if (!_headImage) {
        _headImage = [[UIImageView alloc] init];
        _headImage.userInteractionEnabled = YES;
        _headImage.image = [UIImage imageNamed:@"head"];
    }
    return _headImage;
}

-(UILabel *)nameLabel{
    if (!_nameLabel) {
        _nameLabel = [[UILabel alloc] init];
        _nameLabel.userInteractionEnabled = YES;
        _nameLabel.text = @"skytoo";
        _nameLabel.textColor = TXT_COLOR;
        _nameLabel.font = GZFontWithSize(13);
        
    }
    return _nameLabel;
}

- (UIImageView *)answerImage{
    if (!_answerImage) {
        _answerImage = [[UIImageView alloc] init];
        _answerImage.image = [UIImage imageNamed:@"reading-big"];
    }
    return _answerImage;
}

- (UILabel *)numberLabel{
    if (!_numberLabel) {
        _numberLabel = [[UILabel alloc] init];
        _numberLabel.text = @"4378";
        _numberLabel.font = GZFontWithSize(12);
        _numberLabel.textColor = TXT_COLOR;
        
    }
    return _numberLabel;
}

- (UIButton *)answerBtn{
    if (!_answerBtn) {
        _answerBtn = [UIButton buttonWithType:(UIButtonTypeCustom)];
        [_answerBtn setTitle:@"回答" forState:(UIControlStateNormal)];
        [_answerBtn setTitleColor:PRIMARY_COLOR forState:(UIControlStateNormal)];
        _answerBtn.titleLabel.font = GZFontWithSize(12);
        [_answerBtn setImageEdgeInsets:UIEdgeInsetsMake(0, 0, 0, 10)];
        [_answerBtn setTitleEdgeInsets:UIEdgeInsetsMake(0, 10, 0, 10)];
        [_answerBtn setImage:[UIImage imageNamed:@"write"] forState:(UIControlStateNormal)];
    }
    return _answerBtn;
}

-(UIView *)verticalLine{
    if (!_verticalLine) {
        _verticalLine = [[UIView alloc] init];
        _verticalLine.backgroundColor = UIColorARGB(1, 250, 246, 246);
    }
    return _verticalLine;
}

- (UIView *)verticalLineOne{
    if (!_verticalLineOne) {
        _verticalLineOne = [[UIView alloc] init];
        _verticalLineOne.backgroundColor = UIColorARGB(1, 250, 246, 246);
    }
    return _verticalLineOne;
}

//- (void)drawRect:(CGRect)rect
//{
//    CGContextRef context = UIGraphicsGetCurrentContext();
//    CGContextSetFillColorWithColor(context, [UIColor clearColor].CGColor);
//    CGContextFillRect(context, rect);
//    //上分割线，
//    CGContextSetStrokeColorWithColor(context, SEPARATOR_LINE_COLOR.CGColor);
//    CGContextStrokeRect(context, CGRectMake(0, -0.5, rect.size.width , 0));
//    //下分割线
//    CGContextSetStrokeColorWithColor(context, SEPARATOR_LINE_COLOR.CGColor);
//    CGContextStrokeRect(context, CGRectMake(0, rect.size.height, rect.size.width , 1));
//}

@end
