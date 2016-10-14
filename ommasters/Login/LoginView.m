//
//  LoginView.m
//  CAM
//
//  Created by 瑞宁科技02 on 16/6/28.
//  Copyright © 2016年 reining. All rights reserved.
//

#import "LoginView.h"

@implementation LoginView

- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        [self setupView];
    }
    return self;
}

- (void)setupView{
    [self addSubview:self.logoImage];
    [self addSubview:self.name];
    [self addSubview:self.password];
    [self addSubview:self.registBtn];
    [self addSubview:self.loginbtn];
    [self addSubview:self.company];
    [self addConstraint];
}
- (void)addConstraint{
    _logoImage.sd_layout
    .widthIs(100.0/667*kHeight)
    .heightIs(100.0/667*kHeight)
    .centerXEqualToView(self)
    .topSpaceToView(self,(30.0+64.0)/667*kHeight);
    
    _name.sd_layout
    .topSpaceToView(self.logoImage,43.0/667*kHeight)
    .centerXEqualToView(self)
    .leftSpaceToView(self,3*DEFUALT_MARGIN_SIDES)
    .rightSpaceToView(self,3*DEFUALT_MARGIN_SIDES)
    .heightIs(40.0/667*self.frame.size.height);
    
    _password.sd_layout
    .topSpaceToView(_name,20)
    .centerXEqualToView(self)
    .leftSpaceToView(self,3*DEFUALT_MARGIN_SIDES)
    .rightSpaceToView(self,3*DEFUALT_MARGIN_SIDES)
    .heightIs(40.0/667*self.frame.size.height);
    
    _loginbtn.sd_layout
    .topSpaceToView(_password,30)
    .centerXEqualToView(self)
    .leftSpaceToView(self,3*DEFUALT_MARGIN_SIDES)
    .rightSpaceToView(self,3*DEFUALT_MARGIN_SIDES)
    .heightIs(40.0/667*self.frame.size.height);
    
    _registBtn.sd_layout
    .topSpaceToView(_loginbtn,20)
    .widthRatioToView(_loginbtn,1)
    .leftEqualToView(_loginbtn)
    .heightIs(20);
    

    
    _company.sd_layout
    .bottomSpaceToView(self,20)
    .centerXEqualToView(self)
    .leftSpaceToView(self,DEFUALT_MARGIN_SIDES)
    .rightSpaceToView(self,DEFUALT_MARGIN_SIDES)
    .heightIs(40);
}
-(UIImageView *)logoImage{
    if (!_logoImage) {
        _logoImage = [[UIImageView alloc] init];
        _logoImage.userInteractionEnabled = YES;
        _logoImage.image = [UIImage imageNamed:@"logo"];
    }
    return _logoImage;
}

- (Image_textField *)name{
    if (!_name) {
        _name = [[Image_textField alloc] init];
        _name.rightTextField.placeholder = @"请输入账号";
        _name.leftImage.image = [UIImage imageNamed:@"data"];
        [self.name.rightTextField setClearButtonMode:UITextFieldViewModeWhileEditing];//右侧删除按钮
        _name.vertify.hidden = YES;
    }
    return _name;
}

- (Image_textField *)password{
    if (!_password) {
        _password = [[Image_textField alloc] init];
        _password.rightTextField.placeholder = @"请输入密码";
        _password.leftImage.image = [UIImage imageNamed:@"account"];
        [self.password.rightTextField setClearButtonMode:UITextFieldViewModeWhileEditing];//右侧删除按钮
        _password.vertify.hidden = YES;
    }
    return _password;
}

-(UIButton *)loginbtn{
    if (!_loginbtn) {
        _loginbtn = [UIButton buttonWithType:(UIButtonTypeCustom)];
        [_loginbtn setTitle:@"登录" forState:(UIControlStateNormal)];
        _loginbtn.backgroundColor= PRIMARY_COLOR;
        _loginbtn.layer.cornerRadius = 4;
        _loginbtn.layer.masksToBounds = YES;
    }
    return _loginbtn;
}
-(UIButton *)setting{
    if (!_setting) {
        _setting = [UIButton buttonWithType:(UIButtonTypeCustom)];
        _setting.titleLabel.font = GZFontWithSize(13);
        [_setting setTitleColor:TXT_COLOR forState:(UIControlStateNormal)];
        [_setting setTitle:@"设置服务端地址" forState:(UIControlStateNormal)];
    }
    return _setting;
}
-(UIButton *)forgetPassword{
    if (!_forgetPassword) {
        _forgetPassword = [UIButton buttonWithType:(UIButtonTypeCustom)];
        [_forgetPassword setTitle:@"忘记密码" forState:(UIControlStateNormal)];
        _forgetPassword.titleLabel.font = GZFontWithSize(13);
        [_forgetPassword setTitleColor:TXT_COLOR forState:(UIControlStateNormal)];
    }
    return _forgetPassword;
}

- (UILabel *)company{
    if (!_company) {
        _company = [[UILabel alloc] init];
        _company.text = @"Copyright © 2016 Yunwei Master";
        _company.font = GZFontWithSize(10);
        _company.textColor = TXT_COLOR;
        _company.textAlignment = NSTextAlignmentCenter;
    }
    return _company;
}

- (UIButton *)registBtn{
    if (!_registBtn) {
        _registBtn = [UIButton buttonWithType:(UIButtonTypeCustom)];
        [_registBtn setTitle:@"没有账号去注册" forState:(UIControlStateNormal)];
        _registBtn.titleLabel.font = GZFontWithSize(13);
        [_registBtn setTitleColor:TXT_COLOR forState:(UIControlStateNormal)];
    }
    return _registBtn;
}

@end
