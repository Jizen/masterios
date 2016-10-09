//
//  RegistView.m
//  Opt_master
//
//  Created by 瑞宁科技02 on 16/7/8.
//  Copyright © 2016年 reining. All rights reserved.
//

#import "RegistView.h"
@interface RegistView ()

{
    UIButton *_verifyBtn;
    UILabel  *_timeLab;
}

@end
@implementation RegistView

-(instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        [self setupView];
    }
    return self;
}
- (void)setupView{
//    [self addSubview:self.logoImage];
    [self addSubview:self.name];
    [self addSubview:self.phone];
    [self addSubview:self.vertifyCode];
    [self addSubview:self.password];
    [self addSubview:self.registBtn];
    [self addconstraint];
}

- (void)addconstraint{

    _name.sd_layout
    .topSpaceToView(self,(40.0+64.0)/667*kHeight)
    .centerXEqualToView(self)
    .leftSpaceToView(self,-5)
    .rightSpaceToView(self,3*DEFUALT_MARGIN_SIDES)
    .heightIs(40.0/667*self.frame.size.height);
    
    _phone.sd_layout
    .topSpaceToView(_name,20.0/667*kHeight)
    .centerXEqualToView(self)
    .leftSpaceToView(self,-5)
    .rightSpaceToView(self,3*DEFUALT_MARGIN_SIDES+90)
    .heightIs(40.0/667*self.frame.size.height);
    
    _vertifyCode.sd_layout
    .topSpaceToView(_phone,20.0/667*kHeight)
    .centerXEqualToView(self)
    .leftSpaceToView(self,-5)
    .rightSpaceToView(self,3*DEFUALT_MARGIN_SIDES)
    .heightIs(40.0/667*self.frame.size.height);
    
    _password.sd_layout
    .topSpaceToView(_vertifyCode,20.0/667*kHeight)
    .centerXEqualToView(self)
    .leftSpaceToView(self,-5)
    .rightSpaceToView(self,3*DEFUALT_MARGIN_SIDES)
    .heightIs(40.0/667*self.frame.size.height);
    
    _registBtn.sd_layout
    .topSpaceToView(_password,20.0/667*kHeight)
    .centerXEqualToView(self)
    .leftSpaceToView(self,3*DEFUALT_MARGIN_SIDES)
    .rightSpaceToView(self,3*DEFUALT_MARGIN_SIDES)
    .heightIs(40.0/667*self.frame.size.height);

}



- (ImageTextField *)name{
    if (!_name) {
        _name = [[ImageTextField alloc] init];
        _name.name.placeholder = @"昵称";
        _name.leftImage.hidden = YES;
        _name.name.font = GZFontWithSize(15);

    }
    return _name;
}

- (ImageTextField *)password{
    if (!_password) {
        _password = [[ImageTextField alloc] init];
        _password.name.placeholder = @"密码";
        _password.name.font = GZFontWithSize(15);
        _password.leftImage.hidden = YES;

    }
    return _password;
}
- (ImageTextField *)phone{
    if (!_phone) {
        _phone = [[ImageTextField alloc] init];
        _phone.leftImage.hidden = YES;
        _phone.name.placeholder = @"手机号";
        _phone.name.font = GZFontWithSize(15);
        _phone.name.keyboardType = UIKeyboardTypeNumberPad;


    }
    return _phone;
}

- (ImageTextField *)vertifyCode{
    if (!_vertifyCode) {
        _vertifyCode = [[ImageTextField alloc] init];
        _vertifyCode.leftImage.hidden = YES;
        _vertifyCode.name.placeholder = @"验证码";
        _vertifyCode.name.font = GZFontWithSize(15);
        _vertifyCode.name.keyboardType = UIKeyboardTypeNumberPad;

    }
    return _vertifyCode;
}

-(UIButton *)registBtn{
    if (!_registBtn) {
        _registBtn = [UIButton buttonWithType:(UIButtonTypeCustom)];
        [_registBtn setTitle:@"注册" forState:(UIControlStateNormal)];
        _registBtn.backgroundColor= PRIMARY_COLOR;
        _registBtn.layer.cornerRadius = 4;
        _registBtn.layer.masksToBounds = YES;
    }
    return _registBtn;
}

@end
