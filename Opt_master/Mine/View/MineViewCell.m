//
//  MineViewCell.m
//  Opt_master
//
//  Created by 瑞宁科技02 on 16/7/7.
//  Copyright © 2016年 reining. All rights reserved.
//

#import "MineViewCell.h"

@implementation MineViewCell

+ (instancetype)cellWithTableView:(UITableView *)tableView
{
    static NSString *identifier = @"MineViewCell";
    // 1.缓存中取
    MineViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    // 2.创建
    if (!cell) {
        cell = [[MineViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    }
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
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
- (void)setUpSubViews{
    [self addSubview:self.statusImage];
    [self addSubview:self.messageLabel];
    [self addSubview:self.stateLabel];

    
}

- (void)setCertModel:(CertModel *)certModel{
    _certModel = certModel;
    self.messageLabel.text= certModel.title;
    if ([certModel.type isEqualToString:@"company"]) {
        self.imageView.image = [UIImage imageNamed:@"company-h"];
    }else{
        self.imageView.image = [UIImage imageNamed:@"expert-h"];

    }
    
    if (certModel.verifiedon.length == 0) {
        self.stateLabel.text = @"审核中";
        self.stateLabel.textColor = [UIColor redColor];

    }else{
        self.stateLabel.text = @"已认证";
        self.stateLabel.textColor = UIColorARGB(1, 80, 194, 30);


    }
//    self.stateLabel.text
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
- (void)addConstraint{
    _statusImage.sd_layout
    .centerYEqualToView(self)
    .leftSpaceToView(self,DEFUALT_MARGIN_SIDES)
    .widthIs(15)
    .heightIs(15);

    _messageLabel.sd_layout
    .centerYEqualToView(self)
    .leftSpaceToView(_statusImage,2*DEFUALT_MARGIN_SIDES)
    .rightSpaceToView(self,75)
    .heightIs(20);
    
    _stateLabel.sd_layout
    .centerYEqualToView(self)
    .leftSpaceToView(_messageLabel,0)
    .rightSpaceToView(self,3*DEFUALT_MARGIN_SIDES)
    .heightIs(20);
  

    
}

- (UIImageView *)statusImage{
    if (!_statusImage) {
        _statusImage = [[UIImageView alloc] init];
    }
    return _statusImage;
}

- (UILabel *)messageLabel{
    if (!_messageLabel) {
        _messageLabel = [[UILabel alloc] init];
        _messageLabel.textColor = TXT_MAIN_COLOR;
        _messageLabel.font = GZFontWithSize(15);
    }
    return _messageLabel;
    
}

- (UILabel *)stateLabel{
    if (!_stateLabel) {
        _stateLabel = [[UILabel alloc] init];
        _stateLabel.textAlignment = NSTextAlignmentRight;
        _stateLabel.textColor = TXT_MAIN_COLOR;
        _stateLabel.font = GZFontWithSize(12);
    }
    return _stateLabel;
}
@end
