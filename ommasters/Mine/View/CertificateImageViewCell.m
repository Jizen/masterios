//
//  CertificateImageViewCell.m
//  Opt_master
//
//  Created by 瑞宁科技02 on 16/9/20.
//  Copyright © 2016年 reining. All rights reserved.
//

#import "CertificateImageViewCell.h"

@implementation CertificateImageViewCell
+ (instancetype)cellWithTableView:(UITableView *)tableView
{
    static NSString *identifier = @"CertificateImageViewCell";
    // 1.缓存中取
    CertificateImageViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    // 2.创建
    if (!cell) {
        cell = [[CertificateImageViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}
-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self setupView];
        [self addConstraint];
    }
    return self;
}


- (void)setupView{
    [self.contentView addSubview:self.leftImage];
    [self.contentView addSubview:self.rightImage];

}

- (void)addConstraint{
    _leftImage.sd_layout
    
    .topSpaceToView(self.contentView ,DEFUALT_MARGIN_SIDES/2)
    .leftSpaceToView(self.contentView ,DEFUALT_MARGIN_SIDES)
    .bottomSpaceToView(self.contentView ,DEFUALT_MARGIN_SIDES/2)
//    .centerYEqualToView(self.contentView)
//    .heightIs(85)
    .widthIs((kWidth - 3*DEFUALT_MARGIN_SIDES)/2);
    
    
    _rightImage.sd_layout
    .topSpaceToView(self.contentView ,DEFUALT_MARGIN_SIDES/2)
    .leftSpaceToView(self.leftImage ,DEFUALT_MARGIN_SIDES)
    .bottomSpaceToView(self.contentView ,DEFUALT_MARGIN_SIDES/2)
//    .centerYEqualToView(self.contentView)
//    .heightIs(85)
    .rightSpaceToView(self.contentView ,DEFUALT_MARGIN_SIDES);
}

- (UIImageView *)leftImage{
    if (!_leftImage) {
        _leftImage = [[UIImageView alloc] init];
        _leftImage.userInteractionEnabled = YES;
        _leftImage.clipsToBounds = YES;

        _leftImage.contentMode =  UIViewContentModeScaleAspectFill;
    }
    return _leftImage;
}

- (UIImageView *)rightImage{
    if (!_rightImage) {
        _rightImage = [[UIImageView alloc] init];
        _rightImage.userInteractionEnabled = YES;
        _rightImage.clipsToBounds = YES;

        _rightImage.contentMode =  UIViewContentModeScaleAspectFill;


    }
    return _rightImage;
}
@end
