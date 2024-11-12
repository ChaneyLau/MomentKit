//
//  MMImageListView.h
//  MomentKit
//
//  Created by LEA on 2017/12/14.
//  Copyright © 2017年 LEA. All rights reserved.
//
//  朋友圈动态 > 小图区视图
//

#import <UIKit/UIKit.h>
#import "Moment.h"

@class MMImageView;
@interface MMImageListView : UIView

// 动态
@property (nonatomic, strong) Moment *moment;
// 点击小图
@property (nonatomic, copy) void (^singleTapHandler)(MMImageView *imageView);
// 图片渲染
- (void)loadPicture;

@end
