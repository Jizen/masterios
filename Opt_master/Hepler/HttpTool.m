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
//        NSString *appName = [user objectForKey:@"appname"];

    
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



/** *  @author fangbmian, 16-03-23 13:03:27 * *  上传数据 * *
 
 @param path      uri *
 
 @param datas      图片（NSData）集合 *
 
 @param keys      图片key *
 
 @param parameters 参数 *
 
 @param success    成功回调 *
 
 @param fail      失败回调 */

+ (void)uploadDataWithData:(NSString *)path datas:(NSArray*)datas keys:(NSArray*)keys parameters:(NSDictionary *)parameters success:(void(^)(id responseObject))success fail:(void(^)(NSError * error))fail{
    AFHTTPRequestOperationManager * manage = [AFHTTPRequestOperationManager manager];
    manage.responseSerializer=[AFHTTPResponseSerializer serializer];
    manage.responseSerializer = [AFJSONResponseSerializer serializer];
    
    manage.requestSerializer.timeoutInterval = 60;

    [manage POST:path parameters:parameters constructingBodyWithBlock:^(id <AFMultipartFormData>formData)
     
    {
        
        for(int i = 0; i <[datas count] ; i++)
            
        {
            
            NSData *data = [datas objectAtIndex:i];
            
            NSString *key = [keys objectAtIndex:i];
            
            [formData appendPartWithFileData:data name:key fileName:@"data.jpg" mimeType:@"image/jpg"];
            
        }
        
    } success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        success(responseObject);
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        fail(error);
        
    }];
    
}





@end
