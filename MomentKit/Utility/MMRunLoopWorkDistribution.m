//
//  MMRunLoopWorkDistribution.m
//  MomentKit
//
//  Created by LEA on 2019/3/25.
//  Copyright © 2019 LEA. All rights reserved.
//

#import "MMRunLoopWorkDistribution.h"
#import <objc/runtime.h>

@interface MMRunLoopWorkDistribution ()

@property (nonatomic, strong) NSMutableArray *tasks;
@property (nonatomic, strong) NSMutableArray *tasksKeys;

@end

@implementation MMRunLoopWorkDistribution

- (instancetype)init
{
    if ((self = [super init])) {
        _maximumQueueLength = 30;
        _tasks = [NSMutableArray array];
        _tasksKeys = [NSMutableArray array];
    }
    return self;
}

- (void)addTask:(MMRunLoopWorkDistributionUnit)unit withKey:(id)key
{
    [self.tasks addObject:unit];
    [self.tasksKeys addObject:key];
    if (self.tasks.count > self.maximumQueueLength) {
        [self.tasks removeObjectAtIndex:0];
        [self.tasksKeys removeObjectAtIndex:0];
    }
}
- (void)removeAllTasks
{
    [self.tasks removeAllObjects];
    [self.tasksKeys removeAllObjects];
}

+ (instancetype)sharedInstance
{
    static MMRunLoopWorkDistribution *singleton;
    static dispatch_once_t once;
    dispatch_once(&once, ^{
        singleton = [[MMRunLoopWorkDistribution alloc] init];
        [self _registerMainRunLoopWorkDistribution:singleton];
    });
    return singleton;
}

+ (void)_registerMainRunLoopWorkDistribution:(MMRunLoopWorkDistribution *)runLoopWorkDistribution
{
    static CFRunLoopObserverRef defaultModeObserver;
    _registerObserver(kCFRunLoopBeforeWaiting, defaultModeObserver, NSIntegerMax - 999, kCFRunLoopDefaultMode, (__bridge void *)runLoopWorkDistribution, &_defaultModeRunLoopWorkDistributionCallback);
}

static void _registerObserver(CFOptionFlags activities, CFRunLoopObserverRef observer, CFIndex order, CFStringRef mode, void *info, CFRunLoopObserverCallBack callback)
{
    CFRunLoopRef runLoop = CFRunLoopGetCurrent();
    CFRunLoopObserverContext context = {0, info, &CFRetain, &CFRelease, NULL};
    observer = CFRunLoopObserverCreate(NULL, activities, YES, order, callback, &context);
    CFRunLoopAddObserver(runLoop, observer, mode);
    CFRelease(observer);
}

static void _runLoopWorkDistributionCallback(CFRunLoopObserverRef observer, CFRunLoopActivity activity, void *info)
{
    MMRunLoopWorkDistribution *runLoopWorkDistribution = (__bridge MMRunLoopWorkDistribution *)info;
    if (runLoopWorkDistribution.tasks.count == 0) {
        return;
    }
    BOOL result = NO;
    while (result == NO && runLoopWorkDistribution.tasks.count) {
        MMRunLoopWorkDistributionUnit unit  = runLoopWorkDistribution.tasks.firstObject;
        result = unit();
        [runLoopWorkDistribution.tasks removeObjectAtIndex:0];
        [runLoopWorkDistribution.tasksKeys removeObjectAtIndex:0];
    }
}

static void _defaultModeRunLoopWorkDistributionCallback(CFRunLoopObserverRef observer, CFRunLoopActivity activity, void *info)
{
    _runLoopWorkDistributionCallback(observer, activity, info);
}

@end

@implementation UITableViewCell (MMRunLoopWorkDistribution)
@dynamic currentIndexPath;

- (NSIndexPath *)currentIndexPath
{
    NSIndexPath *indexPath = objc_getAssociatedObject(self, @selector(currentIndexPath));
    return indexPath;
}

- (void)setCurrentIndexPath:(NSIndexPath *)currentIndexPath
{
    objc_setAssociatedObject(self, @selector(currentIndexPath), currentIndexPath, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

@end
