//
//  MomentCell.h
//  MomentKit
//
//  Created by LEA on 2017/12/14.
//  Copyright © 2017年 LEA. All rights reserved.
//
//  朋友圈动态
//

#import <UIKit/UIKit.h>
#import "MMOperateMenuView.h"
#import "MMImageListView.h"
#import "Moment.h"
#import "Comment.h"

//#### 动态
@protocol MomentCellDelegate;
@interface MomentCell : UITableViewCell <MLLinkLabelDelegate>

@property (nonatomic, strong) MMImageView *avatarImageView; // 头像
@property (nonatomic, strong) UILabel *timeLabel; // 时间
@property (nonatomic, strong) UIButton *nicknameBtn; // 名称
@property (nonatomic, strong) UIButton *locationBtn; // 位置
@property (nonatomic, strong) UIButton *deleteBtn; // 时间
@property (nonatomic, strong) UIButton *showAllBtn; // 全文
@property (nonatomic, strong) MLLinkLabel *linkLabel; // 内容
@property (nonatomic, strong) MMImageListView *imageListView; // 图片
@property (nonatomic, strong) UIView *commentView; // 赞和评论视图
@property (nonatomic, strong) UIImageView *bgImageView; // 赞和评论视图背景
@property (nonatomic, strong) MMOperateMenuView *menuView; // 操作视图
@property (nonatomic, strong) UILongPressGestureRecognizer *longPress; // 长按手势
@property (nonatomic, strong) UIMenuController *menuController; // 拷贝Menu

@property (nonatomic, strong) Moment *moment; // 动态
@property (nonatomic, assign) id<MomentCellDelegate> delegate;// 代理
// 图片渲染
- (void)loadPicture;

@end

@protocol MomentCellDelegate <NSObject>

@optional

// 点击头像|删除|点赞|评论|全文/收起
- (void)didOperateMoment:(MomentCell *)cell operateType:(MMOperateType)operateType;
// 选择评论
- (void)didOperateMoment:(MomentCell *)cell selectComment:(Comment *)comment;
// 点击高亮文字
- (void)didClickLink:(MLLink *)link linkText:(NSString *)linkText;

@end


//#### 评论
@interface CommentLabel : UIView <MLLinkLabelDelegate>

// 内容Label
@property (nonatomic, strong) MLLinkLabel *linkLabel;
// 评论
@property (nonatomic, strong) Comment *comment;
// 点击评论高亮内容
@property (nonatomic, copy) void (^didClickLinkText)(MLLink *link , NSString *linkText);
// 点击评论
@property (nonatomic, copy) void (^didClickText)(Comment *comment);

@end


