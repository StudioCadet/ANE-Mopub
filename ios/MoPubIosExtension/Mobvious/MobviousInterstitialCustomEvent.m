//
//  MobviousInterstitialCustomEvent.m
//  MoPubIosExtension
//
//  Created by Matthieu Kern on 18/08/2014.
//  Copyright (c) 2014 Richard Lord. All rights reserved.
//

#import "MobviousInterstitialCustomEvent.h"
#import "MPLogging.h"
#import "MobviousUtils.h"

#define kDefaultTimeOut 10

@implementation InterstitialRootViewController

- (void)adView:(SASAdView *)adView didDownloadAd:(SASAd *)ad {
    if (adView == self.mpCustomEvent.interstitial) {
        NSLog(@"Ad did load successfuly.");
        [self.mpCustomEvent.delegate interstitialCustomEvent:self.mpCustomEvent didLoadAd:nil];
        self.mpCustomEvent.isFetch = true;
    }
}

- (void)adView:(SASAdView *)adView didFailToLoadWithError:(NSError *)error {
    NSLog(@"Ad did fail to load... Aborting.");
    [self.mpCustomEvent.delegate interstitialCustomEvent:self.mpCustomEvent didFailToLoadAdWithError:error];
}

-(void)adViewDidLoad:(SASAdView *)adView {
    if (adView == self.mpCustomEvent.interstitial) {
        NSLog(@"Ad view did load.");
        [self.mpCustomEvent.delegate interstitialCustomEventDidAppear:nil];
    }
}

-(void)adViewDidDisappear:(SASAdView *)adView {
    if (adView == self.mpCustomEvent.interstitial) {
        NSLog(@"Ad view did disappear.");
        [self.mpCustomEvent.interstitial.delegate dismissViewControllerAnimated:YES completion:^{[self dismissModalViewControllerAnimated:YES];}];
        [self.mpCustomEvent.interstitial.delegate removeFromParentViewController];
        [self.mpCustomEvent.delegate interstitialCustomEventWillDisappear:nil];
        [self.mpCustomEvent.delegate interstitialCustomEventDidDisappear:nil];
    }
}

-(void)dealloc {
    self.mpCustomEvent.interstitial.delegate = nil;
    self.mpCustomEvent.interstitial = nil;
    self.mpCustomEvent = nil;
    [super dealloc];
}

@end


@implementation MobviousInterstitialCustomEvent

#pragma mark - MPInterstitialCustomEvent Subclass Methods

- (void)requestInterstitialWithCustomEventInfo:(NSDictionary *)info {
    if (![MobviousUtils initializeMobviousIfNecessary:info]) {
        [self.delegate interstitialCustomEvent:self didFailToLoadAdWithError:nil];
        return;
    }

    self.isFetch = false;

    NSLog(@"Setting navigation controller to current window...");
	InterstitialRootViewController *controller = [[InterstitialRootViewController alloc] init];
    controller.mpCustomEvent = self;
    
    NSLog(@"Preparing next interstitial...");
    SASInterstitialView *interstitial = [[SASInterstitialView alloc] initWithFrame:[[UIScreen mainScreen] bounds] loader:SASLoaderNone];
    self.interstitial = interstitial;
    [interstitial release];

    NSLog(@"Setting interstitial delegate...");
    _interstitial.delegate = controller;

    NSLog(@"Fetching MoPub configs...");
    if ([info objectForKey:@"MobviousFormatId"] && [info objectForKey:@"MobviousPageId"]) {
        NSLog(@"Setting the MobviousFormatId and the MobviousPageId.");
        NSLog(@"Format ID: %@", [info objectForKey:@"MobviousFormatId"]);
        self.formatId = (NSInteger)[[info objectForKey:@"MobviousFormatId"] intValue];
        NSLog(@"Page ID: %@", [info objectForKey:@"MobviousPageId"]);
        self.pageId = [info objectForKey:@"MobviousPageId"];
    } else {
        NSLog(@"No MobviousFormatId or MobviousPageId to set, aborting...");
        [self.delegate interstitialCustomEvent:self didFailToLoadAdWithError:nil];
        return ;
    }

    NSLog(@"Setting time out...");
    self.timeOut = kDefaultTimeOut;
    if ([info objectForKey:@"MobviousTimeOut"]) {
        NSLog(@"Time out: %@", [info objectForKey:@"MobviousTimeOut"]);
        self.timeOut = [[info objectForKey:@"MobviousTimeOut"] floatValue];
    }

    [_interstitial loadFormatId:self.formatId pageId:self.pageId master:YES target:nil timeout:self.timeOut];

    //[_interstitial prefetchFormatId:self.formatId pageId:self.pageId master:YES target:nil];
    NSLog(@"Fetching next interstitial...");
}

- (void)showInterstitialFromRootViewController:(UIViewController *)rootViewController {
    if (self.isFetch) {
        NSLog(@"Displaying interstitial...");

        [rootViewController presentViewController:self.interstitial.delegate animated:NO completion:nil];
        [[self.interstitial.delegate view] addSubview:_interstitial];
        
        [self.delegate interstitialCustomEventWillAppear:nil];
    } else {
        NSLog(@"No ad fetch, aborting...");
        [self.delegate interstitialCustomEvent:self didFailToLoadAdWithError:nil];
    }
}



@end
