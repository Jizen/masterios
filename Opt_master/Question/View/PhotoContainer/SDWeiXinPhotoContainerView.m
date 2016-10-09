//
//  SDWeiXinPhotoContainerView.m
//  SDAutoLayout 测试 Demo
//
//  Created by gsd on 15/12/23.
//  Copyright © 2015年 gsd. All rights reserved.
//


/*
 
 *********************************************************************************
 *
 * GSD_WeiXin
 *
 * QQ交流群: 362419100(2群) 459274049（1群已满）
 * Email : gsdios@126.com
 * GitHub: https://github.com/gsdios/GSD_WeiXin
 * 新浪微博:GSD_iOS
 *
 * 此“高仿微信”用到了很高效方便的自动布局库SDAutoLayout（一行代码搞定自动布局）
 * SDAutoLayout地址：https://github.com/gsdios/SDAutoLayout
 * SDAutoLayout视频教程：http://www.letv.com/ptv/vplay/24038772.html
 * SDAutoLayout用法示例：https://github.com/gsdios/SDAutoLayout/blob/master/README.md
 *
 *********************************************************************************
 
 */

#import "SDWeiXinPhotoContainerView.h"

#import "UIView+SDAutoLayout.h"

#import "SDPhotoBrowser.h"

#import "UIImageView+WebCache.h"

@interface SDWeiXinPhotoContainerView () <SDPhotoBrowserDelegate>

@property (nonatomic, strong) NSArray *imageViewsArray;

@end

@implementation SDWeiXinPhotoContainerView

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        [self setup];
    }
    return self;
}

- (void)setup
{
    NSMutableArray *temp = [NSMutableArray new];
    
    for (int i = 0; i < 9; i++) {
        UIImageView *imageView = [UIImageView new];
        [self addSubview:imageView];
        imageView.userInteractionEnabled = YES;
        imageView.tag = i;
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapImageView:)];
        [imageView addGestureRecognizer:tap];
        [temp addObject:imageView];
    }
    
    self.imageViewsArray = [temp copy];
}



- (void)setPicPathStringsArray:(NSArray *)picPathStringsArray
{
    
    
    _picPathStringsArray = picPathStringsArray;
    
    for (long i = _picPathStringsArray.count; i < self.imageViewsArray.count; i++) {
        UIImageView *imageView = [self.imageViewsArray objectAtIndex:i];
        imageView.hidden = YES;
        //        UIImageView *image = [_imageViewsArray objectAtIndex:0];
        //        [image sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",PICTURE_URL,_picPathStringsArray.firstObject]]];
    }
    
    if (_picPathStringsArray.count == 0) {
        self.height = 0;
        self.fixedHeight = @(0);
        return;
    }
    
    CGFloat itemW = [self itemWidthForPicPathArray:_picPathStringsArray];
    CGFloat itemH = 0;
    if (_picPathStringsArray.count == 1) {
    UIImageView *image = [_imageViewsArray objectAtIndex:0];
        [image sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",PICTURE_URL,_picPathStringsArray.firstObject]]];
        
        if (image.size.width) {
            itemH = image.size.height / image.size.width * itemW;
        }
    } else {
        itemH = itemW;
    }
    long perRowItemCount = [self perRowItemCountForPicPathArray:_picPathStringsArray];
    CGFloat margin = DEFUALT_MARGIN_SIDES;
    
    [_picPathStringsArray enumerateObjectsUsingBlock:^(NSString *  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        long columnIndex = idx % perRowItemCount;
        long rowIndex = idx / perRowItemCount;
        UIImageView *imageView = [_imageViewsArray objectAtIndex:idx];
        imageView.hidden = NO;
        NSString *imageStr = [NSString stringWithFormat:@"%@%@",PICTURE_URL,_picPathStringsArray[idx]];

        [imageView sd_setImageWithURL:[NSURL URLWithString:imageStr] placeholderImage:[UIImage imageNamed:@"pictureHolder"]];
        imageView.frame = CGRectMake(columnIndex * (itemW + margin), rowIndex * (itemH + margin), itemW, itemH);
        imageView.contentMode = UIViewContentModeScaleAspectFill;
        imageView.clipsToBounds = YES;

        //判断是多张图片还是一张图片
        if (_picPathStringsArray.count > 1) {
//            imageView.frame = CGRectMake(columnIndex * (itemW + margin), rowIndex * (itemH + margin), itemW, itemH);
        }else{
            imageView.frame = CGRectMake(columnIndex * (itemW + margin), rowIndex * (itemH + margin), (kWidth-4*DEFUALT_MARGIN_SIDES)/3, (kWidth-4*DEFUALT_MARGIN_SIDES)/3);
        }
        
//        [self addSubview:imageView];
    }];
    
    CGFloat w = perRowItemCount * itemW + (perRowItemCount - 1) * margin;
    int columnCount = ceilf(_picPathStringsArray.count * 1.0 / perRowItemCount);
    CGFloat h = columnCount * itemH + (columnCount - 1) * margin;
    self.width = w;
    self.height = h;
    
    self.fixedHeight = @(h);
    self.fixedWith = @(w);
    
    
    
    
    
//    _picPathStringsArray = picPathStringsArray;
//    
//    for (long i = _picPathStringsArray.count; i < self.imageViewsArray.count; i++) {
//        UIImageView *imageView = [self.imageViewsArray objectAtIndex:i];
//        imageView.hidden = YES;
//    }
//    
//    if (_picPathStringsArray.count == 0) {
//        self.height = 0;
//        self.fixedHeight = @(0);
//        return;
//    }
//    
//    CGFloat itemW = [self itemWidthForPicPathArray:_picPathStringsArray];
//    CGFloat itemH = 0;
//    if (_picPathStringsArray.count == 1) {
//
//    
//        UIImageView *image = [_imageViewsArray objectAtIndex:0];
//        [image sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",PICTURE_URL,_picPathStringsArray.firstObject]]];
//        
//
//        if (image.size.width) {
//            itemH = image.size.height / image.size.width * itemW;
//        }
//    } else {
//        
//        itemH = itemW;
//    }
//    long perRowItemCount = [self perRowItemCountForPicPathArray:_picPathStringsArray];
//    CGFloat margin = DEFUALT_MARGIN_SIDES;
//    
//    [_picPathStringsArray enumerateObjectsUsingBlock:^(NSString *  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
//        
//        
//        long columnIndex = idx % perRowItemCount;
//        long rowIndex = idx / perRowItemCount;
//        UIImageView *imageView = [_imageViewsArray objectAtIndex:idx];
//        imageView.hidden = NO;
//        NSString *imageStr = [NSString stringWithFormat:@"%@%@",PICTURE_URL,_picPathStringsArray[idx]];
////        [imageView sd_setImageWithURL:[NSURL URLWithString:imageStr] ];
//        [imageView sd_setImageWithURL:[NSURL URLWithString:imageStr] placeholderImage:[UIImage imageNamed:@"pictureHolder"]];
//        imageView.frame = CGRectMake(columnIndex * (itemW + margin), rowIndex * (itemH + margin), itemW, itemH);
//
//        
//                //判断是多张图片还是一张图片
//                if (_picPathStringsArray.count > 1) {
//                    imageView.frame = CGRectMake(columnIndex * (itemW + margin), rowIndex * (itemH + margin), itemW, itemH);
//                }else{
//                    imageView.frame = CGRectMake(columnIndex * (itemW + margin), rowIndex * (itemH + margin), 100, 100);
//                }
//        
//                [self addSubview:imageView];
//  
//    }];
//    
//    CGFloat w = perRowItemCount * itemW + (perRowItemCount - 1) * margin;
//    int columnCount = ceilf(_picPathStringsArray.count * 1.0 / perRowItemCount);
//    CGFloat h = columnCount * itemH + (columnCount - 1) * margin;
//    self.width = w;
//    self.height = h;
//    
//    self.fixedHeight = @(h);
//    self.fixedWith = @(w);
}


#pragma mark - private actions

- (void)tapImageView:(UITapGestureRecognizer *)tap
{
    UIView *imageView = tap.view;
    SDPhotoBrowser *browser = [[SDPhotoBrowser alloc] init];
    browser.currentImageIndex = imageView.tag;
    browser.sourceImagesContainerView = self;
    browser.imageCount = self.picPathStringsArray.count;
    browser.delegate = self;
    [browser show];
}

- (CGFloat)itemWidthForPicPathArray:(NSArray *)array
{
    if (array.count == 1) {
        return (kWidth - 4*DEFUALT_MARGIN_SIDES )/3;
    } else {
        
        return (kWidth - 4*DEFUALT_MARGIN_SIDES )/3;

//        CGFloat w = [UIScreen mainScreen].bounds.size.width > 320 ? 80 : 70;
//        return w;
    }
}

- (NSInteger)perRowItemCountForPicPathArray:(NSArray *)array
{
    if (array.count < 4) {
        return array.count;
    } else if (array.count <= 4) {
        return 3;
    } else {
        return 3;
    }
}


#pragma mark - SDPhotoBrowserDelegate

- (NSURL *)photoBrowser:(SDPhotoBrowser *)browser highQualityImageURLForIndex:(NSInteger)index
{
    
    NSString *imageName = [NSString stringWithFormat:@"%@%@",PICTURE_URL,self.picPathStringsArray[index]];
    NSArray *array = [imageName componentsSeparatedByString:@"!"];
    NSURL *url = [NSURL URLWithString:array[0]];
    return url;

}

- (UIImage *)photoBrowser:(SDPhotoBrowser *)browser placeholderImageForIndex:(NSInteger)index
{
    UIImageView *imageView = self.subviews[index];
    
    return imageView.image;
}

@end
