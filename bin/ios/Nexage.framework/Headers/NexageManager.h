//
//  NexageManager.h
//  Nexage
//
//  Copyright 2013 Nexage Inc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>
#import <UIKit/UIKit.h>

// ChartboostLocations
#define kNexageCBLocationStartup @"CBLocationStartup"
#define kNexageCBLocationHomeScreen @"CBLocationHomeScreen"
#define kNexageCBLocationMainMenu @"CBLocationMainMenu"
#define kNexageCBLocationGameScreen @"CBLocationGameScreen"
#define kNexageCBLocationAchievements @"CBLocationAchievements"
#define kNexageCBLocationQuests @"CBLocationQuests"
#define kNexageCBLocationPause @"CBLocationPause"
#define kNexageCBLocationLevelStart @"CBLocationLevelStart"
#define kNexageCBLocationLevelComplete @"CBLocationLevelComplete"
#define kNexageCBLocationTurnComplete @"CBLocationTurnComplete"
#define kNexageCBLocationIAPStore @"CBLocationIAPStore"
#define kNexageCBLocationItemStore @"CBLocationItemStore"
#define kNexageCBLocationGameOver @"CBLocationGameOver"
#define kNexageCBLocationLeaderBoard @"CBLocationLeaderBoard"
#define kNexageCBLocationSettings @"CBLocationSettings"
#define kNexageCBLocationQuit @"CBLocationQuit"
#define kNexageCBLocationDefault @"CBLocationDefault"

@protocol NexageManagerDelegate;

/**
 * Nexage Manager object.
 */
@interface NexageManager : NSObject

@property (nonatomic, assign) UIViewController *currentViewController;
@property (assign) id<NexageManagerDelegate> delegate;

/**
 * Instance of Nexage Manager (Singleton)
 */
+ (NexageManager *)sharedInstance;

/**
 * This method also adds features you wanted to have support. Look at
 * NexageAdParameters on supported features and the codes you can send.
 */
- (void)startUpWithDelegate:(id<NexageManagerDelegate>)delegate
               mediationUrl:(NSString *)url
                        dcn:(NSString *)dcn
                 attributes:(NSDictionary *)attributes
                   features:(NSArray *)features;

/**
 * Supporting methods
 */
+ (NSString *)getVersion;

// Setup background for Interstitial background
- (void)setAdBackgroundColor:(UIColor *)color;
- (UIColor *)adBackgroundColor;
- (void)addCustomParameter:(NSString *)param value:(NSString *)value;

@end

#pragma mark - NexageManagerDelegate

@protocol NexageManagerDelegate <NSObject>

@optional

/**
 * Callbacks from SDK about various lifecycle events
 */
- (void)adReceived:(UIView *)ad position:(NSString *)pos;
- (void)didFailToReceiveAd:(NSString *)position;

- (void)adFullScreenWebBrowserDidClose:(UIView *)adView; // Any expanded views or browser
- (void)adClosed:(UIView *)adView; // For interstitials
- (void)adWillExitApp:(UIView *)adView; // adView will be nil for third-party ads

/**
 * This method will be called when the user clicks on an ad banner. The URL request
 * is an optional parameter.  If an ad is from the Nexage Mediation Platform you will
 * recieve a valid URL.  If it is nil, this indicates that the URL is from an embedded
 * SDK. Please check if the URL == nil.  A return of YES indicates that the Nexage SDK
 * needs to handle the click.  Otherwise the Nexage SDK will ignore the user action such
 * as an ad click.
 */
- (BOOL)adActionShouldBegin:(NSURLRequest *)request;
- (BOOL)adActionShouldBegin:(NSURLRequest *)request withView:(UIView *)adView;  // used in Mediation

/**
 * When MRAID/Rich Media ads use resize(), SDK callback with this
 * method to offer the size you need to adjust the content to
 * accomodate. Refer MRAID documentation for more details.
 */
- (BOOL)adViewShouldResize:(UIView *)mraidView toPosition:(CGRect)position allowOffscreen:(BOOL)allowOffscreen;
- (void)adWillExpand:(UIView *)adView toFrame:(CGRect)frame;
- (void)adExpanded:(UIView *)adView;
- (void)adDidHide:(UIView *)adView;

#pragma mark - Optional Location data

// If your application uses CoreLocation you can provide the current location to help
// provide more relevant ads to your users.
- (CLLocation *)currentLocation;

#pragma mark - Optional thirdparty integration

/**
 *
 * This interface must be implemented if you want to use the Google AdMob SDK.
 * For this new version of the Google AdMob SDK (which starts with GADBannerView)
 * you must use the following delegate initialization method. Add GADSize.h
 * to your project as well as the following implementation code to your delegate handler:
 *
 
 - (void)initializeGADAdSizeDictionary:(NSMutableDictionary *)dict
 {
 GADAdSize adSizes[] = {
 kGADAdSizeBanner,
 kGADAdSizeMediumRectangle,
 kGADAdSizeFullBanner,
 kGADAdSizeLeaderboard,
 kGADAdSizeSkyscraper,
 kGADAdSizeSmartBannerPortrait,
 kGADAdSizeSmartBannerLandscape,
 kGADAdSizeInvalid,
 };
 
 int len = sizeof(adSizes) / sizeof(GADAdSize);
 for (int i = 0; i < len; i++) {
 NSString *key = NSStringFromGADAdSize(adSizes[i]);
 id obj = [NSValue valueWithBytes:&adSizes[i] objCType:@encode(GADAdSize)];
 [dict setObject:obj forKey:key];
 }
 }
 
 *
 */

- (void)initializeGADAdSizeDictionary:(NSMutableDictionary *)dict;

/**
 *
 * This interface must be implemented if you want to use the AdColony SDK.
 * You must use the following delegate initialization method. Add AdColony.h
 * to your project as well as the following implementation code to your delegate handler:
 *

 - (void)initializeAdColonyMetaDataDictionary:(NSMutableDictionary *)dict
 {
 [dict setObject:ADC_SET_USER_AGE forKey:@"ADC_SET_USER_AGE"];
 [dict setObject:ADC_SET_USER_INTERESTS forKey:@"ADC_SET_USER_INTERESTS"];
 [dict setObject:ADC_SET_USER_GENDER forKey:@"ADC_SET_USER_GENDER"];
 [dict setObject:ADC_SET_USER_LATITUDE forKey:@"ADC_SET_USER_LATITUDE"];
 [dict setObject:ADC_SET_USER_LONGITUDE forKey:@"ADC_SET_USER_LONGITUDE"];
 [dict setObject:ADC_SET_USER_ANNUAL_HOUSEHOLD_INCOME forKey:@"ADC_SET_USER_ANNUAL_HOUSEHOLD_INCOME"];
 [dict setObject:ADC_SET_USER_MARITAL_STATUS forKey:@"ADC_SET_USER_MARITAL_STATUS"];
 [dict setObject:ADC_SET_USER_EDUCATION forKey:@"ADC_SET_USER_EDUCATION"];
 [dict setObject:ADC_SET_USER_ZIPCODE forKey:@"ADC_SET_USER_ZIPCODE"];
 [dict setObject:ADC_USER_MALE forKey:@"ADC_USER_MALE"];
 [dict setObject:ADC_USER_FEMALE forKey:@"ADC_USER_FEMALE"];
 [dict setObject:ADC_USER_SINGLE forKey:@"ADC_USER_SINGLE"];
 [dict setObject:ADC_USER_MARRIED forKey:@"ADC_USER_MARRIED"];
 }
 
 *
 */

- (void)initializeAdColonyMetaDataDictionary:(NSMutableDictionary *)dict;

/**
 *
 * This interface must be implemented if you want to use the Chartboost SDK.
 * You must use the following delegate initialization method. Add Chartboost.h
 * to your project as well as the following implementation code to your delegate handler:
 *
- (void)initializeChartboostLocationDictionary:(NSMutableDictionary *)dict
{
    [dict setObject:CBLocationStartup forKey:@"CBLocationStartup"];
    [dict setObject:CBLocationHomeScreen forKey:@"CBLocationHomeScreen"];
    [dict setObject:CBLocationMainMenu forKey:@"CBLocationMainMenu"];
    [dict setObject:CBLocationGameScreen forKey:@"CBLocationGameScreen"];
    [dict setObject:CBLocationAchievements forKey:@"CBLocationAchievements"];
    [dict setObject:CBLocationQuests forKey:@"CBLocationQuests"];
    [dict setObject:CBLocationPause forKey:@"CBLocationPause"];
    [dict setObject:CBLocationLevelStart forKey:@"CBLocationLevelStart"];
    [dict setObject:CBLocationLevelComplete forKey:@"CBLocationLevelComplete"];
    [dict setObject:CBLocationTurnComplete forKey:@"CBLocationTurnComplete"];
    [dict setObject:CBLocationIAPStore forKey:@"CBLocationIAPStore"];
    [dict setObject:CBLocationItemStore forKey:@"CBLocationItemStore"];
    [dict setObject:CBLocationGameOver forKey:@"CBLocationGameOver"];
    [dict setObject:CBLocationLeaderBoard forKey:@"CBLocationLeaderBoard"];
    [dict setObject:CBLocationSettings forKey:@"CBLocationSettings"];
    [dict setObject:CBLocationQuit forKey:@"CBLocationQuit"];
    [dict setObject:CBLocationDefault forKey:@"CBLocationDefault"];
}

 *
 */

- (void)initializeChartboostLocationDictionary:(NSMutableDictionary *)dict;

/**
 *
 * This interface must be implemented if you want to use the Millennial SDK.
 * You must use the following delegate initialization method. Add #import <MillennialMedia/MMSDK.h>
 * to your project as well as the following implementation code to your delegate handler:
 *
 
 - (void)initializeMillennialDictionary:(NSMutableDictionary *)dict
 {
 [dict setObject:MillennialMediaAdWillTerminateApplication forKey:kNxgMillennialMediaAdWillTerminateApplication];
 [dict setObject:MillennialMediaAdWasTapped forKey:kNxgMillennialMediaAdWasTapped];
 [dict setObject:MillennialMediaAdModalWillAppear forKey:kNxgMillennialMediaAdModalWillAppear];
 [dict setObject:MillennialMediaAdModalDidAppear forKey:kNxgMillennialMediaAdModalDidAppear];
 [dict setObject:MillennialMediaAdModalWillDismiss forKey:kNxgMillennialMediaAdModalWillDismiss];
 [dict setObject:MillennialMediaAdModalDidDismiss forKey:kNxgMillennialMediaAdModalDidDismiss];
 [dict setObject:MillennialMediaKeyboardWillObscureAd forKey:kNxgMillennialMediaKeyboardWillObscureAd];
 [dict setObject:MillennialMediaKeyboardWillHide forKey:kNxgMillennialMediaKeyboardWillHide];
 [dict setObject:MillennialMediaAdObjectKey forKey:kNxgMillennialMediaAdObjectKey];
 [dict setObject:MillennialMediaAdObjectKey forKey:kNxgMillennialMediaAdTypeKey];
 [dict setObject:MillennialMediaAdTypeBanner forKey:kNxgMillennialMediaAdTypeBanner];
 [dict setObject:MillennialMediaAdTypeInterstitial forKey:kNxgMillennialMediaAdTypeInterstitial];

 }
 
 *
 */

- (void)initializeMillennialDictionary:(NSMutableDictionary *)dict;


@end
