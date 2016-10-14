//
//  ViewController.m
//  ZPTest
//
//  Created by 张平 on 15/10/29.
//  Copyright © 2015年 zhangping. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ZPTextField.h"

@class NBGroup;

@interface NBParser : NSObject
{
    NSString *_pattern;
    BOOL _ignoreCase;
    NBGroup *_node;
    BOOL _finished;
    NSRegularExpression *_exactQuantifierRegex;
    NSRegularExpression *_rangeQuantifierRegex;
}

- (id)initWithPattern:(NSString*)pattern;
- (id)initWithPattern:(NSString*)pattern ignoreCase:(BOOL)ignoreCase;
- (NSString*)reformatString:(NSString*)input andRegEx:(RegExTextFieldType)_regEx;

@property (readonly, nonatomic) NSString *pattern;

@end
