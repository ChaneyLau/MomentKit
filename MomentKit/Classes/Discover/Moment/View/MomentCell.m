//
//  MomentCell.m
//  MomentKit
//
//  Created by LEA on 2017/12/14.
//  Copyright © 2017年 LEA. All rights reserved.
//

#import "MomentCell.h"

#pragma mark - ------------------ 动态 ------------------

// 最大高度限制
CGFloat maxLimitHeight = 0;
CGFloat lineSpacing = 5;

@implementation MomentCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self configUI];
        // 观察者
        MM_AddObserver(self, @selector(resetMenuView), @"ResetMenuView");
        MM_AddObserver(self, @selector(resetLinkLabel), UIMenuControllerWillHideMenuNotification);
    }
    return self;
}

- (void)configUI
{
    WS(wSelf);
    // 头像视图
    _avatarImageView = [[MMImageView alloc] initWithFrame:CGRectMake(10, kBlank, kAvatarWidth, kAvatarWidth)];
    _avatarImageView.layer.cornerRadius = 4.0;
    _avatarImageView.layer.masksToBounds = YES;
    [_avatarImageView setClickHandler:^(MMImageView *imageView) {
        if ([wSelf.delegate respondsToSelector:@selector(didOperateMoment:operateType:)]) {
            [wSelf.delegate didOperateMoment:wSelf operateType:MMOperateTypeProfile];
        }
        [wSelf resetMenuView];
    }];
    [self.contentView addSubview:_avatarImageView];
    // 名字视图
    _nicknameBtn = [[UIButton alloc] init];
    _nicknameBtn.tag = MMOperateTypeProfile;
    _nicknameBtn.titleLabel.font = [UIFont boldSystemFontOfSize:17.0];
    _nicknameBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    [_nicknameBtn setTitleColor:kHLTextColor forState:UIControlStateNormal];
    [_nicknameBtn addTarget:self action:@selector(buttonClicked:) forControlEvents:UIControlEventTouchUpInside];
    [self.contentView addSubview:_nicknameBtn];
    // 正文视图 ↓↓
    _linkLabel = kMLLinkLabel(YES);
    _linkLabel.font = kTextFont;
    _linkLabel.delegate = self;
    [self.contentView addSubview:_linkLabel];
    // 查看'全文'按钮
    _showAllBtn = [[UIButton alloc] init];
    _showAllBtn.tag = MMOperateTypeFull;
    _showAllBtn.titleLabel.font = kTextFont;
    [_showAllBtn setTitle:@"全文" forState:UIControlStateNormal];
    [_showAllBtn setTitle:@"收起" forState:UIControlStateSelected];
    [_showAllBtn setTitleColor:kHLTextColor forState:UIControlStateNormal];
    [_showAllBtn addTarget:self action:@selector(buttonClicked:) forControlEvents:UIControlEventTouchUpInside];
    [self.contentView addSubview:_showAllBtn];
    [_showAllBtn sizeToFit];
    // 图片区
    _imageListView = [[MMImageListView alloc] initWithFrame:CGRectZero];
    [_imageListView setSingleTapHandler:^(MMImageView *imageView) {
        [wSelf resetMenuView];
    }];
    [self.contentView addSubview:_imageListView];
    // 位置视图
    _locationBtn = [[UIButton alloc] init];
    _locationBtn.tag = MMOperateTypeLocation;
    _locationBtn.titleLabel.font = [UIFont systemFontOfSize:13.0];
    [_locationBtn setTitleColor:kHLTextColor forState:UIControlStateNormal];
    [_locationBtn addTarget:self action:@selector(buttonClicked:) forControlEvents:UIControlEventTouchUpInside];
    [self.contentView addSubview:_locationBtn];
    // 时间视图
    _timeLabel = [[UILabel alloc] init];
    _timeLabel.textColor = MMRGBColor(110.f, 110.f, 110.f);
    _timeLabel.font = [UIFont systemFontOfSize:13.0f];
    [self.contentView addSubview:_timeLabel];
    // 删除视图
    _deleteBtn = [[UIButton alloc] init];
    _deleteBtn.tag = MMOperateTypeDelete;
    [_deleteBtn setImageEdgeInsets:UIEdgeInsetsMake(6, 6, 6, 6)];
    [_deleteBtn setImage:[UIImage imageNamed:@"moment_delete"] forState:UIControlStateNormal];
    [_deleteBtn addTarget:self action:@selector(buttonClicked:) forControlEvents:UIControlEventTouchUpInside];
    [self.contentView addSubview:_deleteBtn];
    // 评论视图
    _bgImageView = [[UIImageView alloc] init];
    [self.contentView addSubview:_bgImageView];
    _commentView = [[UIView alloc] init];
    [self.contentView addSubview:_commentView];
    // 操作视图
    _menuView = [[MMOperateMenuView alloc] initWithFrame:CGRectZero];
    [_menuView setOperateMenu:^(MMOperateType operateType) { // 评论|赞
        if ([wSelf.delegate respondsToSelector:@selector(didOperateMoment:operateType:)]) {
            [wSelf.delegate didOperateMoment:wSelf operateType:operateType];
        }
    }];
    [self.contentView addSubview:_menuView];
    // 最大高度限制
    maxLimitHeight = (_linkLabel.font.lineHeight + lineSpacing) * 6;
}

#pragma mark - setter
- (void)setMoment:(Moment *)moment
{
    _moment = moment;
    // 头像
    [_avatarImageView sd_setImageWithURL:[NSURL URLWithString:moment.user.portrait] placeholderImage:nil];
    // 昵称
    [_nicknameBtn setTitle:moment.user.name forState:UIControlStateNormal];
    [_nicknameBtn sizeToFit];
    if (_nicknameBtn.width > kTextWidth) {
        _nicknameBtn.width = kTextWidth;
    }
    _nicknameBtn.frame = CGRectMake(_avatarImageView.right + 10, _avatarImageView.top, _nicknameBtn.width, 20);
    // 正文
    _showAllBtn.hidden = YES;
    _linkLabel.hidden = YES;
    CGFloat bottom = _nicknameBtn.bottom + kPaddingValue;
    CGFloat rowHeight = 0;
    if ([moment.text length])
    {
        _linkLabel.hidden = NO;
        NSMutableParagraphStyle *style = [[NSMutableParagraphStyle alloc] init];
        style.lineSpacing = lineSpacing;
        NSMutableAttributedString *attributedText = [[NSMutableAttributedString alloc] initWithString:moment.text];
        [attributedText addAttribute:NSParagraphStyleAttributeName value:style range:NSMakeRange(0,[moment.text length])];
        _linkLabel.attributedText = attributedText;
        // 判断显示'全文'/'收起'
        CGSize attrStrSize = [_linkLabel preferredSizeWithMaxWidth:kTextWidth];
        CGFloat labHeight = attrStrSize.height;
        if (labHeight > maxLimitHeight) {
            if (!_moment.isFullText) {
                labHeight = maxLimitHeight;
            }
            _showAllBtn.hidden = NO;
            _showAllBtn.selected = _moment.isFullText;
        }
        _linkLabel.frame = CGRectMake(_nicknameBtn.left, bottom, attrStrSize.width, labHeight);
        _showAllBtn.frame = CGRectMake(_nicknameBtn.left, _linkLabel.bottom, _showAllBtn.width, kMoreLabHeight);
        if (_showAllBtn.hidden) {
            bottom = _linkLabel.bottom + kPaddingValue;
        } else {
            bottom = _showAllBtn.bottom + kPaddingValue;
        }
        // 添加长按手势
        if (!_longPress) {
            _longPress = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(longPressHandler:)];
        }
        [_linkLabel addGestureRecognizer:_longPress];
    }
    // 图片
    _imageListView.moment = moment;
    if ([moment.pictureList count] > 0) {
        _imageListView.origin = CGPointMake(_nicknameBtn.left, bottom);
        bottom = _imageListView.bottom + kPaddingValue;
    }
    // 位置
    _timeLabel.text = [Utility getMomentTime:moment.time];
    [_timeLabel sizeToFit];
    if (moment.location) {
        [_locationBtn setTitle:moment.location.position forState:UIControlStateNormal];
        [_locationBtn sizeToFit];
        _locationBtn.hidden = NO;
        _locationBtn.frame = CGRectMake(_nicknameBtn.left, bottom, _locationBtn.width, kTimeLabelH);
        bottom = _locationBtn.bottom + kPaddingValue;
    } else {
        _locationBtn.hidden = YES;
    }
    _timeLabel.frame = CGRectMake(_nicknameBtn.left, bottom, _timeLabel.width, kTimeLabelH);
    _deleteBtn.frame = CGRectMake(_timeLabel.right + 5, _timeLabel.top - 5, kTimeLabelH + 10, kTimeLabelH + 10);
    bottom = _timeLabel.bottom + kPaddingValue;
    // 操作视图
    _menuView.frame = CGRectMake(k_screen_width-kOperateWidth-15, _timeLabel.top-(kOperateHeight-kTimeLabelH)/2, kOperateWidth, kOperateHeight);
    _menuView.show = NO;
    _menuView.isLike = moment.isLike;
    // 处理评论/赞
    _commentView.frame = CGRectZero;
    _bgImageView.frame = CGRectZero;
    _bgImageView.image = nil;
    [_commentView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    // 处理赞
    CGFloat top = 0;
    CGFloat width = k_screen_width - kRightMargin - _nicknameBtn.left;
    if ([moment.likeList count]) {
        MLLinkLabel *likeLabel = kMLLinkLabel(NO);
        likeLabel.delegate = self;
        likeLabel.attributedText = kMLLinkAttributedText(moment);
        CGSize attrStrSize = [likeLabel preferredSizeWithMaxWidth:kTextWidth];
        likeLabel.frame = CGRectMake(5, 8, attrStrSize.width, attrStrSize.height);
        [_commentView addSubview:likeLabel];
        // 分割线
        UIView *line = [[UIView alloc] initWithFrame:CGRectMake(0, likeLabel.bottom + 5, width, 0.5)];
        line.backgroundColor = [[UIColor lightGrayColor] colorWithAlphaComponent:0.2];
        [_commentView addSubview:line];
        // 更新
        top = attrStrSize.height + 15;
    }
    // 处理评论
    NSInteger count = [moment.commentList count];
    for (NSInteger i = 0; i < count; i ++) {
        __block CommentLabel *label = [[CommentLabel alloc] initWithFrame:CGRectMake(0, top, width, 0)];
        label.comment = [moment.commentList objectAtIndex:i];
        // 点击评论
        [label setDidClickText:^(Comment *comment) {
            // 当前moment相对tableView的frame
            CGRect rect = [[label superview] convertRect:label.frame toView:self.superview];
            [AppDelegate sharedInstance].convertRect = rect;
            
            if ([self.delegate respondsToSelector:@selector(didOperateMoment:selectComment:)]) {
                [self.delegate didOperateMoment:self selectComment:comment];
            }
            [self resetMenuView];
        }];
        // 点击高亮
        [label setDidClickLinkText:^(MLLink *link, NSString *linkText) {
            if ([self.delegate respondsToSelector:@selector(didClickLink:linkText:)]) {
                [self.delegate didClickLink:link linkText:linkText];
            }
            [self resetMenuView];
        }];
        [_commentView addSubview:label];
        // 更新
        top += label.height;
    }
    // 更新UI
    if (top > 0) {
        _bgImageView.frame = CGRectMake(_nicknameBtn.left, bottom, width, top);
        _bgImageView.backgroundColor = MMRGBColor(247, 247, 247);
        _bgImageView.layer.cornerRadius = 4.0;
        _bgImageView.layer.masksToBounds = YES;
        _commentView.frame = CGRectMake(_nicknameBtn.left, bottom, width, top);
        rowHeight = _commentView.bottom + kBlank;
    } else {
        rowHeight = _timeLabel.bottom + kBlank;
    }
    // 这样做就是起到缓存行高的作用，省去重复计算!!!
    _moment.rowHeight = rowHeight;
}

// 图片渲染
- (void)loadPicture
{
    [_imageListView loadPicture];
}

#pragma mark - 点击事件
// 点击昵称/查看位置/查看全文|收起/删除动态
- (void)buttonClicked:(UIButton *)sender
{
    MMOperateType operateType = sender.tag;
    // 改变背景色
    sender.titleLabel.backgroundColor = kHLBgColor;
    GCD_AFTER(0.3, ^{  // 延迟执行
        sender.titleLabel.backgroundColor = [UIColor whiteColor];
        if (operateType == MMOperateTypeFull) {
            _moment.isFullText = !_moment.isFullText;
            [_moment update];
        }
        if ([self.delegate respondsToSelector:@selector(didOperateMoment:operateType:)]) {
            [self.delegate didOperateMoment:self operateType:operateType];
        }
    });
    [self resetMenuView];
}

#pragma mark - MLLinkLabelDelegate
- (void)didClickLink:(MLLink *)link linkText:(NSString *)linkText linkLabel:(MLLinkLabel *)linkLabel
{
    [self resetMenuView];
    // 点击动态正文或者赞高亮
    if ([self.delegate respondsToSelector:@selector(didClickLink:linkText:)]) {
        [self.delegate didClickLink:link linkText:linkText];
    }
}

#pragma mark - UIResponder
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    MM_PostNotification(@"ResetMenuView", nil);
}

- (BOOL)canPerformAction:(SEL)action withSender:(id)sender
{
    if (action == @selector(copyHandler)) {
        return YES;
    } else {
        return NO;
    }
}

- (BOOL)canBecomeFirstResponder
{
    return YES;
}

#pragma mark - 长按拷贝
- (void)longPressHandler:(UILongPressGestureRecognizer *)gestureRecognizer
{
    if (gestureRecognizer.state == UIGestureRecognizerStateBegan)
    {
        [self becomeFirstResponder];
        
        _linkLabel.backgroundColor = kHLBgColor;
        CGRect frame = [[_linkLabel superview] convertRect:_linkLabel.frame toView:self];
        CGRect menuFrame = CGRectMake(frame.origin.x + frame.size.width/2.0, frame.origin.y, 0, 0);
        if (!_menuController) {
            UIMenuItem *copyItem = [[UIMenuItem alloc] initWithTitle:@"拷贝" action:@selector(copyHandler)];
            _menuController = [UIMenuController sharedMenuController];
            [_menuController setMenuItems:@[copyItem]];
        }
        [_menuController setTargetRect:menuFrame inView:self];
        [_menuController setMenuVisible:YES animated:YES];
    }
}

- (void)copyHandler
{
    UIPasteboard *pasteboard = [UIPasteboard generalPasteboard];
    [pasteboard setString:_moment.text];
    [_menuController setMenuVisible:NO animated:YES];
}

- (void)resetLinkLabel
{
    _linkLabel.backgroundColor = [UIColor whiteColor];
}

- (void)resetMenuView
{
    _menuView.show = NO;
    [_menuController setMenuVisible:NO animated:YES];
}

#pragma mark -
- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

@end

#pragma mark - ------------------ 评论 ------------------
@implementation CommentLabel

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        _linkLabel = kMLLinkLabel(NO);
        _linkLabel.delegate = self;
        [self addSubview:_linkLabel];
    }
    return self;
}

#pragma mark - Setter
- (void)setComment:(Comment *)comment
{
    _comment = comment;
    _linkLabel.attributedText = kMLLinkAttributedText(comment);
    CGSize attrStrSize = [_linkLabel preferredSizeWithMaxWidth:kTextWidth];
    _linkLabel.frame = CGRectMake(5, 3, attrStrSize.width, attrStrSize.height);
    self.height = attrStrSize.height + 5;
}

#pragma mark - MLLinkLabelDelegate
- (void)didClickLink:(MLLink *)link linkText:(NSString *)linkText linkLabel:(MLLinkLabel *)linkLabel
{
    if (self.didClickLinkText) {
        self.didClickLinkText(link,linkText);
    }
}

#pragma mark - 点击
- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    self.backgroundColor = kHLBgColor;
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    GCD_AFTER(0.3, ^{  // 延迟执行
        self.backgroundColor = [UIColor clearColor];
        if (self.didClickText) {
            self.didClickText(_comment);
        }
    });
}

- (void)touchesCancelled:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    self.backgroundColor = [UIColor clearColor];
}

@end
