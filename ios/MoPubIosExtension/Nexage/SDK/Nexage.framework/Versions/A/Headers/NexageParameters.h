//
//  NexageParameters.h
//  Nexage
//
//  Copyright 2013 Nexage Inc. All rights reserved.
//

#import <Foundation/Foundation.h>

/*
 * Customer's profile attributes.
*/
extern NSString * const kNexageDOB; // Date of Birth - Format: yyyyMMdd
extern NSString * const kNexageGender; //case sensitive "M", "F", or "O" for male, female, or other.
extern NSString * const kNexageEthnicity; // "0" (African-American), "1" (Asian), "2" (Hispanic), "3" (White), or "4" (Other).
extern NSString * const kNexageMarital; // case sensitive: "S", "M", "D", or "O" for single, married, divorced, or other.
extern NSString * const kNexageHaveKids; //Have kids - Boolean true if there are kids within the household (including perhaps the consumer).
extern NSString * const kNexageHouseHoldIncome; //Household income - in local base units (e.g., dollars, euros, yen) per annum.
extern NSString * const kNexageZip;
extern NSString * const kNexageCountry; // Three letter abbreviations
extern NSString * const kNexageCity;
extern NSString * const kNexageDesignatedMarketArea; //Designated Market Area (DMA) - by Nielsen Media Research
extern NSString * const kNexageKeywords; //A comma separated list of keywords pertaining to the user's interests
extern NSString * const kNexageAge; // Age if available (not needed if you have DOB)

/*
 * Optional consumers profile attributes
*/
extern NSString * const kNexageRequestKeywords;
extern NSString * const kNexageRequestZipcode;
extern NSString * const kNexageRequestAreaCode;
extern NSString * const kNexageRequestSearchString;

extern NSString * const kNexageImpressionGroups;


/*
 * Nexage support features
*/

extern NSString * const kNexageFeatureCoppaEnabled;
extern NSString * const kNexageFeatureSupportLogging;
extern NSString * const kNexageFeatureDonotSendAdId;
extern NSString * const kNexageFeatureDonotSupportCalendar;
extern NSString * const kNexageFeatureDonotSupportInlineVideo;
extern NSString * const kNexageFeatureDonotSupportSMS;
extern NSString * const kNexageFeatureDonotSupportPhoneDialing;
extern NSString * const kNexageFeatureDonotSupportSavingPicturesOrCoupons;
extern NSString * const kNexageFeatureDonotSuppressJSAlerts;
extern NSString * const kNexageFeatureDonotSuppressBannerAutoRedirects;

/*
  * SDK settings
 */

extern NSString * const kNexageVASTVideoLoadTimeout;
