//
//  NexageListenerManager.h
//  Nexage
//
//  Copyright (c) 2015 Nexage Inc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>

@class NexageAdView;

// A delegate for MRAIDView to listen for notification on ad ready or expand related events.
@protocol NexageListenerDelegate <NSObject>

@required

/**
 * Callbacks from SDK about various lifecycle events
 */
- (void)adReceived:(UIView *)ad position:(NSString *)pos;
- (void)didFailToReceiveAd:(NSString *)position;

/**
 * This method will be called when the user clicks on an ad banner. The URL request
 * is an optional parameter.  If an ad is from the Nexage Mediation Platform you will
 * recieve a valid URL.  If it is nil, this indicates that the URL is from an embedded
 * SDK. Please check if the URL == nil.  A return of YES indicates that the Nexage SDK
 * needs to handle the click.  Otherwise the Nexage SDK will ignore the user action such
 * as an ad click.
 */
- (BOOL)adActionShouldBegin:(NSURLRequest *)request withView:(UIView *)adView;
- (void)adFullScreenWebBrowserDidClose:(UIView *)adView;

/**
 * When MRAID/Rich Media ads use resize(), SDK callback with this
 * method to offer the size you need to adjust the content to
 * accomodate. Refer MRAID documentation for more details.
 */
- (BOOL)adViewShouldResize:(UIView *)adView toPosition:(CGRect)position allowOffscreen:(BOOL)allowOffscreen;
- (void)adExpanded:(UIView *)adView;
- (void)adClosed:(UIView *)adView;
- (void)adWillExitApp:(UIView *)adView;

@optional

- (void)refreshWillPresentFullScreenModal:(UIView *)adView;  // refresh full screen state for expanded or resized adViews (AdMob)

- (CLLocation *)currentLocation;

@end

@interface NexageListenerManager : NSObject

@property (nonatomic, assign) BOOL fullscreenModalActive;

- (void)addAdView:(NexageAdView *)adView withAdapter:(id)mediationAdapter;
- (void)removeAdView:(NexageAdView *)adView;

+ (NexageListenerManager *)sharedInstance;

@end
