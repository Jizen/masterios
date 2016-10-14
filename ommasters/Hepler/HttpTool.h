//
//  HttpTool.h
//  cts
//
//  Created by 瑞宁科技02 on 15/11/25.
//  Copyright © 2015年 reining. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AFNetworking.h"
@interface HttpTool : NSObject


+ (AFHTTPSessionManager *)shareManager;


@end
