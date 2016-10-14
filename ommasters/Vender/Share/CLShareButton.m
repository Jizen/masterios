//
//  CLShareButton.m
//  CLShare
//
//  Created by ClaudeLi on 16/5/4.
//  Copyright © 2016年 ClaudeLi. All rights reserved.
//

#import "CLShareButton.h"

@implementation CLShareButton

- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        self.imageView.contentMode = UIViewContentModeScaleAspectFit;
        self.titleLabel.textAlignment = NSTextAlignmentCenter;
        self.titleLabel.font = [UIFont systemFontOfSize:12];
        [self setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
    }
    return self;
}

-(CGRect)titleRectForContentRect:(CGRect)contentRect{
    
    CGFloat titleY = contentRect.size.height *0.8;
    
    CGFloat titleW = contentRect.size.width;
    
    CGFloat titleH = contentRect.size.height - titleY;
    
    return CGRectMake(0, titleY, titleW, titleH);
}


-(CGRect)imageRectForContentRect:(CGRect)contentRect{
    
    CGFloat imageW = CGRectGetWidth(contentRect);
    
    CGFloat imageH = contentRect.size.height * 0.6;
    
    return CGRectMake(0, 0, imageW, imageH);
    
}


@end
