//
//  ViewController.m
//  ZPTest
//
//  Created by 张平 on 15/10/29.
//  Copyright © 2015年 zhangping. All rights reserved.
//

#import "ZPTextField.h"
#import "NBParser.h"

#define TEXT_HOLDER_COLOR [UIColor colorWithRed:202.0/255.0 green:216.0/255.0 blue:221.0/255.0 alpha:1]
#define INPUT_TEXT_COLOR [UIColor colorWithRed:98.0/255.0 green:98.0/255.0 blue:98.0/255.0 alpha:1]
#define TEXT_FONT_SIZE [UIFont systemFontOfSize:18]

@interface ZPTextField () {
    CGFloat _placeholderWidth;
    BOOL _isMoving;
    CGFloat _x;
    BOOL _leftToRight;
    
    CGFloat _afterDelay;//定时 时间
    
    BOOL _isFirst;
}

- (void)movePlaceholder;

@end

@implementation ZPTextField

@synthesize NBregEx;
@synthesize PlaceholderColor;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        _lastAcceptedValue = nil;
        _parser = nil;
        _isFirst = NO;
         self.PlaceholderColor = TEXT_HOLDER_COLOR;
        [self setTextColor:INPUT_TEXT_COLOR];
        [self setFont:TEXT_FONT_SIZE];
        self.contentVerticalAlignment=UIControlContentVerticalAlignmentCenter;
        [self addTarget:self action:@selector(formatInput:) forControlEvents:UIControlEventEditingChanged];
        
    }
    return self;
}

- (void)setPattern:(NSString *)pattern
{
    if (pattern == nil || [pattern isEqualToString:@""])
        _parser = nil;
    else
        _parser = [[NBParser alloc] initWithPattern:pattern];
}

- (NSString*)pattern
{
    return _parser.pattern;
}
/**
 *  初始化输入正则表达式
 *
 *  @param voidsetNBregEx:RegExTextFieldType <#voidsetNBregEx:RegExTextFieldType description#>
 *
 *  @return 返回正则
 */
#pragma mark - 设置正则
-(void)setNBregEx:(RegExTextFieldType)nbregEx
{
    regExTextFieldType = nbregEx;
    switch (nbregEx) {
        case REGEX_ZHUCE_TYPE:
        case REGEX_USER_TYPE:// 用户名 数字 字母 下划线
            self.pattern = @"^[a-zA-Z0-9_]{6,20}$";
//            self.pattern = @"^[a-zA-Z]{1}([a-zA-Z0-9]|[_-]){5,19}$";
//            self.pattern = @"^(?!\\d+$)[a-zA-Z0-9]+$";
            break;
        case REGEX_USERPASSWORD_TYPE:
        {
            [self setPlaceholder:@"请输入密码"];
            [self setSecureTextEntry:YES];
            [self setKeyboardType:UIKeyboardTypeNumbersAndPunctuation];
//            self.pattern = @"^[a-zA-Z0-9]{1}([a-zA-Z0-9]|[_]){5,19}$";
            self.pattern = @"^[a-zA-Z0-9~!@#$%^&*_]{6,20}$";
        }
            break;
        case REGEX_NUMBER_TYPE: // 电话号
        {
            [self setPlaceholder:@"请输入手机号"];
            [self setKeyboardType:UIKeyboardTypeNumbersAndPunctuation];
            self.pattern = @"^(1[0-9])\\d{9}$";
//            self.pattern = @"^(13[0-9]|14[5|7]|15[0|1|2|3|5|6|7|8|9]|18[0-9])\\d{8}$";
        }
            break;
        case REGEX_MAIL_TYPE:// 邮箱
        {
            [self setPlaceholder:@"例如：Phone@163.com"];
            [self setKeyboardType:UIKeyboardTypeEmailAddress];
//            self.pattern = @"^(\\w)+(.\\w+)*@(\\w)+((.\\w{2,3}){1,3})$";
            self.pattern = @"^(\\w)+(.\\w+)*@(\\w)+((.\\w+)+)$";
        }
            break;
        case REGEX_WEIXIN_TYPE: //微信号
        {
            self.pattern = @"^[a-zA-Z]{1}([a-zA-Z0-9]|[_-]){5,19}$";
        }
            break;
        case REGEX_USERNUM_TYPE://用户编号 16位数字
        {
            [self setKeyboardType:UIKeyboardTypeNumbersAndPunctuation];
            self.pattern = @"^[0-9]{7,10}$";
        }
            break;
        case REGEX_CLIENTPASSWORD_TYPE: //数字6位
        {
            [self setPlaceholder:@"6-12位字符"];
            [self setSecureTextEntry:YES];
            [self setKeyboardType:UIKeyboardTypeNumbersAndPunctuation];
            self.pattern = @"^[a-zA-Z0-9~!@#$%^&*]{6,12}$";
        }
            break;
        case REGEX_CLIENTPASSWORD_TYPE1: //数字6位
        {
            [self setPlaceholder:@"6-12个数字"];
            [self setSecureTextEntry:YES];
            [self setKeyboardType:UIKeyboardTypeNumbersAndPunctuation];
            self.pattern = @"^[0-9]{5,11}$";
        }
            break;
        case REGEX_VECODE_TYPE:  //验证码
        {
            [self setPlaceholder:@"6位验证码"];
            [self setKeyboardType:UIKeyboardTypeNumbersAndPunctuation];
            self.pattern = @"^[0-9]{6}$";
        }
            break;
        case REGEX_MONEY_TYPE:  //金额
        {
            [self setKeyboardType:UIKeyboardTypeNumbersAndPunctuation];
            self.pattern = @"^(([1-9]{1}[0-9]*)|([0]{1}))(\\.([0-9]){1,2})?$";
            //self.pattern = @"^[1-9]{1}([0-9]){0,10}$";
        }
            break;
        case REGEX_SEARCH_TYPE:  //搜索
            break;
        case REGEX_CONTACT_TYPE1:
        case REGEX_CONTACT_TYPE://联系人
            self.pattern = @"^([A-Za-z]|[\u4E00-\u9FA5])+$";
            break;
        case REGEX_ADDER_TYPE1:
        case REGEX_ADDER_TYPE://地址
//            self.pattern = @"^([\\w]{1}[\\w])|([_]{1}|[-]{1})+$";
//            self.pattern = @"^[a-zA-Z0-9_\u4e00-\u9fa5!?,.#*()-=+/]+$";
            break;
        case REGEX_CHONGZHIKA_TYPE:
            [self setKeyboardType:UIKeyboardTypeNumbersAndPunctuation];
            self.pattern = @"^[0-9]{20}$";
            break;
        case REGEX_SHENQINGBIANHAO:
            self.pattern=@"^[1-9]{1}[0-9]{0,23}$";
            break;
        case REGEX_USER_TYPE_JIANGSU:
            self.pattern = @"^[a-zA-Z0-9_\u4e00-\u9fa5!?,.#*()-=+/]{6,20}$";
            break;
        case REGEX_POWER_USER_NAME:
            [self setPlaceholder:@"不超过40位字符"];
            self.pattern = @"^([A-Za-z]|[\u4E00-\u9FA5]){0,40}$";
            break;
        case REGEX_POWER_TELPHOONE_NUMBER:
            [self setPlaceholder:@"手机号/固定电话"];
            [self setKeyboardType:UIKeyboardTypeNumbersAndPunctuation];
            self.pattern = @"^[+]{0,1}([0-9]){1,3}[ ]?([-]?(([0-9])|[ ]){1,12})$";
            break;
        case REGEX_POWER_ADDRESS:
            [self setPlaceholder:@"3-120位字符"];
            self.pattern = @"^([A-Za-z]|[\u4E00-\u9FA5]){3,120}$";//^[\u4e00-\u9fa5]{4,8}$
            break;
        case REGEX_POWER_CONTECT:
            [self setPlaceholder:@"不超过12位字符"];
            self.pattern = @"^([A-Za-z]|[\u4E00-\u9FA5]){0,12}$";
            break;
        case REGEX_DEBUG_NAME:
            [self setPlaceholder:@"3-50位字符"];
            self.pattern = @"^([A-Za-z]|[\u4E00-\u9FA5]){3,50}$";
            break;
        case REGEX_DEBUG_UNIT:
            [self setPlaceholder:@"3-50位字符"];
            self.pattern = @"^([A-Za-z]|[\u4E00-\u9FA5]){3,50}$";
            break;
        case REGEX_DEBUG_PERSON:
            [self setPlaceholder:@"2-4位中文汉字"];
            self.pattern = @"^([\u4E00-\u9FA5]){2,4}$";
            break;


        default:
//            _parser = nil;
            break;
    }
}

#pragma mark - 输入控制
- (void)formatInput:(UITextField *)textField
{
    if (textField.text==nil||[textField.text isEqualToString:@""]) {
        [textField setPlaceholder:textField.placeholder];
    }
    if (_parser == nil) return;
    
    __block NBParser *localParser = _parser;
    
    dispatch_async(dispatch_get_main_queue(), ^{
        NSString *formatted = [localParser reformatString:textField.text andRegEx:regExTextFieldType];
        if (formatted == nil)
            formatted = _lastAcceptedValue;
        else
            _lastAcceptedValue = formatted;
        NSString *newText = formatted;
        
        if (![textField.text isEqualToString:newText]) {
            textField.text = formatted;
            [self sendActionsForControlEvents:UIControlEventValueChanged];
        }
    });
}

#pragma mark - 验证正则
-(NSString*)VerificationTextField
{
    
    BOOL isMatch = YES;
    
    NSString *error = @"OK";
    switch (regExTextFieldType) {
        case REGEX_ZHUCE_TYPE:
        case REGEX_USER_TYPE:// 用户名 数字 字母 下划线
        {
            isMatch = [self regexMatch];
            error = @"请输入正确的用户名/手机号";
        }
            break;
        case REGEX_USERPASSWORD_TYPE: //数字 字母 下划线
        {
            isMatch = [self regexMatch];
            error = @"密码请输入6-20位字符";
        }
            break;
        case REGEX_NUMBER_TYPE: // 电话号
        {
            isMatch = [self regexMatch];
            error = @"请输入正确的手机号码";
        }
            break;
        
        case REGEX_USERNUM_TYPE://用户编号 16位数字
        {
            isMatch = [self regexMatch];
            error = @"请输入正确的客户编号";
        }
            break;
        case REGEX_CLIENTPASSWORD_TYPE: //数字 字母 下划线
        {
            isMatch = [self regexMatch];
            error = @"请输入正确的查询密码";
        }
            break;
        case REGEX_CLIENTPASSWORD_TYPE1: //数字 字母 下划线
        {
            isMatch = [self regexMatch];
            error = @"请输入正确的查询密码";
        }
            break;
        case REGEX_VECODE_TYPE:
        {
            isMatch = [self regexMatch];
            error = @"请输入正确的验证码";
        }
            break;
        case REGEX_MONEY_TYPE:
        {
            if ([self text].length == 0) {
                isMatch = NO;
                error = @"金额不能为空!";
            }else{
                isMatch = [self regexMatch];
                error = @"请输入正确的支付金额";
            }
        }
            break;
        case REGEX_MAIL_TYPE:// 邮箱
        {
            
                isMatch = [self regexMatch];
                error = @"请输入正确的邮箱地址";
            
        }
            break;
        case REGEX_WEIXIN_TYPE:// 微信
        {
            if (![self textMatch]) {
                isMatch = [self regexMatch];
                error = @"请输入正确的微信号";
            }
        }
            break;
        case REGEX_SEARCH_TYPE:
        {
            if (![self textMatch]) {
//                isMatch = [self regexMatch];
//                error = @"邮箱输入有误!";
            }
        }
            break;
        case REGEX_CONTACT_TYPE1:
        {
            isMatch = [self regexMatch];
            error = @"请输入正确的联系人";
        }
            break;
        case REGEX_CONTACT_TYPE: //字母和汉字
        {
            if (![self textMatch]) {
                isMatch = [self regexMatch];
                error = @"请输入正确的联系人";
            }
        }
            break;
        case REGEX_ADDER_TYPE1:
            isMatch = [self regexMatch];
            error = @"请输入正确的地址";
            break;
        case REGEX_ADDER_TYPE:
            if (![self textMatch]) {
                isMatch = [self regexMatch];
                error = @"请输入正确的地址";
            }
            break;
        case REGEX_CHONGZHIKA_TYPE://用户编号 16位数字
        {
            isMatch = [self regexMatch];
            error = @"请输入正确的充值卡密码";
        }
            break;
        case REGEX_SHENQINGBIANHAO://申请编号
        {
            isMatch=[self regexMatch];
            error=@"请输入正确的申请编号";
        }
            break;
        case REGEX_POWER_USER_NAME://
        {
            isMatch=[self regexMatch];
            error=@"不超过40位字符";
        }
            
            break;
        default:
            //_parser = nil;
            break;
    }
//    NSLog(@"000000=%@",error);
    return isMatch ? @"OK": error;
}

#pragma mark - 验证正则表达式
-(BOOL)regexMatch
{
    
    NSString * regex        = self.pattern;
    NSPredicate * pred      = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regex];
    BOOL isMatch            = [pred evaluateWithObject:[self text]];
    
    if( regExTextFieldType == REGEX_ADDER_TYPE){
        NSUInteger asciiLength = 0;
        isMatch = YES;
        for (NSUInteger i=0; i<[self text].length; i++) {
            unichar uc = [[self text] characterAtIndex:i];
            asciiLength += isascii(uc)?1:2;
        }
        if(asciiLength<3)
        {
            isMatch = NO;
        }
    }
    if( regExTextFieldType == REGEX_ADDER_TYPE1){
        NSUInteger asciiLength = 0;
        isMatch = YES;
        for (NSUInteger i=0; i<[self text].length; i++) {
            unichar uc = [[self text] characterAtIndex:i];
            asciiLength += isascii(uc)?1:2;
        }
        if(asciiLength<3)
        {
            isMatch = NO;
        }
    }
    switch (regExTextFieldType) {
        case REGEX_ZHUCE_TYPE:
        {
            if (isMatch) {
                NSString * regex        = @"^\\d+$";
//                NSString *regex =  @"^(13[0-9]|14[5|7]|15[0|1|2|3|5|6|7|8|9]|18[0-9])\\d{8}$";
                NSPredicate * pred      = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regex];
                isMatch            = [pred evaluateWithObject:[self text]];
                isMatch = isMatch ? NO:YES;
            }
            
        }
            break;
        case REGEX_CONTACT_TYPE:
            if (isMatch) {
                isMatch = [self unicodeLengthOfString:[self text]];
            }
            break;
        default:
            break;
    }
    
    NSLog(@"isM = %d",isMatch);
    
    return isMatch;
}
//中英文混合计算字符长度
-(BOOL) unicodeLengthOfString:(NSString*)text {
    BOOL isasc = YES;
    NSUInteger asciiLength = 0;
    if (regExTextFieldType == REGEX_CONTACT_TYPE1) {
        for (NSUInteger i=0; i<text.length; i++) {
            unichar uc = [text characterAtIndex:i];
            asciiLength += isascii(uc)?1:2;
        }
        if(asciiLength<1||asciiLength>12){
            isasc = NO;
        }
    }else{
        for (NSUInteger i=0; i<text.length; i++) {
            unichar uc = [text characterAtIndex:i];
            asciiLength += isascii(uc)?1:2;
            if(isascii(uc))
            {
                isasc = NO;
                break;
            }
        }
        if(isasc){
            if(asciiLength<4||asciiLength>8){
                isasc = NO;
            }
        }
    }
    return isasc;
}
#pragma mark - 设置 PlaceholderColor 字体颜色
- (void) drawPlaceholderInRect:(CGRect)rect {
    [self.PlaceholderColor setFill];
    [[self placeholder] drawInRect:rect withFont:TEXT_FONT_SIZE];
}

#pragma mark -- 设置text文本
-(void)setText:(NSString *)text
{
    [super setText:text];
    
    _placeholderWidth = [text sizeWithFont:self.font].width;
    _x = 0.0f;
    _leftToRight = YES;
    
}
#pragma mark -- 设置placeholder文本
- (void)setPlaceholder:(NSString *)placeholder {
    [super setPlaceholder:placeholder];
    
    _placeholderWidth = [placeholder sizeWithFont:self.font].width;
    _x = 0.0f;
    _leftToRight = NO;
}

#pragma mark -- 设置placeholder Bounds
-(CGRect)placeholderRectForBounds:(CGRect)bounds
{
    CGRect placeholderRect = [super placeholderRectForBounds:bounds];
    if ([[[UIDevice currentDevice] systemVersion] floatValue]>=7.0&&bounds.size.height>40) {
        placeholderRect = CGRectMake(0, 13, bounds.size.width, bounds.size.height);
    }
    if (_placeholderWidth > placeholderRect.size.width) {
        if (_x >= _placeholderWidth - (placeholderRect.size.width - (bounds.size.width - placeholderRect.size.width) * 0.5)) {
            _leftToRight = YES;
        } else if (_x <= 0.0f) {
            _leftToRight = NO;
        }
        
        if (!_leftToRight) {
            _x += 1.0f;
        } else {
            _x -= 1.0f;
        }
        
        placeholderRect.origin.x -= _x;
        placeholderRect.size.width = _placeholderWidth;
    }
    
    return placeholderRect;
}

#pragma mark -- 设置text Bounds
-(CGRect)textRectForBounds:(CGRect)bounds
{
    CGRect placeholderRect = [super textRectForBounds:bounds];
    
    if (_placeholderWidth > placeholderRect.size.width) {
        
        if (_x >= _placeholderWidth - (placeholderRect.size.width - (bounds.size.width - placeholderRect.size.width) * 0.5)) {
            _leftToRight = YES;
            _isFirst = YES;
        } else if (_x < 0.0f) {
            _leftToRight = NO;
            _isFirst = YES;
        }
        
        if (!_leftToRight) {
            _x += 0.5f;
        } else {
            _x -= 0.5f;
        }
        
        placeholderRect.origin.x -= _x;
        placeholderRect.size.width = _placeholderWidth;
    }
    
    return placeholderRect;
}

#pragma mark -- 开始滚动
- (void)startMoving {
    if (!_isMoving) {
        _isMoving = YES;
        _isFirst = YES;
        [self movePlaceholder];
    }
}
#pragma mark -- 停止滚动
- (void)stopMoving {
    if (_isMoving) {
        _isMoving = NO;
        [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(movePlaceholder) object:nil];
    }
}
/**
 *  根据输入框长度设置滚动
 */
- (void)movePlaceholder {
    if (!_isMoving) {
        return;
    }
    
    if (_isFirst) {
        _isFirst = NO;
        _afterDelay = 2.0;
    }else
    {
        _afterDelay = 1.0 / 30.0;
        if ([self.text length] > 0) {
            [self setNeedsLayout];
        }
        if ([self.text length] == 0 && [self.placeholder length] > 0) {
            [self setNeedsLayout];
        }
    }
    
    [self performSelector:@selector(movePlaceholder) withObject:nil afterDelay:_afterDelay]; // 30 FPS
}

#pragma mark - 判断输入框是否为空
-(BOOL)textMatch
{
    BOOL isMatch = YES;
    if (![[self text] isEqualToString:@""] || [[self text] stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]].length != 0)
        isMatch = NO;
    
    return isMatch;
}


@end
