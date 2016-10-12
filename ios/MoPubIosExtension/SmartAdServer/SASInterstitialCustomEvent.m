#import "SASInterstitialCustomEvent.h"
#import "MPLogging.h"


#define kDefaultTimeOut 10

/** The last time an impression request failed. */
static NSDate *lastImpressionFailedAt = nil;

//////////////////////////////////////////////////////////////////////////////////////////////////

@implementation InterstitialRootViewController

- (void)adView:(SASAdView *)adView didDownloadAd:(SASAd *)ad {
    if (adView == self.mpCustomEvent.interstitial) {
        NSLog(@"Ad did load successfuly.");
        //[self.mpCustomEvent.delegate interstitialCustomEvent:self.mpCustomEvent didLoadAd:nil];
        // -> we faked it earlier, no need to trigger the Mopub event
    }
}

- (void)adView:(SASAdView *)adView didFailToLoadWithError:(NSError *)error {
    if (adView == self.mpCustomEvent.interstitial) {
        NSLog(@"Ad did fail to load... Aborting.");
        lastImpressionFailedAt = [[NSDate alloc] init];
        //[self.mpCustomEvent.delegate interstitialCustomEvent:self.mpCustomEvent didFailToLoadAdWithError:error];
        // -> Mopub doesn't expect this event now, bypass it
        
        NSLog(@"Telling Mopub the ad is dimissed.");
        [self.mpCustomEvent.delegate interstitialCustomEventWillDisappear:self.mpCustomEvent];
        [self.mpCustomEvent.delegate interstitialCustomEventDidDisappear:self.mpCustomEvent];
    }
}

-(void)adViewDidLoad:(SASAdView *)adView {
    if (adView == self.mpCustomEvent.interstitial) {
        NSLog(@"Ad view did load. Displaying the ad.");
        [self.mpCustomEvent.delegate interstitialCustomEventWillAppear:nil];
        [self.mpCustomEvent.rootViewController presentViewController:self animated:NO completion:nil];
        [self.view addSubview:self.mpCustomEvent.interstitial];
        [self.mpCustomEvent.delegate interstitialCustomEventDidAppear:self.mpCustomEvent];
    }
}

-(void)adViewDidDisappear:(SASAdView *)adView {
    if (adView == self.mpCustomEvent.interstitial) {
        NSLog(@"Ad view did disappear.");
        UIViewController *delegate = (UIViewController *) self.mpCustomEvent.interstitial.delegate;
        [delegate dismissViewControllerAnimated:YES completion:^{[self dismissViewControllerAnimated:YES completion:nil];}];
        [delegate removeFromParentViewController];
        [self.mpCustomEvent.delegate interstitialCustomEventWillDisappear:self.mpCustomEvent];
        [self.mpCustomEvent.delegate interstitialCustomEventDidDisappear:self.mpCustomEvent];
    }
}

- (void)adView:(SASAdView *)adView willPerformActionWithExit:(BOOL)willExit {
    if (adView == self.mpCustomEvent.interstitial) {
        NSLog(@"Ad clicked");
        [self.mpCustomEvent.delegate interstitialCustomEventDidReceiveTapEvent:self.mpCustomEvent];
    }
}

-(void)dealloc {
    self.mpCustomEvent.interstitial.delegate = nil;
    self.mpCustomEvent.interstitial = nil;
    self.mpCustomEvent.rootViewController = nil;
}

@end


//////////////////////////////////////////////////////////////////////////////////////////////////


@implementation SASInterstitialCustomEvent

#pragma mark - MPInterstitialCustomEvent Subclass Methods

- (void)requestInterstitialWithCustomEventInfo:(NSDictionary *)info {
    // Create the InterstitialRootViewController instance to display ad into :
    NSLog(@"Setting navigation controller to current window...");
    InterstitialRootViewController *controller = [[InterstitialRootViewController alloc] init];
    controller.mpCustomEvent = self;
    
    // Create a Mobvious interstitial :
    NSLog(@"Preparing next interstitial...");
    SASInterstitialView *interstitial = [[SASInterstitialView alloc] initWithFrame:[[UIScreen mainScreen] bounds] loader:SASLoaderNone];
    self.interstitial = interstitial;
    
    NSLog(@"Setting interstitial delegate...");
    self.interstitial.delegate = controller;
    
    // Get parameters from MoPub :
    NSLog(@"Fetching MoPub configs...");
    if(![info objectForKey:@"MobviousFormatId"] || ![info objectForKey:@"MobviousPageId"] || ![info objectForKey:@"MobviousRetryDelay"]) {
        NSLog(@"Invalid Mobvious configuration on Mopub server ! Check that MobviousFormatId, MobviousPageId and MobviousRetryDelay are set.");
        [self.delegate interstitialCustomEvent:self didFailToLoadAdWithError:nil];
        return;
    }
    
    self.formatId = (NSInteger)[[info objectForKey:@"MobviousFormatId"] intValue];
    self.pageId = [info objectForKey:@"MobviousPageId"];
    self.retryDelay = (NSInteger)[[info objectForKey:@"MobviousRetryDelay"] intValue];
    NSLog(@"Mobvious parameters set to {MobviousFormatID:%@, MobviousPageId:%@, MobviousRetryDelay:%@", @(self.formatId), self.pageId, @(self.retryDelay));
    
    NSLog(@"Setting time out...");
    self.timeOut = kDefaultTimeOut;
    if ([info objectForKey:@"MobviousTimeOut"]) {
        self.timeOut = [[info objectForKey:@"MobviousTimeOut"] floatValue];
        NSLog(@"Time out: %f", self.timeOut);
    }
    
    // Last impression failed too soon ago, tell Mopub there is no ad to display :
    if(lastImpressionFailedAt != nil && fabs([lastImpressionFailedAt timeIntervalSinceNow]) < self.retryDelay) {
        NSLog(@"Last Mobvious attempt failed too soon ago. Telling MoPub the fetch failed.");
        [self.delegate interstitialCustomEvent:self didFailToLoadAdWithError:nil];
    }
    
    // Tell MoPub we have an ad :
    else {
        NSLog(@"Faking fetch of a Mobvious interstitial ad.");
        lastImpressionFailedAt = nil;
        [self.delegate interstitialCustomEvent:self didLoadAd:nil];
    }
}

- (void)showInterstitialFromRootViewController:(UIViewController *)rootViewController {
    NSLog(@"Showing a master interstitial ad with parameters {MobviousFormatID:%@, MobviousPageId:%@, MobviousRetryDelay:%@", @(self.formatId), self.pageId, @(self.retryDelay));
    self.rootViewController = rootViewController;
    [self.interstitial loadFormatId:self.formatId pageId:self.pageId master:YES target:nil timeout:self.timeOut];
}



@end
