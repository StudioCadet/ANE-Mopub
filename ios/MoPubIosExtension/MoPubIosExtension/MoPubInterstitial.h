//
//  MoPubInterstitial.h
//  MoPubIosExtension
//
//  Created by Richard Lord on 14/11/2012.
//  Copyright (c) 2012 Richard Lord. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FlashRuntimeExtensions.h"
#import "MPInterstitialAdController.h"

@interface MoPubInterstitial : NSObject <MPInterstitialAdControllerDelegate>
{
}

- (id) initWithContext:(FREContext)extensionContext adUnitId:(NSString*)adUnitId;
- (BOOL) getIsReady;
- (void) setTesting:(BOOL)value;
- (void) loadInterstitial;
- (BOOL) showInterstitial;
+ (void)interstitialDidCancel:(MPInterstitialAdController *)interstitial;

@end
