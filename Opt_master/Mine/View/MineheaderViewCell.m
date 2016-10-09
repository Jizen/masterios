//
//  MineheaderViewCell.m
//  Opt_master
//
//  Created by 瑞宁科技02 on 16/7/11.
//  Copyright © 2016年 reining. All rights reserved.
//

#import "MineheaderViewCell.h"

@implementation MineheaderViewCell

+ (instancetype)cellWithTableView:(UITableView *)tableView
{
    static NSString *identifier = @"MineheaderViewCell";
    // 1.缓存中取
    MineheaderViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    // 2.创建
    if (!cell) {
        cell = [[MineheaderViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    }
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
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
    [self addSubview:self.nameLabel];
    [self addSubview:self.messageLabel];

}
- (void)setMineModel:(MineModel *)mineModel{
    _mineModel = mineModel;
    NSString *headUrl =[NSString stringWithFormat:@"%@/%@",BASE_URL,mineModel.avatar] ;
    [self.headImage sd_setImageWithURL:[NSURL URLWithString:headUrl]];
    
    self.nameLabel.text = mineModel.nickname;
}
- (void)addConstraint{
    self.headImage.sd_layout
    .centerYEqualToView(self)
    .leftSpaceToView(self,DEFUALT_MARGIN_SIDES)
    .widthIs(45)
    .heightIs(45);
    self.headImage.sd_cornerRadiusFromWidthRatio = @(0.5);
    
    self.nameLabel.sd_layout
    .topEqualToView(self.headImage)
    .leftSpaceToView(self.headImage,DEFUALT_MARGIN_SIDES)
    .widthIs(300)
    .heightIs(20);
    
    self.messageLabel.sd_layout
    .bottomEqualToView(self.headImage)
    .leftSpaceToView(self.headImage,DEFUALT_MARGIN_SIDES)
    .rightSpaceToView(self,DEFUALT_MARGIN_SIDES)
    .heightIs(20);
}

- (UIImageView *)headImage{
    if (!_headImage) {
        _headImage = [[UIImageView alloc] init];
        _headImage.image = [UIImage imageNamed:@"head"];
    }
    return _headImage;
}

- (UILabel *)nameLabel{
    if (!_nameLabel) {
        _nameLabel = [[UILabel alloc] init];
        _nameLabel.text = @"Sky";
    }
    return _nameLabel;
}

- (UILabel *)messageLabel{
    if (!_messageLabel) {
        _messageLabel = [[UILabel alloc] init];
        _messageLabel.font = GZFontWithSize(14);
        _messageLabel.textColor = TXT_COLOR;
        _messageLabel.text = @"查看或编辑个人资料";
    }
    return _messageLabel;
}
@end
