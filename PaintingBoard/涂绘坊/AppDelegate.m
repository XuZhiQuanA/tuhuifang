//
//  AppDelegate.m
//  涂绘坊
//
//  Created by dmt312 on 2019/4/27.
//  Copyright © 2019 xzq. All rights reserved.
//

#import "AppDelegate.h"
#import "XZQTabBarController.h"
#import "XZQLaunchIViewController.h"

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    
    //1.给window赋值
    self.window = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
    
    //2.设置根控制器
    
//    XZQTabBarController *tabBar = [[XZQTabBarController alloc] init];
//
//    self.window.rootViewController = tabBar;
    
    XZQLaunchIViewController *launchVC = [[XZQLaunchIViewController alloc] init];
    self.window.rootViewController = launchVC;
    
    //3.主窗口
    [self.window makeKeyAndVisible];
    
    //启动完成之后显示状态栏
    application.statusBarHidden = YES;
    
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


@end
