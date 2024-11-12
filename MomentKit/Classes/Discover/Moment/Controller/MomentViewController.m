//
//  MomentViewController.m
//  MomentKit
//
//  Created by LEA on 2017/12/12.
//  Copyright © 2017年 LEA. All rights reserved.
//

#import "MomentViewController.h"
#import "WKWebViewController.h"
#import "MMLocationViewController.h"
#import "MMUserDetailViewController.h"
#import "MMCommentInputView.h"
#import "MomentCell.h"
#import "MomentUtil.h"
#import "MMRunLoopWorkDistribution.h"
#import "MomentAlert.h"
#import <UUActionSheet.h>

@interface MomentViewController ()<UITableViewDelegate,UITableViewDataSource,UUActionSheetDelegate,MomentCellDelegate>

@property (nonatomic, strong) NSMutableArray *momentList;  // 朋友圈动态列表
@property (nonatomic, strong) MMTableView *tableView; // 表格
@property (nonatomic, strong) UIView *tableHeaderView; // 表头
@property (nonatomic, strong) MMImageView *coverImageView; // 封面
@property (nonatomic, strong) MMImageView *avatarImageView; // 当前用户头像
@property (nonatomic, strong) MMCommentInputView *commentInputView; // 评论输入框
@property (nonatomic, strong) MomentCell *operateCell; // 当前操作朋友圈动态
@property (nonatomic, strong) Comment *operateComment; // 当前操作评论
@property (nonatomic, strong) MUser *loginUser; // 当前用户
@property (nonatomic, strong) NSIndexPath *selectedIndexPath; // 当前评论indexPath
@property (nonatomic, assign) CGFloat keyboardHeight; // 键盘高度

@end

@implementation MomentViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.title = @"朋友圈";
    self.view.backgroundColor = [UIColor whiteColor];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"moment_camera"] style:UIBarButtonItemStylePlain target:self action:@selector(addMoment)];
    
    [self configData];
    [self configUI];
}

#pragma mark - 模拟数据
- (void)configData
{
    self.loginUser = [MUser findFirstByCriteria:@"WHERE type = 1"];
    self.momentList = [[NSMutableArray alloc] init];
    [self.momentList addObjectsFromArray:[MomentUtil getMomentList:0 pageNum:5]];
}

#pragma mark - UI
- (void)configUI
{
    // 封面
    MMImageView *imageView = [[MMImageView alloc] initWithFrame:CGRectMake(0, -k_top_height, k_screen_width, 350)];
    [imageView sd_setImageWithURL:[NSURL URLWithString:self.loginUser.momentCover] placeholderImage:nil];
    self.coverImageView = imageView;
    // 用户头像
    imageView = [[MMImageView alloc] initWithFrame:CGRectMake(k_screen_width-85, self.coverImageView.bottom-50, 75, 75)];
    imageView.layer.cornerRadius = 8;
    [imageView sd_setImageWithURL:[NSURL URLWithString:self.loginUser.portrait] placeholderImage:nil];
    self.avatarImageView = imageView;
    // 用户名
    UILabel *nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(25, imageView.top + 20, k_screen_width - 120, 20)];
    nameLabel.textAlignment = NSTextAlignmentRight;
    nameLabel.textColor = [UIColor whiteColor];
    nameLabel.font = [UIFont boldSystemFontOfSize:17.0];
    nameLabel.text = self.loginUser.name;
    // 表头
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, k_screen_width, 320)];
    view.userInteractionEnabled = YES;
    [view addSubview:self.coverImageView];
    [view addSubview:self.avatarImageView];
    [view addSubview:nameLabel];
    self.tableHeaderView = view;
    // 表格
    self.tableView = [[MMTableView alloc] initWithFrame:CGRectZero];
    self.tableView.separatorInset = UIEdgeInsetsZero;
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    self.tableView.tableHeaderView = self.tableHeaderView;
    if (@available(iOS 15.0, *)) {
        self.tableView.sectionHeaderTopPadding = 0.0;
    }
    [self.view addSubview:self.tableView];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
    // 上拉加载更多
    MJRefreshAutoNormalFooter *footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
        Moment *moment = [self.momentList lastObject];
        NSArray *tempList = [MomentUtil getMomentList:moment.pk pageNum:5];
        if ([tempList count]) {
            [self.momentList addObjectsFromArray:tempList];
            [self.tableView reloadData];
            [self.tableView.mj_footer endRefreshing];
        } else {
            [self.tableView.mj_footer endRefreshingWithNoMoreData];
        }
    }];
    [footer setTitle:@"已加载全部" forState:MJRefreshStateNoMoreData];
    footer.stateLabel.font = [UIFont systemFontOfSize:14];
    self.tableView.mj_footer = footer;
}

#pragma mark - 发布动态
- (void)addMoment
{
    NSLog(@"新增");
}

#pragma mark - 评论相关
- (void)addComment:(NSString *)commentText
{
    // 新增评论
    Comment *comment = [[Comment alloc] init];
    comment.text = commentText;
    comment.fromUser = self.loginUser;
    comment.fromId = self.loginUser.pk;
    if (self.operateComment) { // 回复评论
        comment.toUser = self.operateComment.fromUser;
        comment.toId = self.operateComment.fromUser.pk;
    }
    [comment save];
    // 更新评论列表
    Moment *moment = self.operateCell.moment;
    NSMutableArray *commentList = [[NSMutableArray alloc] initWithArray:moment.commentList];
    [commentList addObject:comment];
    moment.commentList = commentList;
    NSMutableString *ids = [[NSMutableString alloc] initWithString:moment.commentIds];
    if ([ids length]) {
        [ids appendFormat:@",%d",comment.pk];
    } else {
        [ids appendFormat:@"%d",comment.pk];
    }
    moment.commentIds = ids;
    [moment update];
    // 刷新
    self.operateCell.moment = moment;
    [UIView performWithoutAnimation:^{
        [self.tableView reloadRowsAtIndexPaths:@[self.selectedIndexPath]
                              withRowAnimation:UITableViewRowAnimationNone];
    }];
}

// 滚动table
- (void)scrollForComment
{
    if (self.keyboardHeight > 0) {
        CGRect rect = [AppDelegate sharedInstance].convertRect;
        // 转换成window坐标
        rect = [self.tableView convertRect:rect toView:nil];
        CGFloat delta = self.commentInputView.ctTop - rect.origin.y - rect.size.height;
        CGFloat offsetY = self.tableView.contentOffset.y - delta;
        [self.tableView setContentOffset:CGPointMake(0, offsetY) animated:YES];
    } else {
        if(self.selectedIndexPath.section == self.momentList.count - 1){
            [UIView performWithoutAnimation:^{
                [self.tableView scrollToBottomAnimated:NO];
            }];
        }
    }
}

#pragma mark - MomentCellDelegate
- (void)didOperateMoment:(MomentCell *)cell operateType:(MMOperateType)operateType;
{
    switch (operateType)
    {
        case MMOperateTypeProfile: // 用户详情
        {
            MMUserDetailViewController *controller = [[MMUserDetailViewController alloc] init];
            controller.user = cell.moment.user;
            [self.navigationController pushViewController:controller animated:YES];
            break;
        }
        case MMOperateTypeDelete: // 删除
        {
            WS(wSelf);
            MomentAlert *alert = [[MomentAlert alloc] initWithTitle:@"删除该朋友圈？" action:^(NSInteger buttonIndex) {
                if (buttonIndex == 1) {
                    // db移除
                    [cell.moment deleteObject];
                    // 移除UI
                    [wSelf.momentList removeObject:cell.moment];
                    [wSelf.tableView reloadData];
                }
            }];
            [alert show];
            break;
        }
        case MMOperateTypeLocation: // 位置
        {
            MMLocationViewController *controller = [[MMLocationViewController alloc] init];
            controller.location = cell.moment.location;
            [self.navigationController pushViewController:controller animated:YES];
        }
        case MMOperateTypeLike: // 点赞
        {
            // data
            Moment *moment = cell.moment;
            NSMutableArray *likeList = [NSMutableArray arrayWithArray:moment.likeList];
            NSMutableArray *idList = [NSMutableArray arrayWithArray:[moment.likeIds componentsSeparatedByString:@","]];
            if (moment.isLike) { // 取消点赞
                moment.isLike = 0;
                NSPredicate *predicate = [NSPredicate predicateWithFormat:@"type = 1"];
                NSArray *result = [likeList filteredArrayUsingPredicate:predicate];
                if ([result count]) {
                    MUser *removeUser = [result firstObject];
                    [likeList removeObject:removeUser];
                    [idList removeObject:[NSString stringWithFormat:@"%d",removeUser.pk]];
                }
            } else { // 点赞
                moment.isLike = 1;
                [likeList addObject:self.loginUser];
                [idList addObject:[NSString stringWithFormat:@"%d",self.loginUser.pk]];
            }
            moment.likeList = likeList;
            moment.likeIds = [MomentUtil getIdsByIdList:idList];
            [moment update];
            // 刷新
            [self.momentList replaceObjectAtIndex:cell.tag withObject:moment];
            NSIndexPath *indexPath = [self.tableView indexPathForCell:cell];
            if (indexPath) {
                [UIView performWithoutAnimation:^{
                    [self.tableView reloadRowsAtIndexPaths:@[indexPath]
                                          withRowAnimation:UITableViewRowAnimationNone];
                }];
            }
            break;
        }
        case MMOperateTypeComment: // 添加评论
        {
            self.operateCell = cell;
            self.operateComment = nil;
            
            self.selectedIndexPath = [self.tableView indexPathForCell:cell];
            CGRect rect = [self.tableView rectForRowAtIndexPath:self.selectedIndexPath];
            [AppDelegate sharedInstance].convertRect = rect;
            self.commentInputView.comment = nil;
            [self.commentInputView show];
            break;
        }
        case MMOperateTypeFull: // 全文/收起
        {
            NSIndexPath *indexPath = [self.tableView indexPathForCell:cell];
            if (indexPath) {
                [UIView performWithoutAnimation:^{
                    [self.tableView reloadRowsAtIndexPaths:@[indexPath]
                                          withRowAnimation:UITableViewRowAnimationNone];
                }];
            }
            break;
        }
        default:
            break;
    }
}

// 选择评论
- (void)didOperateMoment:(MomentCell *)cell selectComment:(Comment *)comment
{
    self.operateCell = cell;
    self.operateComment = comment;
    
    if (comment.fromUser.type == 1) { // 删除自己的评论
        UUActionSheet *sheet = [[UUActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:@"删除" otherButtonTitles:nil];
        sheet.tag = MMDeleteCommentTag;
        [sheet showInView:self.view.window];
    } else { // 回复评论
        self.selectedIndexPath = [self.tableView indexPathForCell:cell];
        self.commentInputView.comment = comment;
        [self.commentInputView show];
    }
}

// 点击高亮文字
- (void)didClickLink:(MLLink *)link linkText:(NSString *)linkText
{
    switch (link.linkType)
    {
        case MLLinkTypeURL: // 链接
        {
            WKWebViewController *controller = [[WKWebViewController alloc] init];
            controller.url = linkText;
            [self.navigationController pushViewController:controller animated:YES];
            break;
        }
        case MLLinkTypePhoneNumber: // 电话
        {
            UUActionSheet *sheet = [[UUActionSheet alloc] initWithTitle:[NSString stringWithFormat:@"%@可能是一个电话号码，你可以",link.linkValue] delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"呼叫", @"复制号码",nil];
            sheet.tag = MMHandlePhoneTag;
            [sheet showInView:self.view.window];
            break;
        }
        case MLLinkTypeEmail: // 邮箱
        {
            UUActionSheet *sheet = [[UUActionSheet alloc] initWithTitle:[NSString stringWithFormat:@"向%@可发送邮件",link.linkValue] delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"使用默认邮件账户", @"复制邮箱",nil];
            sheet.tag = MMHandleEmailTag;
            [sheet showInView:self.view.window];
            break;
        }
        case MLLinkTypeOther: // 用户
        {
            int pk = [link.linkValue intValue];
            MUser *user = [MUser findByPK:pk];
            MMUserDetailViewController *controller = [[MMUserDetailViewController alloc] init];
            controller.user = user;
            [self.navigationController pushViewController:controller animated:YES];
            break;
        }
        default:
            break;
    }
}

#pragma mark - UUActionSheetDelegate
- (void)actionSheet:(UUActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (actionSheet.tag == MMHandlePhoneTag) { // 电话
        NSString *title = actionSheet.title;
        NSString *subString = [title substringWithRange:NSMakeRange(0, [title length] - 13)];
        if (buttonIndex == 0) { // 拨打电话
            UIWebView *webView = [[UIWebView alloc] init];
            NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"tel://%@",subString]];
            [webView loadRequest:[NSURLRequest requestWithURL:url]];
            [self.view addSubview:webView];
        } else if (buttonIndex == 1) { // 复制
            [[UIPasteboard generalPasteboard] setValue:subString forPasteboardType:[UIPasteboardTypeListString objectAtIndex:0]];
        } else { // 取消

        }
    } else if (actionSheet.tag == MMHandleEmailTag) {
        NSString *title = actionSheet.title;
        NSString *subString = [title substringWithRange:NSMakeRange(1, [title length] - 6)];
        if (buttonIndex == 0) {
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:[NSString stringWithFormat:@"mailto://%@",subString]]];
        } else if (buttonIndex == 1) { // 复制
            [[UIPasteboard generalPasteboard] setValue:subString forPasteboardType:[UIPasteboardTypeListString objectAtIndex:0]];
        } else { // 取消

        }
    } else if (actionSheet.tag == MMDeleteCommentTag) { // 删除自己的评论
        if (buttonIndex == 0) {
            // 移除Moment的评论
            Moment *moment = self.operateCell.moment;
            NSMutableArray *tempList = [NSMutableArray arrayWithArray:moment.commentList];
            [tempList removeObject:self.operateComment];
            NSMutableArray *idList = [NSMutableArray arrayWithArray:[MomentUtil getIdListByIds:moment.commentIds]];
            [idList removeObject:[NSString stringWithFormat:@"%d",self.operateComment.pk]];
            moment.commentIds = [MomentUtil getIdsByIdList:idList];
            moment.commentList = tempList;
            // 数据库更新
            [moment update];
            [self.operateComment deleteObject];
            // 刷新
            [self.momentList replaceObjectAtIndex:self.operateCell.tag withObject:moment];
            NSIndexPath *indexPath = [self.tableView indexPathForCell:self.operateCell];
            if (indexPath) {
                [UIView performWithoutAnimation:^{
                    [self.tableView reloadRowsAtIndexPaths:@[indexPath]
                                          withRowAnimation:UITableViewRowAnimationNone];
                }];
            }
        } else { // 取消

        }
    } else {

    }
}

#pragma mark - UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.momentList count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *identifier = @"MomentCell";
    MomentCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (!cell) {
        cell = [[MomentCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.backgroundColor = [UIColor whiteColor];
    }
    cell.tag = indexPath.row;
    cell.moment = [self.momentList objectAtIndex:indexPath.row]; // UITrackingRunLoopMode
    cell.delegate = self;
    // 停止滚动时渲染图片
    cell.currentIndexPath = indexPath;
    [[MMRunLoopWorkDistribution sharedInstance] addTask:^BOOL{ // kCFRunLoopDefaultMode
        if (![cell.currentIndexPath isEqual:indexPath]) {
            return NO;
        }
        [cell loadPicture];
        return YES;
    } withKey:indexPath];
    return cell;
}

#pragma mark - UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    // 使用缓存行高，避免计算多次
    Moment *moment = [self.momentList objectAtIndex:indexPath.row];
    return moment.rowHeight;
}

#pragma mark - UIScrollViewDelegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    MM_PostNotification(@"ResetMenuView", nil);
}

#pragma mark - lazy load
- (MMCommentInputView *)commentInputView
{
    if (!_commentInputView) {
        _commentInputView = [[MMCommentInputView alloc] initWithFrame:[UIScreen mainScreen].bounds];
        WS(wSelf);
        [_commentInputView setMMCompleteInputTextBlock:^(NSString *commentText) { // 完成文本输入
            [wSelf addComment:commentText];
        }];
        [_commentInputView setMMContainerWillChangeFrameBlock:^(CGFloat keyboardHeight) { // 输入框监听
            wSelf.keyboardHeight = keyboardHeight;
            [wSelf scrollForComment];
        }];
    }
    return _commentInputView;
}

#pragma mark -
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

@end
