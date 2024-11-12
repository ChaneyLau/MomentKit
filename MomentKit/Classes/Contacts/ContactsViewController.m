//
//  ContactsViewController.m
//  MomentKit
//
//  Created by LEA on 2019/2/2.
//  Copyright © 2019 LEA. All rights reserved.
//

#import "ContactsViewController.h"
#import "SearchResultViewController.h"
#import "MMUserDetailViewController.h"
#import "MMImageListView.h"
#import "NSString+Letter.h"
#import "MUser.h"

@interface ContactsViewController ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic, strong) MMTableView *tableView;
@property (nonatomic, strong) UIView *contactView;
@property (nonatomic, strong) UILabel *contactNumLab;
@property (nonatomic, strong) NSMutableArray *indexes;
@property (nonatomic, strong) NSMutableArray *sectionTitles;
@property (nonatomic, strong) NSMutableArray *userList;

@end

@implementation ContactsViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.view.backgroundColor = k_background_color;
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"contact_add"] style:UIBarButtonItemStylePlain target:self action:@selector(addContact)];

    [self configData];
    [self.view addSubview:self.tableView];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
}

#pragma mark - load data
- (void)configData
{
    // 联系人数据 ↓↓
    NSArray *users = [MUser findAll];
    // 分组和排序 ↓↓
    UILocalizedIndexedCollation *indexedCollation = [UILocalizedIndexedCollation currentCollation];
    self.sectionTitles = [[NSMutableArray alloc] initWithArray:[indexedCollation sectionTitles]];
    NSInteger sectionNum = [self.sectionTitles count];
    NSMutableArray *newSectionsArray = [[NSMutableArray alloc] initWithCapacity:sectionNum];
    // 空数组
    for (int i = 0; i < sectionNum; i ++) {
        NSMutableArray *array = [[NSMutableArray alloc] init];
        [newSectionsArray addObject:array];
    }
    // 插入数据
    for (MUser *user in users)
    {
        if (user.name.length <= 0) {
            NSMutableArray *sectionTitles = newSectionsArray.lastObject;
            [sectionTitles addObject:user];
        } else {
            NSInteger sectionIndex = [indexedCollation sectionForObject:user.name collationStringSelector:@selector(firstLetter)];
            NSMutableArray *sectionTitles = newSectionsArray[sectionIndex];
            [sectionTitles addObject:user];
        }
    }
    // 移除空数组
    for (int i = 0; i < newSectionsArray.count; i ++)
    {
        NSMutableArray *sectionTitles = newSectionsArray[i];
        if (sectionTitles.count == 0) {
            [newSectionsArray removeObjectAtIndex:i];
            if(sectionNum > i) {
                [self.sectionTitles removeObjectAtIndex:i];
            }
            i --;
        }
    }
    // 第一组
    NSArray *titles = [NSArray arrayWithObjects:@"新朋友",@"群聊",@"标签",@"公众号", nil];
    [newSectionsArray insertObject:titles atIndex:0];
    // 二维数组
    self.userList = newSectionsArray;
    self.indexes = [[NSMutableArray alloc] init];
    [self.indexes addObject:UITableViewIndexSearch];
    [self.indexes addObjectsFromArray:self.sectionTitles];
    // 显示联系人数目
    self.contactNumLab.text = [NSString stringWithFormat:@"%ld个朋友",[users count]];
    [self.tableView reloadData];
    
    GCD_AFTER(0.5, ^{
        NSLog(@"11：%@", NSStringFromCGRect(self.contactView.frame));
    });
}

- (void)addContact
{
    
}

#pragma mark - UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return [self.userList count];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [[self.userList objectAtIndex:section] count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *identifier = @"ContactsCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:identifier];
        cell.accessoryType = UITableViewCellAccessoryNone;
        cell.backgroundColor = [UIColor whiteColor];
        // 头像
        MMImageView *imageView = [MMImageView new];
        imageView.tag = 101;
        imageView.layer.cornerRadius = 4.0;
        imageView.layer.masksToBounds = YES;
        [cell.contentView addSubview:imageView];
        [imageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.width.height.mas_equalTo(40);
            make.left.mas_equalTo(15);
            make.centerY.equalTo(cell.contentView);
        }];
        // 昵称
        UILabel *label = [UILabel new];
        label.tag = 102;
        label.font = [UIFont systemFontOfSize:17.0];
        [cell.contentView addSubview:label];
        [label mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(imageView.mas_right).offset(10);
            make.right.equalTo(cell.contentView).offset(-15);
            make.centerY.equalTo(cell.contentView);
        }];
        // 分割线
        UIView *line = [UIView new];
        line.tag = 103;
        line.backgroundColor = [UIColor colorWithWhite:0 alpha:0.1];
        [cell.contentView addSubview:line];
        [line mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(cell.contentView).offset(65);
            make.right.bottom.equalTo(cell.contentView).offset(0);
            make.height.mas_equalTo(0.5);
        }];
    }
    MMImageView *imageView = [cell.contentView viewWithTag:101];
    UILabel *label = [cell.contentView viewWithTag:102];
    UIView *line = [cell.contentView viewWithTag:103];
    // 赋值
    if (indexPath.section == 0) {
        imageView.image = [UIImage imageNamed:[NSString stringWithFormat:@"contact_%ld",indexPath.row]];
        label.text = [[self.userList objectAtIndex:indexPath.section] objectAtIndex:indexPath.row];
    } else {
        MUser *user = [[self.userList objectAtIndex:indexPath.section] objectAtIndex:indexPath.row];
        label.text = user.name;
        [imageView sd_setImageWithURL:[NSURL URLWithString:user.portrait] placeholderImage:[UIImage imageNamed:@"mine_head"]];
    }
    // 分割线
    NSInteger rowNum = [[self.userList objectAtIndex:indexPath.section] count];
    if (indexPath.row == rowNum - 1) {
        [line mas_updateConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(cell.contentView).offset(15);
        }];
    } else {
        [line mas_updateConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(cell.contentView).offset(65);
        }];
    }
    return cell;
}

- (NSArray *)sectionIndexTitlesForTableView:(UITableView *)tableView
{
    return self.indexes;
}

- (NSInteger)tableView:(UITableView *)tableView sectionForSectionIndexTitle:(NSString *)title atIndex:(NSInteger)index
{
    NSIndexPath *selectIndexPath = [NSIndexPath indexPathForRow:0 inSection:index];
    if(index == 0) { // 搜索框
        [tableView setContentOffset:CGPointMake(0,0) animated:NO];
        return -1;
    } else  {
        [tableView scrollToRowAtIndexPath:selectIndexPath atScrollPosition:UITableViewScrollPositionBottom animated:YES];
    }
    return index;
}

#pragma mark - UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 56;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return section > 0 ? 40 : 0.01;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    if (section == 0) {
        return nil;
    }
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, 40)];
    view.backgroundColor = [UIColor whiteColor];
    
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(15, 20, self.view.bounds.size.width - 30, 20)];
    label.font = [UIFont boldSystemFontOfSize:14.0];
    label.text = self.sectionTitles[section-1];
    label.textColor = [UIColor grayColor];
    [view addSubview:label];
    return view;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (indexPath.section == 0) {
        return;
    }
    MUser *user = [[self.userList objectAtIndex:indexPath.section] objectAtIndex:indexPath.row];
    MMUserDetailViewController *controller = [[MMUserDetailViewController alloc] init];
    controller.user = user;
    controller.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:controller animated:YES];
}

#pragma mark - UIScrollViewDelegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    CGFloat a = scrollView.contentOffset.y;
    CGFloat b = scrollView.bounds.size.height;
    CGFloat c = scrollView.contentSize.height;
    CGFloat d = a + b - c;
    if (d > 0) { // 上拉
        CGRect rect = self.contactView.frame;
        rect.size.height = 50 + d;
        self.contactView.frame = rect;
    }
}

#pragma mark - lazy load
- (MMTableView *)tableView
{
    if (!_tableView) {
        _tableView = [[MMTableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
        _tableView.dataSource = self;
        _tableView.delegate = self;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.sectionIndexColor = [UIColor colorWithWhite:0 alpha:0.5];
        if (@available(iOS 15.0, *)) {
            _tableView.sectionHeaderTopPadding = 0.0;
        }
        _tableView.tableFooterView = self.contactView;

        SearchResultViewController *controller = [[SearchResultViewController alloc] init];
        UISearchController *searchController = [[UISearchController alloc] initWithSearchResultsController:controller];
        searchController.searchBar.userInteractionEnabled = NO;
        [searchController.searchBar setPositionAdjustment:UIOffsetMake((self.view.bounds.size.width-80)/2.0, 0) forSearchBarIcon:UISearchBarIconSearch];
        [searchController.searchBar setBackgroundImage:[UIImage imageWithRenderColor:k_background_color renderSize:CGSizeMake(1, 1)] forBarPosition:UIBarPositionAny barMetrics:UIBarMetricsDefault];
        [searchController.searchBar sizeToFit];
        // 输入框
        UITextField *searchField = nil;
        if (@available(iOS 13.0, *)) {
            searchField = [searchController.searchBar valueForKey:@"searchTextField"];
        } else {
            searchField = [searchController.searchBar valueForKey:@"_searchField"];
        }
        searchField.borderStyle = UITextBorderStyleNone;
        searchField.textAlignment = NSTextAlignmentCenter;
        searchField.textColor = [UIColor lightGrayColor];
        searchField.font = [UIFont systemFontOfSize:17];
        searchField.placeholder = @"搜索";
        searchField.layer.masksToBounds = YES;
        searchField.layer.cornerRadius = 5;
        searchField.backgroundColor = [UIColor whiteColor];
        _tableView.tableHeaderView = searchController.searchBar;
        // 更新
        [searchField mas_updateConstraints:^(MASConstraintMaker *make) {
            make.height.mas_equalTo(36);
            make.left.mas_equalTo(10);
            make.right.mas_equalTo(-10);
            make.centerY.equalTo(searchField.superview);
        }];
    }
    return _tableView;
}

- (UIView *)contactView
{
    if (!_contactView) {
        _contactView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, 50)];
        _contactView.backgroundColor = [UIColor whiteColor];
        [_contactView addSubview:self.contactNumLab];
    }
    return _contactView;
}

- (UILabel *)contactNumLab
{
    if (!_contactNumLab) {
        _contactNumLab = [[UILabel alloc] initWithFrame:CGRectMake(0, 10, self.view.bounds.size.width, 30)];
        _contactNumLab.textAlignment = NSTextAlignmentCenter;
        _contactNumLab.font = [UIFont systemFontOfSize:15.0];
        _contactNumLab.textColor = [UIColor colorWithWhite:0 alpha:0.5];
    }
    return _contactNumLab;
}

#pragma mark -
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

@end



