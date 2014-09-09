//
//  VCVidCoin.h
//  VidCoin
//
//  Created by VidCoin on 04/03/14.
//  Copyright (c) 2014 VidCoin. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

// Constants used in +updateUserDictionary:
#define kVCUserGameID @"userGameId"
#define kVCUserBirthYear @"birthYear"
#define kVCUserGenderKey @"gender"
#define kVCUserGenderMale @"MALE"
#define kVCUserGenderFemale @"FEMALE"

// Constants used in viewInfo
#define kVCStatusCodeKey @"statusCode"
typedef NS_ENUM(NSInteger, VCStatusCode) {
    VCStatusCodeSuccess = 1,
    VCStatusCodeError = 2,
    VCStatusCodeCancel = 3
};

@protocol VidCoinDelegate;

#pragma mark - VidCoin Main Class

@interface VidCoin : NSObject

/**
 *  VidCoin's main delegate. See VidCoinDelegate protocol for all available methods.
 */
@property (nonatomic, weak) id<VidCoinDelegate> delegate;

/**
 *  The recommended way to install VidCoin into your application is to place a call
 * to +startWithGameId: in your -application:didFinishLaunchingWithOptions: method.
 *
 *  @param gameId Your game's ID in VidCoin's backoffice.
 */
+(void)startWithGameId:(NSString*)gameId;

/**
 * The recommended way to install VidCoin into your application is to place a call
 * to +startWithGameId:delegate: in your -application:didFinishLaunchingWithOptions: method.
 *
 *  @param gameId   Your game's ID in VidCoin's backoffice.
 *  @param delegate VidCoin's delegate.
 */
+(void)startWithGameId:(NSString*)gameId delegate:(id<VidCoinDelegate>)delegate;

/**
 *  Set VidCoin's delegate.
 *
 *  @param delegate VidCoin's delegate.
 */
+(void)setDelegate:(id<VidCoinDelegate>)delegate;

/**
 *  Update the user information dictionary.
 *
 *  @code
 *  @{ kVCUserGameID: @"playerXX", kVCUserBirthYear: @"1989", kVCUserGenderKey: kVCUserGenderMale }
 *  @endcode
 *
 *  @param userDictionary A dictionary containing values for the specific keys.
 */
+(void)updateUserDictionary:(NSDictionary*)userDictionary;

/**
 *  
 * Access the singleton VidCoin instance.
 *
 */
+(VidCoin*)sharedInstance;

/**
 *  Tells wether a video is available to play for a given placement code.
 *
 *  @param placementCode Your placement code.
 *
 *  @return YES or NO, depending if a video is in cache for the placement or not.
 */
+(BOOL)videoIsAvailableForPlacement:(NSString*)placementCode;

/**
 *  Plays a video ad for a given placement code.
 *
 *  @param viewController UIViewController to push from.
 *  @param placementCode  Code for the placement.
 *  @param animated       Wether the appearing of the video should be animated.
 */
+(void)playAdFromViewController:(UIViewController*)viewController forPlacement:(NSString*)placementCode animated:(BOOL)animated;

/**
 *  Enables / disables logging.
 *
 *  @param enable enable A BOOL value to enable / disable logging.
 */
+(void)setLoggingEnabled:(BOOL)enable;

@end

#pragma mark - VidCoinDelegate

@protocol VidCoinDelegate <NSObject>
@optional

/**
 *  Called any time there is a status update in VidCoin's SDK. For exemple,
 *  this method will be called if a video was stored in cache, or if the
 *  list of available campaigns for the user changed.
 */
-(void)vidcoinCampaignsUpdate;

/**
 *  This method is called just before VidCoin's video player appears on screen.
 */
-(void)vidcoinViewWillAppear;

/**
 *  This method is called right after VidCoin's video player disappeared from screen.
 *  You can access some information about the view in the viewInfo dictionary you get in parameter:
 *
 *  @code
 *  // Check if the user watched the whole video, or if something happened:
 *  VCStatusCode status = [[viewInfo objectForKey:@"statusCode"] integerValue];
 *  // You can compare status to VCStatusCodeSuccess, VCStatusCodeError, VCStatusCodeCancel
 *
 *  // In case of an item sponsoring, know how much the user will be credited:
 *  NSNumber *reward = [viewInfo objectForKey:@"reward"];
 *  @endcode
 *
 *  @param viewInfo A dictionary with information on the view. See the above code for available keys.
 */
-(void)vidcoinViewDidDisappearWithViewInformation:(NSDictionary*)viewInfo;

/**
 *  This method is called when VidCoin validated the user view on server.
 *  Note that your implementation of this method will *always* be called *after* the call
 *  placed to vidcoinViewDidDisappearWithViewInformation:
 *
 *  You can access some information about the view in the viewInfo dictionary you get in parameter:
 *
 *  @code
 *  // Check if the view was validated on VidCoin's server:
 *  VCStatusCode status = [[viewInfo objectForKey:@"statusCode"] integerValue];
 *  // You can compare status to VCStatusCodeSuccess, VCStatusCodeError
 *
 *  // In case of an item sponsoring,
 *  // know how much the user was credited if the view was validated:
 *  NSNumber *reward = [viewInfo objectForKey:@"reward"];
 *  @endcode
 *
 *  @param viewInfo A dictionary with information on the view. See the above code for available keys.
 */
-(void)vidcoinDidValidateView:(NSDictionary*)viewInfo;

@end
