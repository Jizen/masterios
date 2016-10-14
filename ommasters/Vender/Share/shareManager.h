//
//  shareManager.h
//  ommasters
//
//  Created by 瑞宁科技02 on 2016/10/13.
//  Copyright © 2016年 reining. All rights reserved.
//

#import <Foundation/Foundation.h>

#define ScreenWidth [[UIScreen mainScreen] bounds].size.width
#define ScreenHeight [[UIScreen mainScreen] bounds].size.height
#define shareNameArray @[@"微信",@"朋友圈",@"新浪微博",@"QQ",@"QQ空间"]
#define shareImageArray @[@"share_微信",@"share_朋友圈",@"share_微博",@"share_qq",@"share_QQ空间"]
@interface shareManager : NSObject

// 分享视图背景
@property (nonatomic, strong) UIView *shareBgView;
// 分享视图
@property (nonatomic, strong) UIView *shareView;

//@property (nonatomic ,strong)
/**
 *  设置分享的AppKey，Appdelegate中执行一次即可。
 */
+ (void)setShareAppKey;

/**
 *  需要分享的内容
 *
 *  @param vc      分享所在视图控制器
 *  @param content 分享的内容
 *  @param image   分享的图片
 *  @param url     分享的urlString
 */
- (void)setShareVC:(UIViewController *)vc content:(NSString *)content image:(UIImage *)image url:(NSString *)url;

/**
 *  显示分享视图
 */
- (void)show;

/**
 *  隐藏分享视图
 */
- (void)hiddenShareView;

/**
 *  各个分享按钮点击事件
 *
 *  @param sender sender
 */
- (void)shareAction:(UIButton *)sender;


@end
