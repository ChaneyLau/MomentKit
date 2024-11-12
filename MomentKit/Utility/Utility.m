//
//  Utility.m
//  MomentKit
//
//  Created by LEA on 2017/12/12.
//  Copyright © 2017年 LEA. All rights reserved.
//

#import "Utility.h"

@implementation Utility

// 时间戳转换
+ (NSString *)getMomentTime:(long long)timestamp
{
    // 入参日期
    NSDate *date = [NSDate dateWithTimeIntervalSince1970:timestamp];
    // 当前日期
    NSDate *curDate = [NSDate date];
    // 日历
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSCalendarUnit unitFlags = NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay | NSCalendarUnitHour | NSCalendarUnitMinute | NSCalendarUnitSecond;
    // 获取日期差
    NSDateComponents *delta = [calendar components:unitFlags fromDate:date toDate:curDate options:0];
    NSInteger year = delta.year;
    NSInteger month = delta.month;
    NSInteger day = delta.day;
    NSInteger hour = delta.hour;
    NSInteger minute = delta.minute;
    NSInteger second = delta.second;
    
    if (1 <= year) {
        return [NSString stringWithFormat:@"%ld年前",year];
    } else if(1 <= month) {
        return [NSString stringWithFormat:@"%ld月前",month];
    } else if(1 <= day) {
        return [NSString stringWithFormat:@"%ld天前",day];
    } else if(1 <= hour) {
        return [NSString stringWithFormat:@"%ld小时前",hour];
    } else if(1 <= minute) {
        return [NSString stringWithFormat:@"%ld分钟前",minute];
    } else if(1 <= second) {
        return [NSString stringWithFormat:@"%ld秒前",second];
    } else {
        return @"刚刚";
    }
}

+ (NSString *)getMessageTime:(long long)timestamp
{
    // 入参日期
    NSTimeZone *timeZone = [[NSTimeZone alloc] initWithName:@"Asia/Shanghai"];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy年MM月dd日 HH:mm"];
    [dateFormatter setTimeZone:timeZone];
    NSDate *date = [NSDate dateWithTimeIntervalSince1970:timestamp];
    // 当前日期
    NSDate *curDate = [NSDate date];
    // 日历
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSCalendarUnit unit = NSCalendarUnitDay;
    // 获取日期差
    NSDateComponents *delta = [calendar components:unit fromDate:curDate toDate:date options:0];
    NSInteger day = delta.day;
    NSString *temString = nil;
    if (day == 0) { // 今天
        [dateFormatter setDateFormat:@"HH:mm"];
        temString = [dateFormatter stringFromDate:date];
    } else if (day == 1) { // 昨天
        [dateFormatter setDateFormat:@"HH:mm"];
        temString = [dateFormatter stringFromDate:date];
        temString = [NSString stringWithFormat:@"昨天 %@", temString];
        return temString;
    } else {
        [dateFormatter setDateFormat:@"yyyy年MM月dd日"];
        temString = [dateFormatter stringFromDate:date];
    }
    return temString;
}

// 获取单张图片的实际size
+ (CGSize)getMomentImageSize:(CGSize)size
{
    // 最大尺寸
    CGFloat max_width = k_screen_width - 150;
    CGFloat max_height = k_screen_width - 130;
    // 原尺寸
    CGFloat width = size.width;
    CGFloat height = size.height;
    // 输出
    CGFloat out_width = 0;
    CGFloat out_height = 0;
    if (height / width > 3.0) { // 细长图
        out_height = max_height;
        out_width = out_height / 2.0;
    } else  {
        out_width = max_width;
        out_height = max_width * height / width;
        if (out_height > max_height) {
            out_height = max_height;
            out_width = max_height * width / height;
        }
    }
    return CGSizeMake(out_width, out_height);
}

@end
