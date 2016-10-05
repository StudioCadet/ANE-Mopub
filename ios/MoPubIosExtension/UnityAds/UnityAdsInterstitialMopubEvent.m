//
//  UnityAdsInterstitialMopubEvent.m
//  BallShoot

#import <Foundation/Foundation.h>

/*
 * Copyright 2013, Unity Technologies
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 * http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */

#import "UnityAdsInterstitialMopubEvent.h"

@implementation UnityAdsInterstitialMopubEvent

static NSString const * const kUnityAdsOptionZoneIdKey = @"zoneId";

@synthesize delegate;

- (void)requestInterstitialWithCustomEventInfo:(NSDictionary *)info {
    [[UnityAds sharedInstance] setDebugMode:TRUE];
    [[UnityAds sharedInstance] startWithGameId:[info objectForKey:@"gameId"]];
    [[UnityAds sharedInstance] setDelegate:self];
    
    // Parse the options, if we have any
    _params = [[NSMutableDictionary alloc] init];
    _zoneId = [info objectForKey:kUnityAdsOptionZoneIdKey];
    
    NSString *noOfferScreenValue = [info objectForKey:kUnityAdsOptionNoOfferscreenKey];
    NSString *openAnimatedValue = [info objectForKey:kUnityAdsOptionOpenAnimatedKey];
    NSString *gamerSidValue = [info objectForKey:kUnityAdsOptionGamerSIDKey];
    NSString *muteVideoSoundsValue = [info objectForKey:kUnityAdsOptionMuteVideoSounds];
    NSString *videoUsesDeviceOrientationValue = [info objectForKey:kUnityAdsOptionVideoUsesDeviceOrientation];
    
    if(noOfferScreenValue != nil) {
        [_params setObject:noOfferScreenValue forKey:kUnityAdsOptionNoOfferscreenKey];
    }
    if(openAnimatedValue != nil) {
        [_params setObject:openAnimatedValue forKey:kUnityAdsOptionOpenAnimatedKey];
    }
    if(gamerSidValue != nil) {
        [_params setObject:gamerSidValue forKey:kUnityAdsOptionGamerSIDKey];
    }
    if(muteVideoSoundsValue != nil) {
        [_params setObject:muteVideoSoundsValue forKey:kUnityAdsOptionMuteVideoSounds];
    }
    if(videoUsesDeviceOrientationValue != nil) {
        [_params setObject:videoUsesDeviceOrientationValue forKey:kUnityAdsOptionVideoUsesDeviceOrientation];
    }
    
    if([[UnityAds sharedInstance] canShow] && [[UnityAds sharedInstance] canShowAds]) {
        [self.delegate interstitialCustomEvent:self didLoadAd:nil];
    }
}

- (void)showInterstitialFromRootViewController:(UIViewController *)rootViewController {
    if([[UnityAds sharedInstance] canShow] && [[UnityAds sharedInstance] canShowAds]) {
        [[UnityAds sharedInstance] setViewController:rootViewController];
        [[UnityAds sharedInstance] setZone:_zoneId];
        [[UnityAds sharedInstance] show:_params];
    }
}

- (void)unityAdsVideoCompleted:(NSString *)rewardItemKey skipped:(BOOL)skipped {
    // Ignored, as no support for incentivised ads via Mopub
}

- (void)unityAdsFetchCompleted {
    [self.delegate interstitialCustomEvent:self didLoadAd:nil];
}

- (void)unityAdsFetchFailed {
    NSMutableDictionary* details = [NSMutableDictionary dictionary];
    [details setValue:@"No ads available" forKey:NSLocalizedDescriptionKey];
    [self.delegate interstitialCustomEvent:self didFailToLoadAdWithError:[NSError errorWithDomain:@"unityads_sdk" code:404 userInfo:details]];
}

- (void)unityAdsDidHide {
    [self.delegate interstitialCustomEventDidDisappear:self];
}

- (void)unityAdsDidShow {
    [self.delegate interstitialCustomEventDidAppear:self];
}

- (void)unityAdsVideoStarted {
    // Ignored
}

- (void)unityAdsWillHide {
    [self.delegate interstitialCustomEventWillDisappear:self];
}

- (void)unityAdsWillShow {
    [self.delegate interstitialCustomEventWillAppear:self];
}

- (void)unityAdsWillLeaveApplication {
    [self.delegate interstitialCustomEventWillLeaveApplication:self];
}

@end