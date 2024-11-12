//
//  Utility.h
//  MomentKit
//
//  Created by LEA on 2017/12/12.
//  Copyright © 2017年 LEA. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Utility : NSObject

// 朋友圈动态时间
+ (NSString *)getMomentTime:(long long)timestamp;
// 消息时间
+ (NSString *)getMessageTime:(long long)timestamp;
// 获取单张图片的实际size
+ (CGSize)getMomentImageSize:(CGSize)size;

@end
