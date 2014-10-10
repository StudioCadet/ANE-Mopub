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

@interface RootViewController : UIViewController <UITableViewDelegate, SASAdViewDelegate>

@end

@interface MobviousInterstitialCustomEvent : MPInterstitialCustomEvent <UIApplicationDelegate, SASAdViewDelegate>

    @property (nonatomic, retain) RootViewController *controller;
    @property (nonatomic, retain) UINavigationController *navigationController;
    @property (nonatomic, retain) UIWindow *window;

    @property NSInteger siteId;
    @property (nonatomic, copy) NSString* baseUrl;

    @property NSInteger formatId;
    @property (nonatomic, copy) NSString* pageId;
    @property (nonatomic) float timeOut;

    @property (nonatomic, retain) SASInterstitialView *interstitial;
    @property Boolean isFetch;

@end
