//
//  MPNativeAd+Internal.m
//  MoPubSDK
//
//  Copyright (c) 2015 MoPub. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MPNativeAd+Internal.h"
#import "MPNativeView.h"

@implementation MPNativeAd (Internal)

@dynamic impressionTrackerURLs;
@dynamic clickTrackerURLs;
@dynamic creationDate;
@dynamic renderer;
@dynamic associatedView;

- (void)updateAdViewSize:(CGSize)size
{
    self.associatedView.frame = CGRectMake(0, 0, size.width, size.height);
}

@end
