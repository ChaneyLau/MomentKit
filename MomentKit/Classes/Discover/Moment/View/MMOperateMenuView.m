//
//  MMOperateMenuView.m
//  MomentKit
//
//  Created by LEA on 2017/12/15.
//  Copyright © 2017年 LEA. All rights reserved.
//

#import "MMOperateMenuView.h"

@interface MMOperateMenuView ()

@property (nonatomic, strong) UIView *menuView;
@property (nonatomic, strong) UIButton *menuBtn;
@property (nonatomic, strong) UIButton *likeBtn;
@property (nonatomic, strong) UIButton *commentBtn;

@end

@implementation MMOperateMenuView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        _show = NO;
        [self setUpUI];
    }
    return self;
}

#pragma mark - 设置UI
- (void)setUpUI
{
    // 菜单容器视图
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(kOperateWidth-kOperateBtnWidth-kOperateMargin, 0, kOperateWidth-kOperateBtnWidth-kOperateMargin, kOperateHeight)];
    view.backgroundColor = MMRGBColor(70.0,74.0,75.0);
    view.layer.cornerRadius = 4.0;
    view.layer.masksToBounds = YES;
    [self addSubview:view];
    // 点赞
    MMOperateMenuButton *btn = [[MMOperateMenuButton alloc] initWithFrame:CGRectMake(0, 0, view.width/2, kOperateHeight)];
    btn.tag = MMOperateTypeLike;
    btn.highlighted = NO;
    btn.allowAnimation = YES;
    [btn setTitle:@"赞" forState:UIControlStateNormal];
    [btn setImage:[UIImage imageNamed:@"moment_like"] forState:UIControlStateNormal];
    [btn addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
    [view addSubview:btn];
    self.likeBtn = btn;
    // 分割线
    UIView *line = [[UIView alloc] initWithFrame:CGRectMake(btn.right-5, 8, 0.5, kOperateHeight-16)];
    line.backgroundColor = MMRGBColor(50.f, 50.f, 50.f);
    [view addSubview:line];
    // 评论
    btn = [[MMOperateMenuButton alloc] initWithFrame:CGRectMake(line.right, 0, btn.width, kOperateHeight)];
    btn.tag = MMOperateTypeComment;
    btn.highlighted = NO;
    [btn setTitle:@"评论" forState:UIControlStateNormal];
    [btn setImage:[UIImage imageNamed:@"moment_comment"] forState:UIControlStateNormal];
    [btn addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
    [view addSubview:btn];
    self.commentBtn = btn;
    self.menuView = view;
    // 菜单操作按钮
    UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(kOperateWidth-kOperateBtnWidth, 0, kOperateBtnWidth, kOperateHeight)];
    [button setImage:[UIImage imageNamed:@"moment_operate"] forState:UIControlStateNormal];
    [button setImage:[UIImage imageNamed:@"moment_operate_hl"] forState:UIControlStateHighlighted];
    [button addTarget:self action:@selector(menuClick) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:button];
    self.menuBtn = button;
}

#pragma mark - 显示/不显示
- (void)setShow:(BOOL)show
{
    _show = show;
    CGFloat menu_left = kOperateWidth - kOperateBtnWidth - kOperateMargin;
    CGFloat menu_width = 0;
    if (_show) {
        menu_left = 0;
        menu_width = kOperateWidth - kOperateBtnWidth - kOperateMargin;
    }
    self.menuView.width = menu_width;
    self.menuView.left = menu_left;
}

- (void)setIsLike:(BOOL)isLike
{
    if (isLike) {
        [self.likeBtn setTitle:@"取消" forState:UIControlStateNormal];
    } else {
        [self.likeBtn setTitle:@"赞" forState:UIControlStateNormal];
    }
}

#pragma mark - 事件
- (void)menuClick
{
    _show = !_show;
    CGFloat menu_left = kOperateWidth - kOperateBtnWidth - kOperateMargin;
    CGFloat menu_width = 0;
    if (_show) {
        menu_left = 0;
        menu_width = kOperateWidth - kOperateBtnWidth - kOperateMargin;
    }
    [UIView animateWithDuration:0.2 animations:^{
        self.menuView.width = menu_width;
        self.menuView.left = menu_left;
    }];
}

- (void)buttonClick:(UIButton *)sender
{
    [self menuClick];
    // 0.1秒刷新UI
    GCD_AFTER(0.1, ^{
        MMOperateType operateType = sender.tag;
        if (self.operateMenu) {
            self.operateMenu(operateType);
        }
    });
}

@end


@interface MMOperateMenuButton ()

@property (nonatomic, strong) UIImageView *likeAnimationView;

@end

@implementation MMOperateMenuButton

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self == [super initWithFrame:frame]) {
        self.backgroundColor = [UIColor clearColor];
        self.titleLabel.font = [UIFont systemFontOfSize:14.0];
        [self setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];

        _allowAnimation = NO;
        // 点赞动画
        UIImageView *imageView = [[UIImageView alloc] init];
        imageView.hidden = YES;
        [self addSubview:imageView];
        self.likeAnimationView = imageView;
    }
    return self;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    self.likeAnimationView.frame = self.imageView.frame;
}

// 监听事件
- (void)sendAction:(SEL)action to:(nullable id)target forEvent:(nullable UIEvent *)event
{
    if (!self.allowAnimation) {
        [super sendAction:action to:target forEvent:event];
        return;
    }
    // 显示动画
    self.likeAnimationView.hidden = NO;
    self.likeAnimationView.image = [self imageForState:UIControlStateHighlighted];
    self.likeAnimationView.transform = CGAffineTransformIdentity;
    [UIView animateWithDuration:0.2 animations:^{
        self.likeAnimationView.transform = CGAffineTransformScale(self.imageView.transform, 0.4, 0.4);
    } completion:^(BOOL finished) {
        self.likeAnimationView.transform  = CGAffineTransformIdentity;
        self.likeAnimationView.hidden = YES;
        [super sendAction:action to:target forEvent:event];
    }];
}

@end
