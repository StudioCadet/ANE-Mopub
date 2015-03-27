//
//  NexageInsterstitialCustomEvent.m
//  MoPubIosExtension
//
//  Created by Antoine Kleinpeter on 25/03/15.
//  Copyright (c) 2015 Richard Lord. All rights reserved.
//

#import "NexageInterstitialCustomEvent.h"
#import "MPLogging.h"
#import "MoPubKeywords.h"
#import "MoPubCustomEventClassData.h"

@implementation NexageInterstitialCustomEvent

- (void)dealloc {
    self.interstitial = nil;
    self.delegate = nil;
    self.customEventClassData = nil;
    
    NSLog(@"DEALLOC !");
    [super dealloc];
    
    NSLog(@"DEALLOC OK ");
}

-(void) requestInterstitialWithCustomEventInfo:(NSDictionary *)info {
    MPLogInfo(@"Requesting a Nexage interstitial ad...");
    
    self.customEventClassData = [[MoPubCustomEventClassData alloc] initWithMopubWebsiteData:info];
    
    if (![self.customEventClassData hasRequiredProperties:@[@"position", @"dcn"]]) {
        MPLogInfo(@"One of the required parameters is missing, cannot load interstitial !");
        [self.delegate interstitialCustomEvent:self didFailToLoadAdWithError:nil];
        return;
    }
    
    static dispatch_once_t once;
    dispatch_once(&once, ^{
        [self initNexage];
    });

    
    [self loadAd];
}

- (void) initNexage {
    MPLogInfo(@"Initializing Nexage...");
    [[NexageManager sharedInstance] startUpWithDelegate:self mediationUrl:@"http://bos.ads0.nexage.com" dcn:[self.customEventClassData getPropertyValue:@"dcn"]
                                    attributes:@{
                                            kNexageDOB: [self getFormattedDateOfBirth],
                                            kNexageGender: [self getGender],
                                            kNexageKeywords: [self getKeywords]
                                    }
                                    features:@[kNexageFeatureSupportLogging]
    ];
}

- (void) loadAd {
    NSString* position = [self.customEventClassData getPropertyValue:@"position"];
    
    MPLogInfo(@"Using position %@", position);
    
    self.interstitial = [[NexageInterstitial alloc] initWithMediationPosition:position delegate:self];
    NSLog(@"LALALALALALALALAL : 5,1");
    [self.interstitial getAd];
    NSLog(@"LALALA : 5.2");
}

-(NSString *)getFormattedDateOfBirth {
    NSDate* dateOfBirth = [[MoPubKeywords current] dateOfBirth];
    
    if (dateOfBirth == nil)
        return @"";
    
    NSDateFormatter* dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyMMdd"];
    
    return [dateFormatter stringFromDate:dateOfBirth];
}

-(NSString *)getGender {
    NSString* mopubGender = [[MoPubKeywords current] gender];
    
    if (mopubGender == nil)
        return @"O";

    return [mopubGender uppercaseString];
}

-(NSString *)getKeywords {
    NSString* keywords = [[MoPubKeywords current] inMobiInterests];
    
    if (keywords == nil)
        return @"";

    return keywords;
}

-(void) showInterstitialFromRootViewController:(UIViewController *)rootViewController {
    if (![self.interstitial isAdLoaded]) {
        MPLogInfo(@"No ad loaded, cannot show Nexage interstitial.");
        [self.delegate interstitialCustomEvent:self didFailToLoadAdWithError:nil];
        return;
    }
    
    [[NexageManager sharedInstance] setCurrentViewController:rootViewController];
    [self.interstitial show];
}

#pragma mark - Nexage interstitial delegate

- (void)interstitialFailedToReceiveAd {
    MPLogInfo(@"Nexage ad did fail to load.");
    [self.delegate interstitialCustomEvent:self didFailToLoadAdWithError:nil];
}

- (void)interstitialAdReady {
    MPLogInfo(@"Nexage ad loaded.");
    [self.delegate interstitialCustomEvent:self didLoadAd:self.interstitial];
}

- (void)interstitialAdWillBegin {
    MPLogInfo(@"Nexage ad will begin.");
    [self.delegate interstitialCustomEventWillAppear:self];
}

- (void)interstitialAdDidClose {
    MPLogInfo(@"Nexage ad did close.");
    [self.delegate interstitialCustomEventDidDisappear:self];
}

#pragma mark - NexageManagerDelegate

- (void)adWillExitApp:(UIView *)adView {
    MPLogInfo(@"Nexage ad was clicked !");
    [self.delegate interstitialCustomEventDidReceiveTapEvent:self];
}
@end
