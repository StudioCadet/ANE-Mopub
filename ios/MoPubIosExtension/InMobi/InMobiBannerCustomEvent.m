//
//  InMobiBannerCustomEvent.m
//  MoPub
//
//  Copyright (c) 2013 MoPub, Inc. All rights reserved.
//

#import "InMobiBannerCustomEvent.h"
#import "MPInstanceProvider.h"
#import "MPConstants.h"
#import "MPLogging.h"

#define INVALID_INMOBI_AD_SIZE  -1

@interface MPInstanceProvider (InMobiBanners)

- (IMBanner *)buildIMBannerWithFrame:(CGRect)frame appId:(NSString *)appId adSize:(int)adSize;
- (IMBanner *)buildIMBannerWithSlotIdAndFrame:(CGRect)frame slotId:(long long)slotId;

@end

@implementation MPInstanceProvider (InMobiBanners)

- (IMBanner *)buildIMBannerWithFrame:(CGRect)frame appId:(NSString *)appId adSize:(int)adSize
{
    return [[IMBanner alloc] initWithFrame:frame appId:appId adSize:adSize];
}

- (IMBanner *)buildIMBannerWithSlotIdAndFrame:(CGRect)frame slotId:(long long)slotId
{
    return [[IMBanner alloc] initWithFrame:frame slotId:slotId];
}

@end

////////////////////////////////////////////////////////////////////////////////////////////////////

@interface InMobiBannerCustomEvent ()

@property (nonatomic, strong) IMBanner *inMobiBanner;

- (int)imAdSizeConstantForCGSize:(CGSize)size;

@end

@implementation InMobiBannerCustomEvent

#pragma mark - MPBannerCustomEvent Subclass Methods

- (void)requestAdWithSize:(CGSize)size customEventInfo:(NSDictionary *)info
{
    MPLogInfo(@"Requesting InMobi banner");
    int imAdSizeConstant = [self imAdSizeConstantForCGSize:size];
    if (imAdSizeConstant == INVALID_INMOBI_AD_SIZE) {
        MPLogInfo(@"Failed to create an inMobi Banner with invalid size %@", NSStringFromCGSize(size));
        [self.delegate bannerCustomEvent:self didFailToLoadAdWithError:nil];
        return;
    }
    
    // Get the property ID to use :
    NSString *propertyId = [info objectForKey:@"property"];
    if(!propertyId) {
        propertyId = [[NSBundle mainBundle] objectForInfoDictionaryKey:@"IN_MOBI_PROPERTY_ID"];
        NSLog(@"No property ID specified through MoPub custom network, using default property ID.");
    }
    
    // Create the banner :
    NSLog(@"Creating InMobi banner with the property ID %@ (size:%i) ...", propertyId, imAdSizeConstant);
    self.inMobiBanner = [[MPInstanceProvider sharedProvider] buildIMBannerWithFrame:CGRectMake(0, 0, size.width, size.height) appId:propertyId adSize:imAdSizeConstant];
    self.inMobiBanner.delegate = self;
    self.inMobiBanner.refreshInterval = REFRESH_INTERVAL_OFF;
    
    NSMutableDictionary *paramsDict = [[NSMutableDictionary alloc] init];
    [paramsDict setObject:@"c_mopub" forKey:@"tp"];
	[paramsDict setObject:MP_SDK_VERSION forKey:@"tp-ver"];
    self.inMobiBanner.additionaParameters = paramsDict; // For supply source identification

    if (self.delegate.location) {
        [InMobi setLocationWithLatitude:self.delegate.location.coordinate.latitude
                               longitude:self.delegate.location.coordinate.longitude
                                accuracy:self.delegate.location.horizontalAccuracy];
    }
    
    [self.inMobiBanner loadBanner];
    
}

- (int)imAdSizeConstantForCGSize:(CGSize)size
{
    if (CGSizeEqualToSize(size, MOPUB_BANNER_SIZE)) {
        return IM_UNIT_320x50;
    } else if (CGSizeEqualToSize(size, MOPUB_MEDIUM_RECT_SIZE)) {
        return IM_UNIT_300x250;
    } else if (CGSizeEqualToSize(size, MOPUB_LEADERBOARD_SIZE)) {
        return IM_UNIT_728x90;
    } else {
        return INVALID_INMOBI_AD_SIZE;
    }
}

- (BOOL)enableAutomaticImpressionAndClickTracking {
    return NO;
}


- (void)dealloc
{
    [self.inMobiBanner setDelegate:nil];
}

#pragma mark - IMBannerDelegate

- (void)bannerDidReceiveAd:(IMBanner *)banner {
    MPLogInfo(@"InMobi banner did load");
    [self.delegate trackImpression];
    [self.delegate bannerCustomEvent:self didLoadAd:banner];
}

- (void)banner:(IMBanner *)banner didFailToReceiveAdWithError:(IMError *)error {
    MPLogInfo(@"InMobi banner did fail with error: %@", error.localizedDescription);
    [self.delegate bannerCustomEvent:self didFailToLoadAdWithError:error];
}

- (void)bannerDidDismissScreen:(IMBanner *)banner {
    MPLogInfo(@"adViewDidDismissScreen");
    [self.delegate bannerCustomEventDidFinishAction:self];
}

- (void)bannerWillDismissScreen:(IMBanner *)banner {
    MPLogInfo(@"adViewWillDismissScreen");
}

- (void)bannerWillPresentScreen:(IMBanner *)banner {
    MPLogInfo(@"InMobi banner will present modal");
    [self.delegate bannerCustomEventWillBeginAction:self];
}

- (void)bannerWillLeaveApplication:(IMBanner *)banner {
    MPLogInfo(@"InMobi banner will leave application");
    [self.delegate bannerCustomEventWillLeaveApplication:self];
}

- (void)bannerDidInteract:(IMBanner *)banner withParams:(NSDictionary *)dictionary {
    MPLogInfo(@"InMobi banner was clicked");
    [self.delegate trackClick];
}

@end
