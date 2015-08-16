//
//  AppDelegate.m
//  DeathStar
//
//  Created by Tawanda Kanyangarara on 07/01/2015.
//  Copyright (c) 2015 Tawanda Kanyangarara. All rights reserved.
//

#import "AppDelegate.h"
#import <Fabric/Fabric.h>
#import <TwitterKit/TwitterKit.h>
#import <Crashlytics/Crashlytics.h>
#import "TwitterClient.h"
#import <SimpleAuth/SimpleAuth.h>

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    [Fabric with:@[TwitterKit, CrashlyticsKit]];
    
    SimpleAuth.configuration[@"instagram"] = @{ @"client_id" : @"54e23ad3acd8452ba61ed1ee53ba3fa4",
                                               SimpleAuthRedirectURIKey : @"instaTglDeathstar://auth/instagram"
                                               };
   
    return YES;
}


- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    [FBAppEvents activateApp];
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    // Saves changes in the application's managed object context before the application terminates.
    //[self saveContext];
}

-(BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation {
    
    [[TwitterClient sharedInstance] fetchAccessTokenWithPath:@"oauth/access_token" method:@"POST" requestToken:[BDBOAuth1Credential credentialWithQueryString:url.query] success:^(BDBOAuth1Credential *accessToken) {
        NSLog(@"GOt the access token");
        
        
        
        [[TwitterClient sharedInstance].requestSerializer saveAccessToken:accessToken];

    /*
        [[TwitterClient sharedInstance] GET:@"1.1/account/verify_credentials.json" parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
            NSLog(@"%@", responseObject);
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            NSLog(@"Failed to get JSON");
        }];
   */
        [[TwitterClient sharedInstance] GET:@"1.1/statuses/home_timeline.json" parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
            //NSLog(@"%@", responseObject);
            NSLog(@"Got JSON Data 1.1/statuses/home_timeline.json");
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            NSLog(@"Failed to get JSON");
        }];
    } failure:^(NSError *error) {
        NSLog(@"Failed to get token");
    }];
    
//     return [FBAppCall handleOpenURL:url sourceApplication:sourceApplication];
    return YES;
}



@end
