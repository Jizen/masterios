//
//  AnswerViewController.m
//  Opt_master
//
//  Created by 瑞宁科技02 on 16/7/7.
//  Copyright © 2016年 reining. All rights reserved.
//

#import "AnswerViewController.h"
#import "QuestionDetailViewController.h"
#import "HttpTool.h"
@interface AnswerViewController ()<UITextViewDelegate>
@property (nonatomic ,strong)UITextView *answerView;
@property (nonatomic ,strong)UIView *backView;
@property (nonatomic ,strong)UILabel *questionLabel;
@end

@implementation AnswerViewController
#pragma mark - lazy
- (UITextView *)answerView{
    if (!_answerView) {
        _answerView = [[UITextView alloc] init];
        _answerView.text = @"请写下您的答案";
        _answerView.font = GZFontWithSize(15);
        _answerView.textColor = TXT_COLOR;
        _answerView.tintColor = PRIMARY_COLOR;
        _answerView.backgroundColor = BG;
    }
    return _answerView;
}
-(UIView *)backView{
    if (!_backView) {
        _backView = [[UIView alloc] init];
        _backView.backgroundColor = BG;
    }
    return _backView;
}

- (UILabel *)questionLabel{
    if (!_questionLabel) {
        _questionLabel = [[UILabel alloc] init];
        _questionLabel.numberOfLines = 0 ;
        _questionLabel.textColor = TXT_MAIN_COLOR;
    }
    return _questionLabel;
}

#pragma mark - basic
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.answerView becomeFirstResponder];
    self.navigationController.navigationBarHidden = YES;

}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    self.title = @"回答";
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:17],NSForegroundColorAttributeName:[UIColor blackColor]}];
    [self setupView];
    [self createNavBar];
    self.questionLabel.text = self.question;
}
#pragma mark - UI
-(void)createNavBar{
    
    UIView *navBar = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kWidth, 64)];
    navBar.backgroundColor = Navigation_COLOR;
    [self.view addSubview:navBar];
    
    UILabel *titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(kWidth/2-50, 30, 100, 20)];
    titleLabel.textAlignment = NSTextAlignmentCenter;
    titleLabel.text = @"问题";
    titleLabel.textColor = [UIColor blackColor];
    [navBar addSubview:titleLabel];
    
    UIButton *backBtn = [UIButton buttonWithType:UIButtonTypeSystem];
    backBtn.frame = CGRectMake(0, 20, 60, 44);
    [backBtn setTitleColor:PRIMARY_COLOR forState:UIControlStateNormal];
    [backBtn setTitle:@"取消" forState:UIControlStateNormal];
    backBtn.titleLabel.font = GZFontWithSize(18);
    [backBtn addTarget:self action:@selector(CancelAnswerForQuestion) forControlEvents:UIControlEventTouchUpInside];
    [navBar addSubview:backBtn];
    
    UIButton *backBtn1 = [UIButton buttonWithType:UIButtonTypeSystem];
    backBtn1.frame = CGRectMake(kWidth - 60, 20, 60, 44);
    backBtn1.titleLabel.font = GZFontWithSize(18);
    [backBtn1 setTitleColor:PRIMARY_COLOR forState:UIControlStateNormal];
    [backBtn1 setTitle:@"提交" forState:UIControlStateNormal];
    [backBtn1 addTarget:self action:@selector(answerForQuestion) forControlEvents:UIControlEventTouchUpInside];
    [navBar addSubview:backBtn1];
    
    UIView *line = [[UIView alloc] initWithFrame:CGRectMake(0, 63.5, kWidth, 0.5)];
    line.backgroundColor = SEPARATOR_LINE_COLOR;
    [navBar addSubview:line];
}

- (void)setupView{
    [self.view addSubview:self.questionLabel];
    [self.view addSubview:self.backView];
    [self.backView addSubview:self.answerView];
    self.answerView.delegate =self;
    self.answerView.tag = 1000;
    
    self.questionLabel.sd_layout
    .topSpaceToView(self.view,64)
    .leftSpaceToView(self.view,DEFUALT_MARGIN_SIDES)
    .rightSpaceToView(self.view,0)
    .heightIs(50);
    
    self.backView.sd_layout
    .topSpaceToView(self.questionLabel,3)
    .leftEqualToView(self.view)
    .rightSpaceToView(self.view,0)
    .bottomEqualToView(self.view);
    
    self.answerView.sd_layout
    .topSpaceToView(self.backView,DEFUALT_MARGIN_SIDES)
    .leftSpaceToView(self.backView,DEFUALT_MARGIN_SIDES)
    .rightSpaceToView(self.backView,DEFUALT_MARGIN_SIDES)
    .bottomSpaceToView(self.backView,DEFUALT_MARGIN_SIDES);
    

}

#pragma mark - Delegate
-(BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{
    if ([text isEqualToString:@"\n"]) {
        [textView resignFirstResponder];
        return NO;
    }
    return YES;
}

- (void)textViewDidBeginEditing:(UITextView *)textView{
    textView.text = @"";
}

#pragma mark - Action
- (void)answerForQuestion{
    if (self.answerView.text.length == 0) {
        [self hudWithTitle:@"请输入回答内容"];
    }else{
        NSDictionary *topic = @{@"topicid": self.itemID,@"content":self.answerView.text,};
        [[HttpTool shareManager] POST:URL_REPLY_NEW parameters:topic success:^(NSURLSessionDataTask *task, id responseObject) {
            NSLog(@"URL_REPLY_NEW : %@",responseObject);
            NSDictionary *data = responseObject[@"data"];
            NSString *num = data[@"replynum"];
            NSNumber *code = responseObject[@"code"];
            if ([code isEqualToNumber:@200] ) {
                self.model.replynum =  [NSString stringWithFormat:@"%@",num];
                if (_model == nil) {

                }else{
                    _passValue(self.model.replynum);
                }
                [self dismissViewControllerAnimated:YES completion:nil];
                [self.navigationController popViewControllerAnimated:YES];
                [self.answerView resignFirstResponder];
            }

        } failure:^(NSURLSessionDataTask *task, NSError *error) {
        }];
    }
}


- (void)CancelAnswerForQuestion{
    if (self.page == 2) {
        [self.navigationController popViewControllerAnimated:YES];
    } else  if (self.page1 == 3) {
        [self.navigationController popViewControllerAnimated:YES];
    }
    else{
    [self dismissViewControllerAnimated:YES completion:nil];
    }
    [self.answerView resignFirstResponder];

}
- (void)hudWithTitle:(NSString *)title
{
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
    hud.mode = MBProgressHUDModeText;
    hud.label.text = title;
    [hud hideAnimated:YES afterDelay:1.f];
}
@end
