//
//  MomentMacros.h
//  MomentKit
//
//  Created by LEA on 2019/3/27.
//  Copyright © 2019 LEA. All rights reserved.
//

#pragma mark - ------------------ 全局 ------------------

// 弱引用
#define WS(wSelf)               __weak typeof(self) wSelf = self
// RGB颜色
#define MMRGBColor(r,g,b)       [UIColor colorWithRed:(r)/255.0 green:(g)/255.0 blue:(b)/255.0 alpha:1.0]

// 屏幕物理尺寸宽度
#define k_screen_width          [UIScreen mainScreen].bounds.size.width
// 屏幕物理尺寸高度
#define k_screen_height         [UIScreen mainScreen].bounds.size.height
// 状态栏高度
#define k_status_height         [[UIApplication sharedApplication] statusBarFrame].size.height
// 导航栏高度
#define k_nav_height            self.navigationController.navigationBar.height
// 顶部整体高度
#define k_top_height            (k_status_height + k_nav_height)
// 刘海屏
#define k_safeArea_height       MMSafeAreaHeight()
// tabbar高度
#define k_bar_height            (k_safeArea_height > 0 ? 83.0 : 49.0)
// 背景颜色
#define k_background_color      MMRGBColor(240, 240, 240)


#pragma mark - ------------------ 朋友圈 ------------------

// 头像视图的宽、高
#define kAvatarWidth            40
// 名字视图高度
#define kNameLabelH             20
// 时间视图高度
#define kTimeLabelH             15

// 操作按钮的间距
#define kOperateMargin          10
// 操作按钮的宽度
#define kOperateBtnWidth        32
// 操作视图的高度
#define kOperateHeight          38
// 操作视图的高度
#define kOperateWidth           220

// 顶部和底部的留白
#define kBlank                  15
// 右侧留白
#define kRightMargin            15

// 内容视图宽度
#define kTextWidth              (k_screen_width - 60 - 25)
// 正文字体
#define kTextFont               [UIFont systemFontOfSize:17.0]
// 评论字体
#define kComTextFont            [UIFont systemFontOfSize:15.0]
// 评论高亮字体
#define kComHLTextFont          [UIFont boldSystemFontOfSize:15.0]
// 主色调高亮颜色（暗蓝色）
#define kHLTextColor            [UIColor colorWithRed:0.28 green:0.35 blue:0.54 alpha:1.0]
// 正文高亮颜色（蓝色）
#define kLinkTextColor          [UIColor colorWithRed:0.28 green:0.35 blue:0.54 alpha:1.0]
// 按住背景颜色
#define kHLBgColor              [UIColor colorWithRed:0.8 green:0.8 blue:0.8 alpha:1.0]

// 图片间距
#define kImagePadding           5
// 图片宽度
#define kImageWidth             75
// 全文/收起按钮高度
#define kMoreLabHeight          20
// 视图之间的间距
#define kPaddingValue           10
