//
//  MMRunLoopWorkDistribution.h
//  MomentKit
//
//  Created by LEA on 2019/3/25.
//  Copyright © 2019 LEA. All rights reserved.
//
//  利用runloop对流式页面的优化，参考：https://github.com/diwu/RunLoopWorkDistribution
//

#import <Foundation/Foundation.h>

typedef BOOL(^MMRunLoopWorkDistributionUnit)(void);

@interface MMRunLoopWorkDistribution : NSObject

@property (nonatomic, assign) NSUInteger maximumQueueLength;

+ (instancetype)sharedInstance;

- (void)addTask:(MMRunLoopWorkDistributionUnit)unit withKey:(id)key;
- (void)removeAllTasks;

@end


@interface UITableViewCell (MMRunLoopWorkDistribution)

@property (nonatomic, strong) NSIndexPath *currentIndexPath;

@end
