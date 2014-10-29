//
//  VidCoinInterstitialCustomEvent.m
//  MoPubIosExtension
//
//  Created by Matthieu Kern on 18/08/2014.
//  Copyright (c) 2014 Richard Lord. All rights reserved.
//

#import "VidCoinInterstitialCustomEvent.h"
#import "MPLogging.h"
#import "MoPubInterstitial.h"

/*
 * This adapter needs that you set some parameters in the MoPub web interface. Create a network
 * withe the "Custom Native Network" type, place "VidCoinInterstitialCustomEvent" in the "Custom
 * Class" colunm, and add this JSON in the "Custom Class Data":
 *     {"VidCoinGameID": "Your game ID", "VidCoinPlacementCode": "The ad placement code"}
 */

static BOOL isInitialized = false;

@implementation VidCoinInterstitialCustomEvent

#pragma mark - MPInterstitialCustomEvent Subclass Methods

- (void)requestInterstitialWithCustomEventInfo:(NSDictionary *)info {
    if (isInitialized == false) {
        if ([info objectForKey:@"VidCoinGameID"]) {
            self.gameID = [info objectForKey:@"VidCoinGameID"];
            NSLog(@"Setting the VidCoinGameID.");
        } else {
            NSLog(@"No VidCoinGameID to set, aborting...");
            [self.delegate interstitialCustomEvent:self didFailToLoadAdWithError:nil];
            return ;
        }
        
        NSLog(@"Connecting to VidCoin...");
        [VidCoin startWithGameId: self.gameID];
        [VidCoin setLoggingEnabled: YES];
        isInitialized = true;
    }

    [VidCoin setDelegate: self];
    
    if ([info objectForKey:@"VidCoinPlacementCode"]) {
        self.placementCode = [info objectForKey:@"VidCoinPlacementCode"];
        NSLog(@"Setting the VidCoinPlacementCode.");
    } else {
        NSLog(@"No VidCoinPlacementCode to set, aborting...");
        [self.delegate interstitialCustomEvent:self didFailToLoadAdWithError:nil];
        return ;
    }
    
    if ([VidCoin videoIsAvailableForPlacement: self.placementCode] == YES) {
        NSLog(@"Ad available.");
        [self.delegate interstitialCustomEvent:self didLoadAd:nil];
    } else {
        NSLog(@"No ad available.");
        [self.delegate interstitialCustomEvent:self didFailToLoadAdWithError:nil];
    }
}
 
- (void)showInterstitialFromRootViewController:(UIViewController *)rootViewController {
    if (self.placementCode == NULL) {
        NSLog(@"VidCoinPlacementCode not set, aborting...");
        [self.delegate interstitialCustomEvent:self didFailToLoadAdWithError:nil];
        return ;
    }
    
    if ([VidCoin videoIsAvailableForPlacement: self.placementCode] == YES) {
        NSLog(@"A video is available.");
        [VidCoin playAdFromViewController: rootViewController forPlacement: self.placementCode animated:YES];
        [self.delegate interstitialCustomEventWillAppear:self];
    } else {
        NSLog(@"No video available...");
        [self.delegate interstitialCustomEvent:self didFailToLoadAdWithError:nil];
    }
}

#pragma mark - VidCoin Delegate

-(void)vidcoinCampaignsUpdate {
    NSLog(@"The VidCoin available videos have been updated.");
}

-(void)vidcoinViewWillAppear {
    NSLog(@"VidCoin video will appear...");
    [self.delegate interstitialCustomEventWillAppear: self];
    [self.delegate interstitialCustomEventDidAppear: self];
}

-(void)vidcoinViewDidDisappearWithViewInformation:(NSDictionary *)viewInfo {
    if ([[viewInfo objectForKey: @"statusCode"] integerValue] != VCStatusCodeSuccess) {
        NSLog(@"Something went wrong or the user cancelled the VidCoin video...");
        [MoPubInterstitial interstitialDidCancel:nil];
        return;
    }
    
    NSLog(@"VidCoin video disappear...");
    [self.delegate interstitialCustomEventWillDisappear: self];
    [self.delegate interstitialCustomEventDidDisappear: self];
}

-(void)vidcoinDidValidateView:(NSDictionary *)viewInfo {
    if ([[viewInfo objectForKey: @"statusCode"] integerValue] != VCStatusCodeSuccess) {
        NSLog(@"The server didn't validate the view.");
        return;
    }

    NSLog(@"VidCoin server validate the view.");
}

-(void)dealloc {
    self.gameID = nil;
    self.placementCode = nil;

    [super dealloc];
}

@end
