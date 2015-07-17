#import "TestBannerCustomEvent.h"

@implementation TestBannerCustomEvent

- (void) requestAdWithSize:(CGSize)size customEventInfo:(NSDictionary *)info {
    self.bannerCustomEvent = [[InMobiBannerCustomEvent alloc] init];
    self.bannerCustomEvent.delegate = self.delegate;
    
    NSMutableDictionary* customInfo = [info mutableCopy];
    
    [customInfo setValue:@"6b99a57cf0fb481a9db5c00cc93baa73" forKey:@"property"];
    
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
