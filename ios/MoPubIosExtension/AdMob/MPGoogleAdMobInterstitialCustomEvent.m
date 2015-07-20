//
//  MPGoogleAdMobInterstitialCustomEvent.m
//  MoPub
//
//  Copyright (c) 2012 MoPub, Inc. All rights reserved.
//

#import <GoogleMobileAds/GADInterstitial.h>
#import "MPGoogleAdMobInterstitialCustomEvent.h"
#import "MPInterstitialAdController.h"
#import "MPLogging.h"
#import "MPAdConfiguration.h"
#import "MPInstanceProvider.h"
#import <CoreLocation/CoreLocation.h>
#import "MoPubKeywords.h"

@interface MPInstanceProvider (AdMobInterstitials)

- (GADInterstitial *)buildGADInterstitialAd;
- (GADRequest *)buildGADInterstitialRequest;

@end

@implementation MPInstanceProvider (AdMobInterstitials)

- (GADInterstitial *)buildGADInterstitialAd
{
    return [[GADInterstitial alloc] init];
}

- (GADRequest *)buildGADInterstitialRequest
{
    return [GADRequest request];
}

@end

////////////////////////////////////////////////////////////////////////////////////////////////////

@interface MPGoogleAdMobInterstitialCustomEvent ()

@property (nonatomic, strong) GADInterstitial *interstitial;

@end

@implementation MPGoogleAdMobInterstitialCustomEvent

@synthesize interstitial = _interstitial;

#pragma mark - MPInterstitialCustomEvent Subclass Methods

- (void)requestInterstitialWithCustomEventInfo:(NSDictionary *)info
{
    MPLogInfo(@"Requesting Google AdMob interstitial");
    
    NSString* adUnitID = [info objectForKey:@"adUnitID"];
    
    if (adUnitID == nil) {
        MPLogError(@"No ad unit ID specified for AdMob, cannot load interstitial !");
        [self.delegate interstitialCustomEvent:self didFailToLoadAdWithError:nil];
        return;
    }
    
    MPLogInfo(@"Using AdMob ad unit ID : %@", adUnitID);
    
    self.interstitial = [[MPInstanceProvider sharedProvider] buildGADInterstitialAd];
    
    self.interstitial.adUnitID = adUnitID;
    self.interstitial.delegate = self;
    
    [self.interstitial loadRequest:[self createGADRequest]];
}

- (GADRequest *)createGADRequest {
    GADRequest *request = [[MPInstanceProvider sharedProvider] buildGADInterstitialRequest];
    
    request.requestAgent = @"Mopub";

    request.gender = [self getGADGender];
    request.birthday = [MoPubKeywords current].dateOfBirth;
    request.keywords = [[MoPubKeywords current].additionalKeywords allValues];
    
    CLLocation *location = self.delegate.location;
    if (location) {
        [request setLocationWithLatitude:location.coordinate.latitude
                               longitude:location.coordinate.longitude
                                accuracy:location.horizontalAccuracy];
    }
    
    // You can set test devices using request.testDevices
    // See AdMob documentation
    
    return request;
}

- (GADGender)getGADGender {
    if ([[MoPubKeywords current].gender isEqualToString:@"m"])
        return kGADGenderMale;
    else if ([[MoPubKeywords current].gender isEqualToString:@"f"])
        return kGADGenderFemale;
    
    return kGADGenderUnknown;
}

- (void)showInterstitialFromRootViewController:(UIViewController *)rootViewController
{
    [self.interstitial presentFromRootViewController:rootViewController];
}

- (void)dealloc
{
    self.interstitial.delegate = nil;
    [super dealloc];
}

#pragma mark - GADInterstitialDelegate

- (void)interstitialDidReceiveAd:(GADInterstitial *)interstitial
{
    MPLogInfo(@"Google AdMob Interstitial did load");
    [self.delegate interstitialCustomEvent:self didLoadAd:self];
}

- (void)interstitial:(GADInterstitial *)interstitial didFailToReceiveAdWithError:(GADRequestError *)error
{
    MPLogInfo(@"Google AdMob Interstitial failed to load with error: %@", error.localizedDescription);
    [self.delegate interstitialCustomEvent:self didFailToLoadAdWithError:error];
}

- (void)interstitialWillPresentScreen:(GADInterstitial *)interstitial
{
    MPLogInfo(@"Google AdMob Interstitial will present");
    [self.delegate interstitialCustomEventWillAppear:self];
    [self.delegate interstitialCustomEventDidAppear:self];
}

- (void)interstitialWillDismissScreen:(GADInterstitial *)ad
{
    MPLogInfo(@"Google AdMob Interstitial will dismiss");
    [self.delegate interstitialCustomEventWillDisappear:self];
}

- (void)interstitialDidDismissScreen:(GADInterstitial *)ad
{
    MPLogInfo(@"Google AdMob Interstitial did dismiss");
    [self.delegate interstitialCustomEventDidDisappear:self];
}

- (void)interstitialWillLeaveApplication:(GADInterstitial *)ad
{
    MPLogInfo(@"Google AdMob Interstitial will leave application");
    [self.delegate interstitialCustomEventDidReceiveTapEvent:self];
}

@end