//
//  MoPubBanner.m
//  MoPubIosExtension
//
//  Created by Richard Lord on 23/10/2012.
//  Copyright (c) 2012 Richard Lord. All rights reserved.
//

#import "MoPubBanner.h"
#import "MoPubInternalMessages.h"
#import "MoPubKeywords.h"

@interface MoPubBanner ()
{
}
@property (nonatomic, assign)FREContext context;
@property (nonatomic, assign)BOOL didDispatchAdClicked;

@end

@implementation MoPubBanner

@synthesize context;

- (id) initWithContext:(FREContext)extensionContext adUnitId:(NSString*)adUnitId size:(CGSize)size
{
    self = [super initWithAdUnitId:adUnitId size:size];
    
    if( self )
    {
        self.context = extensionContext;
        self.delegate = self;
    }
    return self;
}

- (void)dealloc
{
    self.delegate = nil;
    [super dealloc];
}

- (float) getDisplayDensity
{
    return [UIScreen mainScreen].scale;
}

+ (CGSize) getAdSizeFromSizeId:(int) sizeId
{
    switch( sizeId )
    {
        case 1:
            return MOPUB_BANNER_SIZE;
        case 2:
            return MOPUB_MEDIUM_RECT_SIZE;
        case 3:
            return MOPUB_LEADERBOARD_SIZE;
        case 4:
            return MOPUB_WIDE_SKYSCRAPER_SIZE;
        default:
            return MOPUB_BANNER_SIZE;
    }
}

- (BOOL) getAutorefresh
{
    return !self.ignoresAutorefresh;
}

- (void) setAutorefresh:(BOOL)value
{
    self.ignoresAutorefresh = !value;
}

- (int) getPositionX
{
    return (int) round( self.frame.origin.x * [self getDisplayDensity] );
}

- (int) getPositionY
{
    return (int) round( self.frame.origin.y * [self getDisplayDensity] );
}

- (int) getFrameWidth
{
    return (int) round( self.frame.size.width * [self getDisplayDensity] );
}

- (int) getFrameHeight
{
    return (int) round( self.frame.size.height * [self getDisplayDensity] );
}

- (void) setPositionX:(int)value
{
    CGRect frame = self.frame;
    frame.origin.x = (float)value / [self getDisplayDensity];
    self.frame = frame;
}

- (void) setPositionY:(int)value
{
    CGRect frame = self.frame;
    frame.origin.y = (float) value / [self getDisplayDensity];
    self.frame = frame;
}

- (void) setFrameWidth:(int)value
{
    CGRect frame = self.frame;
    frame.size.width = (float)value / [self getDisplayDensity];
    self.frame = frame;
}

- (void) setFrameHeight:(int)value
{
    CGRect frame = self.frame;
    frame.size.height = (float)value / [self getDisplayDensity];
    self.frame = frame;
}

- (void) setAdSize:(int)value
{
    CGSize size = [MoPubBanner getAdSizeFromSizeId:value];
    CGRect frame = self.frame;
    frame.size = size;
    self.frame = frame;
}

- (int) getCreativeWidth
{
    return (int) round( [self adContentViewSize].width * [self getDisplayDensity] );
}

- (int) getCreativeHeight
{
    return (int) round( [self adContentViewSize].height * [self getDisplayDensity] );
}

- (void) loadBanner
{
    [super setKeywords:[[MoPubKeywords current] getMopubKeywords]];
    self.didDispatchAdClicked = false;
    [self loadAd];
}

- (void) showBanner
{
    [[UIApplication sharedApplication].keyWindow.rootViewController.view addSubview:self];
}

- (void) removeBanner
{
    [self removeFromSuperview];
}

- (UIViewController*)viewControllerForPresentingModalView
{
    return [UIApplication sharedApplication].keyWindow.rootViewController;
}

// Delegate

- (void)dispatchAdClickedIfPossible {
    if (self.didDispatchAdClicked)
        return;
    
    self.didDispatchAdClicked = true;
    FREDispatchStatusEventAsync( context, "", bannerAdClicked );
}

- (void)adViewDidLoadAd:(MPAdView*)view
{
    FREDispatchStatusEventAsync( context, "", bannerLoaded );
}

- (void)adViewDidFailToLoadAd:(MPAdView*)view
{
    FREDispatchStatusEventAsync( context, "", bannerFailedToLoad );
}

- (void)willPresentModalViewForAd:(MPAdView *)view
{
    [self dispatchAdClickedIfPossible];
}

- (void)didDismissModalViewForAd:(MPAdView *)view
{
    FREDispatchStatusEventAsync( context, "", bannerAdClosed );
}

- (void)willLeaveApplicationFromAd:(MPAdView *)view
{
    [self dispatchAdClickedIfPossible];
}

@end
