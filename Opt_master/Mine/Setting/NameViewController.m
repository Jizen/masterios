//
//  NameViewController.m
//  cts
//
//  Created by 瑞宁科技02 on 15/11/3.
//  Copyright © 2015年 reining. All rights reserved.
//

#import "NameViewController.h"
#import "LoginViewController.h"
#import "PickerChoiceView.h"
#import "HttpTool.h"

@interface NameViewController ()<UITextFieldDelegate,TFPickerDelegate>
@property (nonatomic ,strong)UILabel *nameLabel;
@property (nonatomic ,strong)UILabel *sexLabel;
@property (nonatomic ,strong)UITextField *nameTextfield;
@property (nonatomic ,strong)UIButton *commitButton;
@property (nonatomic ,strong)UIView *backview;
@property (nonatomic ,strong)UIView *separateViewOne;
@property (nonatomic ,strong)UIView *separateViewTwo;
@property (nonatomic ,strong)UIButton *male;
@property (nonatomic ,strong)UIButton *female;
@property (nonatomic ,strong)NSNumber *sex;
@property (nonatomic ,strong)UILabel *titleLabel;
@end

@implementation NameViewController

#pragma mark - basic
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.navigationController.navigationBarHidden = YES;
}
- (void)viewDidLoad {
    [super viewDidLoad];

    self.title = @"编辑昵称";
    [self.navigationController.navigationBar setTitleTextAttributes:
     @{NSFontAttributeName:[UIFont systemFontOfSize:17],
       NSForegroundColorAttributeName:[UIColor blackColor]}];
    self.view.backgroundColor = [UIColor whiteColor];

    [self setupView];
    self.nameTextfield.delegate =self;
    self.nameTextfield.placeholder = self.name;
    [self createNavBar];
        if ([_sexNum isEqual:@1]) {
        _male.selected = YES;
        if (_male.selected == YES) {
            _sex = @1;
        }else{
            _sex = @2;
        }
        
    }else{
        _male.selected = NO;
        _female.selected = YES;
    }
    
}
#pragma mark - UI
- (void)addRightButton{
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"保存" style:(UIBarButtonItemStyleDone) target:self action:@selector(rightButtonAction)];
}
- (void)setupView{
    
    self.view.backgroundColor = BG;
    self.backview = [[UIView alloc] initWithFrame:CGRectMake(0, DEFUALT_MARGIN_SIDES+64, self.view.frame.size.width, 45)];
    self.backview.layer.borderColor = SEPARATOR_LINE_COLOR.CGColor;
    self.backview.layer.borderWidth = SEPARATOR_LINE_HEIGHT;
    self.backview.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:self.backview];
    self.nameTextfield = [[UITextField alloc] init];
    self.nameTextfield.backgroundColor = [UIColor whiteColor];
//    _nameTextfield.placeholder = @"编辑昵称";
    
    [self.nameTextfield setClearButtonMode:UITextFieldViewModeWhileEditing];//右侧删除按钮
    self.nameTextfield.leftViewMode=UITextFieldViewModeAlways;
    _nameTextfield.font = GZFontWithSize(15);
    _nameTextfield.textColor = TXT_COLOR;
    _nameTextfield.clearButtonMode = UITextFieldViewModeAlways;
    [self.backview addSubview:_nameTextfield];
    _nameTextfield.tintColor = PRIMARY_COLOR;
    
    _nameTextfield.sd_layout
    .topSpaceToView(self.backview,0)
    .leftSpaceToView(self.backview,60)
    .rightSpaceToView(self.backview,DEFUALT_MARGIN_SIDES)
    .heightIs(45);
    
    self.nameLabel = [[UILabel alloc] init];
    self.nameLabel.text = self.leftStr;
    self.nameLabel.textColor = TXT_COLOR;
    self.nameLabel.font = GZFontWithSize(15);
    [self.backview addSubview:self.nameLabel];
    self.nameLabel.sd_layout
    .topSpaceToView(self.backview,14)
    .leftSpaceToView(self.backview,DEFUALT_MARGIN_SIDES)
    .widthIs(40)
    .heightIs(15);
    
    UIView *sepLine = [[UIView alloc] init];
    sepLine.backgroundColor = SEPARATOR_LINE_COLOR;
    [self.backview addSubview:sepLine];
    sepLine.sd_layout
    .centerYEqualToView(self.nameTextfield)
    .heightIs(15)
    .leftSpaceToView(self.nameLabel,0)
    .widthIs(1);
    
}

-(void)createNavBar{
    UIView *navBar = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kWidth, 64)];
    navBar.backgroundColor = Navigation_COLOR;
    [self.view addSubview:navBar];
    
    self.titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(kWidth/2-50, 30, 100, 20)];
    _titleLabel.textAlignment = NSTextAlignmentCenter;
    _titleLabel.text = self.titleStr;
    _titleLabel.textColor = [UIColor blackColor];
    [navBar addSubview:_titleLabel];
    
    UIButton *backBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    backBtn.frame = CGRectMake(0, 20, 60, 44);
    [backBtn setImageEdgeInsets:UIEdgeInsetsMake(0, 0, 0, 10)];
    [backBtn setTitleColor:PRIMARY_COLOR forState:UIControlStateNormal];
    [backBtn setImage:[UIImage imageNamed:@"return"] forState:(UIControlStateNormal)];
    [backBtn addTarget:self action:@selector(leftAction) forControlEvents:UIControlEventTouchUpInside];
    [navBar addSubview:backBtn];
    
    UIButton *backBtn1 = [UIButton buttonWithType:UIButtonTypeSystem];
    backBtn1.frame = CGRectMake(kWidth - 50, 20, 40, 44);
    [backBtn1 setTitleColor:PRIMARY_COLOR forState:UIControlStateNormal];
    [backBtn1 setTitle:@"保存" forState:UIControlStateNormal];
    backBtn1.titleLabel.font = GZFontWithSize(18);
    [backBtn1 addTarget:self action:@selector(rightButtonAction) forControlEvents:UIControlEventTouchUpInside];
    [navBar addSubview:backBtn1];
    
    UIView *line = [[UIView alloc] initWithFrame:CGRectMake(0, 63.5, kWidth, 0.5)];
    line.backgroundColor = SEPARATOR_LINE_COLOR;
    [navBar addSubview:line];
}

#pragma mark - Action
- (void)rightButtonAction{
    
    // 传值
    if ([_nameTextfield.text isEqualToString:@""]) {
        _passValue(_nameTextfield.placeholder);
    }else{
        
        NSDictionary *topic;
        if ([self.titleStr isEqualToString:@"编辑昵称"]) {
            _passValue(_nameTextfield.text);
            topic = @{ @"nickname": _nameTextfield.text,};

        }else if ([self.titleStr isEqualToString:@"职业身份"]){
            _passValue(_nameTextfield.text);
            topic = @{ @"vocation": _nameTextfield.text,};

        }else if ([self.titleStr isEqualToString:@"从业经验"]){
            NSUInteger index = self.nameTextfield.text.length;
           NSString *string = [_nameTextfield.text substringToIndex:index-1];
            _passValue(string);
            topic = @{ @"experience": string,};
            
        }

        [[HttpTool shareManager] POST:URL_USER_UPDATE parameters:topic success:^(NSURLSessionDataTask *task, id responseObject) {
            NSLog(@"修改资料 结果= %@",responseObject);
            
            
            NSNumber *code = responseObject[@"code"];
            
            if ([code isEqualToNumber:@200]) {
                
                NSDictionary *data = responseObject[@"data"];
                NSUserDefaults *user = [NSUserDefaults standardUserDefaults];
                NSString *userid = data[@"id"];
                NSString *avatar = data[@"avatar"];
                NSString *nickname = data[@"nickname"];
                NSString *experience = [NSString stringWithFormat:@"%@",data[@"experience"]] ;
                NSString *vocation = data[@"vocation"];
                NSString *tags = data[@"tags"];
                
                [user setValue:avatar forKey:@"avatar"];
                [user setValue:nickname forKey:@"nickname"];
                [user setValue:experience forKey:@"experience"];
                [user setValue:tags forKey:@"tags"];
                [user setValue:vocation forKey:@"vocation"];
                
                NSString *str = [NSString stringWithFormat:@"%@",userid];
                [user setValue:str forKey:@"userid"];
                [user synchronize];

            }else{
            }
            [self.navigationController popViewControllerAnimated:YES];

        } failure:^(NSURLSessionDataTask *task, NSError *error) {
            
        }];
    }
    if (_male.selected == YES) {
        _sex = @1;
    }else{
        _sex = @2;
    }
    
    
}

- (void)leftAction{
    [self.navigationController popViewControllerAnimated:YES];
}
- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    
    [textField resignFirstResponder];
    return YES;
}

#pragma mark - Delegate

- (void)PickerSelectorIndixString:(NSString *)str{
    
    self.nameTextfield.text = [NSString stringWithFormat:@"%@年",str];
}
- (void)textFieldDidBeginEditing:(UITextField *)textField{
    if ([self.titleStr isEqualToString:@"从业经验"]) {
        [textField resignFirstResponder];
        PickerChoiceView *picker = [[PickerChoiceView alloc]initWithFrame:CGRectMake(0, 64, kWidth, kHeight-64)];
        picker.selectLb.text = @"年限";
        picker.delegate = self;
        picker.customArr = @[@"1",@"2",@"3",@"4",@"5",@"6",@"7",@"8",@"9",@"10",];
        [self.view addSubview:picker];
    }
}



@end
