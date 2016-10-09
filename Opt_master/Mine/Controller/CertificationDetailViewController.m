//
//  CertificationDetailViewController.m
//  Opt_master
//
//  Created by 瑞宁科技02 on 16/9/20.
//  Copyright © 2016年 reining. All rights reserved.
//

#import "CertificationDetailViewController.h"
#import "CertificateViewCell.h"
#import "CertificateImageViewCell.h"
#import "RegEx.h"
@interface CertificationDetailViewController ()<UITableViewDataSource,UITableViewDelegate,UIImagePickerControllerDelegate,UITextFieldDelegate>
@property (nonatomic ,strong)UITableView *tableView;
@property (nonatomic ,strong)UIButton *logOutButton;
@property (nonatomic ,strong)UIImageView *imageView3;
@property (nonatomic ,strong)CertificateImageViewCell *cell1;
@property (nonatomic ,strong)CertificateImageViewCell *cell2;
@property (nonatomic ,strong)CertificateImageViewCell *cell3;

@property (nonatomic ,strong)CertificateViewCell *cell;
@property (nonatomic ,strong)CertificateViewCell *cellname; // 真实姓名
@property (nonatomic ,strong)CertificateViewCell *certCell;// 证书名称
@property (nonatomic ,strong)CertificateViewCell *certCellNumber;// 证书编号

@property (nonatomic ,strong)CertificateViewCell *cellphone; // 手机号
@property (nonatomic ,strong)CertificateViewCell *cellIDnumber; // 身份证
@property (nonatomic ,strong)CertificateViewCell *cellcompany; // 公司名称
@property (nonatomic ,strong)CertificateViewCell *cellcompany1; // j机构代码

@property (nonatomic ,copy)NSString *image_type;
@property (nonatomic ,copy)NSString *frontUrl;
@property (nonatomic ,copy)NSString *reverseUrl;
@property (nonatomic ,copy)NSString *handingUrl;
@property (nonatomic ,copy)NSString *certUrl;

@end

@implementation CertificationDetailViewController
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.hidden = YES;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    if ([self.titles isEqualToString:@"企业认证"]) {
        self.cert_type = @"company";
    }else{
        self.cert_type = @"person";
    }
    [self createNavBar];
    [self initTableView];
    [self setupLogOutButton];

    UITapGestureRecognizer *tapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(keyboardHide:)];
    //设置成NO表示当前控件响应后会传播到其他控件上，默认为YES。
    tapGestureRecognizer.cancelsTouchesInView = NO;
    //将触摸事件添加到当前view
    [self.view addGestureRecognizer:tapGestureRecognizer];
}

-(void)keyboardHide:(UITapGestureRecognizer*)tap{
    [self.cell.nameTextfield resignFirstResponder];
    [self.cellIDnumber.nameTextfield resignFirstResponder];
    [self.certCellNumber.nameTextfield resignFirstResponder];
    [self.cell.nameTextfield resignFirstResponder];
    [self.cellcompany.nameTextfield resignFirstResponder];
    [self.cellcompany1.nameTextfield resignFirstResponder];
    [self.certCell.nameTextfield resignFirstResponder];
    [self.cellname.nameTextfield resignFirstResponder];



    
}
-(void)createNavBar{
    UIView *navBar = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kWidth, 64)];
    navBar.backgroundColor = Navigation_COLOR;
    [self.view addSubview:navBar];
    
    UILabel *titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(kWidth/2-70, 30, 140, 20)];
    titleLabel.textAlignment = NSTextAlignmentCenter;
    titleLabel.text = self.titles;
    titleLabel.textColor = [UIColor blackColor];
    [navBar addSubview:titleLabel];
    
    UIButton *backBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    backBtn.frame = CGRectMake(0, 20, 60, 44);
    [backBtn setImageEdgeInsets:UIEdgeInsetsMake(0, 0, 0, 10)];
    [backBtn setTitleColor:PRIMARY_COLOR forState:UIControlStateNormal];
    [backBtn setImage:[UIImage imageNamed:@"return"] forState:(UIControlStateNormal)];
    [backBtn addTarget:self action:@selector(leftAction) forControlEvents:UIControlEventTouchUpInside];
    [navBar addSubview:backBtn];
    
    UIView *line = [[UIView alloc] initWithFrame:CGRectMake(0, 63.5, kWidth, 0.5)];
    line.backgroundColor = SEPARATOR_LINE_COLOR;
    [navBar addSubview:line];
}
- (void)leftAction{
    
    
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - ui
- (void)initTableView{
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 64, self.view.bounds.size.width, self.view.bounds.size.height-NaviBarHeight) style:UITableViewStylePlain];
    self.tableView.backgroundColor = BG;
    self.tableView.dataSource =self;
    self.tableView.delegate = self;
    self.tableView.contentInset = UIEdgeInsetsMake(0, 0, 0, 0);
    self.tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    self.tableView.scrollIndicatorInsets=self.tableView.contentInset;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:self.tableView];
    
}
#pragma mark - delegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

    if ([self.titles isEqualToString:@"个人认证"]) {
        return 5;
    }
    return 3;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if ([self.titles isEqualToString:@"个人认证"]) {
            if (indexPath.section == 0) {
                if (indexPath.row == 3 || indexPath.row == 4) {
                    return 135;
                }else{
                    return 45;
                }
            }
    }
    if ([self.titles isEqualToString:@"证书认证"]) {
        if (indexPath.row == 0 || indexPath.row == 1) {
            return 45;
        }
    }
    if ([self.titles isEqualToString:@"企业认证"]) {
        if (indexPath.row == 0 || indexPath.row == 1) {
            return 45;
        }
    }
    return 135;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    self.cell = [CertificateViewCell cellWithTableView:tableView];
    self.cell.nameTextfield.delegate = self;
    if ([self.titles isEqualToString:@"个人认证"]) {
            if (indexPath.section == 0) {
                if (indexPath.row == 0) {
                    self.cellname = [CertificateViewCell cellWithTableView:tableView];
                    self.cellname.nameLabel.text = @"真实姓名";
                    return self.cellname;
                }else if(indexPath.row == 1){
                    self.cellphone = [CertificateViewCell cellWithTableView:tableView];
                    self.cellphone.nameLabel.text = @"手机号码";
                    self.cellphone.nameTextfield.userInteractionEnabled = NO;
                    NSUserDefaults *user = [NSUserDefaults standardUserDefaults];
                    NSString *mobile = [user valueForKey:@"mobile"];
                    self.cellphone.nameTextfield.placeholder =[NSString stringWithFormat:@"%@",mobile] ;
                    [self.cellphone.nameTextfield setValue: TXT_MAIN_COLOR forKeyPath:@"placeholderLabel.textColor"];

                    return self.cellphone;

                }else if(indexPath.row == 2){
                    self.cellIDnumber = [CertificateViewCell cellWithTableView:tableView];
                    self.cellIDnumber.nameLabel.text = @"身份证号";
                    self.cellIDnumber.nameTextfield.autocapitalizationType = UITextAutocapitalizationTypeAllCharacters;
                    self.cellIDnumber.nameTextfield.delegate = self;
                    self.cellIDnumber.nameTextfield.tag = 1000;
                    return self.cellIDnumber;
                    
                }else if(indexPath.row == 3){
                    self.cell1 = [CertificateImageViewCell cellWithTableView:tableView];
                    self.cell1.leftImage.image = [UIImage imageNamed:@"上传身份证正面"];
                    self.cell1.rightImage.image = [UIImage imageNamed:@"上传身份证反面"];
                    self.cell1.leftImage.tag = 102;
                    self.cell1.rightImage.tag = 103;
                    // 添加手势
                    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(backTapAction:)];
                    [self.cell1.leftImage addGestureRecognizer:tap];
                    UITapGestureRecognizer *tap1 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(backTapAction:)];
                    [self.cell1.rightImage addGestureRecognizer:tap1];
                    return self.cell1;

                }else{
                    self.cell2 = [CertificateImageViewCell cellWithTableView:tableView];
                    self.cell2.leftImage.image = [UIImage imageNamed:@"上传手持身份证"];
                    self.cell2.rightImage.hidden = YES;
                    self.cell2.leftImage.tag = 100;
                    // 添加手势
                    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(backTapAction:)];
                    [self.cell2.leftImage addGestureRecognizer:tap];
                    
                    return self.cell2;
                }
        }
    }
    if ([self.titles isEqualToString:@"企业认证"]) {
        if (indexPath.row == 0) {
                self.cellcompany = [CertificateViewCell cellWithTableView:tableView];
                self.cellcompany.nameLabel.text = @"企业全称";
                return self.cellcompany;
        }  else if (indexPath.row == 1) {
                self.cellcompany1 = [CertificateViewCell cellWithTableView:tableView];
                self.cellcompany1.nameLabel.text = @"机构代码";
                return self.cellcompany1;
        }else{
                self.cell2 = [CertificateImageViewCell cellWithTableView:tableView];
                self.cell2.leftImage.tag = 104;
                self.cell2.rightImage.hidden = YES;
                self.cell2.leftImage.image = [UIImage imageNamed:@"上传营业执照正面"];
                UITapGestureRecognizer *tap1 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(backTapAction:)];
                [self.cell2.leftImage addGestureRecognizer:tap1];
                return self.cell2;
        }
    }
    if ([self.titles isEqualToString:@"证书认证"]) {
        if (indexPath.row == 0 ) {
            self.certCell = [CertificateViewCell cellWithTableView:tableView];
            self.certCell.nameLabel.text = @"证书名称";
            self.certCell.nameTextfield.placeholder = @"例如思科CCIE认证";
            return self.certCell;
        }else if (indexPath.row == 1 ) {
            self.certCellNumber = [CertificateViewCell cellWithTableView:tableView];
            self.certCellNumber.nameLabel.text = @"证书编号";
            self.certCellNumber.nameTextfield.placeholder = @"1000000001";
            return self.certCellNumber;
        } else{
            self.cell3 = [CertificateImageViewCell cellWithTableView:tableView];
            self.cell3.leftImage.tag = 101;
            self.cell3.rightImage.hidden = YES;
            self.cell3.leftImage.image = [UIImage imageNamed:@"上传证书正面"];
            UITapGestureRecognizer *tap1 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(backTapAction:)];
            [self.cell3.leftImage addGestureRecognizer:tap1];
            return self.cell3;
        }
    }
    return self.cell;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kWidth, 30)];
    view.backgroundColor = BG;
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(DEFUALT_MARGIN_SIDES, 0, kWidth, 30)];
    label.backgroundColor = BG;
    label.textColor = TXT_COLOR;
    label.font = GZFontWithSize(12);
    if (section == 0 ) {
        label.text = self.titles;
    }else{
        label.text = @"真实认证";
    }
    [view addSubview:label];
    return view;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    
    return 30;
}

- (void)setupLogOutButton{
    // 退出按钮
    self.logOutButton = [UIButton buttonWithType:(UIButtonTypeSystem)];
    self.logOutButton.layer.cornerRadius = BTN_CORNER_RADIUS;
    self.logOutButton.layer.masksToBounds = YES;
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 40+DEFUALT_MARGIN_SIDES)];
    self.tableView.tableFooterView = view;
    [view addSubview:_logOutButton];
    
    self.logOutButton.sd_layout
    .centerXEqualToView(self.tableView.tableFooterView)
    .topSpaceToView(view,DEFUALT_MARGIN_SIDES)
    .leftSpaceToView(view,3*DEFUALT_MARGIN_SIDES)
    .rightSpaceToView(view,3*DEFUALT_MARGIN_SIDES)
    .heightIs(40);
    [self.logOutButton setTitle:@"提交认证" forState:(UIControlStateNormal)];
    [self.logOutButton setTitleColor:[UIColor whiteColor] forState:(UIControlStateNormal)];
    self.logOutButton.titleLabel.font = GZFontWithSize(18);
    self.logOutButton.layer.cornerRadius = BTN_CORNER_RADIUS;
    self.logOutButton.backgroundColor = PRIMARY_COLOR;
    self.logOutButton.layer.masksToBounds = YES;
    [self.logOutButton addTarget:self action:@selector(clickLogOutButtonAction:) forControlEvents:(UIControlEventTouchUpInside)];
}
- (void)clickLogOutButtonAction:(UIButton *)sender{
    if ([self.titles isEqualToString:@"个人认证"]) {
        NSString *cert = [NSString stringWithFormat:@"%@,%@,%@",self.frontUrl,self.reverseUrl,self.handingUrl];
        BOOL isMatch = [RegEx checkUserIdCard:self.cellIDnumber.nameTextfield.text];

        NSLog(@"frontUrl === %@",self.frontUrl);
        NSLog(@"reverseUrl === %@",self.reverseUrl);

        NSLog(@"handingUrl === %@",self.handingUrl);

        if (self.cellname.nameTextfield.text == nil || self.frontUrl == nil || self.reverseUrl == nil ||self.handingUrl == nil ) {
            [self hudWithTitle:@"请填写完整信息"];
        }else if (self.cellname.nameTextfield.text.length > 5){
            [self hudWithTitle:@"姓名长度不超过5个字"];
        }else if (!isMatch){
            [self hudWithTitle:@"请填写正确的身份证号码"];
        }else{
        
            NSDictionary *topic = @{@"realname":self.cellname.nameTextfield.text,@"mobile":self.cellphone.nameTextfield.text,@"authimages":cert,
                                    @"idnumber":self.cellIDnumber.nameTextfield.text,@"status":@"0"};
            [[HttpTool shareManager] POST:URL_USER_UPDATE parameters:topic success:^(NSURLSessionDataTask *task, id responseObject) {
                NSLog(@"修改资料 结果= %@",responseObject);
                [self.navigationController popViewControllerAnimated:YES];
            } failure:^(NSURLSessionDataTask *task, NSError *error) {
            }];
        }

    }else if ([self.titles isEqualToString:@"证书认证"]) {
        if (self.certUrl.length == 0 || self.certCell.nameTextfield.text.length == 0 || self.certCellNumber.nameTextfield.text.length == 0) {
            [self hudWithTitle:@"请填写完整信息"];
        }else{
        
            NSDictionary *json = @{
                                   @"images":self.certUrl,
                                   @"title":self.certCell.nameTextfield.text,
                                   @"type":self.cert_type, @"number":self.certCellNumber.nameTextfield.text,  };
            
            [[HttpTool shareManager] POST:URL_certification_new parameters:json success:^(NSURLSessionDataTask *task, id responseObject) {
                NSLog(@"证书认证结果= %@",responseObject);
                [self.navigationController popViewControllerAnimated:YES];
            } failure:^(NSURLSessionDataTask *task, NSError *error) {
            }];
        }
    }else{
        
        if (self.certUrl.length == 0 || self.cellcompany.nameTextfield.text.length == 0 || self.cellcompany1.nameTextfield.text.length == 0) {
            [self hudWithTitle:@"请填写完整信息"];
        }else{
            NSDictionary *json = @{@"images":self.certUrl, @"title":self.cellcompany.nameTextfield.text,@"type":self.cert_type,@"number":self.cellcompany1.nameTextfield.text,   };
            
            [[HttpTool shareManager] POST:URL_certification_new parameters:json success:^(NSURLSessionDataTask *task, id responseObject) {
                NSLog(@"qiye企业认证结果= %@",responseObject);
                [self.navigationController popViewControllerAnimated:YES];
            } failure:^(NSURLSessionDataTask *task, NSError *error) {
            }];
        }
    }
}

#pragma mark - action
- (void)backTapAction:(UITapGestureRecognizer *)tap{
    
    [self.cell.nameTextfield resignFirstResponder];
    [self.cellIDnumber.nameTextfield resignFirstResponder];
    [self.certCellNumber.nameTextfield resignFirstResponder];
    [self.cell.nameTextfield resignFirstResponder];
    [self.cellcompany.nameTextfield resignFirstResponder];
    [self.cellcompany1.nameTextfield resignFirstResponder];
    [self.certCell.nameTextfield resignFirstResponder];
    [self.cellname.nameTextfield resignFirstResponder];
    
    if (tap.view.tag == 100) {
        self.imageView3 = [[UIImageView alloc] init];
        self.imageView3 = self.cell2.leftImage ;
        self.image_type = @"handing";
    }else if (tap.view.tag == 101){
        self.imageView3 = [[UIImageView alloc] init];
        self.imageView3 = self.cell3.leftImage ;
        self.image_type = @"cert";

    }else if (tap.view.tag == 102) {
        self.imageView3 = [[UIImageView alloc] init];
        self.imageView3 = self.cell1.leftImage ;
        self.image_type = @"front";

    }else if (tap.view.tag == 103){
        self.imageView3 = [[UIImageView alloc] init];
        self.imageView3 = self.cell1.rightImage ;
        self.image_type = @"reverse";

    }else if (tap.view.tag == 104){
        self.imageView3 = [[UIImageView alloc] init];
        self.imageView3 = self.cell2.leftImage ;
        self.image_type = @"company_cert";

    }

    NSString *otherButtonTitle = NSLocalizedString(@"从手机相册选择", nil);
    NSString *otherButtonTitle1 = NSLocalizedString(@"拍照", nil);
    NSString *cancelButtonTitle = NSLocalizedString(@"取消", nil);
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:nil message:nil preferredStyle:UIAlertControllerStyleActionSheet];
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:cancelButtonTitle style:UIAlertActionStyleCancel handler:^(UIAlertAction *action) {
    }];
    
    UIAlertAction *otherAction = [UIAlertAction actionWithTitle:otherButtonTitle style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        UIImagePickerController *pickerImage = [[UIImagePickerController alloc] init];
        
        if([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypePhotoLibrary]) {
            pickerImage.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
            pickerImage.mediaTypes = [UIImagePickerController availableMediaTypesForSourceType:pickerImage.sourceType];
            
        }
        pickerImage.delegate = self;
        pickerImage.allowsEditing = YES;
        [self presentViewController:pickerImage animated:YES completion:nil];
    }];
    
    UIAlertAction *otherAction1 = [UIAlertAction actionWithTitle:otherButtonTitle1 style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {

        //先设定sourceType为相机，然后判断相机是否可用（ipod）没相机，不可用将sourceType设定为相片库
        UIImagePickerControllerSourceType sourceType = UIImagePickerControllerSourceTypeCamera;
        UIImagePickerController *picker = [[UIImagePickerController alloc] init];//初始化
        picker.delegate = self;
        picker.allowsEditing = YES;//设置可编辑
        picker.sourceType = sourceType;
        [self presentViewController:picker animated:YES completion:nil];
        
    }];
    
    // Add the actions.
    [alertController addAction:cancelAction];
    [alertController addAction:otherAction];
    [alertController addAction:otherAction1];
    [self presentViewController:alertController animated:YES completion:nil];
}
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info{
    self.cell1.rightImage.userInteractionEnabled =NO;
    self.cell2.leftImage.userInteractionEnabled =NO;

    
    
    self.imageView3.image = info[UIImagePickerControllerEditedImage];
    [picker dismissViewControllerAnimated:NO completion:^{
        [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault];
    
        
        NSString *url = [NSString stringWithFormat:@"%@%@/%@",URL_certification,self.cert_type,self.image_type];
        
        NSLog(@"url --- %@",url);
        [[HttpTool shareManager] POST:url parameters:nil constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
                    NSData *imageData = UIImageJPEGRepresentation(self.imageView3.image, 0.006);
                    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
                    [formatter setDateFormat:@"yyyyMMddHHmmss"];
                    NSString *dateString = [formatter stringFromDate:[NSDate date]];
                    NSString *fileName = [NSString  stringWithFormat:@"%@.png", dateString];
                    [formData appendPartWithFileData:imageData name:@"file" fileName:fileName mimeType:@"image/png"]; //
            
        } success:^(NSURLSessionDataTask *task, id responseObject) {
            NSLog(@"URL_TOPIC_NEW = responseObject = %@",responseObject);
            NSString *url = responseObject[@"msg"];
            if ([self.image_type isEqualToString:@"front"]) {
                self.frontUrl = [NSString stringWithFormat:@"%@",url];
                
                NSLog(@"111111 == %@",self.frontUrl);
            }else if ([self.image_type isEqualToString:@"reverse"]){
                self.reverseUrl = [NSString stringWithFormat:@"%@",url];
                
                NSLog(@"222222 == %@",self.reverseUrl);

            }else if ([self.image_type isEqualToString:@"handing"]){
                self.handingUrl = [NSString stringWithFormat:@"%@",url];
                
                NSLog(@"33333 == %@",self.handingUrl);

            }else if ([self.image_type isEqualToString:@"cert"]){
                self.certUrl = [NSString stringWithFormat:@"%@",url];
            }else if ([self.image_type isEqualToString:@"company_cert"]){
                self.certUrl = [NSString stringWithFormat:@"%@",url];
            }
            
            
            if ([responseObject[@"code"] isEqualToNumber:@200]) {
                self.cell1.rightImage.userInteractionEnabled =YES;
                self.cell2.leftImage.userInteractionEnabled =YES;
            }
            
            
            if (self.certUrl.length > 0 && self.cellcompany.nameTextfield.text.length > 0 && self.cellcompany1.nameTextfield.text.length > 0) {
                [self.logOutButton setTitle:@"提交认证ok" forState:(UIControlStateNormal)];
            }
            
            

            
        } failure:^(NSURLSessionDataTask *task, NSError *error) {
            
            NSLog(@"error == %@",error);
        }];
    }];
}
#pragma mark - delegate
-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}

//- (void)textFieldDidEndEditing:(UITextField *)textField{
//    if (textField.tag == 1000) {
//        //表单提交前的验证
//        BOOL isMatch = [RegEx checkUserIdCard:self.cellIDnumber.nameTextfield.text];
//        NSLog(@"%d",isMatch);
//        if(!isMatch){
//            [self hudWithTitle:@"请填写正确的身份证号码"];
//            
//        }
//    }
//}
- (void)hudWithTitle:(NSString *)title
{
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
    hud.mode = MBProgressHUDModeText;
    hud.label.text = title;
    [hud hideAnimated:YES afterDelay:1.f];
}
@end
