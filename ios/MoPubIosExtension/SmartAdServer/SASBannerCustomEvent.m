#import "SASBannerCustomEvent.h"

#define kDefaultTimeOut 10

@implementation BannerRootViewController

-(void) adView:(SASAdView *)adView didDownloadAd:(SASAd *)ad {
    if (!ad) {
        NSLog(@"No more banner to load !");
        [self.mpCustomEvent.delegate bannerCustomEvent:self.mpCustomEvent didFailToLoadAdWithError:nil];
    } else {
        if (adView == self.mpCustomEvent.banner) {
            [self.mpCustomEvent.delegate bannerCustomEvent:self.mpCustomEvent didLoadAd:adView];
        }
    }
}

-(void) adView:(SASAdView *)adView didFailToLoadWithError:(NSError *)error {
    NSLog(@"Banner did fail to load !");
    [self.mpCustomEvent.delegate bannerCustomEvent:self.mpCustomEvent didFailToLoadAdWithError:error];
}

-(void) adView:(SASAdView *)adView didExpandWithFrame:(CGRect)frame {
    NSLog(@"Banner did expand.");
}

-(void) adViewDidCollapse:(SASAdView *)adView {
    NSLog(@"Banner did collapse");
}

-(void) adViewDidDisappear:(SASAdView *)adView {
    NSLog(@"Banner did disappear.");
}

-(void) adViewWillExpand:(SASAdView *)adView {
    NSLog(@"Banner will expand");
    [self.mpCustomEvent.delegate bannerCustomEventWillBeginAction:self.mpCustomEvent];
}

- (void)adViewWillPresentModalView:(SASAdView *)adView {
    if (adView == self.mpCustomEvent.banner) {
        NSLog(@"Ad clicked");
        [self.mpCustomEvent.delegate bannerCustomEventWillBeginAction:self.mpCustomEvent];
    }
}
- (void)adView:(SASAdView *)adView willPerformActionWithExit:(BOOL)willExit {
    if (adView == self.mpCustomEvent.banner) {
        NSLog(@"Leaving after ad clicked");
        [self.mpCustomEvent.delegate bannerCustomEventWillLeaveApplication:self.mpCustomEvent];
    }
}

@end

@implementation SASBannerCustomEvent

- (void)requestAdWithSize:(CGSize)size customEventInfo:(NSDictionary *)info
{
    self.isFetch = false;
    
    _window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    BannerRootViewController *controller = [[BannerRootViewController alloc] init];
    controller.mpCustomEvent = self;
    _navigationController = [[UINavigationController alloc] initWithRootViewController:controller];
    
    _window.rootViewController = _navigationController;

    // Add the navigation controller to the view hierarchy, otherwise nothing will happen when clicking on the banner
    [[[[[UIApplication sharedApplication] delegate] window] rootViewController] addChildViewController:_navigationController];
    
    self.banner = [[SASBannerView alloc] initWithFrame:CGRectMake(0, 0, size.width, size.height) loader:SASLoaderNone];
    
    if ([info objectForKey:@"MobviousFormatId"] && [info objectForKey:@"MobviousPageId"]) {
        self.formatId = (NSInteger)[[info objectForKey:@"MobviousFormatId"] intValue];
        self.pageId = [info objectForKey:@"MobviousPageId"];
        NSLog(@"Setting the MobviousFormatId and the MobviousPageId.");
    } else {
        NSLog(@"No MobviousFormatId or MobviousPageId to set, aborting...");
        [self.delegate bannerCustomEvent:self didFailToLoadAdWithError:nil];
        return ;
    }
    
    _banner.delegate = controller;
    
    [_banner loadFormatId:self.formatId pageId:self.pageId master:YES target:nil];
}

- (void) dealloc {
    [self.navigationController removeFromParentViewController];
}

@end
