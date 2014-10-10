//
//  MobviousBannerCustomEvent.m
//  MoPubIosExtension
//
//  Created by Matthieu Kern on 07/10/2014.
//  Copyright (c) 2014 Richard Lord. All rights reserved.
//

#import "MobviousBannerCustomEvent.h"

#define kDefaultTimeOut 10

static BOOL isInitialized = false;

@implementation MobviousBannerCustomEvent

- (void)requestAdWithSize:(CGSize)size customEventInfo:(NSDictionary *)info
{
    if (isInitialized == false) {
        if ([info objectForKey:@"MobviousSiteID"] && [info objectForKey:@"MobviousBaseURL"]) {
            self.siteId = [[info objectForKey:@"MobviousSiteID"] intValue];
            self.baseUrl = [info objectForKey:@"MobviousBaseURL"];
            NSLog(@"Setting the MobviousSiteID.");
        } else {
            NSLog(@"No MobviousSiteID or MobviousBaseURL to set, aborting...");
            [self.delegate bannerCustomEvent:nil didFailToLoadAdWithError:nil];
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

    SASBannerView *banner = [[SASBannerView alloc] initWithFrame:CGRectMake(0, 0, size.width, size.height) loader:SASLoaderNone];
    self.banner = banner;
    [banner release];

    if ([info objectForKey:@"MobviousFormatId"] && [info objectForKey:@"MobviousPageId"]) {
        self.formatId = (NSInteger)[[info objectForKey:@"MobviousFormatId"] intValue];
        self.pageId = [info objectForKey:@"MobviousPageId"];
        NSLog(@"Setting the MobviousFormatId and the MobviousPageId.");
    } else {
        NSLog(@"No MobviousFormatId or MobviousPageId to set, aborting...");
        [self.delegate bannerCustomEvent:self didFailToLoadAdWithError:nil];
        return ;
    }

    _banner.delegate = _controller;
    
    [_banner loadFormatId:self.formatId pageId:self.pageId master:YES target:nil];
}

-(void) adView:(SASAdView *)adView didDownloadAd:(SASAd *)ad {
    if (!ad) {
        NSLog(@"No more banner to load !");
        [self.delegate bannerCustomEvent:self didFailToLoadAdWithError:nil];
    } else {
        NSLog(@"Banner did download.");
    }
}

-(void) adViewDidLoad:(SASAdView *)adView {
    if (adView == self.banner) {
        NSLog(@"Displaying banner...");
        [[[[[UIApplication sharedApplication] keyWindow] rootViewController] view] addSubview:_banner];
        [self.delegate bannerCustomEvent:self didLoadAd:nil];
    }
}

-(void) adView:(SASAdView *)adView didFailToLoadWithError:(NSError *)error {
    NSLog(@"Banner did fail to load !");
    [self.delegate bannerCustomEvent:self didFailToLoadAdWithError:error];
}

- (BOOL)enableAutomaticImpressionAndClickTracking
{
    // Override this method to return NO to perform impression and click tracking manually.
    
    return NO;
}

-(void) adView:(SASAdView *)adView didExpandWithFrame:(CGRect)frame {
    NSLog(@"Banner did expand.");
}

-(void) adViewDidCollapse:(SASAdView *)adView {
    NSLog(@"Banner did collapse");
    [self.delegate bannerCustomEventDidFinishAction:self];
}

-(void) adViewDidDisappear:(SASAdView *)adView {
    NSLog(@"Banner did disappear.");
    [self.delegate bannerCustomEventDidFinishAction:self];
}

-(void) adViewWillExpand:(SASAdView *)adView {
    NSLog(@"Banner will expand");
    [self.delegate bannerCustomEventWillBeginAction:self];
}

-(void) dealloc {
    self.banner.delegate = nil;
    self.banner = nil;
    [super dealloc];
}

@end
