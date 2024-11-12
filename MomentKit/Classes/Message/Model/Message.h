//
//  Message.h
//  MomentKit
//
//  Created by LEA on 2019/2/28.
//  Copyright © 2019 LEA. All rights reserved.
//
//  对话Model
//

#import "JKDBModel.h"

@interface Message : JKDBModel

// 名字
@property (nonatomic, copy) NSString *userName;
// 头像路径
@property (nonatomic, copy) NSString *userPortrait;
// 名字
@property (nonatomic, copy) NSString *content;
// 时间戳
@property (nonatomic, assign) long long time;

@end

