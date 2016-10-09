//
//  QuestionCell.m
//  Opt_master
//
//  Created by 瑞宁科技02 on 16/7/11.
//  Copyright © 2016年 reining. All rights reserved.
//

#import "QuestionCell.h"
#import "UIImageView+WebCache.h"
#import "CompareTime.h"
#import "SDWeiXinPhotoContainerView.h"


#define kSpace 10
#define imgWidth ([UIScreen mainScreen].bounds.size.width-20-75)/3//高宽相等

@implementation QuestionCell

+ (instancetype)cellWithTableView:(UITableView *)tableView
{
    static NSString *identifier = @"myQuestionCell";
    // 1.缓存中取
    QuestionCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    // 2.创建
    if (!cell) {
        cell = [[QuestionCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        // 添加子控件
        [self setUpSubViews];
        // 添加约束
        [self addConstraint];
    }
    return self;
}

- (void)setUpSubViews{
    [self addSubview:self.questionLabel];
    [self addSubview:self.tagImage];
    [self addSubview:self.tagLabel];
    [self addSubview:self.timeLabel];
    self.picContainerView = [[SDWeiXinPhotoContainerView alloc] initWithFrame:CGRectMake(30, 40, kWidth-30, 100)];
    [self addSubview:self.picContainerView];

    [self addSubview:self.headImage];
    [self addSubview:self.nameLabel];
    [self addSubview:self.answerImage];
    [self addSubview:self.numberLabel];
    [self addSubview:self.answerBtn];
    self.backView = [[UIView alloc] init];
    self.backView.userInteractionEnabled = YES;
    [self addSubview:self.backView];
    
    


    
    
    
    
}

- (void)setModel:(QuestionModel *)model{
    _model = model;
    
    NSLog(@"tupian = %@",model.images);
    self.questionLabel.text = model.title;
    
    NSUserDefaults *user = [NSUserDefaults standardUserDefaults];
    NSString *avatar = [user valueForKey:@"avatar"];
    NSString *nickname = [user valueForKey:@"nickname"];
    
    
    NSString *baseUrl = [user objectForKey:@"baseUrl"];
    NSString *appName = [user objectForKey:@"appname"];
    
    NSString *headUrl =[NSString stringWithFormat:@"%@%@/%@",baseUrl,appName,avatar] ;
    [self.headImage sd_setImageWithURL:[NSURL URLWithString:headUrl] placeholderImage:[UIImage imageNamed:@"head"]];
    NSDate *currentTime = [NSDate dateWithTimeIntervalSince1970:[model.createdon intValue]];    
    NSString *time2 = [CompareTime comparesCurrentTime:currentTime ];
    self.timeLabel.text = time2;

    self.tagLabel.text = model.tags;
    self.nameLabel.text = model.author[@"nickname"];
    
    self.numberLabel.text = model.replynum;
    NSArray *tags;
    if ( model.images.length == 0) {
        
    }else{
        tags = [ model.images componentsSeparatedByString:@","];
    }

    if (model.images.length != 0) {
//        [self imageViewWithImg:model.images];

    }
    
    NSInteger imgH;
    if (model.images.length == 0) {
        
        self.views.sd_layout
        .topSpaceToView(self.questionLabel,0)
        .leftSpaceToView(self,50)
        .widthIs(287)
        .heightIs(0);
        imgH = 0;
        
        self.timeLabel.sd_layout
        .topSpaceToView(self.picContainerView,DEFUALT_MARGIN_SIDES)
        .leftSpaceToView(self,DEFUALT_MARGIN_SIDES)
        .heightIs(15);
        [self.timeLabel setSingleLineAutoResizeWithMaxWidth:[UIScreen mainScreen].bounds.size.width];
        
        

        
    }else{
        NSInteger imgcount = [model.images componentsSeparatedByString:@","].count;
        NSLog(@"imgcount = %ld",(long)imgcount);
        if (imgcount == 1) {

            
            self.timeLabel.sd_layout
            .topSpaceToView(self.questionLabel,100)
            .leftSpaceToView(self,DEFUALT_MARGIN_SIDES)
            .heightIs(15);
            [self.timeLabel setSingleLineAutoResizeWithMaxWidth:[UIScreen mainScreen].bounds.size.width];

        }else{
            imgH = (10+imgWidth)*(imgcount/4+1);
            
            
            self.views.sd_layout
            .topSpaceToView(self.questionLabel,DEFUALT_MARGIN_SIDES)
            .leftSpaceToView(self,50)
            .widthIs(287)
            .heightIs(imgH);
            
            
            self.timeLabel.sd_layout
            .topSpaceToView(self.picContainerView,DEFUALT_MARGIN_SIDES)
            .leftSpaceToView(self,DEFUALT_MARGIN_SIDES)
            .heightIs(15);
            [self.timeLabel setSingleLineAutoResizeWithMaxWidth:[UIScreen mainScreen].bounds.size.width];

        }
        
    }
    self.tagImage.sd_layout
    .centerYEqualToView(self.timeLabel)
    .leftSpaceToView(self.timeLabel,DEFUALT_MARGIN_SIDES)
    .widthIs(12)
    .heightIs(12);
    
    self.tagLabel.sd_layout
    .topEqualToView(self.timeLabel)
    .leftSpaceToView(self.tagImage,5)
    .heightIs(15);
    [self.tagLabel setSingleLineAutoResizeWithMaxWidth:[UIScreen mainScreen].bounds.size.width];
    
    self.sepLine.sd_layout
    .topSpaceToView(self.tagImage,DEFUALT_MARGIN_SIDES)
    .leftSpaceToView(self,DEFUALT_MARGIN_SIDES)
    .rightSpaceToView(self,DEFUALT_MARGIN_SIDES)
    .heightIs(0.5);
    
    
    
    
    self.answerBtn.sd_layout
    .topSpaceToView(self.timeLabel,3)
    .rightSpaceToView(self.contentView,0)
    .widthIs(70)
    .heightIs(40);
    
    self.verticalLine.sd_layout
    .topSpaceToView(self.sepLine,DEFUALT_MARGIN_SIDES)
    .rightSpaceToView(self.answerBtn,5)
    .widthIs(0.5)
    .heightIs(20);
    
    self.headImage.sd_layout
    .centerYEqualToView(self.answerBtn)
    .leftSpaceToView(self,DEFUALT_MARGIN_SIDES)
    .widthIs(20)
    .heightIs(20);
    self.headImage.sd_cornerRadiusFromHeightRatio = @(0.5); // 设置view0的圆角半径为自身高度的0.5倍
    
    
    
    self.nameLabel.sd_layout
    .centerYEqualToView(self.answerBtn)
    .leftSpaceToView(self.headImage,DEFUALT_MARGIN_SIDES)
    .widthIs(100)
    .heightIs(20);
    
    
    self.numberLabel.sd_layout
    .centerYEqualToView(self.answerBtn)
    .rightSpaceToView(self.answerBtn,5)
    .heightIs(20);
    [self.numberLabel setSingleLineAutoResizeWithMaxWidth:[UIScreen mainScreen].bounds.size.width];
    
    self.answerImage.sd_layout
    .centerYEqualToView(self.answerBtn)
    .rightSpaceToView(self.numberLabel,5)
    .widthIs(14)
    .heightIs(14);
    
    
    self.backView.backgroundColor = [UIColor clearColor];
    self.backView.sd_layout
    .topSpaceToView(self.tagLabel,DEFUALT_MARGIN_SIDES)
    .leftEqualToView(self)
    .bottomEqualToView(self)
    .rightEqualToView(self.nameLabel);
//    
    NSLog(@"ttttt = %@",model.images);
    _picContainerView.picPathStringsArray = tags;
    CGFloat picContainerTopMargin = 0;
    if (tags.count) {
        picContainerTopMargin = 10;
    }
    _picContainerView.sd_layout.topSpaceToView(_questionLabel, picContainerTopMargin);
//    [self setupAutoHeightWithBottomView:_nameLabel bottomMargin:15];



}
//发表的图片
-(void)imageViewWithImg:(NSString*)imgName{
    if (imgName.length !=  0) {
        NSArray *imgs = [imgName componentsSeparatedByString:@","];
        for (NSInteger i=0;i<imgs.count;i++) {
            UIImageView *imageView = [[UIImageView alloc]initWithFrame:CGRectMake((kSpace+imgWidth)*(i%3),(kSpace+imgWidth)*(i/3), imgWidth, imgWidth)];
            NSUserDefaults *user = [NSUserDefaults standardUserDefaults];
            NSString *avatar = [user valueForKey:@"avatar"];
            
            NSString *baseUrl = [user objectForKey:@"baseUrl"];
            NSString *appName = [user objectForKey:@"appname"];
            
            NSString *headUrl =[NSString stringWithFormat:@"%@%@/%@",baseUrl,appName,avatar] ;
            [imageView sd_setImageWithURL:[NSURL URLWithString:headUrl] placeholderImage:[UIImage imageNamed:@"head"] ];
            imageView.contentMode = UIViewContentModeScaleAspectFill;
            imageView.userInteractionEnabled = YES;
            imageView.tag = i;
            UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapAction:)];
            [imageView addGestureRecognizer:tap];
            [self.views addSubview:imageView];
        }

    }
   
}
-(void)tapAction:(UITapGestureRecognizer*)tap{
    
    NSArray *imgs = [_model.images componentsSeparatedByString:@","];
    NSUserDefaults *user = [NSUserDefaults standardUserDefaults];
    NSString *baseUrl = [user objectForKey:@"baseUrl"];
    NSString *appName = [user objectForKey:@"appname"];
    
    [self.myDelegate checkImage:[NSString stringWithFormat:@"%@%@%@",baseUrl,appName,imgs[tap.view.tag]]];
}
- (void)addConstraint{
    self.questionLabel.sd_layout
    .topSpaceToView(self,DEFUALT_MARGIN_SIDES)
    .leftSpaceToView(self,DEFUALT_MARGIN_SIDES)
    .rightSpaceToView(self,DEFUALT_MARGIN_SIDES)
    .heightIs(20);

    
}
- (UIView *)views{
    if (!_views) {
        _views = [[UIView alloc] init];
    }
    return _views;
}

- (UILabel *)questionLabel{
    if (!_questionLabel) {
        _questionLabel = [[UILabel alloc] init];
        _questionLabel.textColor = TXT_MAIN_COLOR;
        _questionLabel.text = @"怎么解决手机总死机问题？";
    }
    return _questionLabel;
}
- (UIImageView *)tagImage{
    if (!_tagImage) {
        _tagImage = [[UIImageView alloc] init];
        _tagImage.image =[UIImage imageNamed:@"tag-three"];
    }
    return _tagImage;
}
- (UILabel *)tagLabel
{
    if (!_tagLabel) {
        _tagLabel = [[UILabel alloc] init];
        _tagLabel.textColor = TXT_COLOR;
        _tagLabel.font = GZFontWithSize(12);
        _tagLabel.text = @"网络·信息安全";
    }
    return _tagLabel;
}

- (UILabel *)timeLabel{
    if (!_timeLabel) {
        _timeLabel = [[UILabel alloc] init];
        _timeLabel.textColor = TXT_COLOR;
        _timeLabel.font = GZFontWithSize(12);
        _timeLabel.text = @"一天前";
    }
    return _timeLabel;
}

- (UIView *)sepLine{
    if (!_sepLine) {
        _sepLine = [[UIView alloc] init];
        _sepLine.backgroundColor = UIColorARGB(1, 250, 246, 246);
    }
    return _sepLine;
}

- (UIImageView *)headImage{
    if (!_headImage) {
        _headImage = [[UIImageView alloc] init];
        _headImage.userInteractionEnabled = YES;
        _headImage.image = [UIImage imageNamed:@"head"];
    }
    return _headImage;
}

-(UILabel *)nameLabel{
    if (!_nameLabel) {
        _nameLabel = [[UILabel alloc] init];
        _nameLabel.userInteractionEnabled = YES;
        _nameLabel.text = @"skytoo";
        _nameLabel.textColor = TXT_COLOR;
        _nameLabel.font = GZFontWithSize(13);

    }
    return _nameLabel;
}

- (UIImageView *)answerImage{
    if (!_answerImage) {
        _answerImage = [[UIImageView alloc] init];
        _answerImage.image = [UIImage imageNamed:@"reading-big"];
    }
    return _answerImage;
}

- (UILabel *)numberLabel{
    if (!_numberLabel) {
        _numberLabel = [[UILabel alloc] init];
        _numberLabel.text = @"4378";
        _numberLabel.font = GZFontWithSize(12);
        _numberLabel.textColor = TXT_COLOR;

    }
    return _numberLabel;
}

- (UIButton *)answerBtn{
    if (!_answerBtn) {
        _answerBtn = [UIButton buttonWithType:(UIButtonTypeCustom)];
        [_answerBtn setTitle:@"回答" forState:(UIControlStateNormal)];
        [_answerBtn setTitleColor:PRIMARY_COLOR forState:(UIControlStateNormal)];
        _answerBtn.titleLabel.font = GZFontWithSize(12);
        [_answerBtn setImageEdgeInsets:UIEdgeInsetsMake(0, 0, 0, 10)];
        [_answerBtn setTitleEdgeInsets:UIEdgeInsetsMake(0, 10, 0, 10)];
        [_answerBtn setImage:[UIImage imageNamed:@"write"] forState:(UIControlStateNormal)];
    }
    return _answerBtn;
}

-(UIView *)verticalLine{
    if (!_verticalLine) {
        _verticalLine = [[UIView alloc] init];
        _verticalLine.backgroundColor = UIColorARGB(1, 250, 246, 246);
    }
    return _verticalLine;
}

- (UIView *)verticalLineOne{
    if (!_verticalLineOne) {
        _verticalLineOne = [[UIView alloc] init];
        _verticalLineOne.backgroundColor = UIColorARGB(1, 250, 246, 246);
    }
    return _verticalLineOne;
}

- (void)drawRect:(CGRect)rect
{
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(context, [UIColor clearColor].CGColor);
    CGContextFillRect(context, rect);
    //上分割线，
    CGContextSetStrokeColorWithColor(context, SEPARATOR_LINE_COLOR.CGColor);
    CGContextStrokeRect(context, CGRectMake(0, -0.5, rect.size.width , 0));
    //下分割线
    CGContextSetStrokeColorWithColor(context, SEPARATOR_LINE_COLOR.CGColor);
    CGContextStrokeRect(context, CGRectMake(0, rect.size.height, rect.size.width , 1));
}
@end
