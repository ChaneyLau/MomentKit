//
//  MineViewController.m
//  MomentKit
//
//  Created by LEA on 2019/2/2.
//  Copyright © 2019 LEA. All rights reserved.
//

#import "MineViewController.h"
#import "MMUserDetailViewController.h"

@interface MineViewController ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic, strong) MMTableView *tableView;
@property (nonatomic, strong) UIView *tableHeaderView;
@property (nonatomic, strong) NSArray *titles;
@property (nonatomic, strong) MUser *loginUser;

@end

@implementation MineViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.view.backgroundColor = k_background_color;
    [self configUI];
    self.loginUser = [MUser findFirstByCriteria:@"WHERE type = 1"];
    self.titles = [NSArray arrayWithObjects:@[@" "],@[@"服务"],@[@"收藏",@"朋友圈",@"表情"],@[@"设置"], nil];
    [self.tableView reloadData];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.hidden = YES;
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    self.navigationController.navigationBar.hidden = NO;
}

- (void)configUI
{
    _tableHeaderView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, 10)];
    _tableHeaderView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:_tableHeaderView];
    
    _tableView = [[MMTableView alloc] initWithFrame:self.view.bounds style:UITableViewStylePlain];
    _tableView.dataSource = self;
    _tableView.delegate = self;
    _tableView.separatorColor = [UIColor colorWithWhite:0 alpha:0.1];
    if (@available(iOS 15.0, *)) {
        _tableView.sectionHeaderTopPadding = 0.0;
    }
    [self.view addSubview:_tableView];
}

#pragma mark - UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return [self.titles count];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [[self.titles objectAtIndex:section] count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        static NSString *identifier = @"MineInfoCell";
        MineInfoCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
        if (!cell) {
            cell = [[MineInfoCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:identifier];
        }
        cell.user = self.loginUser;
        return cell;
    } else {
        static NSString *identifier = @"MineOtherCell";
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
        if (!cell) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
            cell.backgroundColor = [UIColor whiteColor];
        }
        cell.imageView.image = [UIImage imageNamed:[NSString stringWithFormat:@"mine_list_%ld_%ld",indexPath.section,indexPath.row]];
        cell.textLabel.text = [[self.titles objectAtIndex:indexPath.section] objectAtIndex:indexPath.row];
        cell.textLabel.font = [UIFont systemFontOfSize:17.0];
        return cell;
    }
}

#pragma mark - UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        return 160;
    }
    return 56;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (section == 0) {
        return 0.01;
    }
    return 8;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, section == 0 ? 0.01: 8)];
    view.backgroundColor = k_background_color;
    return view;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0.01;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (indexPath.section != 0) {
        return;
    }
    MMUserDetailViewController *controller = [[MMUserDetailViewController alloc] init];
    controller.user = self.loginUser;
    controller.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:controller animated:YES];
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

#pragma mark -
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

@end

@interface MineInfoCell ()

@property (nonatomic, strong) MMImageView *avatarImageView; // 头像
@property (nonatomic, strong) UIImageView *arrowImageView; // 箭头
@property (nonatomic, strong) UILabel *nameLabel; // 名称
@property (nonatomic, strong) UILabel *accountLabel; // 微信号
@end

@implementation MineInfoCell

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
            make.left.mas_equalTo(30);
            make.width.height.mas_equalTo(60);
            make.centerY.equalTo(self.contentView).offset(10);
        }];
        // 名字
        _nameLabel = [UILabel new];
        _nameLabel.font = [UIFont boldSystemFontOfSize:20.0];
        _nameLabel.textColor = [UIColor blackColor];
        [self.contentView addSubview:_nameLabel];
        [_nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(_avatarImageView.mas_right).offset(15);
            make.top.equalTo(_avatarImageView.mas_top).offset(5);
            make.width.lessThanOrEqualTo(self.contentView.mas_width).offset(-150);
        }];
        // 账号
        _accountLabel = [UILabel new];
        _accountLabel.font = [UIFont systemFontOfSize:15.0];
        _accountLabel.textColor = [UIColor grayColor];
        [self.contentView addSubview:_accountLabel];
        [_accountLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(_avatarImageView.mas_right).offset(15);
            make.top.equalTo(_nameLabel.mas_bottom).offset(5);
            make.width.lessThanOrEqualTo(self.contentView.mas_width).offset(-100);
        }];
        // 账号
        _arrowImageView = [UIImageView new];
        _arrowImageView.image = [UIImage imageNamed:@"mine_list_arrow"];
        [self.contentView addSubview:_arrowImageView];
        [_arrowImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(self.contentView).offset(-10);
            make.centerY.equalTo(_accountLabel);
            make.width.height.mas_equalTo(16);
        }];
    }
    return self;
}

- (void)setUser:(MUser *)user
{
    _nameLabel.text = user.name;
    _accountLabel.text = [NSString stringWithFormat:@"微信号：%@",user.account];
    [_avatarImageView sd_setImageWithURL:[NSURL URLWithString:user.portrait] placeholderImage:[UIImage imageNamed:@"moment_head"]];
}

@end
