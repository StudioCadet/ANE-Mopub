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
    
    NSString *conversionId = [[NSBundle mainBundle] objectForInfoDictionaryKey:@"ADMOB_CONVERSION_ID"];
    NSString *label = [[NSBundle mainBundle] objectForInfoDictionaryKey:@"ADMOB_CONVERSION_LABEL"];
    NSString *value = [[NSBundle mainBundle] objectForInfoDictionaryKey:@"ADMOB_CONVERSION_VALUE"];

    [ACTAutomatedUsageTracker disableAutomatedUsageReportingWithConversionID:conversionId];
    [ACTConversionReporter reportWithConversionID:conversionId label:label value:value isRepeatable:NO];
}

@end
