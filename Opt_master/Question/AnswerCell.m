//
//  AnswerCell.m
//  Opt_master
//
//  Created by 瑞宁科技02 on 16/7/14.
//  Copyright © 2016年 reining. All rights reserved.
//

#import "AnswerCell.h"
#import "LSCoreToolCenter.h"
#import "AnswerModel.h"
#import "UILabel+extension.h"
#import "CompareTime.h"
static CGFloat answercellHeight;

@implementation AnswerCell

+ (instancetype)cellWithTableView:(UITableView *)tableView
{
    static NSString *identifier = @"AnswerCell";
    // 1.缓存中取
    AnswerCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    
    // 2.创建
    if (!cell) {
        cell = [[AnswerCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        // 添加子控件
        [self setUpSubViews];
        // 添加约束
//        [self addConstraint];
    }
    return self;
}


- (void)setUpSubViews{
    self.backgroundColor = [UIColor whiteColor];
    [self addSubview:self.headImage];
    [self addSubview:self.nameLabel];
    [self addSubview:self.contentLabel];
    [self addSubview:self.timeLabel];
    [self addSubview:self.bottomLine];
    
    
    _headImage
    .whc_LeftSpace(DEFUALT_MARGIN_SIDES)
    .whc_TopSpace(DEFUALT_MARGIN_SIDES)
    .whc_Size(CGSizeMake(30, 30));

    _nameLabel
    .whc_LeftSpaceToView(DEFUALT_MARGIN_SIDES,_headImage)
    .whc_TopSpace(19)
    .whc_RightSpace(DEFUALT_MARGIN_SIDES)
    .whc_Height(15);
    
    _contentLabel
    .whc_LeftSpaceToView(DEFUALT_MARGIN_SIDES,_headImage)
    .whc_TopSpaceToView(DEFUALT_MARGIN_SIDES,_nameLabel)
    .whc_RightSpace(DEFUALT_MARGIN_SIDES)
    .whc_heightAuto();
    
    _timeLabel
    .whc_LeftSpaceToView(DEFUALT_MARGIN_SIDES,_headImage)
    .whc_TopSpaceToView(DEFUALT_MARGIN_SIDES,_contentLabel)
    .whc_RightSpace(DEFUALT_MARGIN_SIDES)
    .whc_Height(20);
    
    
    self.whc_CellBottomOffset = 10;

    
}
- (void)addConstraint{
    __weak __typeof(self) weakSelf = self;

    self.headImage.sd_layout
    .topSpaceToView(weakSelf,DEFUALT_MARGIN_SIDES)
    .leftSpaceToView(weakSelf,DEFUALT_MARGIN_SIDES)
    .widthIs(30)
    .heightIs(30);
    self.headImage.sd_cornerRadiusFromWidthRatio = @(0.5);
    self.nameLabel.backgroundColor = PRIMARY_COLOR;
    self.nameLabel.sd_layout
    .centerYEqualToView(self.headImage)
    .leftSpaceToView(self.headImage,DEFUALT_MARGIN_SIDES)
    .heightIs(15);
    [self.nameLabel setSingleLineAutoResizeWithMaxWidth:[UIScreen mainScreen].bounds.size.width];

    self.contentLabel.sd_layout
    .topSpaceToView(self.nameLabel,5)
    .leftEqualToView(self.nameLabel)
    .widthIs(kWidth-80)
    .autoHeightRatio(0);

    
    self.timeLabel.sd_layout
    .bottomSpaceToView(self,DEFUALT_MARGIN_SIDES)
    .leftSpaceToView(self.headImage,DEFUALT_MARGIN_SIDES)
    .rightSpaceToView(weakSelf,DEFUALT_MARGIN_SIDES)
    .heightIs(10);
    
    
    self.bottomLine.sd_layout
    .bottomSpaceToView(self,0)
    .leftSpaceToView(self,0)
    .rightSpaceToView(self,0)
    .heightIs(0.5);
//    [self setupAutoHeightWithBottomView:self.timeLabel bottomMargin:DEFUALT_MARGIN_SIDES];

}

- (UIImageView *)headImage{
    if (!_headImage) {
        _headImage   =[[UIImageView alloc] init];
        _headImage.layer.cornerRadius = 15;
        _headImage.layer.masksToBounds =YES;
        _headImage.userInteractionEnabled = YES;
        _headImage.image = [UIImage imageNamed:@"head"];
    }
    return _headImage;
}
-(UILabel *)nameLabel{
    if (!_nameLabel) {
        _nameLabel  = [[UILabel alloc] init];
        _nameLabel.textColor = TXT_COLOR;
        _nameLabel.font = GZFontWithSize(15);
        _nameLabel.userInteractionEnabled = YES;
    }
    return _nameLabel;
}

-(UILabel *)contentLabel{
    if (!_contentLabel) {
        _contentLabel = [[UILabel alloc] init];
        _contentLabel.textAlignment = NSTextAlignmentLeft;
        NSString *total3 = @"重新启动动重新启动重新启动重新启动重新启动重新启动重新启动。";
        self.changeLineSpaceString = [LSCoreToolCenter ls_changeLineSpaceWithTotalString:total3 LineSpace:6.0];
        [_contentLabel setAttributedText:self.changeLineSpaceString];
        _contentLabel.textColor = TXT_MAIN_COLOR;
        _contentLabel.font = GZFontWithSize(15);
        _contentLabel.numberOfLines = 0;
    }
    return _contentLabel;
}

- (UILabel *)timeLabel{
    if (!_timeLabel) {
        _timeLabel = [[UILabel alloc] init];
        _timeLabel.textColor = TXT_COLOR;
        _timeLabel.font = GZFontWithSize(12);
        _timeLabel.textAlignment = NSTextAlignmentLeft;
        _timeLabel.text = @"5小时前";
    }
    return _timeLabel;
}

- (UIView *)bottomLine{
    if (!_bottomLine) {
        _bottomLine = [[UIView alloc] init];
        _bottomLine.backgroundColor = SEPARATOR_LINE_COLOR;
    }
    return _bottomLine;
}

- (void)setModel:(AnswerModel *)model{
    _model = model;

    self.contentLabel.text = model.content;
    self.nameLabel.text = model.author[@"nickname"];
    NSDate *currentTime = [NSDate dateWithTimeIntervalSince1970:[model.createdon intValue]];
    NSString *time2 = [CompareTime comparesCurrentTime:currentTime ];
    self.timeLabel.text = time2;

    
    NSString *headUrl =[NSString stringWithFormat:@"%@",model.author[@"avatar"]] ;
    [self.headImage sd_setImageWithURL:[NSURL URLWithString:headUrl] placeholderImage:[UIImage imageNamed:@"head"]];

    NSLog(@"headUrl = %@",headUrl);

    self.contentLabel.numberOfLines = 0;
    self.contentLabel.lineBreakMode = NSLineBreakByWordWrapping;
    CGSize size = [self.contentLabel sizeThatFits:CGSizeMake(self.contentLabel.frame.size.width, MAXFLOAT)];
    CGRect frame = self.contentLabel.frame;
    frame.size.height = size.height;
    self.contentLabel.frame = frame;
    // 设置label的行间距
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:model.content];
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    [paragraphStyle setLineSpacing:4];
    [attributedString addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, [model.content length])];
    [self.contentLabel setAttributedText:attributedString];
    [self.contentLabel sizeToFit];

    self.whc_CellBottomView = _timeLabel;

}




+ (CGFloat)cellForHeight{
    
    return answercellHeight;
    
}

#pragma mark -  自适应高度
+ (CGFloat)heightForString:(NSString *)str {
    CGRect rectFrame = [str boundingRectWithSize:CGSizeMake(kWidth-80, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:15.f]} context:nil];
    return rectFrame.size.height;
}

+ (CGFloat)cellForHeightWithModel:(AnswerModel *)model{
    
    return [self heightForString:model.content]+74;
}

- (void)drawRect:(CGRect)rect
{
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(context, [UIColor clearColor].CGColor);
    CGContextFillRect(context, rect);
    //上分割线，
    CGContextSetStrokeColorWithColor(context, SEPARATOR_LINE_COLOR.CGColor);
    CGContextStrokeRect(context, CGRectMake(0, -0.5, rect.size.width , 0));
    //下分割线
    CGContextSetStrokeColorWithColor(context, SEPARATOR_LINE_COLOR.CGColor);
    CGContextStrokeRect(context, CGRectMake(0, rect.size.height, rect.size.width , 1));
}

@end

