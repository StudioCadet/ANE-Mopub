//
//  InMobiInterstitialCustomEvent.m
//  MoPub
//
//  Copyright (c) 2013 MoPub, Inc. All rights reserved.
//

#import "OperaInterstitialCustomEvent.h"
#import "MPLogging.h"
#import "AdMarvelView.h"


@interface OperaInterstitialCustomEvent ()

@property (nonatomic, strong) AdMarvelView *adMarvelInterstitial;
@property (nonatomic, strong) NSString *partnerId;
@property (nonatomic, strong) NSString *siteId;
@property (nonatomic, strong) UIViewController *rootViewController;

@end

@implementation OperaInterstitialCustomEvent

#pragma mark - MPInterstitialCustomEvent Subclass Methods

- (void)requestInterstitialWithCustomEventInfo:(NSDictionary *)info {
    MPLogInfo(@"Requesting an Opera interstitial ...");

    // Get the required IDs
    self.partnerId = info[@"pid"];
    self.siteId = info[@"sid"];

    if(!self.partnerId || self.siteId) {
        MPLogError(@"Invalid partnerId (%@) or siteId (%@)!", self.partnerId, self.siteId);
        [self.delegate interstitialCustomEvent:self didFailToLoadAdWithError:nil];
    }
    
    self.adMarvelInterstitial = [AdMarvelView createAdMarvelViewWithDelegate:self];

    [self.adMarvelInterstitial getInterstitialAd];
}

- (void)showInterstitialFromRootViewController:(UIViewController *)rootViewController {
    self.rootViewController = rootViewController;
    [self.adMarvelInterstitial displayInterstitial];
}


#pragma mark - Delegate implementation

- (NSString*)partnerId:(AdMarvelView*)adMarvelView {
    return self.partnerId;
}

- (NSString*)siteId:(AdMarvelView*)adMarvelView {
    return self.siteId;
}

- (UIViewController *) applicationUIViewController:(AdMarvelView*)adMarvelView {
    return self.rootViewController;
}

- (BOOL) testingMode:(AdMarvelView*)adMarvelView {
    return YES;
}

- (void) getInterstitialAdSucceeded:(AdMarvelView *)adMarvelView {
    MPLogInfo(@"Opera Mediaworks interstitial did load");
    [self.delegate interstitialCustomEvent:self didLoadAd:adMarvelView];
}

- (void) getInterstitialAdFailed:(AdMarvelView *)adMarvelView {
    MPLogInfo(@"Opera Mediaworks interstitial did fail to load");
    [self.delegate interstitialCustomEvent:self didFailToLoadAdWithError:nil];
}

- (void) interstitialActivated:(AdMarvelView *)adMarvelView {
    MPLogInfo(@"Opera Mediaworks interstitial did display");
    [self.delegate interstitialCustomEventDidAppear:self];
}

- (void) interstitialClosed:(AdMarvelView *)adMarvelView {
    MPLogInfo(@"Opera Mediaworks interstitial did dismiss");
    [self.delegate interstitialCustomEventDidDisappear:self];
}

- (void) handleAdMarvelSDKClick:(NSString *)urlString forAdMarvelView:(AdMarvelView *)adMarvelView {
    MPLogInfo(@"Opera Mediaworks interstitial was tapped");
    [self.delegate interstitialCustomEventDidReceiveTapEvent:self];
}

- (void) adMarvelViewWasClicked:(AdMarvelView *)adMarvelView {
    MPLogInfo(@"Opera Mediaworks interstitial was tapped");
    [self.delegate interstitialCustomEventDidReceiveTapEvent:self];
}


- (void)dealloc {
    [self.adMarvelInterstitial setDelegate:nil];
    self.adMarvelInterstitial = nil;

    self.rootViewController = nil;
    self.partnerId = nil;
    self.siteId = nil;

}

@end
