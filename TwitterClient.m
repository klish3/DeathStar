//
//  TwitterClient.m
//  DeathStar
//
//  Created by Tawanda Kanyangarara on 11/02/2015.
//  Copyright (c) 2015 Tawanda Kanyangarara. All rights reserved.
//

#import "TwitterClient.h"


NSString *const kTwitterConsumerKey = @"ybWs3BuB2JbKWojQxWvaLdnGT";
NSString *const kTwitterConsumerSecret = @"a00LmfHdrmU0neKXjw3SXrCqCdufKXA7Pdmu3mtRT1OiyLXVsG";
NSString *const kTwitterBaseUrl = @"https://api.twitter.com/";

@implementation TwitterClient

+ (TwitterClient *)sharedInstance {
    static TwitterClient *instance = nil;
    
 
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        if (instance == nil) {
            instance = [[TwitterClient alloc]initWithBaseURL:[NSURL
                URLWithString:kTwitterBaseUrl] consumerKey:kTwitterConsumerKey
                consumerSecret:kTwitterConsumerSecret];
        }
    });
    
    return instance;
}

@end
