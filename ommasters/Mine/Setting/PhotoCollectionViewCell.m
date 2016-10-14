//
//  PhotoCollectionViewCell.m
//  wyh
//
//  Created by ShiQin on 16/1/18.
//  Copyright © 2016年 HW. All rights reserved.
//

#import "PhotoCollectionViewCell.h"

@implementation PhotoCollectionViewCell

//懒加载创建数据
-(UIImageView *)photoV{
    if (_photoV == nil) {
        self.photoV = [[UIImageView alloc]initWithFrame:self.bounds];
    }
    return _photoV;
}

//创建自定义cell时调用该方法
- (instancetype)initWithFrame:(CGRect)frame{

    self = [super initWithFrame:frame];
    if (self) {
        [self.contentView addSubview:self.photoV];
        
        
        _deleBt = [UIButton buttonWithType:UIButtonTypeCustom];
        _deleBt.frame = CGRectMake(frame.size.width-5, -5, 10, 10);
        [_deleBt setBackgroundColor:[UIColor redColor]];
        [_deleBt setTitle:@"—" forState:UIControlStateNormal];
        [_deleBt setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        _deleBt.layer.cornerRadius = _deleBt.frame.size.width/2;
        [self addSubview:_deleBt];

    }
    return self;
}

@end
