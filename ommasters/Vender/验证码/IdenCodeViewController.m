//
//  IdenCodeViewController.m
//  封装验证码
//
//  Created by 纵索科技 on 16/4/23.
//  Copyright © 2016年 贺乾龙. All rights reserved.
//

#import "IdenCodeViewController.h"
#import "CaptchaView.h"
#import "UIColor+Hex.h"
#import "Masonry.h"
#define kScreenSize [UIScreen mainScreen].bounds.size


@interface IdenCodeViewController ()<UITextFieldDelegate,UIGestureRecognizerDelegate>{

    UIView *_view;
    UIView *_coverView;
    UIButton *_okButton;
    UIButton *_cancelbutton;
    UILabel *_pleaseLabel;
    UITextField *_codeField;
    UIView *_codeView;
    CaptchaView *_captchaView;
    UIButton *_promptbtn;
    UIView *_lineView01;
    UIView *_secondView;

}

@end

@implementation IdenCodeViewController

- (void)viewDidLoad {
    [super viewDidLoad];


    
}

-(void)sendCode{
    
    //不区分大小写进行比较
    if ([_codeField.text caseInsensitiveCompare:_captchaView.changeString] == NSOrderedSame) {
        
        
        NSLog(@"输入的:%@",_codeField.text);
        NSLog(@"生成的:%@",_captchaView.changeString);
        NSLog(@"验证码正确");
//        [_codeView];
        
    } else {
        
        NSLog(@"验证码错误");
        
    }
    
}
//关闭悬浮窗口
-(void)cancelCode{
    
    [_view removeFromSuperview];
    _view = nil;
    [_coverView removeFromSuperview];
    _coverView = nil;
    
    
}
//更换验证码
-(void)ChangeCode{
    
    [_captchaView changeCaptcha];
    
    [_captchaView setNeedsDisplay];
    
}

-(void)identyCode{
   // _okButton = [[UIButton alloc]initWithFrame:CGRectMake(180, 140, 40, 30)];
    _okButton = [[UIButton alloc]init];
    _okButton.titleLabel.font = [UIFont systemFontOfSize:16.0f];
    [_okButton setTitle:@"确定" forState:UIControlStateNormal];
    [_okButton addTarget:self action:@selector(sendCode) forControlEvents:UIControlEventTouchUpInside];
    [_okButton setTitleColor:[UIColor colorWithHexString:@"#ff8400"] forState:UIControlStateNormal];
    
    //_cancelbutton = [[UIButton alloc]initWithFrame:CGRectMake(40, 140, 40, 30)];
    _cancelbutton = [[UIButton alloc]init];
    _cancelbutton.titleLabel.font = [UIFont systemFontOfSize:16.0f];
    [_cancelbutton setTitle:@"取消" forState:UIControlStateNormal];
    [_cancelbutton addTarget:self action:@selector(cancelCode) forControlEvents:UIControlEventTouchUpInside];
    [_cancelbutton setTitleColor:[UIColor colorWithHexString:@"#ff8400"] forState:UIControlStateNormal];
    
   // _pleaseLabel = [[UILabel alloc]initWithFrame:CGRectMake(85, 0, 150, 50)];
    _pleaseLabel = [[UILabel alloc]init];
    _pleaseLabel.text = @"获取验证码";
    _pleaseLabel.textColor = [UIColor colorWithHexString:@"#111111"];
    _pleaseLabel.font = [UIFont systemFontOfSize:16.0f];
    
   // _codeField = [[UITextField alloc]initWithFrame:CGRectMake(15, 45, 227, 36)];
    _codeField = [[UITextField alloc]init];
    _codeField.placeholder = @"请输入校验码";
    _codeField.font = [UIFont systemFontOfSize:15.0f];
    _codeField.textColor = [UIColor colorWithHexString:@"#AAAAAA"];
    _codeField.backgroundColor = [UIColor colorWithHexString:@"#fafafa"];
    _codeField.layer.masksToBounds = YES;
    _codeField.layer.cornerRadius = 5.0f;
    _codeField.layer.borderWidth = 0.5f;
    _codeField.delegate = self;
    _codeField.layer.borderColor = [UIColor colorWithHexString:@"#dcdcdc"].CGColor;
    _codeField.returnKeyType = UIReturnKeyDone;
    
  //  _captchaView = [[CaptchaView alloc]initWithFrame:CGRectMake(40, 90, 60,40)];
    _captchaView = [[CaptchaView alloc]init];
    _captchaView.backgroundColor = [UIColor whiteColor];
    
   // _promptbtn = [[UIButton alloc]initWithFrame:CGRectMake(130, 90, 125, 30)];
    _promptbtn = [[UIButton alloc]init];
    [_promptbtn setTitle:@"看不清,换一张" forState:UIControlStateNormal];
    _promptbtn.titleLabel.font = [UIFont systemFontOfSize:14.0f];
    [_promptbtn setTitleColor:[UIColor colorWithHexString:@"#999999"] forState:UIControlStateNormal];
    [_promptbtn addTarget:self action:@selector(ChangeCode) forControlEvents:UIControlEventTouchUpInside];
    
    
    //_lineView01 = [[UIView alloc]initWithFrame:CGRectMake(0, 133, 260, 1)];
    _lineView01 = [[UIView alloc]init];
    _lineView01.backgroundColor = [UIColor colorWithHexString:@"#dcdcdc"];
    
   // _secondView = [[UIView alloc]initWithFrame:CGRectMake(135, 133, 0.5, 45)];
    _secondView = [[UIView alloc]init];
    _secondView.backgroundColor = [UIColor colorWithHexString:@"#dcdcdc"];
    
    UIWindow * _window = [UIApplication sharedApplication].keyWindow;
    
    if (!_view) {
        
          //  _view = [[UIView alloc]initWithFrame:CGRectMake(80,(kScreenSize.height - 178)/2 , 260, 178)];
            _view = [[UIView alloc]init];
            _view.backgroundColor = [UIColor whiteColor];
            _view.layer.cornerRadius = 4.0f;
            _view.layer.masksToBounds = YES;
        /**
         如果使用masonary进行约束，后面将无法改变其frame，不知道什么原因？
         */
            _coverView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kScreenSize.width, kScreenSize.height)];
            //_coverView = [[UIView alloc]init];
            _coverView.tag = 2016;
            _coverView.backgroundColor = [UIColor colorWithRed:(211.0/255.0) green:(211.0/255.0) blue:(211.0/255.0) alpha:0.4];
        
            UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(coverViewTap)];
            singleTap.delegate = self;
            [_coverView addGestureRecognizer:singleTap];
            
            [_coverView addSubview:_view];
            [_window addSubview:_coverView];
            [_view addSubview:_okButton];
            [_view addSubview:_cancelbutton];
            [_view addSubview:_pleaseLabel];
            [_view addSubview:_codeField];
            [_view addSubview:_captchaView];
            [_view addSubview:_promptbtn];
            [_view addSubview:_lineView01];
            [_view addSubview:_secondView];
        
//        [_coverView mas_makeConstraints:^(MASConstraintMaker *make) {
//            
//            make.size.mas_equalTo(CGSizeMake(kScreenSize.width, kScreenSize.height));
//        }];
        
        [_view mas_makeConstraints:^(MASConstraintMaker *make) {
            // 设置当前center和父视图的center一样
            make.center.mas_equalTo(_coverView);
            // 设置当前视图的大小
            make.size.mas_equalTo(CGSizeMake(220, 200));
        }];

        [_okButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(_view.mas_right).offset(-25);
            make.bottom.equalTo(_view.mas_bottom).offset = -5;
            make.size.mas_equalTo(CGSizeMake(40, 30));
        }];

        [_cancelbutton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(_view.mas_left).offset(25);
            make.bottom.equalTo(_view.mas_bottom).offset = -5;
            make.size.mas_equalTo(CGSizeMake(40, 30));
        }];
        
        [_pleaseLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(_view.mas_top).offset = 15;
            make.centerX.mas_equalTo(_view.mas_centerX);
        }];
       
        [_codeField mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(_view).offset = 15;
            make.right.equalTo(_view).offset = -15;
            make.top.equalTo(_pleaseLabel.mas_bottom).offset = 15;
            make.height.mas_equalTo(40);
        }];
        [_captchaView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(_codeField.mas_bottom).offset = 15;
            make.left.equalTo(_view).offset = 15;
            make.size.mas_equalTo(CGSizeMake(60, 45));
        }];
        [_promptbtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(_captchaView.mas_right).offset = 25;
            make.top.equalTo(_codeField.mas_bottom).offset = 20;
        }];
        [_lineView01 mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(_promptbtn.mas_bottom).offset = 15;
            make.height.mas_equalTo(1);
            make.left.equalTo(@0);
            make.right.equalTo(@0);
        }];
        [_secondView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.mas_equalTo(_view.mas_centerX);
            make.top.equalTo(_lineView01.mas_bottom).offset = 0;
            make.bottom.equalTo(_view.mas_bottom).offset = 0;
            make.width.mas_equalTo(1);
        }];
        
    }
    
}

-(BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch{
    
    if (touch.view.tag == 2016) {
        return YES;
    }else{
        return NO;
    }
}

-(void)coverViewTap{
    
    //NSLog(@"点击手势");
    [self cancelCode];
    
}


//将要编辑的时候
-(BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    
    
    CGFloat offset;
    if (kScreenSize.height == 480) {
        //4s
        offset = _coverView.frame.size.height - (textField.frame.origin.y + textField.frame.size.height + 225 + 20) - 300;
        
    }else if (kScreenSize.height == 568){
        // 5s  6 6s
        offset = _coverView.frame.size.height - (textField.frame.origin.y + textField.frame.size.height + 225 + 20) - 340;
    }
    else if (kScreenSize.height == 667){

        offset = _coverView.frame.size.height - (textField.frame.origin.y + textField.frame.size.height + 225 + 20) - 370;
        
        
    }
    else if (kScreenSize.height == 736){
        //6sp
        offset = _coverView.frame.size.height - (textField.frame.origin.y + textField.frame.size.height + 225 + 20) - 450;
        
    }
    
    if (offset <= 0) {
        [UIView animateWithDuration:0.3 animations:^{
            
            CGRect frame = _coverView.frame;
            frame.origin.y = offset;
            _coverView.frame =frame;
            NSLog(@"视图高度**%@",NSStringFromCGRect(_coverView.frame));
        }];
        
    }
    
    return YES;
}

-(BOOL)textFieldShouldEndEditing:(UITextField *)textField{
    
    
    [UIView animateWithDuration:0.3 animations:^{
        CGRect frame = _coverView.frame;
        frame.origin.y =0;
        _coverView.frame = frame;
        
    }];
    return YES;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField

{
   /// 回收键盘,取消第一响应者
    
    [textField resignFirstResponder];
    return YES;

}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
