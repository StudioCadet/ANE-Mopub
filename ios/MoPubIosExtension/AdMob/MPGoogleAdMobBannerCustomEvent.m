//
//  MPGoogleAdMobBannerCustomEvent.m
//  MoPub
//
//  Copyright (c) 2013 MoPub. All rights reserved.
//

#import <GoogleMobileAds/GoogleMobileAds.h>
#import "MPGoogleAdMobBannerCustomEvent.h"
#import "MPLogging.h"
#import "MPInstanceProvider.h"
#import "MoPubKeywords.h"

@interface MPInstanceProvider (AdMobBanners)

- (GADBannerView *)buildGADBannerViewWithFrame:(CGRect)frame;
- (GADRequest *)buildGADBannerRequest;

@end

@implementation MPInstanceProvider (AdMobBanners)

- (GADBannerView *)buildGADBannerViewWithFrame:(CGRect)frame
{
    return [[GADBannerView alloc] initWithFrame:frame];
}

- (GADRequest *)buildGADBannerRequest
{
    return [GADRequest request];
}

@end

////////////////////////////////////////////////////////////////////////////////////////////////////

@interface MPGoogleAdMobBannerCustomEvent () <GADBannerViewDelegate>

@property (nonatomic, strong) GADBannerView *adBannerView;

@end


@implementation MPGoogleAdMobBannerCustomEvent

- (id)init
{
    self = [super init];
    if (self)
    {
        self.adBannerView = [[MPInstanceProvider sharedProvider] buildGADBannerViewWithFrame:CGRectZero];
        self.adBannerView.delegate = self;
    }
    return self;
}

- (void)dealloc
{
    self.adBannerView.delegate = nil;
    
}

- (void)requestAdWithSize:(CGSize)size customEventInfo:(NSDictionary *)info
{
    MPLogInfo(@"Requesting Google AdMob banner");
    
    NSString* adUnitID = [info objectForKey:@"adUnitID"];
    
    if (adUnitID == nil) {
        MPLogError(@"No ad unit ID specified for AdMob, cannot load banner !");
        [self.delegate bannerCustomEvent:self didFailToLoadAdWithError:nil];
        return;
    }
    
    MPLogInfo(@"Using AdMob ad unit ID : %@", adUnitID);
    
    self.adBannerView.frame = [self frameForCustomEventInfo:info];
    self.adBannerView.adUnitID = adUnitID;
    self.adBannerView.rootViewController = [self.delegate viewControllerForPresentingModalView];

    GADRequest *request = [self createGADRequest];
    [self.adBannerView loadRequest:request];
}

- (GADRequest *)createGADRequest {
    GADRequest *request = [[MPInstanceProvider sharedProvider] buildGADBannerRequest];
    
    request.requestAgent = @"Mopub";
    
    request.gender = [self getGADGender];
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

- (CGRect)frameForCustomEventInfo:(NSDictionary *)info
{
    CGFloat width = [[info objectForKey:@"adWidth"] floatValue];
    CGFloat height = [[info objectForKey:@"adHeight"] floatValue];

    if (width < GAD_SIZE_320x50.width && height < GAD_SIZE_320x50.height) {
        width = GAD_SIZE_320x50.width;
        height = GAD_SIZE_320x50.height;
    }
    return CGRectMake(0, 0, width, height);
}

#pragma mark -
#pragma mark GADBannerViewDelegate methods

- (void)adViewDidReceiveAd:(GADBannerView *)bannerView
{
    MPLogInfo(@"Google AdMob Banner did load");
    [self.delegate bannerCustomEvent:self didLoadAd:self.adBannerView];
}

- (void)adView:(GADBannerView *)bannerView didFailToReceiveAdWithError:(GADRequestError *)error
{
    MPLogInfo(@"Google AdMob Banner failed to load with error: %@", error.localizedDescription);
    [self.delegate bannerCustomEvent:self didFailToLoadAdWithError:error];
}

- (void)adViewWillPresentScreen:(GADBannerView *)bannerView
{
    MPLogInfo(@"Google AdMob Banner will present modal");
    [self.delegate bannerCustomEventWillBeginAction:self];
}

- (void)adViewDidDismissScreen:(GADBannerView *)bannerView
{
    MPLogInfo(@"Google AdMob Banner did dismiss modal");
    [self.delegate bannerCustomEventDidFinishAction:self];
}

- (void)adViewWillLeaveApplication:(GADBannerView *)bannerView
{
    MPLogInfo(@"Google AdMob Banner will leave the application");
    [self.delegate bannerCustomEventWillLeaveApplication:self];
}

@end
