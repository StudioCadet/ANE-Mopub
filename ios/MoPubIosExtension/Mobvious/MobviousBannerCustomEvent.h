//
//  MobviousBannerCustomEvent.h
//  MoPubIosExtension
//
//  Created by Matthieu Kern on 07/10/2014.
//  Copyright (c) 2014 Richard Lord. All rights reserved.
//

#import "MPBannerCustomEvent.h"
#import "MobviousInterstitialCustomEvent.h"

@interface MobviousBannerCustomEvent : MPBannerCustomEvent

    @property (nonatomic, retain) UINavigationController *navigationController;
    @property (nonatomic, retain) UIWindow *window;

    @property NSInteger formatId;
    @property (nonatomic, copy) NSString* pageId;
    @property float timeOut;

    @property (nonatomic, retain) SASBannerView *banner;
    @property (nonatomic) Boolean isFetch;

@end

@interface BannerRootViewController : UIViewController <UITableViewDelegate, SASAdViewDelegate>
@property (nonatomic, retain) MobviousBannerCustomEvent *mpCustomEvent;
@end


