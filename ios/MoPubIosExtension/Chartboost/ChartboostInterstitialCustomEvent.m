//
//  ChartboostInterstitialCustomEvent.m
//  MoPub
//
//  Copyright (c) 2012 MoPub, Inc. All rights reserved.
//

#import "ChartboostInterstitialCustomEvent.h"
#import "MPInstanceProvider.h"
#import "MPLogging.h"

////////////////////////////////////////////////////////////////////////////////////////////////////

@interface MPChartboostRouter : NSObject <ChartboostDelegate>

@property (nonatomic, retain) NSMutableDictionary *events;
@property (nonatomic, retain) NSMutableSet *activeLocations;
@property (nonatomic, retain) Chartboost *chartboost;

+ (MPChartboostRouter *)sharedRouter;

- (void)cacheInterstitialForLocation:(NSString *)location forChartboostInterstitialCustomEvent:(ChartboostInterstitialCustomEvent *)event;
- (BOOL)hasCachedInterstitialForLocation:(NSString *)location;
- (void)showInterstitialForLocation:(NSString *)location;

- (void)setEvent:(ChartboostInterstitialCustomEvent *)event forLocation:(NSString *)location;
- (void)unregisterEvent:(ChartboostInterstitialCustomEvent *)event;

- (ChartboostInterstitialCustomEvent *)eventForLocation:(NSString *)location;
- (void)unregisterEventForLocation:(NSString *)location;

@end

////////////////////////////////////////////////////////////////////////////////////////////////////

@interface MPInstanceProvider (ChartboostInterstitials)
- (Chartboost *)buildChartboost;
- (MPChartboostRouter *)sharedMPCharboostRouter;
@end

@implementation MPInstanceProvider (ChartboostInterstitials)

- (Chartboost *)buildChartboost
{
    return [Chartboost sharedChartboost];
}

- (MPChartboostRouter *)sharedMPCharboostRouter
{
    return [self singletonForClass:[MPChartboostRouter class]
                          provider:^id{
                              return [[[MPChartboostRouter alloc] init] autorelease];
                          }];
}

@end

////////////////////////////////////////////////////////////////////////////////////////////////////

@interface ChartboostInterstitialCustomEvent ()

@property (nonatomic, retain) NSString *location;

@end

@implementation ChartboostInterstitialCustomEvent

@synthesize location = _location;

- (void)invalidate
{
    [[MPChartboostRouter sharedRouter] unregisterEvent:self];
    self.location = nil;
}

////////////////////////////////////////////////////////////////////////////////////////////////////

#pragma mark - MPInterstitialCustomEvent Subclass Methods

- (void)requestInterstitialWithCustomEventInfo:(NSDictionary *)info
{
    NSString *location = [info objectForKey:@"location"];
    self.location = location ? location : @"Default";

    MPLogInfo(@"Requesting Chartboost interstitial ad. Location: %@", self.location);
    [[MPChartboostRouter sharedRouter] cacheInterstitialForLocation:self.location forChartboostInterstitialCustomEvent:self];
}

- (void)showInterstitialFromRootViewController:(UIViewController *)rootViewController
{
    if ([[MPChartboostRouter sharedRouter] hasCachedInterstitialForLocation:self.location]) {
        MPLogInfo(@"Showing Chartboost interstitial ad. Location: %@", self.location);
        [self.delegate interstitialCustomEventWillAppear:self]; // -> Chartboost doesn't have a callback for that
        [[MPChartboostRouter sharedRouter] showInterstitialForLocation:self.location];
        [self.delegate interstitialCustomEventDidAppear:self]; // -> Chartboost doesn't have a callback for that
    }
    else {
        MPLogInfo(@"Failed to show Chartboost interstitial ad. Location: %@", self.location);
        [self.delegate interstitialCustomEvent:self didFailToLoadAdWithError:nil];
    }
}

////////////////////////////////////////////////////////////////////////////////////////////////////

#pragma mark - ChartboostDelegate

- (void)didCacheInterstitial:(NSString *)location
{
    MPLogInfo(@"Successfully loaded Chartboost interstitial. Location: %@", location);

    [self.delegate interstitialCustomEvent:self didLoadAd:nil];
}

- (void)didFailToLoadInterstitial:(NSString *)location withError:(CBLoadError)error
{
    MPLogInfo(@"Failed to load Chartboost interstitial. Location: %@", location);
    [self.delegate interstitialCustomEvent:self didFailToLoadAdWithError:nil];
}

- (void)didDismissInterstitial:(NSString *)location
{
    MPLogInfo(@"Chartboost interstitial was dismissed. Location: %@", location);

    // Chartboost doesn't seem to have a separate callback for the "will disappear" event, so we
    // signal "will disappear" manually.

    [self.delegate interstitialCustomEventWillDisappear:self];
    [self.delegate interstitialCustomEventDidDisappear:self];
}

- (void)didClickInterstitial:(NSString *)location
{
    MPLogInfo(@"Chartboost interstitial was clicked. Location: %@", location);
    [self.delegate interstitialCustomEventDidReceiveTapEvent:self];
}



@end

////////////////////////////////////////////////////////////////////////////////////////////////////

/*
 * Chartboost only provides a shared instance, so only one object may be the Chartboost delegate at
 * any given time. However, because it is common to request Chartboost interstitials for separate
 * "locations" in a single app session, we may have multiple instances of our custom event class,
 * all of which are interested in delegate callbacks.
 *
 * MPChartboostRouter is a singleton that is always the Chartboost delegate, and dispatches
 * events to all of the custom event instances.
 */

@implementation MPChartboostRouter

@synthesize events = _events;
@synthesize activeLocations = _activeLocations;
@synthesize chartboost = _chartboost;

+ (MPChartboostRouter *)sharedRouter
{
    return [[MPInstanceProvider sharedProvider] sharedMPCharboostRouter];
}

- (id)init
{
    self = [super init];
    if (self) {
        self.events = [NSMutableDictionary dictionary];

        /*
         * We need the activeLocations set to keep track of locations that are currently being
         * cached/ready to show/visible on screen.
         * It is *not* enough to just use the events dictionary.  The reason is that when a user
         * taps a Chartboost interstitial.  Chartboost calls didDismissInterstitial *before* it calls
         * didClickInterstitial.  Since we *must* mark the location as available for reuse when
         * the interstitial is dismissed (e.g. the user simply closes it) the only way to allow
         * for click tracking, is to ensure that the event is still available after dismissal, but
         * is marked as free to be released.
         */
        self.activeLocations = [NSMutableSet set];

        self.chartboost = [[MPInstanceProvider sharedProvider] buildChartboost];
        self.chartboost.delegate = self;
    }
    return self;
}

- (void)dealloc
{
    self.chartboost = nil;
    self.events = nil;
    self.activeLocations = nil;
    [super dealloc];
}


#pragma mark - Fetch and show ads

- (void)cacheInterstitialForLocation:(NSString *)location forChartboostInterstitialCustomEvent:(ChartboostInterstitialCustomEvent *)event
{
    if ([self.activeLocations containsObject:location]) {
        MPLogInfo(@"Failed to load Chartboost interstitial: location %@ is already in use.", location);
        [event didFailToLoadInterstitial:location withError:CBLoadErrorInternal];
        return;
    }
    
    [self setEvent:event forLocation:location];
    [self.chartboost cacheInterstitial:location];
}

- (BOOL)hasCachedInterstitialForLocation:(NSString *)location
{
    return [self.chartboost hasCachedInterstitial:location];
}

- (void)showInterstitialForLocation:(NSString *)location
{
    [self.chartboost showInterstitial:location];
}


#pragma mark - Router events

- (void)setEvent:(ChartboostInterstitialCustomEvent *)event forLocation:(NSString *)location
{
    [self.events setObject:event forKey:location];
    [self.activeLocations addObject:location];
}

- (void)unregisterEvent:(ChartboostInterstitialCustomEvent *)event
{
    if ([[self.events objectForKey:event.location] isEqual:event]) {
        [self unregisterEventForLocation:event.location];
    }
}

- (ChartboostInterstitialCustomEvent *)eventForLocation:(NSString *)location
{
    return [self.events objectForKey:location];
}


- (void)unregisterEventForLocation:(NSString *)location
{
    [self.activeLocations removeObject:location];
}



- (void)didCacheInterstitial:(NSString *)location
{
    [[self eventForLocation:location] didCacheInterstitial:location];
}

- (void)didFailToLoadInterstitial:(NSString *)location withError:(CBLoadError)error
{
    [[self eventForLocation:location] didFailToLoadInterstitial:location withError:CBLoadErrorInternal];
    [self unregisterEventForLocation:location];
}

- (void)didDismissInterstitial:(NSString *)location
{
    [[self eventForLocation:location] didDismissInterstitial:location];
    [self unregisterEventForLocation:location];
}

- (void)didClickInterstitial:(NSString *)location
{
    [[self eventForLocation:location] didClickInterstitial:location];
}

@end

