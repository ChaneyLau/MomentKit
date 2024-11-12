//
//  MomentUtil.m
//  MomentKit
//
//  Created by LEA on 2019/2/1.
//  Copyright © 2019 LEA. All rights reserved.
//

#import "MomentUtil.h"

@implementation MomentUtil

#pragma mark - 获取
// 获取动态集合
+ (NSArray *)getMomentList:(int)momentId pageNum:(int)pageNum
{
    NSString *sql = nil;
    if (momentId == 0) {
        sql = [NSString stringWithFormat:@"ORDER BY pk DESC limit %d",pageNum];
    } else {
        sql = [NSString stringWithFormat:@"WHERE pk < %d ORDER BY pk DESC limit %d",momentId,pageNum];
    }
    NSMutableArray *momentList = [[NSMutableArray alloc] init];
    NSArray *tempList = [Moment findByCriteria:sql];
    NSInteger count = [tempList count];
    for (NSInteger i = 0; i < count; i ++)
    {
        Moment *moment = [tempList objectAtIndex:i];
        // 处理评论 ↓↓
        NSArray *idList = [MomentUtil getIdListByIds:moment.commentIds];
        NSInteger count = [idList count];
        NSMutableArray *list = [NSMutableArray array];
        for (NSInteger i = 0; i < count; i ++)
        {
            NSInteger pk = [[idList objectAtIndex:i] integerValue];
            Comment *comment = [Comment findFirstByCriteria:[NSString stringWithFormat:@"WHERE PK = %ld",(long)pk]];
            MUser *user = nil;
            if (comment.fromId != 0) {
                user = [MUser findFirstByCriteria:[NSString stringWithFormat:@"WHERE PK = %ld",(long)comment.fromId]];
            } else {
                user = nil;
            }
            comment.fromUser = user;
            if (comment.toId != 0) {
                user = [MUser findFirstByCriteria:[NSString stringWithFormat:@"WHERE PK = %ld",(long)comment.toId]];
            } else {
                user = nil;
            }
            comment.toUser = user;
            [list addObject:comment];
        }
        moment.commentList = list;
        // 处理赞  ↓↓
        idList = [MomentUtil getIdListByIds:moment.likeIds];
        count = [idList count];
        list = [NSMutableArray array];
        for (NSInteger i = 0; i < count; i ++)
        {
            NSInteger pk = [[idList objectAtIndex:i] integerValue];
            MUser *user = [MUser findFirstByCriteria:[NSString stringWithFormat:@"WHERE PK = %ld",(long)pk]];
            [list addObject:user];
        }
        moment.likeList = list;
        // 处理图片 ↓↓
        idList = [MomentUtil getIdListByIds:moment.pictureIds];
        count = [idList count];
        list = [NSMutableArray array];
        for (NSInteger i = 0; i < count; i ++)
        {
            NSInteger pk = [[idList objectAtIndex:i] integerValue];
            MPicture *pic = [MPicture findFirstByCriteria:[NSString stringWithFormat:@"WHERE PK = %ld",(long)pk]];
            [list addObject:pic];
        }
        moment.pictureList = list;
        // 发布者
        MUser *user = [MUser findFirstByCriteria:[NSString stringWithFormat:@"WHERE PK = %ld",moment.userId]];
        moment.user = user;
        // 位置
        MLocation *location = [MLocation findByPK:1];
        moment.location = location;
        // == 加入集合
        [momentList addObject:moment];
    }
    return momentList;
}

#pragma mark - 辅助方法
// id集合
+ (NSArray *)getIdListByIds:(NSString *)ids
{
    if (ids.length == 0) {
        return nil;
    }
    return [ids componentsSeparatedByString:@","];
}

// ids
+ (NSString *)getIdsByIdList:(NSArray *)idList
{
    NSMutableString *ids = [[NSMutableString alloc] init];
    NSInteger count = [idList count];
    for (NSInteger i = 0; i < count; i ++) {
        NSString *idd = [idList objectAtIndex:i];
        if (i == count - 1) {
            [ids appendString:[NSString stringWithFormat:@"%@",idd]];
        } else {
            [ids appendString:[NSString stringWithFormat:@"%@,",idd]];
        }
    }
    return ids;
}

// 数组转字符
+ (NSString *)getLikeString:(Moment *)moment
{
    NSMutableString *likeString = [[NSMutableString alloc] init];
    NSInteger count = [moment.likeList count];
    for (NSInteger i = 0; i < count; i ++)
    {
        MUser *user = [moment.likeList objectAtIndex:i];
        if (i == 0) {
            [likeString appendString:user.name];
        } else {
            [likeString appendString:[NSString stringWithFormat:@", %@",user.name]];
        }
    }
    return likeString;
}

@end
