//
//  SOMANativeAd.h
//  iSoma
//
//  Created by Aman Shaikh on 17/12/14.
//  Copyright (c) 2014 Smaato Inc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@class SOMANativeAd;

@protocol SOMANativeAdDelegate <NSObject>
@required
- (void)somaNativeAdDidLoad:(SOMANativeAd*)nativeAd;
- (void)somaNativeAdDidFailed:(SOMANativeAd*)nativeAd withError:(NSError*)error;
- (BOOL)somaNativeAdShouldEnterFullScreen:(SOMANativeAd *)nativeAd;
@end

@interface SOMANativeAd : NSObject
@property float rating;
@property NSString* callToAction;
@property BOOL shouldAddSponsoredLabel;
@property NSURL* clickURL;
@property NSArray* beacons;

@property(nonatomic, weak) id<SOMANativeAdDelegate> delegate;

@property(nonatomic, weak) UILabel* labelForTitle;
@property(nonatomic, weak) UILabel* labelForDescription;
@property(nonatomic, weak) UIImageView* imageViewForIcon;
@property(nonatomic, weak) UIImageView* imageViewForMainImage;

-(instancetype) initWithPublisherId:(NSString*)publisherId adSpaceId:(NSString*)adSpaceId;
- (void)load;
- (void)registerViewForUserInteraction:(UIView*)view;

@end
