//
//  CommonCell.m
//  Opt_master
//
//  Created by 瑞宁科技02 on 16/7/11.
//  Copyright © 2016年 reining. All rights reserved.
//

#import "CommonCell.h"
#import "CompareTime.h"
@implementation CommonCell

+ (instancetype)cellWithTableView:(UITableView *)tableView
{
    static NSString *identifier = @"CommonCell";
    // 1.缓存中取
    CommonCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    // 2.创建
    if (!cell) {
        cell = [[CommonCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    }
//    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self setupView];
        [self addConstraint];
        
    }
    return self;
}

- (void)setupView{
    [self addSubview:self.leftlabel];
    [self addSubview:self.statusLabel];
    [self addSubview:self.timeLabel];

}

- (void)setMyQueationModel:(QuestionModel *)myQueationModel{
    _myQueationModel = myQueationModel;
    self.leftlabel.text = myQueationModel.title;
    
    
    NSDate *currentTime = [NSDate dateWithTimeIntervalSince1970:[myQueationModel.createdon intValue]];

    NSString *time2 = [CompareTime comparesCurrentTime:currentTime ];
    self.timeLabel.text = time2;
    
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
    // 添加子控件
    self.leftlabel.sd_layout
    .topSpaceToView(self,DEFUALT_MARGIN_SIDES)
    .leftSpaceToView(self,DEFUALT_MARGIN_SIDES)
    .rightSpaceToView(self,DEFUALT_MARGIN_SIDES)
    .heightIs(20);
    
    
    self.statusLabel.sd_layout
    .bottomSpaceToView(self,DEFUALT_MARGIN_SIDES)
    .leftEqualToView(self.leftlabel)
    .widthIs(100)
    .heightIs(20);
    
    self.timeLabel.sd_layout
    .bottomSpaceToView(self,DEFUALT_MARGIN_SIDES)
    .rightSpaceToView(self,DEFUALT_MARGIN_SIDES)
    .widthIs(100)
    .heightIs(20);
}
- (UILabel *)leftlabel{
    if (!_leftlabel) {
        _leftlabel = [[UILabel alloc] init];
        _leftlabel.textAlignment = NSTextAlignmentLeft;
        _leftlabel.textColor = TXT_MAIN_COLOR;
        _leftlabel.font = GZFontWithSize(15);
    }
    return _leftlabel;
}
- (UILabel *)timeLabel{
    if (!_timeLabel) {
        _timeLabel = [[UILabel alloc] init];
        _timeLabel.textColor = TXT_COLOR;
        _timeLabel.textAlignment = NSTextAlignmentRight;
        _timeLabel.font = GZFontWithSize(12);
    }
    return _timeLabel;
}
- (UILabel *)statusLabel{
    if (!_statusLabel) {
        _statusLabel = [[UILabel alloc] init];
        _statusLabel.text = @"已解决";
        _statusLabel.textAlignment = NSTextAlignmentLeft;
        _statusLabel.textColor = PRIMARY_COLOR;
        _statusLabel.font = GZFontWithSize(12);
    }
    return _statusLabel;
}
@end
