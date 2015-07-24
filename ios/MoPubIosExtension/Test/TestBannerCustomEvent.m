#import "TestBannerCustomEvent.h"

@implementation TestBannerCustomEvent

- (void) requestAdWithSize:(CGSize)size customEventInfo:(NSDictionary *)info {
    // AdMob
    self.bannerCustomEvent = [[MPGoogleAdMobBannerCustomEvent alloc] init];
    NSMutableDictionary* customInfo = [[NSMutableDictionary alloc] init];
    [customInfo setValue:@"ca-app-pub-6354112556091525/5789924499" forKey:@"adUnitID"];
    
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

- (void) dealloc {
    self.bannerCustomEvent = nil;
    
    [super dealloc];
}

@end
