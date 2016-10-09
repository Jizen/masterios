//
//  LoginView.h
//  CAM
//
//  Created by 瑞宁科技02 on 16/6/28.
//  Copyright © 2016年 reining. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Image+textField.h"
@interface LoginView : UIView<UIScrollViewDelegate>
/**
 *  LogoImage
 */
@property (nonatomic ,strong)UIImageView *logoImage;

@property (nonatomic ,strong) Image_textField *name;
@property (nonatomic ,strong) Image_textField *password;

@property (nonatomic ,strong) UIButton *loginbtn;

@property (nonatomic ,strong) UIButton *setting;

@property (nonatomic ,strong) UIButton *forgetPassword;

@property (nonatomic ,strong) UILabel *company;
@property (nonatomic ,strong) UIButton *registBtn;

@property (nonatomic,strong) UIScrollView *scrollView;

@end
