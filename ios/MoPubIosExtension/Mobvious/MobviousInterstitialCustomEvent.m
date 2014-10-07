//
//  MobviousInterstitialCustomEvent.m
//  MoPubIosExtension
//
//  Created by Matthieu Kern on 18/08/2014.
//  Copyright (c) 2014 Richard Lord. All rights reserved.
//

#import "MobviousInterstitialCustomEvent.h"
#import "MPLogging.h"

#define kDefaultTimeOut 10

static BOOL isInitialized = false;

@implementation RootViewController

@end


@implementation MobviousInterstitialCustomEvent

#pragma mark - MPInterstitialCustomEvent Subclass Methods

- (void)requestInterstitialWithCustomEventInfo:(NSDictionary *)info {
    if (isInitialized == false) {
        if ([info objectForKey:@"MobviousSiteID"] && [info objectForKey:@"MobviousBaseURL"]) {
            self.siteId = [[info objectForKey:@"MobviousSiteID"] intValue];
            self.baseUrl = [info objectForKey:@"MobviousBaseURL"];
            NSLog(@"Setting the MobviousSiteID.");
        } else {
            NSLog(@"No MobviousSiteID or MobviousBaseURL to set, aborting...");
            [self.delegate interstitialCustomEvent:self didFailToLoadAdWithError:nil];
            return ;
        }
        
        NSLog(@"Connecting to Mobvious...");
        [SASAdView setSiteID:self.siteId baseURL:self.baseUrl];
        isInitialized = true;
    }
    
    self.isFetch = false;

    _window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
	self.controller = [[RootViewController alloc] initWithNibName:nil bundle:nil];
	_navigationController = [[UINavigationController alloc] initWithRootViewController:_controller];
    
    _window.rootViewController = _navigationController;
    
    SASInterstitialView *interstitial = [[SASInterstitialView alloc] initWithFrame:[[UIScreen mainScreen] bounds] loader:SASLoaderNone];
    self.interstitial = interstitial;
    [interstitial release];

    _interstitial.delegate = _controller;
    
    if ([info objectForKey:@"MobviousFormatId"] && [info objectForKey:@"MobviousPageId"]) {
        self.formatId = [[info objectForKey:@"MobviousFormatId"] intValue];
        self.pageId = [[info objectForKey:@"MobviousPageId"] intValue];
        NSLog(@"Setting the MobviousFormatId and the MobviousPageId.");
    } else {
        NSLog(@"No MobviousFormatId or MobviousPageId to set, aborting...");
        [self.delegate interstitialCustomEvent:self didFailToLoadAdWithError:nil];
        return ;
    }

    self.timeOut = kDefaultTimeOut;
    if ([info objectForKey:@"MobviousTimeOut"]) {
        self.timeOut = [[info objectForKey:@"MobviousTimeOut"] intValue];
    }
    
    [_interstitial loadFormatId:self.formatId pageId:self.pageId master:YES target:self.timeOut];
}
 
- (void)showInterstitialFromRootViewController:(UIViewController *)rootViewController {
    if (self.isFetch) {
        NSLog(@"Displaying interstitial...");
        [[[[[UIApplication sharedApplication] keyWindow] rootViewController] view] addSubview:_interstitial];
        [self.delegate interstitialCustomEventWillAppear:nil];
    } else {
        NSLog(@"No ad fetch, aborting...");
        [self.delegate interstitialCustomEvent:self didFailToLoadAdWithError:nil];
    }
}

#pragma mark - Mobvious Delegate

-(void)adView:(SASAdView *)adView didDownloadAd:(SASAd *)ad {
    if (adView == self.interstitial) {
        NSLog(@"Ad did load succesfuly.");
        [self.delegate interstitialCustomEvent:self didLoadAd:nil];
        self.isFetch = true;
    }
}

-(void)adView:(SASAdView *)adView didFailToLoadWithError:(NSError *)error {
    NSLog(@"Ad did fail to load... Aborting.");
    [self.delegate interstitialCustomEvent:self didFailToLoadAdWithError:error];
}

-(void)adViewDidLoad:(SASAdView *)adView {
    if (adView == self.interstitial) {
        NSLog(@"Ad view did load.");
        [self.delegate interstitialCustomEventDidAppear:nil];
    }
}

-(void)adViewDidDisappear:(SASAdView *)adView {
    if (adView == self.interstitial) {
        NSLog(@"Ad view did disappear.");
        [self.delegate interstitialCustomEventWillDisappear:nil];
        [self.delegate interstitialCustomEventDidDisappear:nil];
    }
}

-(void)dealloc {
    self.formatId = nil;
    self.pageId = nil;
    self.timeOut = nil;
    self.isFetch = false;
    
    self.interstitial.delegate = nil;
    self.interstitial = nil;

    [super dealloc];
}

@end
