#import "MPInterstitialCustomEvent.h"
#import "SASInterstitialView.h"

@interface SASInterstitialCustomEvent : MPInterstitialCustomEvent <UIApplicationDelegate>

@property NSInteger formatId;
@property (nonatomic, copy) NSString* pageId;
@property (nonatomic) float timeOut;
@property NSInteger retryDelay;

@property (nonatomic, strong) SASInterstitialView *interstitial;
@property (nonatomic, strong) UIViewController *rootViewController;

@end


/** A RootViewController implementation that calls appropriate Mopub custom event callbacks on Mobvious ads lifecycle events. */
@interface InterstitialRootViewController : UIViewController <UITableViewDelegate, SASAdViewDelegate>
@property (nonatomic, retain) SASInterstitialCustomEvent *mpCustomEvent;
@end