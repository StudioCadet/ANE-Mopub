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
- (void)requestInterstitialWithCustomEventInfo:(NSDictionary *)info{

    MPLogInfo(@"Requesting a Smaato interstitial ad...");
    
    MoPubCustomEventClassData* customEventClassData = [[MoPubCustomEventClassData alloc] initWithMopubWebsiteData:info];

    if ([customEventClassData hasRequiredProperties:@[@"publisherId",@"adSpaceId"]]) {
        MPLogError(@"One of the required properties is missing, cannot load interstitial !");
        [self.delegate interstitialCustomEvent:self didFailToLoadAdWithError:nil];
        return;
    }
    
    [self prepareAdViewFromCustomEventClassData:customEventClassData];
    
	[self.adview load];
}

- (void) prepareAdViewFromCustomEventClassData:(MoPubCustomEventClassData *)customEventClassData {
    self.adview = [[SOMAInterstitialAdView alloc] init];
    self.adview.delegate = self;
    
    self.adview.adSettings.publisherId = [[customEventClassData getPropertyValue:@"publisherId"] intValue];
    self.adview.adSettings.adSpaceId = [[customEventClassData getPropertyValue:@"adSpaceId"] intValue];
    self.adview.adSettings.dimension = SOMAAdDimensionDefault;
    
    [self prepareAdViewUserProfile];
    [self prepareAdViewLocation];
}

- (void)prepareAdViewUserProfile {
    self.adview.adSettings.userProfile.age = [[MoPubKeywords current] age];
    
    if([[MoPubKeywords current].gender isEqualToString:@"m"])
        self.adview.adSettings.userProfile.gender = SOMAUserGenderMale;
    if([[MoPubKeywords current].gender isEqualToString:@"f"])
        self.adview.adSettings.userProfile.gender = SOMAUserGenderFemale;
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
    MPLogInfo(@"Soma ad view should enter fullscreen !");
    MPLogInfo(@"Soma ad view should enter fullscreen !");
    MPLogInfo(@"Soma ad view should enter fullscreen !");
    MPLogInfo(@"Soma ad view should enter fullscreen !");
    MPLogInfo(@"Soma ad view should enter fullscreen !");
    MPLogInfo(@"Soma ad view should enter fullscreen !");
    MPLogInfo(@"Soma ad view should enter fullscreen !");
    
    return YES;
}


@end
