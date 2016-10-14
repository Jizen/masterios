//
//  UpLoadParam.h
//  cts
//
//  Created by 瑞宁科技02 on 15/12/7.
//  Copyright © 2015年 reining. All rights reserved.
//  图片上传参数

#import <Foundation/Foundation.h>

@interface UpLoadParam : NSObject



@property (nonatomic ,strong)NSData *data;

@property (nonatomic ,copy)NSString *name;

@property (nonatomic ,copy)NSString *filename;

@property (nonatomic ,copy)NSString *mineType;


@end
