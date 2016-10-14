//
//  SubmitQuestionViewController.m
//  Opt_master
//
//  Created by 瑞宁科技02 on 16/7/11.
//  Copyright © 2016年 reining. All rights reserved.
//

#import "SubmitQuestionViewController.h"
#import "QuestionDetailViewController.h"
#import "Label_textField.h"
#import "PlaceholderTextView.h"
#import "HttpTool.h"
#import "QuestionModel.h"
#import "PhotoCollectionViewCell.h"

#import "MKComposePhotosView.h"
#import "MKMessagePhotoView.h"
#import "TZImagePickerController.h"
#define WeakSelf(weakSelf)  __weak __typeof(&*self)weakSelf = self;
#define kMaxInputLimitLength 300
#define kBottomViewH 80
#define kMaxImageCount 9
#define KWIDTH [UIScreen mainScreen].bounds.size.width
@interface SubmitQuestionViewController ()<UITextViewDelegate,UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout,UIImagePickerControllerDelegate,UINavigationControllerDelegate,MKMessagePhotoViewDelegate,TZImagePickerControllerDelegate>
@property (nonatomic, strong) MKMessagePhotoView *photosView;
@property (nonatomic, strong) PlaceholderTextView * textView;
@property (nonatomic, strong) PlaceholderTextView * addTextView;
@property (nonatomic ,strong)Label_textField *titleTF;
@property (nonatomic ,strong)Label_textField *descriptionTF;
@property (nonatomic ,strong)UIView *backView;
//字数的限制
@property (nonatomic, strong)UILabel *wordCountLabel;
@property (nonatomic, strong)UITextField *textField;
@property (nonatomic ,strong)QuestionModel *questionModel;

@property (nonatomic, strong) UIView * aView;

@property (nonatomic, strong)UICollectionView *collectionV;
//上传图片的个数
@property (nonatomic, strong)NSMutableArray *photoArrayM;
@property (nonatomic, strong)UIButton *photoBtn;
@property (nonatomic ,strong) MBProgressHUD *hud;

@end

@implementation SubmitQuestionViewController
- (NSMutableArray *)photoArrayM{
    if (!_photoArrayM) {
        _photoArrayM = [NSMutableArray arrayWithCapacity:0];
    }
    return _photoArrayM;
}
#pragma mark - lazy
-(PlaceholderTextView *)textView{
    if (!_textView) {
        _textView = [[PlaceholderTextView alloc]initWithFrame:CGRectMake(DEFUALT_MARGIN_SIDES, 75, kWidth-2*DEFUALT_MARGIN_SIDES , 70)];
        _textView.backgroundColor = [UIColor whiteColor];
        _textView.delegate = self;
        _textView.font = [UIFont systemFontOfSize:14.f];
        _textView.textColor = [UIColor blackColor];
        _textView.textAlignment = NSTextAlignmentLeft;
        _textView.editable = YES;
        _textView.tag = 1001;
        _textView.tintColor = PRIMARY_COLOR;
        _textView.placeholderColor = TXT_COLOR;
        _textView.placeholder = @"问题标题[字数限制5~50字]";
    }
    return _textView;
}
-(PlaceholderTextView *)addTextView{
    if (!_addTextView) {
        _addTextView = [[PlaceholderTextView alloc]initWithFrame:CGRectMake(DEFUALT_MARGIN_SIDES,120+65,kWidth-2*DEFUALT_MARGIN_SIDES  , 90)];
        _addTextView.backgroundColor = [UIColor whiteColor];
        _addTextView.delegate = self;
        _addTextView.tag = 1002;
        _addTextView.tintColor = PRIMARY_COLOR;
        _addTextView.font = [UIFont systemFontOfSize:14.f];
        _addTextView.textColor = [UIColor blackColor];
        _addTextView.textAlignment = NSTextAlignmentLeft;
        _addTextView.editable = YES;
        _addTextView.placeholderColor = TXT_COLOR;
        _addTextView.placeholder = @"问题描述[可选]";
    }
    return _addTextView;
}
- (Label_textField *)titleTF{
    if (!_titleTF) {
        _titleTF = [[Label_textField alloc] init];
    }
    return _titleTF;
}
- (Label_textField *)descriptionTF{
    if (!_descriptionTF) {
        _descriptionTF = [[Label_textField alloc] init];
    }
    return _descriptionTF;
}
-(UIView *)backView{
    if (!_backView) {
        _backView = [[UIView alloc] init];
        _backView.backgroundColor = BG;
    }
    return _backView;
}

#pragma mark - basic


-(void)viewWillAppear:(BOOL)animated{
    if (self.photoArrayM.count < 5) {
        
        [self.collectionV reloadData];
        _aView.frame = CGRectMake(20, 20+64, self.view.frame.size.width - 40, 180);
        self.photoBtn.frame = CGRectMake(10 * (self.photoArrayM.count + 1) + (self.view.frame.size.width - 60) / 5 * self.photoArrayM.count, 350, (self.view.frame.size.width - 60) / 5, (self.view.frame.size.width - 60) / 5 + 5);
    }else{
        [self.collectionV reloadData];
        self.photoBtn.frame = CGRectMake(0, 0, 0, 0);
        
    }
    [super viewWillAppear:animated];
    self.navigationController.navigationBarHidden = YES;
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(test:) name:@"test" object:nil];

}
- (void)test:(NSNotification *)notification{
    [self.photoArrayM addObject:notification.object];
    [self.collectionV reloadData];

}
- (void)viewDidLoad {
    [super viewDidLoad];
    [self createNavBar];
    self.view.backgroundColor = [UIColor whiteColor];
    [self setupView];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(test) name:@"callBackKeyboard" object:nil];
    UITapGestureRecognizer *tapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(keyboardHide:)];
    tapGestureRecognizer.cancelsTouchesInView = NO;
    [self.view addGestureRecognizer:tapGestureRecognizer];
}
-(void)keyboardHide:(UITapGestureRecognizer*)tap{
    [self.textView resignFirstResponder];
    [self.addTextView resignFirstResponder];
}
- (void)test{
    [self.textView resignFirstResponder];
    [self.addTextView resignFirstResponder];
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
//    backBtn.titleLabel.font = GZFontWithSize(18);
    [backBtn addTarget:self action:@selector(CancelAnswerForQuestion) forControlEvents:UIControlEventTouchUpInside];
    [navBar addSubview:backBtn];
    
    
    UIButton *backBtn1 = [UIButton buttonWithType:UIButtonTypeSystem];
    backBtn1.frame = CGRectMake(kWidth - 60, 20, 60, 44);
    [backBtn1 setTitleColor:PRIMARY_COLOR forState:UIControlStateNormal];
    [backBtn1 setTitle:@"提交" forState:UIControlStateNormal];
//    backBtn1.titleLabel.font = GZFontWithSize(18);
    [backBtn1 addTarget:self action:@selector(commitAction) forControlEvents:UIControlEventTouchUpInside];
    [navBar addSubview:backBtn1];
    
    UIView *line = [[UIView alloc] initWithFrame:CGRectMake(0, 63.5, kWidth, 0.5)];
    line.backgroundColor = SEPARATOR_LINE_COLOR;
    [navBar addSubview:line];
}
- (void)setupView{
    
    self.aView = [[UIView alloc]init];
    _aView.backgroundColor = [UIColor whiteColor];
    _aView.frame = CGRectMake(20, 20+64, self.view.frame.size.width - 40, 180);
    [self.view addSubview:_aView];

    [self.view addSubview:self.textView];
    [self.view addSubview:self.addTextView];
    self.wordCountLabel = [[UILabel alloc]initWithFrame:CGRectMake(0,  160, [UIScreen mainScreen].bounds.size.width - 20, 15)];
    _wordCountLabel.font = [UIFont systemFontOfSize:14.f];
    _wordCountLabel.textColor = [UIColor lightGrayColor];
    self.wordCountLabel.text = @"0/50";
    self.wordCountLabel.backgroundColor = [UIColor whiteColor];
    self.wordCountLabel.textAlignment = NSTextAlignmentRight;
    [self.view addSubview:_wordCountLabel];
    UIView *line = [[UIView alloc] initWithFrame:CGRectMake(0,  self.textView.frame.size.height -50, [UIScreen mainScreen].bounds.size.width - 0, 0.5)];
    line.backgroundColor = [UIColor lightGrayColor];
    [self.wordCountLabel addSubview:line];
    self.automaticallyAdjustsScrollViewInsets = NO;
    [self addLabelText];

    [self setUpPhotosView];

}



#pragma mark -相册视图
-(void)setUpPhotosView
{
    if (!self.photosView)
    {
        
        self.photosView = [[MKMessagePhotoView alloc]initWithFrame:CGRectMake(0,250,KWIDTH, 80)];
        [self.view addSubview:self.photosView];
        
        self.photosView.delegate = self;
        
    }
    
    
}

//实现代理方法
-(void)addPicker:(UIImagePickerController *)picker{
    
    [self presentViewController:picker animated:YES completion:nil];
}

//实现代理方法
-(void)addPickers:(UIImagePickerController *)picker{
    
    [self presentViewController:picker animated:YES completion:nil];
}


-(void)addUIImagePicker:(UIImagePickerController *)picker{
    
    [self presentViewController:picker animated:YES completion:nil];
    self.modalPresentationStyle = UIModalPresentationOverCurrentContext;
}


///填写意见
-(void)addLabelText{
    UILabel * labelText = [[UILabel alloc] init];
    labelText.text = @"问题截图[可选]";
    labelText.frame = CGRectMake(10, 320+2*DEFUALT_MARGIN_SIDES*kHeight/667,[UIScreen mainScreen].bounds.size.width - 20, 20);
    labelText.font = [UIFont systemFontOfSize:14.f];
    labelText.textColor = _textView.placeholderColor;
    [self.view addSubview:labelText];
    
    
}
-(void)picureUpload:(UIButton *)sender{
    
    UIImagePickerController *picker=[[UIImagePickerController alloc]init];
    picker.sourceType=UIImagePickerControllerSourceTypePhotoLibrary;
    picker.mediaTypes=[UIImagePickerController availableMediaTypesForSourceType:picker.sourceType];
    picker.allowsEditing=YES;
    picker.delegate=self;
    [self presentViewController:picker animated:YES completion:nil];
    
}
#pragma mark - delegate
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info
{
    UIImage *image=[info objectForKey:UIImagePickerControllerEditedImage];
    [self.photoArrayM addObject:image];
    //选取完图片之后关闭视图
    [self dismissViewControllerAnimated:YES completion:nil];
}


#pragma mark textField的字数限制
//在这个地方计算输入的字数
- (void)textViewDidChange:(UITextView *)textView
{
    if (textView.tag == 1001) {
    NSInteger wordCount = textView.text.length;
    self.wordCountLabel.text = [NSString stringWithFormat:@"%ld/50",(long)wordCount];
    [self wordLimit:textView];
    }
}
- (void)textViewDidBeginEditing:(UITextView *)textView{
    if (textView.tag == 1001) {
        [self.textView becomeFirstResponder];

    }else if (textView.tag == 1002){
        [self.addTextView becomeFirstResponder];
    }

}
//把回车键当做退出键盘的响应键  textView退出键盘的操作
- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{
    if ([@"\n" isEqualToString:text] == YES)
    {
        [textView resignFirstResponder];
        return NO;
    }
    return YES;
}
#pragma mark 超过300字不能输入
-(BOOL)wordLimit:(UITextView *)text{
    if (text.text.length < 50) {
        self.textView.editable = YES;
        _wordCountLabel.textColor = [UIColor lightGrayColor];
    }else{
        _wordCountLabel.textColor = [UIColor redColor];
    }
    return nil;
}

#pragma mark - action
-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    [_textView resignFirstResponder];
    [_textField resignFirstResponder];
}
- (void)answerForQuestion{
}
- (void)CancelAnswerForQuestion{
    [self.textView resignFirstResponder];
    [self.addTextView resignFirstResponder];
    [self dismissViewControllerAnimated:YES completion:nil];
   
}
- (void)commitAction{

    [self.textView resignFirstResponder];
    [self.addTextView resignFirstResponder];
    
    if (self.textView.text.length < 5 || self.textView.text.length>50) {
        [self hudWithTitle:@"问题字数限制在5~50字之间"];
    }else{

        [self setupProgressHud];

        NSDictionary *topic = @{
            @"content": self.addTextView.text,
            @"title": self.textView.text,
            @"tags"  : @"标签",
            };
        // －－－－－－－－－－－－－－－－－－－－－－－－－－－－上传图片－－－－
        
        [[HttpTool shareManager] POST:URL_TOPIC_NEW parameters:topic constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
            
            if (self.photosView.array.count == 0) {
                
            }else{
            for (int i = 0; i < self.photosView.array.count; i++) {
                UIImage *image = self.photosView.array[i];
                
                NSLog(@"URL_TOPIC_NEW - imgae = %@",image);
                NSData *imageData = UIImageJPEGRepresentation(image, 0.006);
                NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
                // 设置时间格式
                [formatter setDateFormat:@"yyyyMMddHHmmss"];
                NSString *dateString = [formatter stringFromDate:[NSDate date]];
                NSString *fileName = [NSString  stringWithFormat:@"%@.png", dateString];
                
                [formData appendPartWithFileData:imageData name:@"file" fileName:fileName mimeType:@"image/png"]; //
            }
            }
            
        } success:^(NSURLSessionDataTask *task, id responseObject) {
            NSLog(@"URL_TOPIC_NEW = responseObject = %@",responseObject);
            [self.hud hideAnimated:YES];
            NSDictionary *data = responseObject[@"data"];
            NSError* err=nil;
            QuestionModel *model = [[QuestionModel alloc]initWithDictionary:data error:&err];
            QuestionDetailViewController *detail = [[QuestionDetailViewController alloc] init];
            detail.model = model;
            
            self.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:detail animated:YES];

            
        } failure:^(NSURLSessionDataTask *task, NSError *error) {
        }];
        
    }
}

- (void)setupProgressHud
{
    self.hud = [[MBProgressHUD alloc] initWithView:self.view] ;
    self.hud.label.text=@"正在提交...";
    _hud.frame = self.view.bounds;
    _hud.minSize = CGSizeMake(100, 100);
    _hud.mode = MBProgressHUDModeIndeterminate;
    [self.view addSubview:_hud];
    [_hud showAnimated:YES];
}
#pragma mark 上传图片UIcollectionView
-(void)addCollectionViewPicture{
    //创建一种布局
    UICollectionViewFlowLayout *flowL = [[UICollectionViewFlowLayout alloc]init];
    //设置每一个item的大小
    flowL.itemSize = CGSizeMake((self.view.frame.size.width - 60) / 5 , (self.view.frame.size.width - 60) / 5 );
    flowL.sectionInset = UIEdgeInsetsMake(5, 10, 5, 10);
    //列
    flowL.minimumInteritemSpacing = 10;
    //行
    flowL.minimumLineSpacing = 10;
    //创建集合视图
    self.collectionV = [[UICollectionView alloc]initWithFrame:CGRectMake(0, 350, self.view.frame.size.width, ([UIScreen mainScreen].bounds.size.width - 60) / 5 + 10) collectionViewLayout:flowL];
    _collectionV.backgroundColor = [UIColor whiteColor];
    // NSLog(@"-----%f",([UIScreen mainScreen].bounds.size.width - 60) / 5);
    _collectionV.delegate = self;
    _collectionV.dataSource = self;
    //添加集合视图
    [self.view addSubview:_collectionV];
    
    //注册对应的cell
    [_collectionV registerClass:[PhotoCollectionViewCell class] forCellWithReuseIdentifier:@"cell"];
    
}


#pragma mark CollectionView DataSource
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    if (_photoArrayM.count == 0) {
        return 0;
    }
    else{
        return _photoArrayM.count;
    }
}

//返回每一个cell
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    PhotoCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"cell" forIndexPath:indexPath];
    
    [cell.deleBt addTarget:self action:@selector(delePhoto:) forControlEvents:UIControlEventTouchUpInside];
    
    cell.deleBt.tag  = indexPath.row;
    cell.photoV.image = self.photoArrayM[indexPath.item];
    return cell;
}
- (void)delePhoto:(UIButton *)btn{
    [self.photoArrayM removeObjectAtIndex:btn.tag];
    [self.collectionV reloadData];
    
    if (self.photoArrayM.count < 5) {
        
        [self.collectionV reloadData];
        self.photoBtn.frame = CGRectMake(10 * (self.photoArrayM.count + 1) + (self.view.frame.size.width - 60) / 5 * self.photoArrayM.count, 350, (self.view.frame.size.width - 60) / 5, (self.view.frame.size.width - 60) / 5 + 5);
    }else{
        [self.collectionV reloadData];
        self.photoBtn.frame = CGRectMake(10 * (self.photoArrayM.count -5 + 1) + (self.view.frame.size.width - 60) / 5 * self.photoArrayM.count, 350 + (self.view.frame.size.width - 60) / 5, (self.view.frame.size.width - 60) / 5, (self.view.frame.size.width - 60) / 5 + 5);
    }
    self.navigationController.navigationBarHidden = YES;
    
    
}


#pragma mark - public
- (void)hudWithTitle:(NSString *)title
{
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
    hud.mode = MBProgressHUDModeText;
    hud.label.text = title;
    [hud hideAnimated:YES afterDelay:1.f];
}

@end
