//
//  MLocation.h
//  MomentKit
//
//  Created by LEA on 2019/4/1.
//  Copyright © 2019 LEA. All rights reserved.
//

#import "JKDBModel.h"

@interface MLocation : JKDBModel

// 发布位置(地标)
@property (nonatomic, copy) NSString *landmark;
// 发布位置(详细地址)
@property (nonatomic, copy) NSString *address;
// 发布位置(eg 杭州·雷峰塔景区 )
@property (nonatomic, copy) NSString *position;
// 经度
@property (nonatomic, assign) double longitude;
// 维度
@property (nonatomic, assign) double latitude;

@end
