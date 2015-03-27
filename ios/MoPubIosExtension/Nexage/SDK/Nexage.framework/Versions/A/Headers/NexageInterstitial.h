//
//  NexageInterstitial.h
//  NexageSDK
//
//  Copyright 2013 Nexage Inc. All rights reserved.
//

@protocol NexageInterstitialAdDelegate

@optional
/**
 * After calling [interstitial getAd] the application will receive one of
 * the following events: interstitialAdWillBegin or interstitialAdDidClose.
 * However, if an ad is unavailable the interstitialFailedToReceiveAd
 * method will be called.
 */

- (void)interstitialFailedToReceiveAd;
- (void)interstitialAdReady;
- (void)interstitialAdWillBegin;
- (void)interstitialAdDidClose;
- (void)interstitialAdDisplayError;
- (void)interstitialVideoTrackingEvent:(NSString *)eventName;

@end

@interface NexageInterstitial : NSObject

@property (nonatomic, retain) NSString *position;
@property (nonatomic, assign) id<NexageInterstitialAdDelegate> delegate;

- (id)initWithPosition:(NSString *)position delegate:(id<NexageInterstitialAdDelegate>)aDelegate;
- (id)initWithMediationPosition:(NSString *)position delegate:(id<NexageInterstitialAdDelegate>)aDelegate;
- (void)getAd;
- (void)show;
- (BOOL)isAdLoaded;

@end
