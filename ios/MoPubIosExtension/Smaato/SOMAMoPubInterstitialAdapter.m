//
//  SOMAMoPubInterstitialAdapter.m
//  SmaatoShowcase
//
//  Created by Aman Shaikh on 09/10/14.
//  Copyright (c) 2014 Smaato Inc. All rights reserved.
//

#import "MPLogging.h"
#import "SOMAMoPubInterstitialAdapter.h"
#import "MoPubCustomEventClassData.h"
#import "MoPubKeywords.h"

@implementation SOMAMoPubInterstitialAdapter
- (void)requestInterstitialWithCustomEventInfo:(NSDictionary *)info {
    MPLogInfo(@"Requesting a Smaato interstitial ad...");
    
    MoPubCustomEventClassData* customEventClassData = [[MoPubCustomEventClassData alloc] initWithMopubWebsiteData:info];

    if (![customEventClassData hasRequiredProperties:@[@"publisherId",@"adSpaceId"]]) {
        MPLogError(@"One of the required properties is missing, cannot load interstitial !");
        [self.delegate interstitialCustomEvent:self didFailToLoadAdWithError:nil];
        return;
    }
    
    [self prepareAdViewFromCustomEventClassData:customEventClassData];
    
	[self.adview load];
}

- (void) prepareAdViewFromCustomEventClassData:(MoPubCustomEventClassData *)customEventClassData {
    NSDictionary *dicFromEnum = [NSDictionary dictionaryWithObjectsAndKeys:@"0", @"SOMAAdDimensionDefault", @"1", @"SOMAAdDimensionXXLARGE", @"2", @"SOMAAdDimensionXLARGE", @"3", @"SOMAAdDimensionMMA", @"4", @"SOMAAdDimensionMedRect", @"5", @"SOMAAdDimensionLeader", @"6", @"SOMAAdDimensionSky", @"7", @"SOMAAdDimensionWideSky", @"8", @"SOMAAdDimensionInterstitialLandscapePhone", @"9", @"SOMAAdDimensionInterstitialPortraitPhone", @"10", @"SOMAAdDimensionInterstitialLandscapePad", @"11", @"SOMAAdDimensionInterstitialPortraitPad", nil];
    
    self.adview = [[SOMAInterstitialAdView alloc] init];
    self.adview.delegate = self;
    
    int enumDimension = 0;
    if ([dicFromEnum objectForKey:[customEventClassData getPropertyValue:@"dimension"]]) {
        enumDimension = [[dicFromEnum objectForKey:[customEventClassData getPropertyValue:@"dimension"]] intValue];
    } else {
        enumDimension = 0;
    }

    self.adview.adSettings.publisherId = [[customEventClassData getPropertyValue:@"publisherId"] intValue];
    self.adview.adSettings.adSpaceId = [[customEventClassData getPropertyValue:@"adSpaceId"] intValue];
    self.adview.adSettings.dimension = enumDimension;
    self.adview.adSettings.dimensionStrict = NO;
    self.adview.adSettings.formatStrict = NO;
    
    self.adview.adSettings.autoReloadEnabled = NO;
    
    [self prepareAdViewUserProfile];
    [self prepareAdViewLocation];
}

- (void)prepareAdViewUserProfile {
    self.adview.adSettings.userProfile.age = [[MoPubKeywords current] age];
    
    if ([[MoPubKeywords current].gender isEqualToString:@"m"])
        self.adview.adSettings.userProfile.gender = SOMAUserGenderMale;
    if ([[MoPubKeywords current].gender isEqualToString:@"f"])
        self.adview.adSettings.userProfile.gender = SOMAUserGenderFemale;
    
    self.adview.adSettings.keywords = [[MoPubKeywords current] inMobiInterests];
}

- (void)prepareAdViewLocation {
    CLLocation *location = self.delegate.location;
    if (location) {
        self.adview.adSettings.longitude = location.coordinate.longitude;
        self.adview.adSettings.latitude = location.coordinate.latitude;
    }
}


- (void)showInterstitialFromRootViewController:(UIViewController *)rootViewController{
	[self.adview show];
}


#pragma mark -
#pragma mark - SOMAAdviewDelegate
#pragma mark -

- (void)somaAdViewDidLoadAd:(SOMAAdView *)adview {
    MPLogInfo(@"Smaato ad did load.");
    [self.delegate interstitialCustomEvent:self didLoadAd:self];
}

- (void)somaAdView:(SOMAAdView *)adview didFailToReceiveAdWithError:(NSError *)error {
    MPLogInfo(@"Smaato ad did fail to load with error : %@", [error localizedDescription]);

    [self.delegate interstitialCustomEvent:self didFailToLoadAdWithError:error];
}

- (void)somaAdViewDidExitFullscreen:(SOMAAdView *)adview {
    MPLogInfo(@"Smaato ad did exit full screen.");
    [self.delegate interstitialCustomEventDidDisappear:self];
}

- (BOOL)somaAdViewShouldEnterFullscreen:(SOMAAdView *)adview {
    MPLogInfo(@"Soma ad clicked.");
    [self.delegate interstitialCustomEventDidReceiveTapEvent:self];
    
    return YES;
}


@end
