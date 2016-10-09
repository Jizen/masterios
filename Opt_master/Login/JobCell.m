//
//  JobCell.m
//  Opt_master
//
//  Created by 瑞宁科技02 on 16/7/21.
//  Copyright © 2016年 reining. All rights reserved.
//

#import "JobCell.h"

@implementation JobCell

+ (instancetype)cellWithTableView:(UITableView *)tableView
{
    static NSString *identifier = @"JobCell";
    // 1.缓存中取
    JobCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    // 2.创建
    if (!cell) {
        cell = [[JobCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    }
//    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
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
    [self addSubview:self.headImage];
    [self addSubview:self.jobLabel];
    [self addSubview:self.yearImage];
    [self addSubview:self.yearLabel];

}
- (void)addConstraint{
    __weak __typeof(self) weakSelf = self;
    self.headImage.sd_layout
    .leftSpaceToView(weakSelf,DEFUALT_MARGIN_SIDES)
    .widthIs(23)
    .heightIs(23)
    .centerYEqualToView(weakSelf);
    self.headImage.sd_cornerRadiusFromHeightRatio = @(0.5); // 设置view0的圆角半径为自身高度的0.5倍


    self.jobLabel.sd_layout
    .leftSpaceToView(self.headImage,DEFUALT_MARGIN_SIDES)
    .rightSpaceToView(self,kWidth/2-76)
    .heightIs(23)
    .centerYEqualToView(weakSelf);
    

    
    self.yearLabel.sd_layout
    .rightSpaceToView(weakSelf,DEFUALT_MARGIN_SIDES)
    .leftSpaceToView(self.jobLabel,DEFUALT_MARGIN_SIDES)
    .heightIs(23)
    .centerYEqualToView(weakSelf);
    
    
    self.yearImage.sd_layout
    .rightSpaceToView(self.yearLabel,DEFUALT_MARGIN_SIDES)
    .widthIs(23)
    .heightIs(23)
    .centerYEqualToView(weakSelf);
}

- (UIImageView *)headImage{
    if (!_headImage) {
        _headImage = [[UIImageView alloc] init];
        _headImage.image = [UIImage imageNamed:@"head-green"];
    }
    return _headImage;
}

- (UILabel *)jobLabel{
    if (!_jobLabel) {
        _jobLabel = [[UILabel alloc] init];
        _jobLabel.text = @"数据库专家";
        _jobLabel.font = GZFontWithSize(14);
        _jobLabel.textColor = TXT_MAIN_COLOR;
    }
    return _jobLabel;
}

- (UIImageView *)yearImage{
    if (!_yearImage) {
        _yearImage = [[UIImageView alloc] init];
        _yearImage.image = [UIImage imageNamed:@"year-green"];
    }
    return _yearImage;
}


- (UILabel *)yearLabel{
    if (!_yearLabel) {
        _yearLabel = [[UILabel alloc] init];
        _yearLabel.text = @"8年";
        _yearLabel.font = GZFontWithSize(14);
        _yearLabel.textColor = TXT_MAIN_COLOR;
    }
    return _yearLabel;
}
@end
