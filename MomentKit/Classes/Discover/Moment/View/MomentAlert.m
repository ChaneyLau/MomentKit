//
//  MomentAlert.m
//  MomentKit
//
//  Created by LEA on 2017/12/14.
//  Copyright © 2017年 LEA. All rights reserved.
//

#import "MomentAlert.h"

@interface MomentAlert ()

@property (nonatomic, copy) MomentAlertAction action;
@property (nonatomic, copy) NSString *title;
@property (nonatomic, strong) UIView *contentView;

@end

@implementation MomentAlert

- (instancetype)initWithTitle:(NSString *)title action:(MomentAlertAction)action
{
    self = [super initWithFrame:[[UIScreen mainScreen] bounds]];
    if (self) {
        self.backgroundColor = [UIColor colorWithWhite:0 alpha:0.5];
        self.alpha = 0.0;
        self.action = action;
        self.title = title;
        [self configUI];
    }
    return self;
}

- (void)show
{
    [[UIApplication sharedApplication].keyWindow addSubview:self];
    [UIView animateWithDuration:0.2f animations:^{
        self.alpha = 1.0;
    }];
}

#pragma mark - config
- (void)configUI
{
    UIView *contentView = [UIView new];
    contentView.clipsToBounds = YES;
    contentView.layer.cornerRadius = 8.0;
    contentView.layer.masksToBounds = YES;
    contentView.backgroundColor = [UIColor whiteColor];
    [self addSubview:contentView];
    [contentView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(self);
        make.width.equalTo(self.mas_width).offset(-70);
        make.height.mas_equalTo(160);
    }];
    
    UIButton *cancelButton = [UIButton new];
    cancelButton.tag = 1000;
    cancelButton.titleLabel.font = [UIFont boldSystemFontOfSize:17.0];
    [cancelButton setTitle:@"取消" forState:UIControlStateNormal];
    [cancelButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [cancelButton addTarget:self action:@selector(onAction:) forControlEvents:UIControlEventTouchUpInside];
    [contentView addSubview:cancelButton];
    
    UIButton *deleteButton = [UIButton new];
    deleteButton.tag = 1001;
    deleteButton.titleLabel.font = [UIFont boldSystemFontOfSize:17.0];
    [deleteButton setTitle:@"删除" forState:UIControlStateNormal];
    [deleteButton setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
    [deleteButton addTarget:self action:@selector(onAction:) forControlEvents:UIControlEventTouchUpInside];
    [contentView addSubview:deleteButton];

    NSArray *bts = @[cancelButton, deleteButton];
    [bts mas_distributeViewsAlongAxis:MASAxisTypeHorizontal withFixedSpacing:0 leadSpacing:0 tailSpacing:0];
    [bts mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(contentView);
        make.height.mas_equalTo(50);
    }];
    
    UILabel *titleLabel = [UILabel new];
    titleLabel.text = self.title;
    titleLabel.textAlignment = NSTextAlignmentCenter;
    titleLabel.font = [UIFont boldSystemFontOfSize:17.0];
    [contentView addSubview:titleLabel];
    [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.right.equalTo(contentView).offset(0);
        make.bottom.equalTo(cancelButton.mas_top).offset(0);
    }];

    UIView *hLine = [UIView new];
    hLine.backgroundColor = k_background_color;
    [contentView addSubview:hLine];
    [hLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(contentView).offset(0);
        make.top.equalTo(titleLabel.mas_bottom);
        make.height.mas_equalTo(0.5);
    }];

    UIView *vLine = [UIView new];
    vLine.backgroundColor = k_background_color;
    [contentView addSubview:vLine];
    [vLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(0.5);
        make.height.mas_equalTo(50);
        make.centerX.bottom.equalTo(contentView);
    }];
    
    self.contentView = contentView;
    [self layoutIfNeeded];
}

- (void)onAction:(UIButton *)sender
{
    !self.action ?: self.action(sender.tag - 1000);
    [self removeFromSuperview];
}

@end

