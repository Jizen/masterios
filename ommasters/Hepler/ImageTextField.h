//
//  ImageTextField.h
//  Opt_master
//
//  Created by 瑞宁科技02 on 16/7/21.
//  Copyright © 2016年 reining. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ImageTextField : UIView
/**
 *  姓名
 */
@property (nonatomic ,strong)UITextField *name;

/**
 *  密码
 */
@property (nonatomic ,strong)UIImageView *leftImage;

@property (nonatomic ,assign)int imgHeight;
@property (nonatomic ,assign)int imgWidth;

/**
 *  姓名输入框
 */
@property (nonatomic ,strong)UIView *nameBack;

@property (nonatomic, strong)UIView *line;
@end
