//
//  CompareTime.m
//  Opt_master
//
//  Created by 瑞宁科技02 on 16/8/17.
//  Copyright © 2016年 reining. All rights reserved.
//

#import "CompareTime.h"

@implementation CompareTime
/**
 * 计算指定时间与当前的时间差
 * @param compareDate   某一指定时间
 * @return 多少(秒or分or天or月or年)+前 (比如，3天前、10分钟前)
 */
+ (NSString *) comparesCurrentTime:(NSDate*) compareDate
{
    NSTimeInterval  timeInterval = [compareDate timeIntervalSinceNow];
    timeInterval = -timeInterval;
    long temp = 0;
    NSString *result;
    if (timeInterval < 60) {
        result = [NSString stringWithFormat:@"刚刚"];
    }
    else if((temp = timeInterval/60) <60){
        result = [NSString stringWithFormat:@"%ld分前",temp];
    }
    else if((temp = temp/60) <24){
        result = [NSString stringWithFormat:@"%ld小前",temp];
    }
    else if((temp = temp/24) <2){
        result = [NSString stringWithFormat:@"昨天"];
    }
    //    else if((temp = temp/30) <12){
    //        result = [NSString stringWithFormat:@"%ld个月前",temp];
    //    }
    else{
        temp = temp/12;
        NSDateFormatter*dateFormatter = [[NSDateFormatter alloc]init];
        //        [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
        [dateFormatter setDateFormat:@"yyyy-MM-dd"];
        
        NSString*currentDateStr = [dateFormatter stringFromDate:compareDate];
        
        result = currentDateStr;
    }
    return  result;
}

@end
