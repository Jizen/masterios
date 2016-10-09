//
//  RegistView.h
//  Opt_master
//
//  Created by 瑞宁科技02 on 16/7/8.
//  Copyright © 2016年 reining. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Image+textField.h"
#import "ImageTextField.h"
@interface RegistView : UIView
/**
 *  LogoImage
 */
@property (nonatomic ,strong)UIImageView *logoImage;

//@property (nonatomic ,strong) Image_textField *name;
//@property (nonatomic ,strong) Image_textField *password;
//@property (nonatomic ,strong) Image_textField *phone;
//@property (nonatomic ,strong) Image_textField *vertifyCode;
//@property (nonatomic ,strong) UIButton *registBtn;

@property (nonatomic ,strong) ImageTextField *name;
@property (nonatomic ,strong) ImageTextField *password;
@property (nonatomic ,strong) ImageTextField *phone;
@property (nonatomic ,strong) ImageTextField *vertifyCode;
@property (nonatomic ,strong) UIButton *registBtn;
@end
