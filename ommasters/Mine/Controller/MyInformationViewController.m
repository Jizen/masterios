//
//  MyInformationViewController.m
//  Opt_master
//
//  Created by 瑞宁科技02 on 16/7/11.
//  Copyright © 2016年 reining. All rights reserved.
//

#import "MyInformationViewController.h"
#import "NameViewController.h"
#import "PersonalCell.h"
#import <MobileCoreServices/MobileCoreServices.h>
#import "MineModel.h"
#import "UpLoadParam.h"
#import "MJExtension.h"

typedef NS_ENUM(NSInteger, PhotoType)
{
    PhotoTypeIcon,
    PhotoTypeRectangle,
    PhotoTypeRectangle1
};

@interface MyInformationViewController ()<UITableViewDelegate,UITableViewDataSource,UIImagePickerControllerDelegate,UINavigationControllerDelegate>
@property (nonatomic ,strong) NSMutableArray *leftMessageArray;
@property (nonatomic ,strong) NSMutableArray *rightMessageArray;
@property (nonatomic ,strong) UITableView *tableView;
@property (nonatomic ,strong) UILabel *head;
@property (nonatomic ,strong) UIImageView *headImage;
@property (nonatomic ,strong) PersonalCell *nameCell;
@property (nonatomic, assign) PhotoType type;
@property (nonatomic ,strong) PersonalCell *cell;
@property (nonatomic ,strong) MBProgressHUD *hud;
@end

@implementation MyInformationViewController
#pragma mark - lazy
- (NSMutableArray *)leftMessageArray{
    if (_leftMessageArray == nil) {
        _leftMessageArray = [NSMutableArray array];
    }
    return _leftMessageArray;
}
- (NSMutableArray *)rightMessageArray{
    if (_rightMessageArray == nil) {
        _rightMessageArray = [NSMutableArray array];
    }
    return _rightMessageArray;
}
#pragma mark - basic
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.navigationController.navigationBarHidden = YES;
    NSUserDefaults *user = [NSUserDefaults standardUserDefaults];
    NSString *nickname = [user valueForKey:@"nickname"];
    NSString *experience = [NSString stringWithFormat:@"%@年",[user valueForKey:@"experience"]];
    NSString *vocation = [user valueForKey:@"vocation"];
    _rightMessageArray = @[nickname,vocation,experience,].mutableCopy;
    [self.tableView reloadData];

}
- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = BG;
    _leftMessageArray = @[@"昵称",@"职业身份",@"从业经验",].mutableCopy;
    self.tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    [self setupProgressHud];
    [self initTableView];
    [self createNavBar];
    

}

#pragma mark - UI
- (void)setupProgressHud
{
    self.hud = [[MBProgressHUD alloc] initWithView:self.view] ;
    self.hud.label.text=@"正在加载...";
    _hud.frame = self.view.bounds;
    _hud.minSize = CGSizeMake(100, 100);
    _hud.mode = MBProgressHUDModeIndeterminate;
    [self.view addSubview:_hud];
    [_hud showAnimated:YES];
}

- (void)initTableView{
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 64, self.view.bounds.size.width, self.view.bounds.size.height-NaviBarHeight) style:UITableViewStylePlain];
    self.tableView.backgroundColor = BG;
    self.tableView.dataSource =self;
    self.tableView.delegate = self;
    self.tableView.contentInset = UIEdgeInsetsMake(0, 0, 0, 0);
    self.tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    self.tableView.scrollIndicatorInsets=self.tableView.contentInset;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.scrollEnabled = NO;
    [self.view addSubview:self.tableView];
    
    
}
-(void)createNavBar{
    UIView *navBar = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kWidth, 64)];
    navBar.backgroundColor = Navigation_COLOR;
    [self.view addSubview:navBar];
    
    UILabel *titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(kWidth/2-50, 30, 100, 20)];
    titleLabel.textAlignment = NSTextAlignmentCenter;
    titleLabel.text = @"个人资料";
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

#pragma mark - request


- (void)hudWithTitle:(NSString *)title
{
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
    hud.mode = MBProgressHUDModeText;
    hud.label.text = title;
    [hud hideAnimated:YES afterDelay:1.f];
}
#pragma mark - Table view data source
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 4;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *identifier = @"personalCell";
    self.cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (_cell==nil) {
        _cell=[[PersonalCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    }
    
    if (indexPath.row == 0) {
        [self.head removeFromSuperview];
        self.head = [[UILabel alloc] init];
        self.head.text = @"头像";
        self.head.textAlignment = NSTextAlignmentLeft;
        self.head.font = GZFontWithSize(17);
        self.head.textColor = TXT_MAIN_COLOR;
        self.head.centerY = _cell.centerY;
        [_cell addSubview:self.head];
        self.head.sd_layout
        .centerYEqualToView(_cell)
        .leftSpaceToView(_cell,DEFUALT_MARGIN_SIDES)
        .widthIs(50)
        .heightIs(20);
        
        NSUserDefaults *user = [NSUserDefaults standardUserDefaults];
        NSString *avatar = [user valueForKey:@"avatar"];
        

        NSString *headUrl =[NSString stringWithFormat:@"%@",avatar] ;

        _headImage = [[UIImageView alloc] init];
        [self.headImage sd_setImageWithURL:[NSURL URLWithString:headUrl] placeholderImage:[UIImage imageNamed:@"head"]];
        _headImage.userInteractionEnabled = YES;
        //UITapGestureRecognizer *tap =[[ UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapAction)];
        //[_headImage addGestureRecognizer:tap];

        [_cell addSubview:_headImage];
        _headImage.sd_layout
        .centerYEqualToView(_cell)
        .rightSpaceToView(_cell,22)
        .widthIs(54)
        .heightIs(54);
        _headImage.sd_cornerRadiusFromHeightRatio = @(0.5);
        _cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return _cell;
    }

    _cell.leftLabel.text = _leftMessageArray[indexPath.row-1];
    _cell.rightLabel.text = _rightMessageArray[indexPath.row -1];
    _cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return _cell;


}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == 0) {
        return 80;
    }
    return 60;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row == 0) {
         [self tapAction];
        
        
        
        
    }else if (indexPath.row == 1) {

        NameViewController *name = [[NameViewController alloc] init];
        name.titleStr = @"编辑昵称";
        name.leftStr = @"昵称";
        name.name = _rightMessageArray[indexPath.row-1];
        name.passValue = ^(NSString *str){
            PersonalCell *cell = [self.tableView cellForRowAtIndexPath: indexPath];
            cell.rightLabel.text = str;
        };
        self.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:name animated:YES];
    }else if (indexPath.row == 2){

        NameViewController *name = [[NameViewController alloc] init];
        name.titleStr = @"职业身份";
        name.leftStr = @"身份";
        name.name = _rightMessageArray[indexPath.row-1];
        name.passValue = ^(NSString *str){
            PersonalCell *cell = [self.tableView cellForRowAtIndexPath: indexPath];
            cell.rightLabel.text = str;
        };
        self.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:name animated:YES];
    }else if (indexPath.row == 3){
        
        NameViewController *name = [[NameViewController alloc] init];
        name.titleStr = @"从业经验";
        name.leftStr = @"经验";
        name.name = _rightMessageArray[indexPath.row-1];
        name.passValue = ^(NSString *str){
            PersonalCell *cell = [self.tableView cellForRowAtIndexPath: indexPath];
            cell.rightLabel.text = [NSString stringWithFormat:@"%@年",str];
        };
        self.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:name animated:YES];
    }
}
#pragma mark - action
- (void)leftAction{
    [self.navigationController popViewControllerAnimated:YES];
}
- (void)tapAction{
    
    //解决iOS8在调用系统相机拍照时，会有一两秒的停顿，然后再弹出UIImagePickConroller的问题
    if([[[UIDevice currentDevice] systemVersion] floatValue]>=8.0) {
        
        self.modalPresentationStyle=UIModalPresentationOverCurrentContext;
        
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
//
#pragma mark -- 调用相机相册之后调用方法
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info{
    _headImage.image = [info objectForKey:UIImagePickerControllerEditedImage];
    UIImage *newImage = [self imageSize:info[UIImagePickerControllerEditedImage]];
    NSData *imageData = UIImageJPEGRepresentation(newImage, 0.001);
    [[HttpTool shareManager] POST:URL_USER_AVATAR parameters:nil constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
        if (imageData!=nil) {   // 图片数据不为空才传递
            NSDate *date = [[NSDate alloc] init];
            NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
            [dateFormatter setDateFormat:@"yyyy-MM-ddHH:mm:ss"];
            NSString *destDateString = [dateFormatter stringFromDate:date];
            NSString *fileName = [NSString stringWithFormat:@"%@image.png", destDateString];
            [formData appendPartWithFileData:imageData name:@"file" fileName:fileName mimeType:@"image/png"];
            
        }

    } success:^(NSURLSessionDataTask *task, id responseObject) {
        NSNumber *code = responseObject[@"code"];
        
        NSLog(@"responseObject === %@",responseObject);
        if ([code isEqualToNumber:@200]) {
            
            NSDictionary *data = responseObject[@"data"];
            NSUserDefaults *user = [NSUserDefaults standardUserDefaults];
            NSString *avatar = data[@"avatar"];
            [user setValue:avatar forKey:@"avatar"];
            NSString *headUrl =[NSString stringWithFormat:@"%@/%@/%@",BASE_URL,APP_NAME,avatar] ;
            [self.headImage sd_setImageWithURL:[NSURL URLWithString:headUrl] ];
            [user synchronize];

        }
        
        
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        NSLog(@"error = %@",error);
    }];
    
    [[NSUserDefaults standardUserDefaults] setObject:imageData forKey:@"userHead"];
    [picker dismissViewControllerAnimated:YES completion:nil];
    
}

- (UIImage *)imageSize:(UIImage *)image {
    //比例
    CGFloat bili = 0.3;
    CGFloat height = image.size.height *bili;
    CGFloat width = image.size.width *bili;
    CGSize newSize = CGSizeMake(width, height);
    
    UIGraphicsBeginImageContext(newSize);
    [image drawInRect:CGRectMake(0,0,newSize.width,newSize.height)];
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    return newImage;
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    [picker dismissViewControllerAnimated:YES completion:^(){
    }];
}


// 此方法不让section 悬停顶部
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    CGFloat sectionHeaderHeight = 40;
    if (scrollView.contentOffset.y<=sectionHeaderHeight&&scrollView.contentOffset.y>=0) {
        scrollView.contentInset = UIEdgeInsetsMake(-scrollView.contentOffset.y, 0, 0, 0);
    } else if (scrollView.contentOffset.y>=sectionHeaderHeight) {
        scrollView.contentInset = UIEdgeInsetsMake(-sectionHeaderHeight, 0, 0, 0);
    }
}

@end
