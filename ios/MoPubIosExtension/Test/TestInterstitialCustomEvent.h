//
//  TestInterstitialCustomEvent.h
//  MoPubIosExtension
//
//  Created by Antoine Kleinpeter on 26/03/15.
//  Copyright (c) 2015 Richard Lord. All rights reserved.
//

#import "MPInterstitialCustomEvent.h"
#import "NexageInterstitialCustomEvent.h"

@interface TestInterstitialCustomEvent : MPInterstitialCustomEvent

@property (nonatomic, retain) NexageInterstitialCustomEvent *interstitialCustomEvent;

@end
