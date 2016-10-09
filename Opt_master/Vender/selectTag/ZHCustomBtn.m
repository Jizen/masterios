//
//  ZHCustomBtn.m
//  CloudCast
//
//  Created by XT on 15/8/24.
//  Copyright (c) 2015年  xiaotu. All rights reserved.
//

#import "ZHCustomBtn.h"


@implementation ZHCustomBtn

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        
        self.leftImgView = [[UIImageView alloc] init];
        self.titleLabel = [[UILabel alloc] init];

        self.leftImgView.image = [UIImage imageNamed:@"unChecked"];
        
        [self addSubview:self.leftImgView];
        [self addSubview:self.titleLabel];
        
        self.titleLabel.font = [UIFont systemFontOfSize:14];
        self.titleLabel.textColor = [UIColor darkGrayColor];
        self.leftImgView.contentMode = UIViewContentModeScaleAspectFit;
        
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(btnDidSelected:)];
        [self addGestureRecognizer:tap];
        
       self.btnSelected = NO;
    }
    return self;
}

- (void)btnDidSelected:(UITapGestureRecognizer *)tap {
    ZHCustomBtn *btn = (ZHCustomBtn *)tap.view;
    if (self.btnOnClick) {
        self.btnOnClick(btn);
    }
}

- (void)setBtnSelected:(BOOL)btnSelected {
    _btnSelected = btnSelected;
    self.leftImgView.image = [UIImage imageNamed:btnSelected ? @"Checked" : @"unChecked"];
}
- (void)layoutSubviews {
    [super layoutSubviews];
    // 图片高度跟字体的高度一致
#pragma clang diagnostic push
#pragma clang diagnostic ignored"-Wdeprecated-declarations"
    CGFloat imgHeight =  [self.titleLabel.text sizeWithFont:[UIFont systemFontOfSize:14]].height;
#pragma clang diagnostic pop
    self.leftImgView.frame = CGRectMake((self.frame.size.height - imgHeight) / 2,
                                        (self.frame.size.height - imgHeight) / 2,
                                        imgHeight , imgHeight);
    self.titleLabel.frame = CGRectMake(CGRectGetMaxX(self.leftImgView.frame) + 5,
                                       0,
                                       self.frame.size.width - self.leftImgView.frame.size.width,
                                       self.frame.size.height);
}

@end
