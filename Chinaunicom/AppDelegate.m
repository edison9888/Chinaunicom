//
//  AppDelegate.m
//  Chinaunicom
//
//  Created by on 13-5-4.
//  Copyright (c) 2013年 Chinaunicom. All rights reserved.
//

#import "AppDelegate.h"
#import "LoginViewController.h"
#import "LoadingController.h"
#import "MessageTypeViewController.h"
#import "HttpRequestHelper.h"
@implementation AppDelegate



- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    // 引导页
    loadingcontroller=[[LoadingController alloc] initWithNibName:@"LoadingController" bundle:nil];
    self.window.rootViewController =loadingcontroller;
    self.window.backgroundColor = [UIColor whiteColor];
    [self.window makeKeyAndVisible];
    
    //3秒后转到登陆页
   timer = [NSTimer scheduledTimerWithTimeInterval:3 target:self selector:@selector(myThreadMainMethod) userInfo:nil repeats:NO];
    return YES;
}
//进入登陆页
-(void)myThreadMainMethod
{
    //移除引导页
    [loadingcontroller.view removeFromSuperview];
    loadingcontroller=nil;
    
    //实例化一个登陆页
    LoginViewController *login=[[LoginViewController alloc]  initWithNibName:@"LoginViewController" bundle:nil];
    //自定义一个导航控制器
//    BaseNavigationController *baseNav=[[BaseNavigationController alloc] initWithRootViewController:login];
    UINavigationController *loginNav=[[UINavigationController alloc]initWithRootViewController:login];
    [loginNav setNavigationBarHidden:YES];
//    [loginNav.navigationBar setBackgroundImage:[UIImage imageNamed:@"title@2x.png"] forBarMetrics:UIBarMetricsDefault];
    self.window.rootViewController =loginNav;
//    self.revealSideViewController = [[PPRevealSideViewController alloc] initWithRootViewController:login];
//    self.window.rootViewController =self.revealSideViewController;
}
- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
    
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
     [self myThreadMainMethod];
}

@end
