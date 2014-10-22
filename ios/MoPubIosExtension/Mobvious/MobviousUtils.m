//
//  MobivousUtils.m
//  MoPubIosExtension
//
//  Created by Antoine Kleinpeter on 21/10/14.
//  Copyright (c) 2014 Richard Lord. All rights reserved.
//

#import "MobviousUtils.h"
#import "SASAdView.h"

@implementation MobviousUtils

static Boolean mobviousIsInitialized = false;

+ (Boolean)initializeMobviousIfNecessary:(NSDictionary *)info
{
    if (mobviousIsInitialized)
        return YES;
    
    NSLog(@"Initializing Mobvious...");
        
    if (![info objectForKey:@"MobviousSiteID"] || ![info objectForKey:@"MobviousBaseURL"]) {
        NSLog(@"No MobviousSiteID or MobviousBaseURL to set, cannot initialize Mobivous.");
        return NO;
    }
        
    [SASAdView setSiteID:[[info objectForKey:@"MobviousSiteID"] intValue] baseURL:[info objectForKey:@"MobviousBaseURL"]];
    mobviousIsInitialized = true;
    
    return YES;
}
@end
