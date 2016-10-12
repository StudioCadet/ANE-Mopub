//
//  MPMoPubNativeAdAdapter.h
//
//  Copyright (c) 2014 MoPub. All rights reserved.
//

#import "MPNativeAdAdapter.h"

@interface MPMoPubNativeAdAdapter : NSObject <MPNativeAdAdapter>

@property (nonatomic, weak) id<MPNativeAdAdapterDelegate> delegate;
@property (nonatomic, readonly) NSArray *impressionTrackerURLs;
@property (nonatomic, readonly) NSArray *clickTrackerURLs;

- (instancetype)initWithAdProperties:(NSMutableDictionary *)properties;

@end
