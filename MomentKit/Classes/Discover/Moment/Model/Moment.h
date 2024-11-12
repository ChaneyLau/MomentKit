//
//  Moment.h
//  MomentKit
//
//  Created by LEA on 2017/12/12.
//  Copyright © 2017年 LEA. All rights reserved.
//
//  动态Model
//

#import "JKDBModel.h"
#import "Comment.h"
#import "MPicture.h"
#import "MLocation.h"
#import "MUser.h"

@interface Moment : JKDBModel

// 正文
@property (nonatomic, copy) NSString *text;
// 发布时间戳
@property (nonatomic, assign) NSInteger time;
// 单张图片的宽度（用于预设视图尺寸）
@property (nonatomic, assign) CGFloat singleWidth;
// 单张图片的高度（用于预设视图尺寸）
@property (nonatomic, assign) CGFloat singleHeight;
// 是否已经点赞
@property (nonatomic, assign) BOOL isLike;
// 显示'全文'/'收起'
@property (nonatomic, assign) BOOL isFullText;
// 发布者
@property (nonatomic, strong) MUser *user;
// 位置信息
@property (nonatomic, strong) MLocation *location;
// 点赞集合
@property (nonatomic, strong) NSArray<MUser *> *likeList;
// 评论集合
@property (nonatomic, strong) NSArray<Comment *> *commentList;
// 图片集合
@property (nonatomic, strong) NSArray<MPicture *> *pictureList;


// ## 关联 ↓↓
// 发布者id
@property (nonatomic, assign) long userId;
// 点赞用户ids
@property (nonatomic, copy) NSString *likeIds;
// 评论用户ids
@property (nonatomic, copy) NSString *commentIds;
// 图片ids
@property (nonatomic, copy) NSString *pictureIds;


// Moment对应cell高度
@property (nonatomic, assign) CGFloat rowHeight;


+ (NSArray *)transients;

@end
