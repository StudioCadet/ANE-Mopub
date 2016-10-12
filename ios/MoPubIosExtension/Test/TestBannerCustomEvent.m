#import "TestBannerCustomEvent.h"

@implementation TestBannerCustomEvent

- (void) requestAdWithSize:(CGSize)size customEventInfo:(NSDictionary *)info {
    // AdMob
    /*
    self.bannerCustomEvent = [[MPGoogleAdMobBannerCustomEvent alloc] init];
    NSMutableDictionary* customInfo = [[NSMutableDictionary alloc] init];
    [customInfo setValue:@"ca-app-pub-6354112556091525/5789924499" forKey:@"adUnitID"];
    */
    
    // InMobi
    /*
    self.bannerCustomEvent = [[InMobiBannerCustomEvent alloc] init];
    NSMutableDictionary* customInfo = [[NSMutableDictionary alloc] init];
    [customInfo setValue:@"6b99a57cf0fb481a9db5c00cc93baa73" forKey:@"property"];
    */
    
    // SAS
    self.bannerCustomEvent = [[SASBannerCustomEvent alloc] init];
    NSMutableDictionary* customInfo = [[NSMutableDictionary alloc] init];
    [customInfo setValue:@"8948" forKey:@"MobviousFormatId"];
    [customInfo setValue:@"497341" forKey:@"MobviousPageId"];

    // Other networks here
    // ...
    
    
    self.bannerCustomEvent.delegate = self.delegate;
    [self.bannerCustomEvent requestAdWithSize:size customEventInfo:customInfo];
}

- (void)rotateToOrientation:(UIInterfaceOrientation)newOrientation {
    [self.bannerCustomEvent rotateToOrientation:newOrientation];
}


- (void)didDisplayAd {
    [self.bannerCustomEvent didDisplayAd];
}


- (BOOL)enableAutomaticImpressionAndClickTracking {
    return [self.bannerCustomEvent enableAutomaticImpressionAndClickTracking];
}


@end
