//
//  NexageAdView.h
//  NexageSDK
//
//  Copyright 2013 Nexage Inc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

typedef enum 
{
    NexageTransitionRandom = 0, // default
    NexageTransitionFade,
    NexageTransitionSlideFromLeft,
    NexageTransitionSlideFromRight,
    NexageTransitionSlideFromTop,
    NexageTransitionSlideFromBottom,
    NexageTransitionMax = NexageTransitionSlideFromBottom
} NexageTransition;

/**
 * Nexage AdView
 */
@interface NexageAdView : UIView

@property (nonatomic, assign) BOOL enable;
@property (nonatomic, readonly, assign) BOOL hasAdLoaded;
@property (nonatomic, copy) NSString *position;

/**
 * Initialize NexageAdView with a frame (0,0, 320, 50).
 */
- (id)initWithPosition:(NSString *)position;
- (id)initWithPosition:(NSString *)position frame:(CGRect)frame;
- (id)initWithMediationPosition:(NSString *)position frame:(CGRect)frame;
- (void)rollover;

/**
 * Set this controller's frame.
 */
- (void)setFrame:(CGRect)frame;

/**
 * Get/Set the ad rotation interval seconds.
 */
- (NSInteger)intervalSeconds;
- (void)setIntervalTo:(NSInteger)seconds;
- (void)cancel;

@end

