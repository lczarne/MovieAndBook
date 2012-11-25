//
//  NewApplicationAppDelegate.m
//  NewApplication
//
//  Created by Łukasz Czarnecki on 2/10/12.
//  Copyright (c) 2012 htdt. All rights reserved.
//

#import "NewApplicationAppDelegate.h"
#import <FacebookSDK/FacebookSDK.h>
#import "GAI.h"
static const NSInteger kGANDispatchPeriodSec = 10;
static const NSString *GoogleAnalyticsUA = @"UA-36289154-2";

@implementation NewApplicationAppDelegate

@synthesize window = _window;;

- (BOOL)application:(UIApplication *)application
            openURL:(NSURL *)url
  sourceApplication:(NSString *)sourceApplication
         annotation:(id)annotation {
    // attempt to extract a token from the url
    return [FBSession.activeSession handleOpenURL:url];
}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    [GAI sharedInstance].trackUncaughtExceptions = YES;
    [GAI sharedInstance].dispatchInterval = kGANDispatchPeriodSec;
    [GAI sharedInstance].debug = YES;
    NSString *UAID = [NSString stringWithFormat:@"%@",GoogleAnalyticsUA];
    id<GAITracker> tracker = [[GAI sharedInstance] trackerWithTrackingId:UAID];
    
    [GAI sharedInstance].defaultTracker = tracker;
    return YES;
}
							
- (void)applicationWillResignActive:(UIApplication *)application
{
    /*
     Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
     Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
     */
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    /*
     Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
     If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
     */
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    /*
     Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
     */
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    /*
     Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
     */
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    [FBSession.activeSession close];

    /*
     Called when the application is about to terminate.
     Save data if appropriate.
     See also applicationDidEnterBackground:.
     */
}

@end
