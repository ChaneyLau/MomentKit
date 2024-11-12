//
//  MMOperateMenuView.h
//  MomentKit
//
//  Created by LEA on 2017/12/15.
//  Copyright © 2017年 LEA. All rights reserved.
//
//  朋友圈动态 > 评论/赞操作视图
//

#import <UIKit/UIKit.h>

@interface MMOperateMenuView : UIView

// 显示|隐藏
@property (nonatomic, assign) BOOL show;
// 是否已赞
@property (nonatomic, assign) BOOL isLike;
// 赞|评论
@property (nonatomic, copy) void (^operateMenu)(MMOperateType operateType);

@end

@interface MMOperateMenuButton : UIButton

// 动画
@property (nonatomic, readwrite, assign) BOOL allowAnimation;

@end
