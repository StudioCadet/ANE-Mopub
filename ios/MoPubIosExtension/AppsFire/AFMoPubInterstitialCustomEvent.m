/*!
 *  @header    AFMoPubInterstitialCustomEvent.m
 *  @abstract  Appsfire MoPub Interstitial Custom Event class.
 *  @version   1.5
 */

#import "AFMoPubInterstitialCustomEvent.h"

// Appsfire SDK
#import "AppsfireAdSDK.h"
#import "AppsfireAdTimerView.h"

static NSTimeInterval const AFMoPubInterstitialCustomEventTimerInterval = 3.0;

@interface AFMoPubInterstitialCustomEvent () <AppsfireAdSDKDelegate, AFAdSDKModalDelegate>

@property (nonatomic, assign) AFAdSDKModalType modalType;
@property (nonatomic, assign) BOOL shouldShowTimer;
@property (nonatomic, assign, getter=isDelegateAlreadyNotified) BOOL delegateAlreadyNotified;

// Parses and assigns the modal type and timer values.
- (void)parseInfoPayload:(NSDictionary *)info;

// Shows Appsfire interstitials if those are available.
- (void)showAppsfireInterstitialsFromRootViewController:(UIViewController *)rootViewController;

// Checks the availability of Ads.
- (void)checkAdAvailability;

@end

@implementation AFMoPubInterstitialCustomEvent

#pragma mark - Ad Request

- (void)requestInterstitialWithCustomEventInfo:(NSDictionary *)info {
    
    // Variable init.
    _delegateAlreadyNotified = NO;
    
    // Default values
    _modalType = AFAdSDKModalTypeSushi;
    _shouldShowTimer = NO;
    
    // Getting custom values.
    [self parseInfoPayload:info];
    
    // Check if ads are available.
    [self checkAdAvailability];
}

- (void)showInterstitialFromRootViewController:(UIViewController *)rootViewController {
    [self showAppsfireInterstitialsFromRootViewController:rootViewController];
}

- (void)checkAdAvailability {
    
    // We need to know if we have available ads.
    AFAdSDKAdAvailability availability = [AppsfireAdSDK isThereAModalAdAvailableForType:_modalType];
    
    // Depending on the availability.
    switch (availability) {
            
        case AFAdSDKAdAvailabilityPending: {
            
            // Setting the delegate to receive availability events.
            [AppsfireAdSDK setDelegate:self];
            
        } break;
            
        // If we have ads we inform the delegate.
        case AFAdSDKAdAvailabilityYes: {
            [self interstitialDidLoad];
        } break;
            
        // If we have no ads we inform the delegate.
        case AFAdSDKAdAvailabilityNo: {
            NSError *error = [NSError errorWithDomain:@"com.appsfire.sdk"
                                                 code:AFSDKErrorCodeAdvertisingNoAd
                                             userInfo:@{NSLocalizedDescriptionKey : @"No Ads to display."}];
            [self interstitialDidFailToLoadWithError:error];
        } break;
            
        default: {
        } break;
    }
}

#pragma mark - AppsfireAdSDKDelegate

- (void)modalAdsRefreshedAndAvailable {
    
    [self interstitialDidLoad];
    [AppsfireAdSDK setDelegate:nil];
}

- (void)modalAdsRefreshedAndNotAvailable {
    
    NSError *error = [NSError errorWithDomain:@"com.appsfire.sdk"
                                         code:AFSDKErrorCodeAdvertisingNoAd
                                     userInfo:@{NSLocalizedDescriptionKey : @"No Ads to display."}];
    
    [self interstitialDidFailToLoadWithError:error];
    [AppsfireAdSDK setDelegate:nil];
}

#pragma mark - AFAdSDKModalDelegate

- (void)modalAdRequestDidFailWithError:(NSError *)error {
    [self interstitialDidFailToLoadWithError:error];
}

- (void)modalAdWillAppear {
    if ([self.delegate respondsToSelector:@selector(interstitialCustomEventWillAppear:)]) {
        [self.delegate interstitialCustomEventWillAppear:self];
    }
}

- (void)modalAdDidAppear {
    if ([self.delegate respondsToSelector:@selector(interstitialCustomEventDidAppear:)]) {
        [self.delegate interstitialCustomEventDidAppear:self];
    }
}

- (void)modalAdWillDisappear {
    if ([self.delegate respondsToSelector:@selector(interstitialCustomEventWillDisappear:)]) {
        [self.delegate interstitialCustomEventWillDisappear:self];
    }
}

- (void)modalAdDidDisappear {
    if ([self.delegate respondsToSelector:@selector(interstitialCustomEventDidDisappear:)]) {
        [self.delegate interstitialCustomEventDidDisappear:self];
    }
    
    // Setting the delegate to `nil` here because we don't know when the object is dealloaced.
    [AppsfireAdSDK setDelegate:nil];
}

- (void)modalAdDidReceiveTapForDownload {
    if ([self.delegate respondsToSelector:@selector(interstitialCustomEventDidReceiveTapEvent:)]) {
        [self.delegate interstitialCustomEventDidReceiveTapEvent:self];
    }
}

#pragma mark - Misc

- (void)interstitialDidLoad {
    
    if ([self.delegate respondsToSelector:@selector(interstitialCustomEvent:didLoadAd:)] && !self.isDelegateAlreadyNotified) {
        [self.delegate interstitialCustomEvent:self didLoadAd:nil];
        _delegateAlreadyNotified = YES;
    }
}

- (void)interstitialDidFailToLoadWithError:(NSError *)error {
    
    if ([self.delegate respondsToSelector:@selector(interstitialCustomEvent:didFailToLoadAdWithError:)] && !self.isDelegateAlreadyNotified) {
        [self.delegate interstitialCustomEvent:self didFailToLoadAdWithError:error];
        _delegateAlreadyNotified = YES;
    }
}

#pragma mark - Parsing the Info

- (void)parseInfoPayload:(NSDictionary *)info {
    
    // Fetching necessary information in order to decide which ad unit we are showing
    if ([info isKindOfClass:NSDictionary.class]) {
        
        // Getting the type of the ad unit.
        NSString *type = [info objectForKey:@"type"];
        if ([type isKindOfClass:NSString.class]) {
            
            // Sushi
            if ([type isEqualToString:@"sushi"]) {
                _modalType = AFAdSDKModalTypeSushi;
            }
            
            // Uramaki
            else if ([type isEqualToString:@"uramaki"]) {
                _modalType = AFAdSDKModalTypeUraMaki;
            }
        }
        
        // Should we display the timer?
        NSNumber *timer = [info objectForKey:@"timer"];
        if ([timer isKindOfClass:NSNumber.class]) {
            _shouldShowTimer = [timer boolValue];
        }
    }
}

#pragma mark - Show Interstitials

- (void)showAppsfireInterstitialsFromRootViewController:(UIViewController *)rootViewController {
    
    if (![rootViewController isKindOfClass:UIViewController.class]) {
        return;
    }
    
    // If we don't have any available interstitial we skip the next lines.
    if ([AppsfireAdSDK isThereAModalAdAvailableForType:_modalType] != AFAdSDKAdAvailabilityYes) {
        return;
    }
    
    // Showing a timer before presenting the Ad.
    if (_shouldShowTimer) {
        
        [[[AppsfireAdTimerView alloc] initWithCountdownStart:AFMoPubInterstitialCustomEventTimerInterval] presentWithCompletion:^(BOOL accepted) {
            if (accepted) {
                [AppsfireAdSDK requestModalAd:_modalType withController:rootViewController withDelegate:self];
            }
        }];
    }
    
    // Simply showing the Ad.
    else {
        [AppsfireAdSDK requestModalAd:_modalType withController:rootViewController withDelegate:self];
    }
}

@end
