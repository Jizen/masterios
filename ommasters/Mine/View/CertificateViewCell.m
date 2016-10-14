//
//  CertificateViewCell.m
//  Opt_master
//
//  Created by 瑞宁科技02 on 16/9/20.
//  Copyright © 2016年 reining. All rights reserved.
//

#import "CertificateViewCell.h"

@implementation CertificateViewCell
+ (instancetype)cellWithTableView:(UITableView *)tableView
{
    static NSString *identifier = @"CertificateViewCell";
    // 1.缓存中取
    CertificateViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    // 2.创建
    if (!cell) {
        cell = [[CertificateViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        
        // 添加子控件
        [self setUpSubViews];
        // 添加约束
        [self addConstraint];
    }
    return self;
}
- (void)setUpSubViews{

    [self.contentView addSubview:self.nameLabel];
    
    [self.contentView addSubview:self.nameTextfield];
    
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
- (void)addConstraint{
    _nameLabel.sd_layout
    .topSpaceToView(self.contentView,0)
    .leftSpaceToView(self.contentView,DEFUALT_MARGIN_SIDES)
    .widthIs(90)
    .bottomEqualToView(self.contentView);
    
    _nameTextfield.sd_layout
    .topSpaceToView(self.contentView,2)
    .leftSpaceToView(self.contentView,80)
    .rightSpaceToView(self.contentView,DEFUALT_MARGIN_SIDES)
    .bottomEqualToView(self.contentView);
}

- (UILabel *)nameLabel{
    if (!_nameLabel ) {
        _nameLabel = [[UILabel alloc] init];
        _nameLabel.textColor = TXT_MAIN_COLOR;
        _nameLabel.font = GZFontWithSize(15);
        _nameLabel.text = @"真实姓名";
    }
    return _nameLabel;
}

- (UITextField *)nameTextfield{
    if (!_nameTextfield) {
        _nameTextfield = [[UITextField alloc] init];
        [_nameTextfield setClearButtonMode:UITextFieldViewModeWhileEditing];//右侧删除按钮
        _nameTextfield.leftViewMode=UITextFieldViewModeAlways;
//        [self.nameTextfield setValue: TXT_MAIN_COLOR forKeyPath:@"placeholderLabel.textColor"];
//        NSMutableDictionary *attrs = [NSMutableDictionary dictionary];
//        attrs[NSForegroundColorAttributeName] = [UIColor redColor];
//        //NSAttributedString:带有属性的文字（叫富文本，可以让你的文字丰富多彩）但是这个是不可变的带有属性的文字，创建完成之后就不可以改变了  所以需要可变的
//        NSMutableAttributedString *placeHolder = [[NSMutableAttributedString alloc]initWithString:@"占位文字" attributes:attrs];
//        _nameTextfield.attributedPlaceholder = placeHolder;
        _nameTextfield.font = GZFontWithSize(15);
        _nameTextfield.clearButtonMode = UITextFieldViewModeAlways;

    }
    return _nameTextfield;
}
@end
