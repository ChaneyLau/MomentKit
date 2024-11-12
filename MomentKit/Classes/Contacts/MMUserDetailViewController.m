//
//  MMUserDetailViewController.m
//  MomentKit
//
//  Created by LEA on 2019/4/15.
//  Copyright © 2019 LEA. All rights reserved.
//

#import "MMUserDetailViewController.h"
#import "MMImageListView.h"

@interface MMUserDetailViewController ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic, strong) MMTableView *tableView;
@property (nonatomic, strong) UIView *tableHeaderView;
@property (nonatomic, strong) UIView *imageListView;

@end

@implementation MMUserDetailViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self configUI];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    if (@available(iOS 15.0, *)) {
        UINavigationBarAppearance *appearance = [[UINavigationBarAppearance alloc] init];
        appearance.backgroundEffect = [UIBlurEffect effectWithStyle:UIBlurEffectStyleRegular];
        [appearance configureWithDefaultBackground];
        [appearance setBackgroundImage:[UIImage imageWithRenderColor:[UIColor whiteColor] renderSize:CGSizeMake(3, 3)]];
        [appearance setShadowImage:[UIImage imageWithRenderColor:[UIColor whiteColor] renderSize:CGSizeMake(3, 3)]];
        self.navigationController.navigationBar.standardAppearance = appearance;
        self.navigationController.navigationBar.scrollEdgeAppearance = appearance;
    } else {
        [self.navigationController.navigationBar setBackgroundImage:[UIImage imageWithRenderColor:[UIColor whiteColor] renderSize:CGSizeMake(5, 5)] forBarMetrics:UIBarMetricsDefault];
        [self.navigationController.navigationBar setShadowImage:[UIImage new]];
    }
}

- (void)configUI
{
    _tableHeaderView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, 10)];
    _tableHeaderView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:_tableHeaderView];
    
    _tableView = [[MMTableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
    _tableView.dataSource = self;
    _tableView.delegate = self;
    _tableView.separatorColor = [UIColor colorWithWhite:0 alpha:0.1];
    if (@available(iOS 11.0, *)) {
        _tableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
    }
    if (@available(iOS 15.0, *)) {
        _tableView.sectionHeaderTopPadding = 0.0;
    }
    [self.view addSubview:_tableView];
    [_tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
    
    NSArray *images = @[@"https://img0.baidu.com/it/u=4230971553,994426502&fm=253&fmt=auto&app=138&f=JPEG?w=500&h=500",
                        @"https://img0.baidu.com/it/u=408307854,905318993&fm=253&fmt=auto&app=138&f=JPEG?w=475&h=475",
                        @"https://img2.baidu.com/it/u=3917598851,3500238475&fm=253&fmt=auto&app=138&f=JPEG?w=380&h=380"];
    
    _imageListView = [[UIView alloc] initWithFrame:CGRectMake(100, 0, self.view.bounds.size.width - 140, 80)];
    NSInteger count = arc4random() % 3 + 1; // 1-3个
    for (NSInteger i = 0; i < count; i ++) {
        MMImageView *imageView = [[MMImageView alloc] initWithFrame:CGRectMake(60 * i, 15, 50, 50)];
        [imageView sd_setImageWithURL:[NSURL URLWithString:[images objectAtIndex:i]] placeholderImage:nil];
        [_imageListView addSubview:imageView];
    }
}

#pragma mark - UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 3;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == 0) {
        return 3;
    } else {
        return 2;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        if (indexPath.row == 0) {
            static NSString *identifier = @"UserDetailCell";
            MMUserDetailCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
            if (!cell) {
                cell = [[MMUserDetailCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:identifier];
            }
            cell.user = self.user;
            return cell;
        } else {
            static NSString *identifier = @"UserTitleCell";
            MMUserTitleCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
            if (!cell) {
                cell = [[MMUserTitleCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:identifier];
            }
            if (indexPath.row == 1) {
                cell.title = @"备注和标签";
            } else {
                cell.title = @"朋友权限";
            }
            return cell;
        }
    } else if (indexPath.section == 1) {
        static NSString *identifier = @"UserTitleCell";
        MMUserTitleCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
        if (!cell) {
            cell = [[MMUserTitleCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:identifier];
        }
        if (indexPath.row == 0) {
            cell.title = @"朋友圈";
            [cell.contentView addSubview:_imageListView];
        } else {
            cell.title = @"更多信息";
        }
        return cell;
    } else {
        static NSString *identifier = @"UserActionCell";
        MMUserActionCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
        if (!cell) {
            cell = [[MMUserActionCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:identifier];
        }
        if (indexPath.row == 0) {
            cell.image = [UIImage imageNamed:@"mine_message"];
            cell.title = @"发消息";
        } else {
            cell.image = [UIImage imageNamed:@"mine_call"];
            cell.title = @"音视频通话";
        }
        cell.separatorInset = UIEdgeInsetsZero;
        return cell;
    }
}

#pragma mark - UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0 && indexPath.row == 0) {
        return 130;
    } else if (indexPath.section == 1 && indexPath.row == 0) {
        return 80;
    } else {
        return 56;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (section == 0) {
        return 0.01;
    }
    return 10;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0.01;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    if (section == 0) {
        return nil;
    }
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, 10)];
    view.backgroundColor = k_background_color;
    return view;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

#pragma mark - UIScrollViewDelegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    CGFloat y = scrollView.contentOffset.y;
    if (y <= 0) { // 下拉
        CGRect rect = self.tableHeaderView.frame;
        rect.size.height = 10 + fabs(y);
        self.tableHeaderView.frame = rect;
    }
}

@end


@interface MMUserDetailCell ()

@property (nonatomic, strong) MMImageView *avatarImageView; // 头像
@property (nonatomic, strong) UIImageView *genderImageView; // 性别
@property (nonatomic, strong) UILabel *nameLabel; // 名称
@property (nonatomic, strong) UILabel *accountLabel; // 微信号
@property (nonatomic, strong) UILabel *regionLabel; // 地区

@end

@implementation MMUserDetailCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        self.accessoryType = UITableViewCellAccessoryNone;
        self.backgroundColor = [UIColor whiteColor];
        // 头像
        _avatarImageView = [MMImageView new];
        _avatarImageView.layer.cornerRadius = 4.0;
        _avatarImageView.layer.masksToBounds = YES;
        [self.contentView addSubview:_avatarImageView];
        [_avatarImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(20);
            make.width.height.mas_equalTo(60);
            make.centerY.equalTo(self.contentView);
        }];
        // 名字
        _nameLabel = [UILabel new];
        _nameLabel.font = [UIFont boldSystemFontOfSize:20.0];
        _nameLabel.textColor = [UIColor blackColor];
        [self.contentView addSubview:_nameLabel];
        [_nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(_avatarImageView.mas_right).offset(15);
            make.top.equalTo(_avatarImageView.mas_top).offset(-5);
            make.width.lessThanOrEqualTo(self.contentView.mas_width).offset(-150);
        }];
        // 性别
        _genderImageView = [UIImageView new];
        [self.contentView addSubview:_genderImageView];
        [_genderImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(_nameLabel.mas_right).offset(5);
            make.width.height.mas_equalTo(17);
            make.centerY.equalTo(_nameLabel);
        }];
        // 账号
        _accountLabel = [UILabel new];
        _accountLabel.font = [UIFont systemFontOfSize:14.0];
        _accountLabel.textColor = [UIColor grayColor];
        [self.contentView addSubview:_accountLabel];
        [_accountLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(_avatarImageView.mas_right).offset(15);
            make.top.equalTo(_nameLabel.mas_bottom).offset(5);
            make.width.lessThanOrEqualTo(self.contentView.mas_width).offset(-100);
        }];
        // 账号
        _regionLabel = [UILabel new];
        _regionLabel.font = [UIFont systemFontOfSize:15.0];
        _regionLabel.textColor = [UIColor grayColor];
        [self.contentView addSubview:_regionLabel];
        [_regionLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(_avatarImageView.mas_right).offset(15);
            make.top.equalTo(_accountLabel.mas_bottom).offset(3);
            make.width.lessThanOrEqualTo(self.contentView.mas_width).offset(-100);
        }];
    }
    return self;
}

- (void)setUser:(MUser *)user
{
    _nameLabel.text = user.name;
    _accountLabel.text = [NSString stringWithFormat:@"微信号：%@",user.account];
    if (user.gender == 1) {
        _genderImageView.image = [UIImage imageNamed:@"mine_female"];
    } else {
        _genderImageView.image = [UIImage imageNamed:@"mine_male"];
    }
    _regionLabel.text = [NSString stringWithFormat:@"地区：%@",user.region];
    [_avatarImageView sd_setImageWithURL:[NSURL URLWithString:user.portrait] placeholderImage:[UIImage imageNamed:@"moment_head"]];
}

@end

@implementation MMUserTitleCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        self.backgroundColor = [UIColor whiteColor];
        self.textLabel.font = [UIFont systemFontOfSize:17.0];
    }
    return self;
}

- (void)setTitle:(NSString *)title
{
    self.textLabel.text = title;
}

@end

@interface MMUserActionCell ()

@property (nonatomic, strong) UIView *container; // 容器
@property (nonatomic, strong) UIImageView *iconImageView; // 图标
@property (nonatomic, strong) UILabel *titleLabel; // 标题

@end

@implementation MMUserActionCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.accessoryType = UITableViewCellAccessoryNone;
        self.backgroundColor = [UIColor whiteColor];
        
        _container = [UIView new];
        [self.contentView addSubview:_container];
        [_container mas_makeConstraints:^(MASConstraintMaker *make) {
            make.center.height.equalTo(self.contentView);
        }];
        
        _iconImageView = [UIImageView new];
        [_container addSubview:_iconImageView];
        [_iconImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(_container).offset(0);
            make.centerY.equalTo(_container);
            make.width.height.mas_equalTo(22);
        }];
        
        _titleLabel = [UILabel new];
        _titleLabel.textColor = MMRGBColor(88, 108, 147);
        _titleLabel.font = [UIFont boldSystemFontOfSize:17.0];
        [_container addSubview:_titleLabel];
        [_titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(_iconImageView.mas_right).offset(5);
            make.right.equalTo(_container).offset(0);
            make.centerY.equalTo(_container);
        }];
    }
    return self;
}

- (void)setTitle:(NSString *)title
{
    self.titleLabel.text = title;
}

- (void)setImage:(UIImage *)image
{
    self.iconImageView.image = image;
}

@end
