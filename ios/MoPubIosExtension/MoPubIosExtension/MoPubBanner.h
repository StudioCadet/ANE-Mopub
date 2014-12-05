//
//  MoPubBanner.h
//  MoPubIosExtension
//
//  Created by Richard Lord on 23/10/2012.
//  Copyright (c) 2012 Richard Lord. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FlashRuntimeExtensions.h"
#import "MPAdView.h"

@interface MoPubBanner : MPAdView <MPAdViewDelegate>
{
}

+ (CGSize) getAdSizeFromSizeId:(int) sizeId;

- (id) initWithContext:( FREContext ) extensionContext adUnitId:(NSString*)adUnitId size:(CGSize)size;

- (BOOL) getAutorefresh;
- (void) setAutorefresh:(BOOL)value;

- (int) getPositionX;
- (int) getPositionY;
- (int) getFrameWidth;
- (int) getFrameHeight;
- (void) setPositionX:(int)value;
- (void) setPositionY:(int)value;
- (void) setFrameWidth:(int)value;
- (void) setFrameHeight:(int)value;

- (void) setAdSize:(int)value;
- (int) getCreativeWidth;
- (int) getCreativeHeight;

- (void) loadBanner;
- (void) showBanner;
- (void) removeBanner;

- (UIViewController*)viewControllerForPresentingModalView;
- (void)adViewDidLoadAd:(MPAdView*)view;
- (void)adViewDidFailToLoadAd:(MPAdView*)view;


@end
