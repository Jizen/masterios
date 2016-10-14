//
//  PersonalCell.m
//  cts
//
//  Created by 瑞宁科技02 on 16/1/11.
//  Copyright © 2016年 reining. All rights reserved.
//

#import "PersonalCell.h"

@implementation PersonalCell
-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        
        [ self addConstraint];
    }
    
    return self;
}

- (void)addConstraint{

    [self.leftLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.contentView);
        make.left.equalTo(self.contentView).with.offset(DEFUALT_MARGIN_SIDES);
        make.width.equalTo(@100);
        make.height.equalTo(@20);
    }];

    [self.rightLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.contentView);
        make.right.equalTo(self.contentView).with.offset(-22);
        make.width.equalTo(@300);
        make.height.equalTo(@20);
    }];
}

- (UILabel *)leftLabel{
    if (!_leftLabel) {
        _leftLabel = [[UILabel alloc] init];
        _leftLabel.textAlignment = NSTextAlignmentLeft;
        _leftLabel.font = GZFontWithSize(17);
        _leftLabel.textColor = TXT_MAIN_COLOR;
        [self.contentView addSubview:_leftLabel];
    }
    return _leftLabel;
}

- (UILabel *)rightLabel{
    if (!_rightLabel) {
        _rightLabel = [[UILabel alloc] init];
        _rightLabel.textAlignment = NSTextAlignmentRight;
        _rightLabel.font = GZFontWithSize(15);
        _rightLabel.textColor = TXT_COLOR;
        [self.contentView addSubview:_rightLabel];
    }
    return _rightLabel;
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
