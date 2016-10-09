
//
//  ViewController.m
//  ZPTest
//
//  Created by 张平 on 15/10/29.
//  Copyright © 2015年 zhangping. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum RegExTextFieldType_ {
    REGEX_USER_TYPE = 1, //用户名输入限制
    REGEX_ZHUCE_TYPE,     //注册用户名限制
    REGEX_NUMBER_TYPE,   //手机号输入限制
    REGEX_MAIL_TYPE,     //邮箱输入限制
    REGEX_WEIXIN_TYPE,     //微信输入限制
    REGEX_USERNUM_TYPE,  //用户编号输入限制
    REGEX_USERPASSWORD_TYPE, //用户密码输入限制
    REGEX_CLIENTPASSWORD_TYPE, //客户密码输入限制
    REGEX_VECODE_TYPE,   //验证码输入限制
    REGEX_MONEY_TYPE,     //金额输入限制
    REGEX_SEARCH_TYPE,    //搜索输入限制
    REGEX_CONTACT_TYPE,   //联系人
    REGEX_CONTACT_TYPE1,  //咨询联系人
    REGEX_ADDER_TYPE,      //地址
    REGEX_ADDER_TYPE1,      //咨询地址
    REGEX_CLIENTPASSWORD_TYPE1,
    REGEX_CHONGZHIKA_TYPE,
    REGEX_SHENQINGBIANHAO,
    REGEX_USER_TYPE_JIANGSU,
    
    //用电办理进度查询相关正则
    REGEX_POWER_USER_NAME ,//客户名称
    REGEX_POWER_TELPHOONE_NUMBER ,//手机号和电话号
    REGEX_POWER_ADDRESS ,//地址
    REGEX_POWER_CONTECT, //联系人
    REGEX_DEBUG_NAME, // 设备名称
    REGEX_DEBUG_UNIT, // 试验单位
    REGEX_DEBUG_PERSON, // 试验人员
    
    
    //如有需要，自行添加正则表达式
    
} RegExTextFieldType;

@class NBParser;

//输入框的复写类，封装写公用功能

@interface ZPTextField : UITextField<UITextFieldDelegate>
{
    NSString *_lastAcceptedValue;
    NBParser *_parser;
    
    RegExTextFieldType regExTextFieldType;
}

@property (assign, nonatomic) RegExTextFieldType NBregEx;
@property (strong, nonatomic) NSString *pattern;
@property (retain, nonatomic) UIColor *PlaceholderColor;

- (NSString*)VerificationTextField;

- (void)startMoving;
- (void)stopMoving;

@end
