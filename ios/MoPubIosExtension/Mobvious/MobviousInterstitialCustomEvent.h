//
//  MobviousInterstitialCustomEvent.h
//  MoPubIosExtension
//
//  Created by Matthieu Kern on 18/08/2014.
//  Copyright (c) 2014 Richard Lord. All rights reserved.
//

#import "MPInterstitialCustomEvent.h"

#import "SASBannerView.h"
#import "SASInterstitialView.h"

@interface MobviousInterstitialCustomEvent : MPInterstitialCustomEvent <UIApplicationDelegate>

@property NSInteger formatId;
@property (nonatomic, copy) NSString* pageId;
@property (nonatomic) float timeOut;
@property NSInteger retryDelay;

@property (nonatomic, strong) SASInterstitialView *interstitial;
@property (nonatomic, strong) UIViewController *rootViewController;

@end


/** A RootViewController implementation that calls appropriate Mopub custom event callbacks on Mobvious ads lifecycle events. */
@interface InterstitialRootViewController : UIViewController <UITableViewDelegate, SASAdViewDelegate>
    @property (nonatomic, retain) MobviousInterstitialCustomEvent *mpCustomEvent;
@end

