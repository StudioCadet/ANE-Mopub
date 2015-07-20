#import "TestBannerCustomEvent.h"

@implementation TestBannerCustomEvent

- (void) requestAdWithSize:(CGSize)size customEventInfo:(NSDictionary *)info {
    self.bannerCustomEvent = [[MPGoogleAdMobBannerCustomEvent alloc] init];
    self.bannerCustomEvent.delegate = self.delegate;
    
    NSMutableDictionary* customInfo = [info mutableCopy];
    
    [customInfo setValue:@"ca-app-pub-3940256099942544/2934735716" forKey:@"adUnitID"];
    
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
