//
//  InMobiInterstitialCustomEvent.m
//  MoPub
//
//  Copyright (c) 2013 MoPub, Inc. All rights reserved.
//

#import "InMobiInterstitialCustomEvent.h"
#import "MPInstanceProvider.h"
#import "MPLogging.h"

@interface MPInstanceProvider (InMobiInterstitials)

- (IMInterstitial *)buildIMInterstitialWithDelegate:(id<IMInterstitialDelegate>)delegate appId:(NSString *)appId;
- (IMInterstitial *)buildIMInterstitialWithSlotIdAndDelegate:(id<IMInterstitialDelegate>)delegate slotId:(long long)slotId;

@end

@implementation MPInstanceProvider (InMobiInterstitials)

- (IMInterstitial *)buildIMInterstitialWithDelegate:(id<IMInterstitialDelegate>)delegate appId:(NSString *)appId {
    IMInterstitial *inMobiInterstitial = [[IMInterstitial alloc] initWithAppId:appId];
    inMobiInterstitial.delegate = delegate;
    return inMobiInterstitial;
}
- (IMInterstitial *)buildIMInterstitialWithSlotIdAndDelegate:(id<IMInterstitialDelegate>)delegate slotId:(long long) slotId {
    IMInterstitial *inMobiInterstitial = [[IMInterstitial alloc] initWithSlotId:slotId];
    inMobiInterstitial.delegate = delegate;
    return inMobiInterstitial;
}

@end

////////////////////////////////////////////////////////////////////////////////////////////////////


@interface InMobiInterstitialCustomEvent ()

@property (nonatomic, strong) IMInterstitial *inMobiInterstitial;

@end

@implementation InMobiInterstitialCustomEvent

@synthesize inMobiInterstitial = _inMobiInterstitial;

#pragma mark - MPInterstitialCustomEvent Subclass Methods

- (void)requestInterstitialWithCustomEventInfo:(NSDictionary *)info
{
    NSString *propertyId = [info objectForKey:@"property"];
    if(!propertyId) {
        propertyId = [[NSBundle mainBundle] objectForInfoDictionaryKey:@"IN_MOBI_PROPERTY_ID"];
        NSLog(@"No property ID specified through MoPub custom network, using default property ID.");
    }
    
    NSLog(@"Creating InMobi interstitial with the property ID %@ ...", propertyId);
    self.inMobiInterstitial = [[MPInstanceProvider sharedProvider] buildIMInterstitialWithDelegate:self appId:propertyId];
    
    NSMutableDictionary *paramsDict = [[NSMutableDictionary alloc] init];
    [paramsDict setObject:@"c_mopub" forKey:@"tp"];
	[paramsDict setObject:MP_SDK_VERSION forKey:@"tp-ver"];
    self.inMobiInterstitial.additionaParameters = paramsDict; // For supply source identification
    
    if (self.delegate.location) {
        [InMobi setLocationWithLatitude:self.delegate.location.coordinate.latitude
                               longitude:self.delegate.location.coordinate.longitude
                                accuracy:self.delegate.location.horizontalAccuracy];
    }

    [self.inMobiInterstitial loadInterstitial];
}

- (void)showInterstitialFromRootViewController:(UIViewController *)rootViewController
{
    [self.inMobiInterstitial presentInterstitialAnimated:YES];
}

- (void)dealloc
{
    [self.inMobiInterstitial setDelegate:nil];
}

#pragma mark - IMInterstitialDelegate


- (void)interstitialDidReceiveAd:(IMInterstitial *)ad {
    MPLogInfo(@"InMobi interstitial did load");
    [self.delegate interstitialCustomEvent:self didLoadAd:ad];
}

- (void)interstitial:(IMInterstitial *)ad didFailToReceiveAdWithError:(IMError *)error {
    
    MPLogInfo(@"InMobi banner did fail with error: %@", error.localizedDescription);
    [self.delegate interstitialCustomEvent:self didFailToLoadAdWithError:nil];
}

- (void)interstitialWillPresentScreen:(IMInterstitial *)ad {
    MPLogInfo(@"InMobi interstitial will present");
    [self.delegate interstitialCustomEventWillAppear:self];

    // InMobi doesn't seem to have a separate callback for the "did appear" event, so we
    // signal that manually.
    [self.delegate interstitialCustomEventDidAppear:self];
}

- (void)interstitial:(IMInterstitial *)ad didFailToPresentScreenWithError:(IMError *)error {
    MPLogInfo(@"InMobi interstitial failed to present with error: %@", error.localizedDescription);
    [self.delegate interstitialCustomEvent:self didFailToLoadAdWithError:nil];
}

- (void)interstitialWillDismissScreen:(IMInterstitial *)ad {
    MPLogInfo(@"InMobi interstitial will dismiss");
    [self.delegate interstitialCustomEventWillDisappear:self];
}

- (void)interstitialDidDismissScreen:(IMInterstitial *)ad {
    MPLogInfo(@"InMobi interstitial did dismiss");
    [self.delegate interstitialCustomEventDidDisappear:self];
}

- (void)interstitialWillLeaveApplication:(IMInterstitial *)ad {
    MPLogInfo(@"InMobi interstitial will leave application");
    [self.delegate interstitialCustomEventWillLeaveApplication:self];
}

- (void) interstitialDidInteract:(IMInterstitial *)ad withParams:(NSDictionary *)dictionary {
    MPLogInfo(@"InMobi interstitial was tapped");
    [self.delegate interstitialCustomEventDidReceiveTapEvent:self];
}

@end
