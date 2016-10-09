//
//  ZHCustomBtn.h
//  CloudCast
//
//  Created by XT on 15/8/24.
//  Copyright (c) 2015年  xiaotu. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ZHCustomBtn : UIView
@property (strong, nonatomic) UIImageView *leftImgView;

@property (strong, nonatomic)  UILabel *titleLabel;
@property (nonatomic,assign)BOOL btnSelected;

@property (nonatomic,copy)void (^btnOnClick)(ZHCustomBtn *btn);
@end
