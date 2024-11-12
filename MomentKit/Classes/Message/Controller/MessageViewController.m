//
//  MessageViewController.m
//  MomentKit
//
//  Created by LEA on 2019/2/2.
//  Copyright © 2019 LEA. All rights reserved.
//

#import "MessageViewController.h"
#import "SearchResultViewController.h"
#import "MessageCell.h"

@interface MessageViewController ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic, strong) MMTableView *tableView;
@property (nonatomic, strong) NSMutableArray *originList;
@property (nonatomic, strong) NSMutableArray *messageList;

@end

@implementation MessageViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"message_add"] style:UIBarButtonItemStylePlain target:self action:@selector(addMessage)];

    [self.view addSubview:self.tableView];
    
    Message *message;
    // 添加
    message = [[Message alloc] init];
    message.time = [[NSDate date] timeIntervalSince1970];
    message.userName = @"订阅号";
    message.content = @"[10条] 国家博物馆";
    message.userPortrait = @"message_subscribe";
    [self.originList addObject:message];
    
    message = [[Message alloc] init];
    message.time = [[NSDate date] timeIntervalSince1970];
    message.userName = @"文件传输助手";
    message.content = @"[图片]";
    message.userPortrait = @"message_file";
    [self.originList addObject:message];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.messageList removeAllObjects];
    [self.messageList addObjectsFromArray:self.originList];
    [self.messageList addObjectsFromArray:[Message findAll]];
    [self.tableView reloadData];
}

- (void)addMessage
{
    
}

#pragma mark - UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.messageList count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *identifier = @"MessageCell";
    MessageCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (!cell) {
        cell = [[MessageCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:identifier];
        cell.accessoryType = UITableViewCellAccessoryNone;
        cell.backgroundColor = [UIColor whiteColor];
    }
    Message *message = [self.messageList objectAtIndex:indexPath.row];
    cell.message = message;
    return cell;
}

#pragma mark - UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 80;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

#pragma mark - lazy load
- (MMTableView *)tableView
{
    if (!_tableView) {
        _tableView = [[MMTableView alloc] initWithFrame:CGRectMake(0, 0, k_screen_width, k_screen_height-k_top_height - k_bar_height)];
        _tableView.dataSource = self;
        _tableView.delegate = self;
        _tableView.separatorInset = UIEdgeInsetsMake(0, 75, 0, 0);
        
        SearchResultViewController *controller = [[SearchResultViewController alloc] init];
        UISearchController *searchController = [[UISearchController alloc] initWithSearchResultsController:controller];
        searchController.searchBar.userInteractionEnabled = NO;
        searchController.searchBar.enablesReturnKeyAutomatically = YES;
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

- (NSMutableArray *)messageList
{
    if (!_messageList) {
        _messageList = [[NSMutableArray alloc] init];
    }
    return _messageList;
}

- (NSMutableArray *)originList
{
    if (!_originList) {
        _originList = [[NSMutableArray alloc] init];
    }
    return _originList;
}

#pragma mark -
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

@end
