//
//  TestInterstitialCustomEvent.m
//  MoPubIosExtension
//
//  Created by Antoine Kleinpeter on 26/03/15.
//  Copyright (c) 2015 Richard Lord. All rights reserved.
//

#import "TestInterstitialCustomEvent.h"

@implementation TestInterstitialCustomEvent

-(void) requestInterstitialWithCustomEventInfo:(NSDictionary *)info {
    [info setValue:@"interstitial" forKey:@"position"];
    [self.interstitialCustomEvent requestInterstitialWithCustomEventInfo:info];
}

-(void) showInterstitialFromRootViewController:(UIViewController *)rootViewController {
    [self.interstitialCustomEvent showInterstitialFromRootViewController:rootViewController];
}

@end
