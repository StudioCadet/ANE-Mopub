//
//  ChartboostInterstitialCustomEvent.m
//  MoPub
//
//  Copyright (c) 2012 MoPub, Inc. All rights reserved.
//

#import "ChartboostInterstitialCustomEvent.h"
#import "MPInstanceProvider.h"
#import "MPLogging.h"

#define kChartboostAppID        @"530f145f2d42da3e6e213c26"
#define kChartboostAppSignature @"6dbe46fc9262f1eb835648eb349c56d75eb873c8"

////////////////////////////////////////////////////////////////////////////////////////////////////

@implementation ChartboostInterstitialCustomEvent

#pragma mark - MPInterstitialCustomEvent Subclass Methods

- (void)requestInterstitialWithCustomEventInfo:(NSDictionary *)info
{
    NSString *appId = [info objectForKey:@"appId"];
    if (!appId) {
        appId = kChartboostAppID;
    }
    NSString *appSignature = [info objectForKey:@"appSignature"];
    if (!appSignature) {
        appSignature = kChartboostAppSignature;
    }

    NSLog(@"Initializing Chartboost...");
    [Chartboost startWithAppId:appId appSignature:appSignature delegate:self];
    
    NSLog(@"Requesting Chartboost interstitial.");
    [Chartboost cacheInterstitial:CBLocationGameScreen];
    NSLog(@"Waiting for the interstital to be cached...");
}

- (void)showInterstitialFromRootViewController:(UIViewController *)rootViewController
{
    if ([Chartboost hasInterstitial:CBLocationGameScreen]) {
        NSLog(@"Chartboost interstitial will be shown.");
        [self.delegate interstitialCustomEventWillAppear:self];
        [Chartboost showInterstitial:CBLocationGameScreen];
    } else {
        NSLog(@"Failed to show Chartboost interstitial.");
        [self.delegate interstitialCustomEvent:self didFailToLoadAdWithError:nil];
    }
}

#pragma mark - ChartboostDelegate

- (void)didCacheInterstitial:(CBLocation)location
{
    NSLog(@"Successfully loaded Chartboost interstitial.");

    [self.delegate interstitialCustomEvent:self didLoadAd:nil];
}

- (void)didFailToLoadInterstitial:(CBLocation)location withError:(CBLoadError)error
{
    NSLog(@"Failed to load Chartboost interstitial.");

    [self.delegate interstitialCustomEvent:self didFailToLoadAdWithError:nil];
}

- (void)didDismissInterstitial:(CBLocation)location
{
    NSLog(@"Chartboost interstitial was dismissed.");

    [self.delegate interstitialCustomEventWillDisappear:self];
    [self.delegate interstitialCustomEventDidDisappear:self];
}

- (void)didClickInterstitial:(CBLocation)location
{
    NSLog(@"Chartboost interstitial was clicked.");
    [self.delegate interstitialCustomEventDidReceiveTapEvent:self];
}

- (void)didDisplayInterstitial:(CBLocation)location
{
    NSLog(@"Successfully loaded Chartboost interstitial.");
    
    [self.delegate interstitialCustomEventDidAppear:self];
}

@end
