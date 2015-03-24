//
//  SOMAAdView.h
//  iSoma
//
//  Created by Aman Shaikh on 30/05/14.
//  Copyright (c) 2014 Smaato Inc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SOMATypes.h"
#import "SOMAAdViewDelegate.h"
#import "SOMAAdSettings.h"
//#import "SOMADefaultAdViewPresentation.h"
//#import "SOMAAdViewPresentationDelegate.h"

@class SOMAAdRenderer;
@class SOMAFullScreenAdViewController;
@class SOMARenderedAdView;

@interface SOMAAdView : UIView

@property(nonatomic, readonly) BOOL isLoaded;
@property(nonatomic, copy) SOMAAdSettings* adSettings;

@property(nonatomic, weak)IBOutlet id<SOMAAdViewDelegate> delegate; 
//@property(nonatomic, weak) id<SOMAAdViewPresentationDelegate> presentationDelegate;
//@property(nonatomic, strong) id<SOMAAdViewPresentation> presentation;
@property(nonatomic, strong) NSArray* adTransitions;
@property(nonatomic, assign) BOOL shouldAppearAutomatically;
//@property(nonatomic, strong) SOMARenderedAdView* renderedAd;
@property SOMAAdRenderer* currentRenderedAd;
@property(nonatomic, assign) BOOL isNewAdAvailable;
@property(nonatomic, strong) SOMAFullScreenAdViewController* fullScreenViewController;
@property BOOL isPresented;
@property BOOL isAdShown;

- (SOMAAdSettings*) preferredSettings;
-(void)load;

@property(nonatomic, assign)  BOOL doNotStartLoadingAd;

#pragma mark -
#pragma mark - To be used as "User Defined Runtime Atrteibutes" in XCode Interface builder';
#pragma mark -
@property(nonatomic, strong) NSNumber* adSpaceId;
@property(nonatomic, strong) NSNumber* publisherId;
@property(nonatomic, assign) BOOL disableAutoReload;
@property(nonatomic, strong) NSNumber* autoReloadInterval;

-(void)show;
-(void)hide;
-(void) pause;
-(void) resume;
-(void)sizeChanged;
- (UIViewController*) rootViewController;
@end
