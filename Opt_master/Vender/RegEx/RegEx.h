//
//  RegEx.h
//  ZeroNewsDemo
//
//  Created by iOS on 15/10/30.
//  Copyright © 2015年 iOS. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface RegEx : NSObject

// 正则匹配手机号
+ (BOOL)checkTelNumber:(NSString *) telNumber;

// 正则匹配用户密码6-18位数字和字母组合
+ (BOOL)checkPassword:(NSString *) password;

// 正则匹配用户姓名,20位的中文或英文
+ (BOOL)checkUserName : (NSString *) userName;

// 正则匹配用户身份证号
+ (BOOL)checkUserIdCard: (NSString *) idCard;

// 正则匹员工号,12位的数字
+ (BOOL)checkEmployeeNumber : (NSString *) number;

// 正则匹配URL
+ (BOOL)checkURL : (NSString *) url;

@end
