//
//  MomentConstant.h
//  MomentKit
//
//  Created by LEA on 2019/3/27.
//  Copyright © 2019 LEA. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, MMOperateType) {
    MMOperateTypeLike = 1,      // 点赞
    MMOperateTypeComment,       // 评论
    MMOperateTypeDelete,        // 删除
    MMOperateTypeLocation,      // 位置
    MMOperateTypeFull,          // 显示全文
    MMOperateTypeProfile,       // 用户详情
};

// 容器最小高度
FOUNDATION_EXTERN CGFloat const MMContainMinHeight;
// 容器最大高度
FOUNDATION_EXTERN CGFloat const MMContainMaxHeight;
// 容器减去输入框的高度
FOUNDATION_EXTERN CGFloat const MarginHeight;

// 操作电话号码
FOUNDATION_EXTERN CGFloat const MMHandlePhoneTag;
// 删除评论
FOUNDATION_EXTERN CGFloat const MMHandleEmailTag;
// 删除评论
FOUNDATION_EXTERN CGFloat const MMDeleteCommentTag;

// 延迟执行
void GCD_AFTER(CGFloat time,dispatch_block_t block);
void MM_AddObserver(id observer,SEL aSelector,NSNotificationName aName);
void MM_PostNotification(NSNotificationName aName,id anObject);

// 安全区域高度[头部有刘海的iPhone]
CG_INLINE CGFloat MMSafeAreaHeight() {
    
    CGFloat height = 0;
    if (@available(iOS 11.0, *)) {
        UIWindow * mainWindow = [[[UIApplication sharedApplication] delegate] window];
        height = mainWindow.safeAreaInsets.bottom;
    }
    return height;
}
