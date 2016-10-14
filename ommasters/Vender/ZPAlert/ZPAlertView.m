//
//  ViewController.m
//  ZPTest
//
//  Created by 张平 on 15/10/29.
//  Copyright © 2015年 zhangping. All rights reserved.
//

#import "ZPAlertView.h"

#define TIME_T  1.6 //没有按钮的消失时间

#define IOS_7 ([[[UIDevice currentDevice] systemVersion] floatValue]>=7.0)?1:0
#define TEXT_FONT_SIZE [UIFont systemFontOfSize:18]
#define INPUT_TEXT_COLOR [UIColor colorWithRed:98.0/255.0 green:98.0/255.0 blue:98.0/255.0 alpha:1]

static ZPAlertView * _sharedADlertView = nil;///管理alert内存
@interface ZPAlertView(){
    AlertView *alert;
    ZPTextField *_txtFUser;
}

@end

@implementation ZPAlertView

//展示 ADlertView

+ (ZPAlertView *) showAlertTitle:(NSString*)title andMsg:(NSString*)msg cancelButtonTitle:(NSString *)cancelButtonTitle otherButtonTitles:(NSString *)otherButtonTitles andBlock:(AlertViewBlock)block{
    if (!_sharedADlertView) {
		_sharedADlertView = [[ZPAlertView alloc] initWith:title andMsg:msg cancelButtonTitle:cancelButtonTitle otherButtonTitles:otherButtonTitles andBlock:block];
	}
    else{
        [_sharedADlertView showAlertView:title andMsg:msg cancelButtonTitle:cancelButtonTitle otherButtonTitles:otherButtonTitles andBlock:block];
    }
	return _sharedADlertView;
}

- (id)initWith:(NSString*)title andMsg:(NSString*)msg cancelButtonTitle:(NSString *)cancelButtonTitle otherButtonTitles:(NSString *)otherButtonTitles andBlock:(AlertViewBlock)block{
    self =[super init];
    if (self) {
        [self showAlertView:title andMsg:msg cancelButtonTitle:cancelButtonTitle otherButtonTitles:otherButtonTitles andBlock:block];
    }
    return self;
}

//点击按钮
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if([alertView.title isEqualToString:@"编辑短信内容"])
    {
        if(buttonIndex == 1){
            NSString *error = [_txtFUser VerificationTextField];
            if(![error isEqualToString:@"OK"]&&!IOS_7){
                NSLog(@"<><>error = %@", error);
                [GCDiscreetNotificationView initDiscreetNotificationView:error];
                //                return;
            }else{
                if (_Alertblock != nil) {
                    if (IOS_7) {
                        UITextField *textField = [alert textFieldAtIndex:0];
                        _Alertblock(buttonIndex,textField.text);
                    }else
                        _Alertblock(buttonIndex,_txtFUser.text);
                }
                [self dimis:alertView];
            }
        }
    }else{
        if (_Alertblock != nil) {
            _Alertblock(buttonIndex,nil);
        }
        [self dimis:alertView];
    }
}

//alert 消失

- (void)dimis:(UIAlertView*)sender{
    [sender dismissWithClickedButtonIndex:0 animated:YES];
    [sender removeFromSuperview];
}

- (void)showAlertView:(NSString*)title andMsg:(NSString*)msg cancelButtonTitle:(NSString *)cancelButtonTitle otherButtonTitles:(NSString *)otherButtonTitles andBlock:(AlertViewBlock)block{
    _Alertblock = block;
    alert = [[AlertView alloc]initWithTitle:title message:msg delegate:self cancelButtonTitle:cancelButtonTitle otherButtonTitles:otherButtonTitles, nil];
    if([title isEqualToString:@"设置服务端地址"])
    {
        if (IOS_7) {
            alert.alertViewStyle = UIAlertViewStylePlainTextInput;
        }
        if (!IOS_7) {
            _txtFUser = [[ZPTextField alloc] initWithFrame:CGRectMake(125, 40, 140, 30)];
            [_txtFUser setPlaceholder:BASE_URL];
            [_txtFUser becomeFirstResponder];
            [_txtFUser setPlaceholderColor:[UIColor grayColor]];
            [_txtFUser setFont:[UIFont systemFontOfSize:16]];
            [_txtFUser setKeyboardType:UIKeyboardTypeEmailAddress];
            [_txtFUser setReturnKeyType:UIReturnKeyNext];
            _txtFUser.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
            _txtFUser.NBregEx = REGEX_USERNUM_TYPE;
            [_txtFUser setBackgroundColor:[UIColor clearColor]];
            [alert addSubview:_txtFUser];
        }else{
            UITextField *textField = [alert textFieldAtIndex:0];
            [textField setPlaceholder:BASE_URL];
            [textField setFont:[UIFont systemFontOfSize:11]];
            [textField setKeyboardType:UIKeyboardTypeNumberPad];
            textField.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
        }
        
        
    }
    if (alert.numberOfButtons == 0) {
        [self performSelector:@selector(dimis:) withObject:alert afterDelay:TIME_T];
    }
    [alert show];
}

@end

#define BUTTONHEIGHT  43
#define BUTTONSPACE  15

@implementation AlertView

-(void)layoutSubviews{
    if (!IOS_7) {
        CGRect bound = self.bounds;
        for (UIView *v in self.subviews) {
            if ([v isKindOfClass:[UIImageView class]]) {
                UIImageView *imageV = (UIImageView *)v;
                UIImage *img = [UIImage imageNamed:@"alert_background.png"];
                [imageV setImage:img];
            }
            else if ([v isKindOfClass:[UILabel class]]) {
                UILabel *label = (UILabel *)v;
                label.numberOfLines == 1? label.font = TEXT_FONT_SIZE:nil;
                label.textColor = INPUT_TEXT_COLOR;
                label.shadowColor = nil;
                if (self.numberOfButtons ==0) {
                    bound.size.height = label.frame.origin.y+label.frame.size.height+BUTTONSPACE;
                }else bound.size.height = label.frame.origin.y+label.frame.size.height+BUTTONHEIGHT+BUTTONSPACE;
                self.bounds = bound;
            }
            else if ([v isKindOfClass:NSClassFromString(@"UIAlertButton")]) {
                UIButton *button = (UIButton *)v;
                UIImage *image = nil;
                image = [UIImage imageNamed:@"alert_back_onebutton.png"];
                image = [image stretchableImageWithLeftCapWidth:(int)(image.size.width+1)>>1 topCapHeight:0];
                [button setBackgroundImage:image forState:UIControlStateNormal];
                [button setBackgroundImage:image forState:UIControlStateHighlighted];
                [button setTitleShadowColor:nil forState:UIControlStateNormal];
                
                if (self.numberOfButtons == 1) {
                    [button setTitleColor:[UIColor orangeColor] forState:UIControlStateNormal];
                    [button setFrame:CGRectMake(0, self.bounds.size.height - BUTTONHEIGHT, self.bounds.size.width, BUTTONHEIGHT)];
                }
                else if (self.numberOfButtons ==2){
                    [button setFrame:CGRectMake((button.tag -1)*self.bounds.size.width/2.0, self.bounds.size.height - BUTTONHEIGHT, self.bounds.size.width/2.0, BUTTONHEIGHT)];
                    if (button.tag != 1) {
                        UIView *imgView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 0.5, BUTTONHEIGHT)];///分割线
                        imgView.backgroundColor= [UIColor lightGrayColor];
                        [button setTitleColor:[UIColor orangeColor] forState:UIControlStateNormal];
                        [button addSubview:imgView];
                    }
                }
            }
        }
    }
}


@end

