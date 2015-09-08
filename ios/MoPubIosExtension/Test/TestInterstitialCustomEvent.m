#import "TestInterstitialCustomEvent.h"

@implementation TestInterstitialCustomEvent

-(void) requestInterstitialWithCustomEventInfo:(NSDictionary *)info {
    // AdMob
    self.interstitialCustomEvent = [[MPGoogleAdMobInterstitialCustomEvent alloc] init];
    NSMutableDictionary* customInfo = [info mutableCopy];
    [customInfo setValue:@"ca-app-pub-6354112556091525/4620915690" forKey:@"adUnitID"];
    
    // Other networks here
    // ...
    
    self.interstitialCustomEvent.delegate = self.delegate;
    [self.interstitialCustomEvent requestInterstitialWithCustomEventInfo:info];
}

-(void) showInterstitialFromRootViewController:(UIViewController *)rootViewController {
    [self.interstitialCustomEvent showInterstitialFromRootViewController:rootViewController];
}

-(BOOL) enableAutomaticImpressionAndClickTracking {
    return [self.interstitialCustomEvent enableAutomaticImpressionAndClickTracking];
}

-(void) dealloc {
    self.interstitialCustomEvent = nil;
    
    [super dealloc];
}
@end