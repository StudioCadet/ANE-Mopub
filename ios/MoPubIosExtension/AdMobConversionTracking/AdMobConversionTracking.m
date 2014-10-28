//
//  AdMobConversionTracking.m
//  MoPubIosExtension
//
//  Created by Matthieu Kern on 22/10/2014.
//  Copyright (c) 2014 Richard Lord. All rights reserved.
//

#import "AdMobConversionTracking.h"

@implementation AdMobConversionTracking

+(void)trackConversion {
    NSLog(@"Tracking AdMob install if needed...");
    [ACTConversionReporter reportWithConversionID:@"995500816" label:@"_HMJCliw1AgQkMbY2gM" value:@"0.60" isRepeatable:NO];
}

@end
