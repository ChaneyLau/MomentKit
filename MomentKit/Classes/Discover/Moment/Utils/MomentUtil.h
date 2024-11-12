//
//  MomentUtil.h
//  MomentKit
//
//  Created by LEA on 2019/2/1.
//  Copyright © 2019 LEA. All rights reserved.
//
//  Moment、Comment、MUser(赞)、MPicture之间的关联均以Model存储的PK为关联。
//  正常应该是由JSON数据转化，这么做主要为了测试方便。
//

#import <Foundation/Foundation.h>
#import "Moment.h"
#import "Message.h"
#import "MPicture.h"
#import "MLocation.h"
#import "MUser.h"

@interface MomentUtil : NSObject

// 获取动态集合
+ (NSArray *)getMomentList:(int)momentId pageNum:(int)pageNum;
// 获取字符数组
+ (NSString *)getLikeString:(Moment *)moment;

// id集合
+ (NSArray *)getIdListByIds:(NSString *)ids;
// ids
+ (NSString *)getIdsByIdList:(NSArray *)idList;

@end
