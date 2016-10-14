//
//  Image+textField.m
//  CAM
//
//  Created by 瑞宁科技02 on 16/6/28.
//  Copyright © 2016年 reining. All rights reserved.
//

#import "Image+textField.h"
#import "JKCountDownButton.h"
#define SEC 60

@implementation Image_textField

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
    [self addSubview:self.leftImage];
    [self addSubview:self.rightTextField];
    [self addSubview:self.bottomLine];
    [self addSubview:self.vertify];
}

- (void)addConstraint{
    self.leftImage.sd_layout
    .centerYEqualToView(self)
    .leftSpaceToView(self,0)
    .widthIs(18)
    .heightIs(22);
    
    self.rightTextField.sd_layout
    .leftSpaceToView(self.leftImage,12)
    .rightSpaceToView(self,0)
    .topEqualToView(self)
    .bottomEqualToView(self);
    
    self.vertify.sd_layout
    .rightEqualToView(self)
    .centerXEqualToView(self)
    .widthIs(90)
    .heightIs(40);
    
    self.bottomLine.sd_layout
    .leftSpaceToView(self,0)
    .rightSpaceToView(self,0)
    .bottomEqualToView(self)
    .heightIs(SEPARATOR_LINE_HEIGHT);
}


-(UIImageView *)leftImage{
    if (!_leftImage) {
        _leftImage = [[UIImageView alloc] init];
    }
    return _leftImage;
}

- (UITextField *)rightTextField{
    if (!_rightTextField) {
        _rightTextField = [[UITextField alloc] init];
        _rightTextField.tintColor = PRIMARY_COLOR;

        [self.rightTextField setClearButtonMode:UITextFieldViewModeWhileEditing];//右侧删除按钮

    }
    return _rightTextField;
}

-(UIView *)bottomLine{
    if (!_bottomLine) {
        _bottomLine = [[UIView alloc] init];
        _bottomLine.backgroundColor = SEPARATOR_LINE_COLOR;
    }
    return _bottomLine;
}
- (UIButton *)vertify{
    if (!_vertify) {
        _vertify = [JKCountDownButton buttonWithType:(UIButtonTypeCustom)];
        _vertify.layer.cornerRadius = BTN_CORNER_RADIUS;
        _vertify.layer.masksToBounds = YES;
        _vertify.backgroundColor = PRIMARY_COLOR;
        _vertify.titleLabel.textColor = TXT_MAIN_COLOR;
        _vertify.titleLabel.font = GZFontWithSize(14);
        
    }
    return _vertify;
}
@end
