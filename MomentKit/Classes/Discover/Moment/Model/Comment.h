//
//  Comment.h
//  MomentKit
//
//  Created by LEA on 2017/12/12.
//  Copyright © 2017年 LEA. All rights reserved.
//
//  评论Model
//

#import "JKDBModel.h"
#import "MUser.h"

@interface Comment : JKDBModel

// 正文
@property (nonatomic, copy) NSString *text;
// xxx: （来源）
@property (nonatomic, strong) MUser *fromUser;
// 回复:xxx （目标）
@property (nonatomic, strong) MUser *toUser;

// xxx: （来源）
@property (nonatomic, assign) NSInteger fromId;
// 回复:xxx （目标）
@property (nonatomic, assign) NSInteger toId;


+ (NSArray *)transients;

@end
