//
//  SOMAAdViewDelegate.h
//  iSoma
//
//  Created by Aman Shaikh on 30/05/14.
//  Copyright (c) 2014 Smaato Inc. All rights reserved.
//

#import <Foundation/Foundation.h>


@class SOMAAdView;

@protocol SOMAAdViewDelegate <NSObject>
@optional
- (UIViewController*)somaRootViewController;
- (void)somaAdViewWillLoadAd:(SOMAAdView *)adview;
- (void)somaAdViewDidLoadAd:(SOMAAdView *)adview;
- (void)somaAdView:(SOMAAdView *)adview didFailToReceiveAdWithError:(NSError *)error;
- (BOOL)somaAdViewShouldEnterFullscreen:(SOMAAdView *)adview;
- (void)somaAdViewDidExitFullscreen:(SOMAAdView *)adview;
- (void)somaAdViewAutoRedrectionDetected:(SOMAAdView *)adview;
- (void)somaAdViewWillHide:(SOMAAdView *)adview;

@end
