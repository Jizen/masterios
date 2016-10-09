//
//  ModfiyPasswordView.m
//  Opt_master
//
//  Created by 瑞宁科技02 on 16/7/20.
//  Copyright © 2016年 reining. All rights reserved.
//

#import "ModfiyPasswordView.h"

@implementation ModfiyPasswordView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setupView];
    }
    return self;
}

- (void)setupView{
    self.backgroundColor = [UIColor whiteColor];
    self.nameTextfield = [[UITextField alloc] init];
    self.nameTextfield.backgroundColor = [UIColor whiteColor];
    [self.nameTextfield setClearButtonMode:UITextFieldViewModeWhileEditing];//右侧删除按钮
    self.nameTextfield.leftViewMode=UITextFieldViewModeAlways;
    _nameTextfield.font = GZFontWithSize(14);
    _nameTextfield.textColor = TXT_COLOR;
    _nameTextfield.tintColor = PRIMARY_COLOR;
    _nameTextfield.secureTextEntry = YES;

    _nameTextfield.clearButtonMode = UITextFieldViewModeAlways;
    _nameTextfield.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;

    [self addSubview:self.nameTextfield];
    _nameTextfield.sd_layout
    .topSpaceToView(self,3)
    .leftSpaceToView(self,100)
    .rightSpaceToView(self,DEFUALT_MARGIN_SIDES)
    .heightIs(41);
    
    self.nameLabel = [[UILabel alloc] init];
    self.nameLabel.text = @"昵称";
    self.nameLabel.textColor = TXT_COLOR;
    self.nameLabel.font = GZFontWithSize(14);
    [self addSubview:self.nameLabel];
    self.nameLabel.sd_layout
    .centerYEqualToView(self)
    .leftSpaceToView(self,DEFUALT_MARGIN_SIDES)
    .widthIs(80)
    .heightIs(30);
    
    /**
     .topSpaceToView(self.backview,14)
     .leftSpaceToView(self.backview,DEFUALT_MARGIN_SIDES)
     .widthIs(40)
     .heightIs(15);
     
     - returns: <#return value description#>
     */
    
    UIView *sepLine = [[UIView alloc] init];
    sepLine.backgroundColor = SEPARATOR_LINE_COLOR;
    [self addSubview:sepLine];
    sepLine.sd_layout
    .centerYEqualToView(self)
    .heightIs(15)
    .leftSpaceToView(self.nameLabel,0)
    .widthIs(1);
    
}



@end
