//
//  BAAppDelegate.m
//  BrainAlarm
//
//  Created by Nathaniel Mendoza on 10/22/14.
//  Copyright (c) 2014 ___CSE494___. All rights reserved.
//

#import <Parse/Parse.h>

#import "BAAlarmModel.h"
#import "BAAppDelegate.h"
#import "BACompleteTaskViewController.h"
#import "BATableViewController.h"

@implementation BAAppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
	[Parse setApplicationId:@"fmXRs0nWQKwnN5RSLOk9KJAOVmzzw0eLiiwylAXq"
				  clientKey:@"TiqbUTdJGI5gM3ULHrJk8IlKaTvjWJdaZAtj2E3i"];
	
	[PFAnalytics trackAppOpenedWithLaunchOptions:launchOptions];
	
	[BAAlarmModel registerSubclass];
	
    //Asks the user to allow notifications
    if ([UIApplication instancesRespondToSelector:@selector(registerUserNotificationSettings:)]){
        [application registerUserNotificationSettings:[UIUserNotificationSettings settingsForTypes:UIUserNotificationTypeAlert|UIUserNotificationTypeBadge|UIUserNotificationTypeSound categories:nil]];
    }
    
    //If a notification is fired, show them the task they need to complete
   UILocalNotification *locationNotification = [launchOptions objectForKey:UIApplicationLaunchOptionsLocalNotificationKey];
    if (locationNotification) {
        UIStoryboard * storyBoard = [UIStoryboard storyboardWithName:@"Main" bundle:[NSBundle mainBundle]];
        BACompleteTaskViewController * notificationViewController = [storyBoard instantiateViewControllerWithIdentifier:@"CompleteTaskViewController"];
        
        notificationViewController.notification = [locationNotification copy];
        
        notificationViewController.date = [locationNotification.fireDate copy];

        [BATableViewController LoadAlarmList];

        [self.window.rootViewController presentViewController:notificationViewController animated:YES completion:nil];
    }
    
    
    
    return YES;
}

//If a notification is fired, show them the task they need to complete
-(void)application:(UIApplication*)application didReceiveLocalNotification:(UILocalNotification *)notification
{
    UIStoryboard * storyBoard = [UIStoryboard storyboardWithName:@"Main" bundle:[NSBundle mainBundle]];
    BACompleteTaskViewController * notificationViewController = [storyBoard instantiateViewControllerWithIdentifier:@"CompleteTaskViewController"];
    
   notificationViewController.notification = [notification copy];
    notificationViewController.date = [notification.fireDate copy];
    
    [BATableViewController LoadAlarmList];

    self.window.rootViewController = notificationViewController;
    
    
    
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
