//
//  VidCoinInterstitialCustomEvent.h
//  MoPubIosExtension
//
//  Created by Matthieu Kern on 18/08/2014.
//  Copyright (c) 2014 Richard Lord. All rights reserved.
//

#import "MPInterstitialCustomEvent.h"

#import <VidCoin/VidCoin.h>

@interface VidCoinInterstitialCustomEvent : MPInterstitialCustomEvent <VidCoinDelegate>
    @property (nonatomic, copy) NSString* gameID;
    @property (nonatomic, copy) NSString* placementCode;
@end
