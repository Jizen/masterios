//
//  shareManager.m
//  ommasters
//
//  Created by 瑞宁科技02 on 2016/10/13.
//  Copyright © 2016年 reining. All rights reserved.
//

#import "shareManager.h"
#import "shareManager+shareView.h"
#import <UMSocialCore/UMSocialCore.h>

@implementation shareManager{
    
    UIViewController *_shareVC;
    NSString *_content;
    NSString *_image;
    NSString *_url;
}



+ (void)setShareAppKey{
    [[UMSocialManager defaultManager] openLog:YES];
    //设置友盟appkey
    [[UMSocialManager defaultManager] setUmSocialAppkey:@"57f9a972e0f55abc5000201a"];
    
    //各平台的详细配置
    //设置微信的appId和appKey
    [[UMSocialManager defaultManager] setPlaform:UMSocialPlatformType_WechatSession appKey:@"wx7b2e4e2fa36fb6a6" appSecret:@"5d065cb76c75a7814978c5af82c24e3e" redirectURL:@"http://mobile.umeng.com/social"];
    
    //设置分享到QQ互联的appId和appKey
    [[UMSocialManager defaultManager] setPlaform:UMSocialPlatformType_QQ appKey:@"100424468"  appSecret:@"a393c1527aaccb95f3a4c88d6d1455f6" redirectURL:@"http://mobile.umeng.com/social"];
    
    
    
    
//    [[UMSocialManager defaultManager] removePlatformProviderWithPlatformType:UMSocialPlatformType_Sms];
//    [[UMSocialManager defaultManager] removePlatformProviderWithPlatformType:UMSocialPlatformType_Qzone];
    [[UMSocialManager defaultManager] removePlatformProviderWithPlatformType:UMSocialPlatformType_TencentWb];
    [[UMSocialManager defaultManager] removePlatformProviderWithPlatformType:UMSocialPlatformType_WechatFavorite];

}

- (instancetype)init{
    self = [super init];
    if (self) {
        [self creatShareView];
    }
    return self;
}

- (void)setShareVC:(UIViewController *)vc content:(NSString *)content image:(NSString *)image url:(NSString *)url{
    _shareVC = vc;
    _content = content;
    _image = image;
    _url = url;
}

-(void)setSharecontent:(NSString *)content{
 
    _content = content;

}
- (void)show{
    self.shareBgView.hidden = NO;
    [UIView animateWithDuration:0.3 animations:^{
        self.shareBgView.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.2];
        self.shareView.frame = CGRectMake(0, ScreenHeight - 200, ScreenWidth, 200);
    } completion:^(BOOL finished) {
        
    }];
}


- (void)hiddenShareView{
    [UIView animateWithDuration:0.3 animations:^{
        self.shareBgView.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.0];
        self.shareView.frame = CGRectMake(0, ScreenHeight, ScreenWidth, 200);
    } completion:^(BOOL finished) {
        self.shareBgView.hidden = YES;
    }];
}

- (void)shareAction:(UIButton *)sender{
    [self hiddenShareView];
    if (sender.tag == 0) {
        self.isText = NO;

        [self shareDataWithPlatform:UMSocialPlatformType_WechatSession];
    }else if (sender.tag == 1) {
        self.isText = NO;
        [self shareDataWithPlatform:UMSocialPlatformType_WechatTimeLine];
    }else if (sender.tag == 2) {
        self.isText = YES;
        [self shareDataWithPlatform:UMSocialPlatformType_Email];
    }else if (sender.tag == 3){
        self.isText = YES;

        [self shareDataWithPlatform:UMSocialPlatformType_Sms];
    }else{
        [self shareDataWithPlatform:UMSocialPlatformType_Qzone];

    }

}
//创建分享内容对象
- (UMSocialMessageObject *)creatMessageObject
{
    //创建分享消息对象
    UMSocialMessageObject *messageObject = [UMSocialMessageObject messageObject];

    
    
    
    if (self.isText) {
        //纯文本分享
        messageObject.text = _content ;
    }else{
        NSString *title = @"运维专家";
        UMShareWebpageObject *shareObject = [UMShareWebpageObject shareObjectWithTitle:title descr:  _content thumImage:_image];
        [shareObject setWebpageUrl:_url];
        messageObject.shareObject = shareObject;
    }

    
    return messageObject;
}

//直接分享
- (void)shareDataWithPlatform:(UMSocialPlatformType)platformType
{
    
    UMSocialMessageObject *messageObject = [self creatMessageObject];
    //调用分享接口
    [[UMSocialManager defaultManager] shareToPlatform:platformType messageObject:messageObject currentViewController:_shareVC completion:^(id data, NSError *error) {
        
        NSString *message = nil;
        if (!error) {
            message = [NSString stringWithFormat:@"分享成功"];
            
        }
        else{
            if (error) {
//                message = [NSString stringWithFormat:@"失败原因Code: %d\n",(int)error.code];
                message = [NSString stringWithFormat:@"分享失败"];

            }
            else{
                message = [NSString stringWithFormat:@"分享失败"];
            }
        }
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"分享"
                                                        message:message
                                                       delegate:nil
                                              cancelButtonTitle:NSLocalizedString(@"确定", nil)
                                              otherButtonTitles:nil];
        [alert show];
    }];
    
    
}




@end
