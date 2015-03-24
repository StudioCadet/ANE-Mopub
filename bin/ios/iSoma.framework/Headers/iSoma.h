//
//  iSoma.h
//  iSoma
//
//  Created by Aman Shaikh on 30/05/14.
//  Copyright (c) 2014 Smaato Inc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SOMAAdView.h"
#import "SOMAInterstitialAdView.h"
#import "SOMAInterstitialVideoAdView.h"
#import "SOMANativeAd.h"
#import "SOMAToasterAdView.h"
#import "SOMAMedRectAdView.h"
#import "SOMALeaderboardAdView.h"
#import "SOMASkyscraperAdView.h"
#import "SOMATypes.h"
#import "SOMAAdSettings.h"
#import "SOMAUserProfile.h"


@interface iSoma : NSObject

+(SOMAAdSettings*) defaultAdSettings;

+(NSString*) SDKVersion;
+(NSString*) apiVersion;
+(NSString*) mraidVersion;
+(void) setDefaultPublisherId:(NSString*)publisher adSpaceId:(NSString*) adspace;

#pragma mark -
#pragma mark - Syntactical suger for defaultSettings
#pragma mark -
+ (BOOL) isGPSEnabled;
+ (void) setGPSEnabled:(BOOL)yesOrNo;
+ (void) setAutoReloadEnabled:(BOOL) yesOrNo;
+ (BOOL) isAutoReloadEnabled;
+ (void) setAutoReloadInterval:(int) interval;
+ (int) autoReloadInterval;


#pragma mark -
#pragma mark - Logging
#pragma mark -
+(void) setLogLevel:(SOMALogLevel)level;
+(void) setLogOption:(SOMALogOption) option;



@end
