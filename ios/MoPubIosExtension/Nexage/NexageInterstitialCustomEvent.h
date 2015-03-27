//
//  NexageInsterstitialCustomEvent.h
//  MoPubIosExtension
//
//  Created by Antoine Kleinpeter on 25/03/15.
//  Copyright (c) 2015 Richard Lord. All rights reserved.
//

#import "MPInterstitialCustomEvent.h"
#import <Nexage/Nexage.h>
#import "MoPubCustomEventClassData.h"

#define DISPATCH_LOG_EVENT(context, logMessage) FREDispatchStatusEventAsync(context, (uint8_t*)logMessage.UTF8String, logSent);


/**
 * Certified with version 5.6.3 of the Nexage SDK.
 */
@interface NexageInterstitialCustomEvent : MPInterstitialCustomEvent<NexageInterstitialAdDelegate, NexageManagerDelegate>

@property (nonatomic, retain) NexageInterstitial *interstitial;
@property (nonatomic, retain) MoPubCustomEventClassData *customEventClassData;
@end
