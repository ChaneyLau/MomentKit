//
//  MainViewController.m
//  MomentKit
//
//  Created by LEA on 2017/12/12.
//  Copyright © 2017年 LEA. All rights reserved.
//

#import "MainViewController.h"
#import "DiscoverViewController.h"
#import "MineViewController.h"
#import "MessageViewController.h"
#import "ContactsViewController.h"
#import "MomentUtil.h"

@interface MainViewController ()

@end

@implementation MainViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self.tabBar setBackgroundImage:[UIImage imageWithRenderColor:MMRGBColor(245.0, 245.0, 245.0) renderSize:CGSizeMake(3, 3)]];
    self.tabBar.unselectedItemTintColor = [UIColor blackColor];
    self.tabBar.tintColor = MMRGBColor(32.0, 191.0, 100.0);
    self.tabBar.shadowImage = [UIImage imageWithRenderColor:[UIColor colorWithWhite:0 alpha:0.1] renderSize:CGSizeMake(0.5, 0.5)];
   
    UIView *tabBgView = [UIView new];
    tabBgView.backgroundColor = MMRGBColor(245.0, 245.0, 245.0);
    [self.tabBar.superview insertSubview:tabBgView belowSubview:self.tabBar];
    [tabBgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.tabBar);
    }];
    
    // 控制器
    MessageViewController *messageVC = [[MessageViewController alloc] init];
    ContactsViewController *contactsVC = [[ContactsViewController alloc] init];
    DiscoverViewController *discoverVC = [[DiscoverViewController alloc] init];
    MineViewController *mineVC = [[MineViewController alloc] init];
    NSArray *controllers = @[messageVC,contactsVC,discoverVC,mineVC];
    // tabbar
    NSArray *titles = @[@"微信",@"通讯录",@"发现",@"我"];
    NSMutableArray *viewControllers = [[NSMutableArray alloc] init];
    for (int i = 0; i < 4; i ++)
    {
        // 图片
        UIImage *image = [UIImage imageNamed:[NSString stringWithFormat:@"tabbar_%d",i]];
        UIImage *selectedImage = [UIImage imageNamed:[NSString stringWithFormat:@"tabbar_hl_%d",i]];
        // 项
        UITabBarItem *item = [[UITabBarItem alloc] initWithTitle:titles[i] image:image selectedImage:selectedImage];
        [item setTitleTextAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:10.0]} forState:UIControlStateNormal];
        // 控制器
        UIViewController *controller = controllers[i];
        if (i == 3) {
            controller.title = @"";
        } else {
            controller.title = [titles objectAtIndex:i];
        }
        controller.tabBarItem = item;
        // 导航
        UINavigationController *navigation = [[UINavigationController alloc] initWithRootViewController:controller];
        navigation.navigationBar.translucent = NO;
        navigation.navigationBar.tintColor = [UIColor blackColor];
        if (@available(iOS 15.0, *)) {
            UINavigationBarAppearance *appearance = [[UINavigationBarAppearance alloc] init];
            appearance.backgroundEffect = [UIBlurEffect effectWithStyle:UIBlurEffectStyleRegular];
            appearance.titleTextAttributes = @{NSFontAttributeName:[UIFont boldSystemFontOfSize:17.0]};
            [appearance configureWithDefaultBackground];
            [appearance setBackgroundImage:[UIImage imageWithRenderColor:k_background_color renderSize:CGSizeMake(5, 5)]];
            [appearance setShadowColor:nil];
            navigation.navigationBar.standardAppearance = appearance;
            navigation.navigationBar.scrollEdgeAppearance = appearance;
        } else {
            navigation.navigationBar.titleTextAttributes = @{NSFontAttributeName:[UIFont boldSystemFontOfSize:17.0]};
            [navigation.navigationBar setBackgroundImage:[UIImage imageWithRenderColor:k_background_color renderSize:CGSizeMake(5, 5)] forBarMetrics:UIBarMetricsDefault];
            [navigation.navigationBar setShadowImage:[UIImage new]];
        }
        [viewControllers addObject:navigation];
    }
    self.viewControllers = viewControllers;
}

#pragma mark -
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

@end
