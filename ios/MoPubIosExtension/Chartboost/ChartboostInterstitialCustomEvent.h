//
//  ChartboostInterstitialCustomEvent.h
//  MoPubSDK
//
//  Copyright (c) 2012 MoPub, Inc. All rights reserved.
//

#if __has_include(<MoPub/MoPub.h>)
#import <MoPub/MoPub.h>
#else
#import "MPInterstitialCustomEvent.h"
#endif


/*
 * MoPub certified with version 5.0.1 of the Chartboost SDK.
 * Pixmix certified with version 5.1.5 of the Chartboost SDK.
 */

@interface ChartboostInterstitialCustomEvent : MPInterstitialCustomEvent

/**
 * A string that corresponds to a Chartboost CBLocation used for differentiating ad requests.
 */
@property (nonatomic, copy) NSString *location;

@end