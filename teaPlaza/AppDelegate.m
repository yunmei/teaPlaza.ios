//
//  AppDelegate.m
//  teaPlaza
//
//  Created by bevin chen on 13-3-22.
//  Copyright (c) 2013年 maimaicha. All rights reserved.
//

#import "AppDelegate.h"
#import "IndexViewController.h"
#import "ListViewController.h"
#import "UserViewController.h"
#import "AboutViewController.h"
#import "LoginViewController.h"
#import "MobClick.h"

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    self.appEngine = [[MKNetworkEngine alloc]initWithHostName:API_HOSTNAME customHeaderFields:nil];
    [self.appEngine useCache];
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    
    // 定义navigationControllers
    UINavigationController *indexNavigationController = [[UINavigationController alloc]initWithRootViewController:[[IndexViewController alloc] initWithNibName:@"IndexViewController" bundle:nil]];
    UINavigationController *listNavigationController = [[UINavigationController alloc]initWithRootViewController:[[ListViewController alloc] initWithNibName:@"ListViewController" bundle:nil]];
    UINavigationController *userNavigationController = [[UINavigationController alloc]initWithRootViewController:[[UserViewController alloc] initWithNibName:@"UserViewController" bundle:nil]];
    UINavigationController *aboutNavigationController = [[UINavigationController alloc]initWithRootViewController:[[AboutViewController alloc] initWithNibName:@"AboutViewController" bundle:nil]];
    [[UINavigationBar appearance] setBackgroundImage:[UIImage imageNamed:@"navigation_bar_bg"] forBarMetrics:UIBarMetricsDefault];
    [[UINavigationBar appearance] setTintColor:[UIColor colorWithRed:180/255.0f green:180/255.0f blue:180/255.0f alpha:1]];
    
    // 定义tabBarController
    self.tabBarController = [[UITabBarController alloc] init];
    self.tabBarController.viewControllers = @[indexNavigationController, listNavigationController, userNavigationController, aboutNavigationController];
    [self.tabBarController.tabBar setBackgroundImage:[UIImage imageNamed:@"tabbar_bg"]];
    [self.tabBarController.tabBar setSelectionIndicatorImage:[UIImage imageNamed:@"tabbar_bg_selected"]];
    [[UITabBarItem appearance] setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:
                                                       [UIFont systemFontOfSize:10.0], UITextAttributeFont,
                                                       [UIColor colorWithRed:59/255.0 green:59/255.0 blue:59/255.0 alpha:1.0], UITextAttributeTextColor,
                                                       nil] forState:UIControlStateNormal];
    
    self.window.rootViewController = self.tabBarController;
    [self.window makeKeyAndVisible];
    [MobClick startWithAppkey:UM_APPKEY];
    [MobClick checkUpdate];
    [MobClick setLogEnabled:NO];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(openLoginView:) name:@"INeedToLogin" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(userRespondsLogin:) name:@"UserRespondsLogin" object:nil];
    return YES;
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
}

- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation
{
    NSLog(@"url:%@", url);
    NSLog(@"sourceApplication:%@", sourceApplication);
    return YES;
}
/*
// Optional UITabBarControllerDelegate method.
- (void)tabBarController:(UITabBarController *)tabBarController didSelectViewController:(UIViewController *)viewController
{
}
*/

/*
// Optional UITabBarControllerDelegate method.
- (void)tabBarController:(UITabBarController *)tabBarController didEndCustomizingViewControllers:(NSArray *)viewControllers changed:(BOOL)changed
{
}
*/

- (void)openLoginView:(NSNotification *)note
{
    UINavigationController *navController = [[UINavigationController alloc] initWithRootViewController:[[LoginViewController alloc] initWithNibName:@"LoginViewController" bundle:nil]];
    [self.tabBarController.selectedViewController presentModalViewController:navController animated:YES];
}
- (void)userRespondsLogin:(NSNotification *)note
{
    if ([[note userInfo]objectForKey:@"cancel"]) {
        if (self.tabBarController.selectedIndex == 2) {
            [self.tabBarController setSelectedIndex:0];
        }
    }
}
@end
