//
//  ImageTextField.m
//  Opt_master
//
//  Created by 瑞宁科技02 on 16/7/21.
//  Copyright © 2016年 reining. All rights reserved.
//

#import "ImageTextField.h"

@implementation ImageTextField


- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setupView];
    }
    return self;
}

- (void)setupView{
    [self addSubview:self.leftImage];
    [self addSubview:self.name];
    [self addSubview:self.line];
    
    self.leftImage.sd_layout
    .topEqualToView(self)
    .leftSpaceToView(self,DEFUALT_MARGIN_SIDES)
    .widthIs(23)
    .heightIs(23);
    
    self.name.sd_layout
    .centerYEqualToView(self.leftImage)
    .leftSpaceToView(self.leftImage,DEFUALT_MARGIN_SIDES)
    .rightSpaceToView(self,0)
    .heightIs(30);
    

    self.line.sd_layout
    .bottomEqualToView(self.name)
    .leftSpaceToView(self.leftImage,5)
    .rightSpaceToView(self,0)
    .heightIs(0.5);
}

- (UIImageView *)leftImage{
    if (!_leftImage) {
        _leftImage = [[UIImageView alloc] init];
    }
    return _leftImage;
}

- (UIView *)nameBack{
    if (!_nameBack) {
        _nameBack = [[UIView alloc] init];
        _nameBack.layer.borderColor = UIColorARGB(1, 204, 204, 204).CGColor;
        _nameBack.layer.borderWidth = BTN_BORDER_WIDTH;
        _nameBack.layer.cornerRadius = 2;
        _nameBack.layer.masksToBounds = YES;

    }
    return _nameBack;
   
}

- (UIView *)line{
    if (!_line) {
        _line = [[UIView alloc] init];
        _line.backgroundColor = SEPARATOR_LINE_COLOR;
    }
    return _line;
}

- (UITextField *)name{
    if (!_name) {
        _name = [[UITextField alloc] init];
        _name.tintColor = PRIMARY_COLOR;
        [self.name setClearButtonMode:UITextFieldViewModeWhileEditing];//右侧删除按钮

        _name.font = GZFontWithSize(12);

    }
    return _name;
}
@end
