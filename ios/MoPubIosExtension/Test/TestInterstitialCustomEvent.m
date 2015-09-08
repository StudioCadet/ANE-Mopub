#import "TestInterstitialCustomEvent.h"

@implementation TestInterstitialCustomEvent

-(void) requestInterstitialWithCustomEventInfo:(NSDictionary *)info {
    // AdMob
    /*
    self.interstitialCustomEvent = [[MPGoogleAdMobInterstitialCustomEvent alloc] init];
    NSMutableDictionary* customInfo = [[NSMutableDictionary alloc] init];
    [customInfo setValue:@"ca-app-pub-6354112556091525/4620915690" forKey:@"adUnitID"];
    */
    
    // InMobi
    self.interstitialCustomEvent = [[InMobiInterstitialCustomEvent alloc] init];
    NSMutableDictionary* customInfo = [[NSMutableDictionary alloc] init];
    [customInfo setValue:@"0e9b68e0a02b493c8fc81f3b816d9795" forKey:@"property"];
    
    
    // Other networks here
    // ...
    
    self.interstitialCustomEvent.delegate = self.delegate;
    [self.interstitialCustomEvent requestInterstitialWithCustomEventInfo:customInfo];
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