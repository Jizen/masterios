//
//  HttpTool.m
//  cts
//
//  Created by 瑞宁科技02 on 15/11/25.
//  Copyright © 2015年 reining. All rights reserved.
//

#import "HttpTool.h"
#import "PrefixHeader.pch"



@implementation HttpTool
#pragma mark -- AFNetworking 3.0
+ (AFHTTPSessionManager *)shareManager{
        static AFHTTPSessionManager * manager = nil;
        NSUserDefaults *user = [NSUserDefaults standardUserDefaults];
        NSString *userid = [user objectForKey:@"userid"];
        NSString *baseUrl = [user objectForKey:@"baseUrl"];
    
        if (baseUrl== nil) {
            baseUrl = BASE_URL;
        }



    manager = [[AFHTTPSessionManager alloc] initWithBaseURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@/%@",baseUrl,APP_NAME]]];
        manager.requestSerializer = [AFJSONRequestSerializer serializer];
        manager.responseSerializer = [AFJSONResponseSerializer serializer];
        [manager.requestSerializer willChangeValueForKey:@"timeoutInterval"];
        manager.requestSerializer.timeoutInterval = 20.f;
        [manager.requestSerializer didChangeValueForKey:@"timeoutInterval"];
        [manager.requestSerializer setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
        [manager.requestSerializer setValue:@"7E72FB27FC800C6E906557BAEE4ED1DC" forHTTPHeaderField:@"secretKey"];
        [manager.requestSerializer setValue:userid forHTTPHeaderField:@"userid"];

        manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"text/plain", @"multipart/form-data", @"application/json", @"text/html", @"image/jpeg", @"image/png", @"application/octet-stream", @"text/json", nil];

    return manager;

}







@end
