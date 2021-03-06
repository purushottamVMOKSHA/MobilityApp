//
//  AppDelegate.m
//  SimplicITy
//
//  Created by Varghese Simon on 12/3/14.
//  Copyright (c) 2014 Vmoksha. All rights reserved.
//

#import "AppDelegate.h"

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    // Override point for customization after application launch.
    
    [NSThread sleepForTimeInterval:4.0];


    [[UITabBar appearance] setTintColor:[UIColor whiteColor]];
    

    [[UINavigationBar appearance] setTintColor:[UIColor whiteColor]];
    [[UINavigationBar appearance] setTitleTextAttributes:@{NSForegroundColorAttributeName: [UIColor whiteColor],
                                                           NSFontAttributeName : [UIFont fontWithName:@"MuseoSans-700" size:20]}];
    
    
    
    switch ([[NSUserDefaults standardUserDefaults] integerForKey:@"BackgroundTheme"])
    {
        case 0:
            [[UITabBar appearance] setBarTintColor:[UIColor colorWithRed:.13 green:.31 blue:.46 alpha:1]];
            [[UINavigationBar appearance] setBarTintColor:[UIColor colorWithRed:.13 green:.31 blue:.46 alpha:1]];
            
            
//            [[UITabBar appearance] setSelectedImageTintColor:[UIColor greenColor]];
            
            [UITabBar appearance];

            break;
            
        case 1:
            [[UITabBar appearance] setBarTintColor:[UIColor colorWithRed:.9 green:.45 blue:.23 alpha:1]];
            [[UINavigationBar appearance] setBarTintColor:[UIColor colorWithRed:.9 green:.45 blue:.23 alpha:1]];
            break;
            
        case 2:
            [[UITabBar appearance] setBarTintColor:[UIColor colorWithRed:.76 green:.06 blue:.29 alpha:1]];
            [[UINavigationBar appearance] setBarTintColor:[UIColor colorWithRed:.76 green:.06 blue:.29 alpha:1]];
            break;
            
        case 3:
            [[UITabBar appearance] setBarTintColor:[UIColor colorWithRed:.55 green:.7 blue:.31 alpha:1]];
            [[UINavigationBar appearance] setBarTintColor:[UIColor colorWithRed:.55 green:.7 blue:.31 alpha:1]];
            break;
        default:
            break;
    }
    

    return YES;
}

- (void)setTabsWithColorIndex:(NSInteger)colorIndex
{
    
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

@end
