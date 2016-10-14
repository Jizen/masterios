//
//  MessageSettingCell.m
//  Opt_master
//
//  Created by 瑞宁科技02 on 16/7/19.
//  Copyright © 2016年 reining. All rights reserved.
//

#import "MessageSettingCell.h"

@implementation MessageSettingCell

+ (instancetype)cellWithTableView:(UITableView *)tableView
{
    static NSString *identifier = @"MessageSettingCell";
    // 1.缓存中取
    MessageSettingCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    // 2.创建
    if (!cell) {
        cell = [[MessageSettingCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
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
        [self addConstraint];
    }
    return self;
}

- (void)setUpSubViews{
    [self addSubview:self.alertLabel];
    [self addSubview:self.messageLabel];
    [self addSubview:self.mySwitch];

}

- (void)addConstraint{
    __weak __typeof(self) weakSelf = self;

    _alertLabel.sd_layout
    .topSpaceToView(weakSelf,DEFUALT_MARGIN_SIDES)
    .leftSpaceToView(weakSelf,DEFUALT_MARGIN_SIDES)
    .widthIs(200)
    .heightIs(15);
    
    _messageLabel.sd_layout
    .bottomSpaceToView(weakSelf,DEFUALT_MARGIN_SIDES)
    .leftSpaceToView(weakSelf,DEFUALT_MARGIN_SIDES)
    .rightSpaceToView(weakSelf,100)
    .heightIs(15);
    
    _mySwitch.sd_layout
    .centerYEqualToView(weakSelf)
    .rightSpaceToView(weakSelf,DEFUALT_MARGIN_SIDES)
    .heightIs(20)
    .widthIs(80);
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
- (UILabel *)messageLabel{
    if (!_messageLabel) {
        _messageLabel = [[UILabel alloc] init];
        _messageLabel.text = @"关闭后不再接受提醒";
        _messageLabel.font = GZFontWithSize(12);
        _messageLabel.textColor = TXT_COLOR;
    }
    return _messageLabel;
}

- (UILabel *)alertLabel{
    if (!_alertLabel) {
        _alertLabel = [[UILabel alloc] init];
        _alertLabel.text = @"运维专家提醒";
        _alertLabel.font = GZFontWithSize(15);
        _alertLabel.textColor = TXT_MAIN_COLOR;
    }
    return _alertLabel;
}

- (UISwitch *)mySwitch{
    if (!_mySwitch) {
        _mySwitch = [[UISwitch alloc] init];
        _mySwitch.onTintColor = PRIMARY_COLOR;
    }
    return _mySwitch;
}
@end
