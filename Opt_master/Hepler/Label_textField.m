//
//  Label_textField.m
//  Opt_master
//
//  Created by 瑞宁科技02 on 16/7/11.
//  Copyright © 2016年 reining. All rights reserved.
//

#import "Label_textField.h"

@implementation Label_textField
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
    [self addSubview:self.leftLabel];
    [self addSubview:self.rightLabel];
    [self addSubview:self.bottomLine];

}

- (void)addConstraint{
    self.leftLabel.sd_layout
    .topEqualToView(self)
    .leftSpaceToView(self,DEFUALT_MARGIN_SIDES)
    .widthIs(40)
    .heightIs(20);
    
    self.rightLabel.sd_layout
    .topEqualToView(self)
    .leftSpaceToView(self.leftLabel,DEFUALT_MARGIN_SIDES)
    .rightSpaceToView(self,DEFUALT_MARGIN_SIDES)
    .heightIs(20);
    
    self.bottomLine.sd_layout
    .topSpaceToView(self.leftLabel,DEFUALT_MARGIN_SIDES)
    .leftSpaceToView(self,DEFUALT_MARGIN_SIDES)
    .rightSpaceToView(self,DEFUALT_MARGIN_SIDES)
    .heightIs(1);
}

- (UILabel *)leftLabel{
    if (!_leftLabel) {
        _leftLabel = [[UILabel alloc] init];
    }
    return _leftLabel;
}

- (UITextField *)rightLabel{
    if (!_rightLabel) {
        _rightLabel = [[UITextField alloc] init];
    }
    return _rightLabel;
}

- (UIView *)bottomLine{
    if (!_bottomLine) {
        _bottomLine = [[UIView alloc] init];
        _bottomLine.backgroundColor = [UIColor blackColor];
    }
    return _bottomLine;
}
@end
