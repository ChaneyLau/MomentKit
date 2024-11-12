//
//  MUser.h
//  MomentKit
//
//  Created by LEA on 2019/2/28.
//  Copyright © 2019 LEA. All rights reserved.
//
//  用户Model
//

#import <UIKit/UIKit.h>

@interface MUser : JKDBModel

// 用户类型 1：自己 0：其他人
@property (nonatomic, assign) int type;
// 性别 0： 男 1：女
@property (nonatomic, assign) int gender;
// 名字
@property (nonatomic, copy) NSString *name;
// 账号
@property (nonatomic, copy) NSString *account;
// 头像路径
@property (nonatomic, copy) NSString *portrait;
// 区域
@property (nonatomic, copy) NSString *region;
// 朋友圈封面
@property (nonatomic, copy) NSString *momentCover;

@end

