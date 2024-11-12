//
//  AppDelegate.m
//  MomentKit
//
//  Created by LEA on 2017/12/12.
//  Copyright © 2017年 LEA. All rights reserved.
//

#import "AppDelegate.h"
#import "MainViewController.h"
#import "DBCreator.h"
#import <SDWebImageDownloader.h>
#import <UMMobClick/MobClick.h>
#import <AMapFoundationKit/AMapServices.h>
#import <MAMapKit/MAMapKit.h>

#define kAmapKey    @"3c3bcb3161fa1d2b57d20ad028789228"
#define kUmAK       @"5c77c0370cafb212f80009d2"
#define kVersion    [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"]

@interface AppDelegate ()

@property (strong, nonatomic) MainViewController *rootController;

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    self.window = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
    self.window.backgroundColor = [UIColor whiteColor];
    
    _rootController = [[MainViewController alloc] init];
    self.window.rootViewController = _rootController;
    [self.window makeKeyAndVisible];
    
    // 友盟统计(默认以设备[非用户]为标准,日志非加密)
    [MobClick setAppVersion:kVersion];// 获取应用版本号
    UMConfigInstance.appKey = kUmAK;// appKey
    [MobClick startWithConfigure:UMConfigInstance];// 配置以上参数后调用此方法初始化SDK
#if DEBUG
    [MobClick setLogEnabled:YES];// 调试模式,输出log信息
#else
    [MobClick setLogEnabled:NO];// 发布模式,不输出log信息
#endif
    
    // 高德地图
    [AMapServices sharedServices].apiKey = kAmapKey;
    [MAMapView updatePrivacyShow:AMapPrivacyShowStatusDidShow privacyInfo:AMapPrivacyInfoStatusDidContain];
    [MAMapView updatePrivacyAgree:AMapPrivacyAgreeStatusDidAgree];
    
    // 生成测试数据
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        [DBCreator create];
    });
    
    return YES;
}


- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
}


- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}


- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
}


- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}


- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}


+ (AppDelegate *)sharedInstance
{
    return ((AppDelegate *)[[UIApplication sharedApplication] delegate]);
}

@end
