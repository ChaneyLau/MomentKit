//
//  UKViewController.m
//  MomentKit
//
//  Created by LEA on 2017/12/12.
//  Copyright © 2017年 LEA. All rights reserved.
//

#import "UKViewController.h"

@interface UKViewController ()<UIGestureRecognizerDelegate>

@end

@implementation UKViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.navigationController.interactivePopGestureRecognizer.delegate = (id)self;
    self.view.backgroundColor = k_background_color;
    
    // 添加返回按钮
    if ([self.navigationController.viewControllers count] > 1) {
        UIButton *backButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 44, 44)];
        backButton.accessibilityTraits = UIAccessibilityTraitNone;
        backButton.accessibilityLabel = @"返回";
        [backButton setImage:[UIImage imageNamed:@"navigation_back"] forState:UIControlStateNormal];
        [backButton setImageEdgeInsets:UIEdgeInsetsMake(0, -10, 0, 10)];
        [backButton addTarget:self action:@selector(onBackClick) forControlEvents:UIControlEventTouchUpInside];
        self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:backButton];
    }
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    self.navigationController.navigationBar.tintColor = [UIColor blackColor];
    if (@available(iOS 15.0, *)) {
        UINavigationBarAppearance *appearance = [[UINavigationBarAppearance alloc] init];
        appearance.backgroundEffect = [UIBlurEffect effectWithStyle:UIBlurEffectStyleRegular];
        appearance.titleTextAttributes = @{NSFontAttributeName:[UIFont boldSystemFontOfSize:17.0]};
        [appearance configureWithDefaultBackground];
        [appearance setBackgroundImage:[UIImage imageWithRenderColor:k_background_color renderSize:CGSizeMake(3, 3)]];
        [appearance setShadowImage:[UIImage imageWithRenderColor:k_background_color renderSize:CGSizeMake(3, 3)]];
        self.navigationController.navigationBar.standardAppearance = appearance;
        self.navigationController.navigationBar.scrollEdgeAppearance = appearance;
    } else {
        self.navigationController.navigationBar.titleTextAttributes = @{NSFontAttributeName:[UIFont boldSystemFontOfSize:17.0]};
        [self.navigationController.navigationBar setBackgroundImage:[UIImage imageWithRenderColor:k_background_color renderSize:CGSizeMake(3, 3)] forBarMetrics:UIBarMetricsDefault];
        [self.navigationController.navigationBar setShadowImage:[UIImage new]];
    }
}

- (void)onBackClick
{
    [self.navigationController popViewControllerAnimated:YES];
}

@end
