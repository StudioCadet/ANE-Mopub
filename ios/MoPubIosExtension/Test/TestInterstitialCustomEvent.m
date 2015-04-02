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
    self.interstitialCustomEvent = [[NexageInterstitialCustomEvent alloc] init];
    
    NSMutableDictionary* customInfo = [info mutableCopy];
    
    [customInfo setValue:@"8a809418014c4c5807515ba34f970016" forKey:@"dcn"];
    [customInfo setValue:@"320x480" forKey:@"position"];
    
    [self.interstitialCustomEvent requestInterstitialWithCustomEventInfo:info];
}

-(void) showInterstitialFromRootViewController:(UIViewController *)rootViewController {
    [self.interstitialCustomEvent showInterstitialFromRootViewController:rootViewController];
}

-(BOOL) enableAutomaticImpressionAndClickTracking {
    return [self.interstitialCustomEvent enableAutomaticImpressionAndClickTracking];
}

-(void) dealloc {
    self.interstitialCustomEvent = nil;
    
    [super dealloc];
}
@end
