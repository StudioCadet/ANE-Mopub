//
//  MPGoogleAdMobInterstitialCustomEvent.h
//  MoPub
//
//  Copyright (c) 2012 MoPub, Inc. All rights reserved.
//

#if __has_include(<MoPub/MoPub.h>)
#import <MoPub/MoPub.h>
#else
#import "MPInterstitialCustomEvent.h"
#endif
#import <GoogleMobileAds/GADInterstitialDelegate.h>
/*
 * MoPub certified with version 6.12.2 (Jun. 6, 2014) of the Google AdMob Ads SDK.
 * Pixmix certified with version 7.0.0 (Feb. 3, 2015) of the Google AdMob Ads SDK.
 */

@interface MPGoogleAdMobInterstitialCustomEvent : MPInterstitialCustomEvent <GADInterstitialDelegate>

@end
