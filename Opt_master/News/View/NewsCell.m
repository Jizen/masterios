//
//  NewsCell.m
//  Opt_master
//
//  Created by 瑞宁科技02 on 16/7/7.
//  Copyright © 2016年 reining. All rights reserved.
//

#import "NewsCell.h"
#import "UIImageView+WebCache.h"
#import "CompareTime.h"

#define HORIZONTAL_PADDING 7.0f
#define VERTICAL_PADDING   3.0f
#define LABEL_MARGIN       10.0f
#define BOTTOM_MARGIN      10.0f
@implementation NewsCell
{
    CGRect previousFrame ;
//    CompareTime *compareTool;
}

+ (instancetype)cellWithTableView:(UITableView *)tableView
{
    static NSString *identifier = @"NewsCell";
    // 1.缓存中取
    NewsCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    // 2.创建
    if (!cell) {
        cell = [[NewsCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    }
//    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
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
- (void)setModel:(NewsModel *)model{
    _model = model;
  //   设置label的行间距
    self.titleLabel.numberOfLines = 2;

    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:model.title];
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    [paragraphStyle setLineSpacing:4];
    [attributedString addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, [model.title length])];
    paragraphStyle.lineBreakMode = NSLineBreakByTruncatingTail;
    [self.titleLabel setAttributedText:attributedString];

    [self.titleLabel sizeToFit];

    
    [self.picImage sd_setImageWithURL:[NSURL URLWithString:model.cover] placeholderImage:[UIImage imageNamed:@"pictureHolder"]];
    self.nameLabel.text = model.source;
    self.browseLabel.text= [NSString stringWithFormat:@"阅读 : %@",model.readnum];
    NSDate *currentTime = [NSDate dateWithTimeIntervalSince1970:[model.createdon intValue]];
    NSString *time2 = [CompareTime comparesCurrentTime:currentTime ];
    self.timeLabel.text = time2;
    NSArray *tags = [model.tags componentsSeparatedByString:@"|"];
    NSString *string = [tags componentsJoinedByString:@" "];
    
    self.tagLabel.text = string;
}
- (void)setUpSubViews{
    [self.contentView addSubview:self.titleLabel];
    [self.contentView addSubview:self.headImage];
    [self.contentView addSubview:self.nameLabel];
    [self.contentView addSubview:self.timeLabel];
    [self.contentView addSubview:self.picImage];
    [self.contentView addSubview:self.tagImage];
    [self.contentView addSubview:self.tagLabel];
    [self.contentView addSubview:self.browseLabel];
}
- (void)addConstraint{
    
    self.picImage.sd_layout
    .topSpaceToView(self.contentView,20)
    .leftSpaceToView(self.contentView,DEFUALT_MARGIN_SIDES)
    .widthIs(80)
    .heightIs(80);
    
    self.headImage.sd_layout
    .topEqualToView(self.picImage)
    .leftSpaceToView(self.picImage,DEFUALT_MARGIN_SIDES)
    .widthIs(0)
    .heightIs(0);
    
    self.nameLabel.sd_layout
    .topEqualToView(self.picImage)
    .leftSpaceToView(self.picImage,DEFUALT_MARGIN_SIDES)
    .heightIs(12);
    
     [self.nameLabel setSingleLineAutoResizeWithMaxWidth:[UIScreen mainScreen].bounds.size.width];
    
    self.timeLabel.sd_layout
    .topEqualToView(self.picImage)
    .leftSpaceToView(self.nameLabel,DEFUALT_MARGIN_SIDES)
    .rightSpaceToView(self.contentView,DEFUALT_MARGIN_SIDES)
    .heightIs(12);
    

     self.titleLabel.sd_layout
    .centerYEqualToView(self.contentView)
    .leftSpaceToView(self.picImage,DEFUALT_MARGIN_SIDES)
    .rightSpaceToView(self.contentView,DEFUALT_MARGIN_SIDES);
    
    self.browseLabel.sd_layout
    .bottomEqualToView(self.picImage)
    .leftSpaceToView(self.picImage,DEFUALT_MARGIN_SIDES)
    .heightIs(12);
    [self.browseLabel setSingleLineAutoResizeWithMaxWidth:[UIScreen mainScreen].bounds.size.width];

    self.tagImage.sd_layout
    .centerYEqualToView(self.browseLabel)
    .leftSpaceToView(self.browseLabel,DEFUALT_MARGIN_SIDES)
    .widthIs(12)
    .heightIs(12);
    
    self.tagLabel.sd_layout
    .centerYEqualToView(self.browseLabel)
    .leftSpaceToView(self.tagImage ,5)
    .heightIs(12);
    
    
    [self.tagLabel setSingleLineAutoResizeWithMaxWidth:[UIScreen mainScreen].bounds.size.width];
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
- (UILabel *)titleLabel{
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc] init];
        _titleLabel.textColor = TXT_MAIN_COLOR;
        _titleLabel.font = GZFontWithSize(17);
        _titleLabel.numberOfLines = 2;
    }
    return _titleLabel;
}

- (UILabel *)testLabel{
    if (!_testLabel) {
        _testLabel = [[UILabel alloc] init];
        _testLabel.textColor = TXT_MAIN_COLOR;
        _testLabel.font = GZFontWithSize(17);
        _testLabel.numberOfLines = 2;
    }
    return _testLabel;
}

- (UIImageView *)picImage{
    if (!_picImage) {
        _picImage = [[UIImageView alloc] init];
        _picImage.image = [UIImage imageNamed:@"pictureHolder"];
    }
    return _picImage;
}
- (UIImageView *)headImage{
    if (!_headImage) {
        _headImage = [[UIImageView alloc] init];
        _headImage.image = [UIImage imageNamed:@"coming"];
    }
    return _headImage;
}

- (UILabel *)nameLabel{
    if (!_nameLabel) {
        _nameLabel = [[UILabel alloc] init];
        _nameLabel.font = GZFontWithSize(12);
        _nameLabel.textColor = TXT_COLOR;

    }
    return _nameLabel;
}

- (UILabel *)timeLabel{
    if (!_timeLabel) {
        _timeLabel = [[UILabel alloc] init];
        _timeLabel.font = GZFontWithSize(12);
        _timeLabel.textColor = TXT_COLOR;

    }
    return _timeLabel;
}

- (UIImageView *)tagImage{
    if (!_tagImage) {
        _tagImage = [[UIImageView alloc] init];
        _tagImage.image = [UIImage imageNamed:@"tag-three"];
    }
    return _tagImage;
}

- (UILabel *)tagLabel{
    if (!_tagLabel) {
        _tagLabel= [[UILabel alloc] init];
        _tagLabel.textColor = TXT_COLOR;
        _tagLabel.font = GZFontWithSize(12);
    }
    return _tagLabel;
}
- (UILabel *)contentLabel{
    if (!_contentLabel) {
        _contentLabel = [[UILabel alloc] init];
        _contentLabel.font = GZFontWithSize(16);
        _contentLabel.numberOfLines = 0;
    }
    return _contentLabel;
}

- (UILabel *)originLabel{
    if (!_originLabel) {
        _originLabel = [[UILabel alloc] init];
        _originLabel.textColor = TXT_COLOR;
        _originLabel.font = GZFontWithSize(12);
    }
    return _originLabel;
}

- (UIImageView *)browseImage{
    if (!_browseImage) {
        _browseImage = [[UIImageView alloc] init];
        _browseImage.backgroundColor = PRIMARY_COLOR;
    }
    return _browseImage;
}

- (UILabel *)browseLabel{
    if (!_browseLabel) {
        _browseLabel = [[UILabel alloc] init];
        _browseLabel.textColor = TXT_COLOR;
        _browseLabel.font =GZFontWithSize(12);
    }
    return _browseLabel;
}


@end
