//
//  MoPubIosExtension.m
//  MoPubIosExtension
//
//  Created by Richard Lord on 23/10/2012.
//  Copyright (c) 2012 Richard Lord. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FlashRuntimeExtensions.h"
#import "MoPubTypeConversion.h"
#import "MoPubBanner.h"
#import "MoPubInterstitial.h"
#import "MPAdConversionTracker.h"

#define DEFINE_ANE_FUNCTION(fn) FREObject (fn)(FREContext context, void* functionData, uint32_t argc, FREObject argv[])

#define MAP_FUNCTION(fn, data) { (const uint8_t*)(#fn), (data), &(fn) }

MoPub_TypeConversion* mopubConverter;

DEFINE_ANE_FUNCTION( getAdScaleFactor )
{
    double scale = [UIScreen mainScreen].scale;
    FREObject asScale;
    if( [mopubConverter FREGetDouble:scale asObject:&asScale] == FRE_OK )
    {
        return asScale;
    }
    return NULL;
}

DEFINE_ANE_FUNCTION( getNativeScreenWidth )
{
    double width = [UIScreen mainScreen].bounds.size.width * [UIScreen mainScreen].scale;
    FREObject asWidth;
    if( [mopubConverter FREGetDouble:width asObject:&asWidth] == FRE_OK )
    {
        return asWidth;
    }
    return NULL;
}

DEFINE_ANE_FUNCTION( getNativeScreenHeight )
{
    double height = [UIScreen mainScreen].bounds.size.height * [UIScreen mainScreen].scale;
    FREObject asHeight;
    if( [mopubConverter FREGetDouble:height asObject:&asHeight] == FRE_OK )
    {
        return asHeight;
    }
    return NULL;
}

DEFINE_ANE_FUNCTION( initialiseBanner )
{
    NSString* adUnitId;
    if( [mopubConverter FREGetObject:argv[0] asString:&adUnitId] != FRE_OK ) return NULL;
    
    CGSize adType;
    int32_t sizeId;
    if( [mopubConverter FREGetObject:argv[1] asInt:&sizeId] == FRE_OK )
    {
        adType = [MoPubBanner getAdSizeFromSizeId:sizeId];
    }
    else
    {
        adType = MOPUB_BANNER_SIZE;
    }
    
    MoPubBanner* banner = [[MoPubBanner alloc] initWithContext:context adUnitId:adUnitId size:adType];
    [banner retain];
    FRESetContextNativeData( context, banner );
    return NULL;
}

DEFINE_ANE_FUNCTION( setAutorefresh )
{
    MoPubBanner* banner;
    FREGetContextNativeData( context, (void**)&banner );
    if( banner != nil )
    {
        uint32_t autoRefresh;
        if( [mopubConverter FREGetObject:argv[0] asBoolean:&autoRefresh] != FRE_OK ) return NULL;
        [banner setAutorefresh:( autoRefresh == 1 )];
    }
    return NULL;
}

DEFINE_ANE_FUNCTION( setTestMode )
{
    MoPubBanner* banner;
    FREGetContextNativeData( context, (void**)&banner );
    if( banner != nil )
    {
        uint32_t testing;
        if( [mopubConverter FREGetObject:argv[0] asBoolean:&testing] != FRE_OK ) return NULL;
        banner.testing = ( testing == 1 );
    }
    return NULL;
}

DEFINE_ANE_FUNCTION( setAdUnitId )
{
    MoPubBanner* banner;
    FREGetContextNativeData( context, (void**)&banner );
    if( banner != nil )
    {
        NSString* adUnitId;
        if( [mopubConverter FREGetObject:argv[0] asString:&adUnitId] != FRE_OK ) return NULL;
        [banner setAdUnitId:adUnitId];
    }
    return NULL;
}

DEFINE_ANE_FUNCTION( lockNativeAdsToOrientation )
{
    MoPubBanner* banner;
    FREGetContextNativeData( context, (void**)&banner );
    if( banner != nil )
    {
        int32_t orientation;
        if( [mopubConverter FREGetObject:argv[0] asInt:&orientation] != FRE_OK ) return NULL;
        switch( orientation )
        {
            case 0:
                [banner lockNativeAdsToOrientation:MPNativeAdOrientationAny];
                break;
            case 1:
                [banner lockNativeAdsToOrientation:MPNativeAdOrientationPortrait];
                break;
            case 2:
                [banner lockNativeAdsToOrientation:MPNativeAdOrientationLandscape];
                break;
        }
    }
    return NULL;
}

DEFINE_ANE_FUNCTION( getPositionX )
{
    MoPubBanner* banner;
    FREGetContextNativeData( context, (void**)&banner );
    if( banner != nil )
    {
        int32_t pos = [banner getPositionX];
        FREObject asPos;
        if( [mopubConverter FREGetInt:pos asObject:&asPos] == FRE_OK )
        {
            return asPos;
        }
    }
    return NULL;
}

DEFINE_ANE_FUNCTION( getPositionY )
{
    MoPubBanner* banner;
    FREGetContextNativeData( context, (void**)&banner );
    if( banner != nil )
    {
        int32_t pos = [banner getPositionY];
        FREObject asPos;
        if( [mopubConverter FREGetInt:pos asObject:&asPos] == FRE_OK )
        {
            return asPos;
        }
    }
    return NULL;
}

DEFINE_ANE_FUNCTION( getWidth )
{
    MoPubBanner* banner;
    FREGetContextNativeData( context, (void**)&banner );
    if( banner != nil )
    {
        int32_t width = [banner getFrameWidth];
        FREObject asWidth;
        if( [mopubConverter FREGetInt:width asObject:&asWidth] == FRE_OK )
        {
            return asWidth;
        }
    }
    return NULL;
}

DEFINE_ANE_FUNCTION( getHeight )
{
    MoPubBanner* banner;
    FREGetContextNativeData( context, (void**)&banner );
    if( banner != nil )
    {
        int32_t height = [banner getFrameHeight];
        FREObject asHeight;
        if( [mopubConverter FREGetInt:height asObject:&asHeight] == FRE_OK )
        {
            return asHeight;
        }
    }
    return NULL;
}

DEFINE_ANE_FUNCTION( setPositionX )
{
    MoPubBanner* banner;
    FREGetContextNativeData( context, (void**)&banner );
    if( banner != nil )
    {
        int32_t posX;
        if( [mopubConverter FREGetObject:argv[0] asInt:&posX] != FRE_OK ) return NULL;
        [banner setPositionX:posX];
    }
    return NULL;
}

DEFINE_ANE_FUNCTION( setPositionY )
{
    MoPubBanner* banner;
    FREGetContextNativeData( context, (void**)&banner );
    if( banner != nil )
    {
        int32_t posY;
        if( [mopubConverter FREGetObject:argv[0] asInt:&posY] != FRE_OK ) return NULL;
        [banner setPositionY:posY];
    }
    return NULL;
}

DEFINE_ANE_FUNCTION( setWidth )
{
    MoPubBanner* banner;
    FREGetContextNativeData( context, (void**)&banner );
    if( banner != nil )
    {
        int32_t width;
        if( [mopubConverter FREGetObject:argv[0] asInt:&width] != FRE_OK ) return NULL;
        [banner setFrameWidth:width];
    }
    return NULL;
}

DEFINE_ANE_FUNCTION( setHeight )
{
    MoPubBanner* banner;
    FREGetContextNativeData( context, (void**)&banner );
    if( banner != nil )
    {
        int32_t height;
        if( [mopubConverter FREGetObject:argv[0] asInt:&height] != FRE_OK ) return NULL;
        [banner setFrameHeight:height];
    }
    return NULL;
}

DEFINE_ANE_FUNCTION( setSize )
{
    MoPubBanner* banner;
    FREGetContextNativeData( context, (void**)&banner );
    if( banner != nil )
    {
        int32_t size;
        if( [mopubConverter FREGetObject:argv[0] asInt:&size] != FRE_OK ) return NULL;
        [banner setAdSize:size];
    }
    return NULL;
}

DEFINE_ANE_FUNCTION( getCreativeWidth )
{
    MoPubBanner* banner;
    FREGetContextNativeData( context, (void**)&banner );
    if( banner != nil )
    {
        int32_t width = [banner getCreativeWidth];
        FREObject asWidth;
        if( [mopubConverter FREGetInt:width asObject:&asWidth] == FRE_OK )
        {
            return asWidth;
        }
    }
    return NULL;
}

DEFINE_ANE_FUNCTION( getCreativeHeight )
{
    MoPubBanner* banner;
    FREGetContextNativeData( context, (void**)&banner );
    if( banner != nil )
    {
        int32_t height = [banner getCreativeHeight];
        FREObject asHeight;
        if( [mopubConverter FREGetInt:height asObject:&asHeight] == FRE_OK )
        {
            return asHeight;
        }
    }
    return NULL;
}

DEFINE_ANE_FUNCTION(setBannerKeywords)
{
    MoPubBanner* banner;
    FREGetContextNativeData( context, (void**)&banner );
    
    if( banner != nil )
    {
        NSString* keywords;
        if( [mopubConverter FREGetObject:argv[0] asString:&keywords] != FRE_OK ) return NULL;
        [banner setKeywords:keywords];
    }
    
    return NULL;
}

DEFINE_ANE_FUNCTION( loadBanner )
{
    MoPubBanner* banner;
    FREGetContextNativeData( context, (void**)&banner );
    if( banner != nil )
    {
        [banner loadBanner];
    }
    return NULL;
}

DEFINE_ANE_FUNCTION( showBanner )
{
    MoPubBanner* banner;
    FREGetContextNativeData( context, (void**)&banner );
    if( banner != nil )
    {
        [banner showBanner];
    }
    return NULL;
}

DEFINE_ANE_FUNCTION( removeBanner )
{
    MoPubBanner* banner;
    FREGetContextNativeData( context, (void**)&banner );
    if( banner != nil )
    {
        [banner removeBanner];
    }
    return NULL;
}

DEFINE_ANE_FUNCTION( initialiseInterstitial )
{
    NSString* adUnitId;
    if( [mopubConverter FREGetObject:argv[0] asString:&adUnitId] != FRE_OK ) return NULL;
    
    MoPubInterstitial* interstitial = [[MoPubInterstitial alloc] initWithContext:context adUnitId:adUnitId];
    [interstitial retain];
    FRESetContextNativeData( context, interstitial );
    return NULL;
}

DEFINE_ANE_FUNCTION( setInterstitialTestMode )
{
    MoPubInterstitial* interstitial;
    FREGetContextNativeData( context, (void**)&interstitial );
    if( interstitial != nil )
    {
        uint32_t testing;
        if( [mopubConverter FREGetObject:argv[0] asBoolean:&testing] != FRE_OK ) return NULL;
        interstitial.testing = ( testing == 1 );
    }
    return NULL;
}

DEFINE_ANE_FUNCTION( getInterstitialReady )
{
    MoPubInterstitial* interstitial;
    FREGetContextNativeData( context, (void**)&interstitial );
    if( interstitial != nil )
    {
        BOOL ready = [interstitial getIsReady];
        FREObject asReady;
        if( [mopubConverter FREGetBool:ready asObject:&asReady] == FRE_OK )
        {
            return asReady;
        }
    }
    return NULL;
}

DEFINE_ANE_FUNCTION( setInterstitialKeywords )
{
    MoPubInterstitial* interstitial;
    FREGetContextNativeData( context, (void**)&interstitial );
    if( interstitial != nil )
    {
        NSString* keywords;
        if( [mopubConverter FREGetObject:argv[0] asString:&keywords] != FRE_OK ) return NULL;
        [interstitial setKeywords:keywords];
    }
    
    return NULL;
}

DEFINE_ANE_FUNCTION( loadInterstitial )
{
    MoPubInterstitial* interstitial;
    FREGetContextNativeData( context, (void**)&interstitial );
    if( interstitial != nil )
    {        
        [interstitial loadInterstitial];
    }
    return NULL;
}

DEFINE_ANE_FUNCTION( showInterstitial )
{
    MoPubInterstitial* interstitial;
    FREGetContextNativeData( context, (void**)&interstitial );
    if( interstitial != nil )
    {
        BOOL success = [interstitial showInterstitial];
        FREObject asSuccess;
        if( [mopubConverter FREGetBool:success asObject:&asSuccess] == FRE_OK )
        {
            return asSuccess;
        }
    }

    return NULL;
}

DEFINE_ANE_FUNCTION( disposeBanner )
{
    MoPubBanner* banner;
    FREGetContextNativeData( context, (void**)&banner );
    if( banner != nil )
    {
        NSLog(@"Disposing banner...");
        [banner removeFromSuperview];
        [banner release];
    }
    
    return NULL;
}

DEFINE_ANE_FUNCTION( disposeInterstitial )
{
    MoPubInterstitial* interstitial;
    FREGetContextNativeData( context, (void**)&interstitial );
    if( interstitial != nil )
    {
        [interstitial release];
    }
    
    return NULL;
}

DEFINE_ANE_FUNCTION( trackConversion )
{
    NSString *itunesAppId = [[NSBundle mainBundle] objectForInfoDictionaryKey:@"itunesAppId"];
    
    [[MPAdConversionTracker sharedConversionTracker] reportApplicationOpenForApplicationID:itunesAppId];
    
    return NULL;
}

void MoPubContextInitializer( void* extData, const uint8_t* ctxType, FREContext ctx, uint32_t* numFunctionsToSet, const FRENamedFunction** functionsToSet )
{
    if( strcmp( ctxType, "mopub" ) == 0 )
    {
        static FRENamedFunction mopubFunctionMap[] =
        {
            MAP_FUNCTION( getAdScaleFactor, NULL ),
            
            MAP_FUNCTION( getNativeScreenWidth, NULL ),
            MAP_FUNCTION( getNativeScreenHeight, NULL ),
            
            MAP_FUNCTION( trackConversion, NULL )
        };
        
        *numFunctionsToSet = sizeof( mopubFunctionMap ) / sizeof( FRENamedFunction );
        *functionsToSet = mopubFunctionMap;
    }
    else if( strcmp( ctxType, "interstitial" ) == 0 )
    {
        static FRENamedFunction interstitialFunctionMap[] =
        {
            MAP_FUNCTION( initialiseInterstitial, NULL ),
            
            MAP_FUNCTION( setInterstitialTestMode, NULL ),
            MAP_FUNCTION( getInterstitialReady, NULL ),
            
            MAP_FUNCTION( loadInterstitial, NULL ),
            MAP_FUNCTION( showInterstitial, NULL ),
            
            MAP_FUNCTION( setInterstitialKeywords, NULL ),
            
            MAP_FUNCTION( disposeInterstitial, NULL)
        };
        
        *numFunctionsToSet = sizeof( interstitialFunctionMap ) / sizeof( FRENamedFunction );
        *functionsToSet = interstitialFunctionMap;
    }
    else
    {
        static FRENamedFunction bannerFunctionMap[] =
        {
            MAP_FUNCTION( initialiseBanner, NULL ),
            
            MAP_FUNCTION( setAdUnitId, NULL ),
            MAP_FUNCTION( setAutorefresh, NULL ),
            MAP_FUNCTION( setTestMode, NULL ),
            MAP_FUNCTION( lockNativeAdsToOrientation, NULL ),
            
            MAP_FUNCTION( getPositionX, NULL ),
            MAP_FUNCTION( setPositionX, NULL ),
            MAP_FUNCTION( getPositionY, NULL ),
            MAP_FUNCTION( setPositionY, NULL ),
            MAP_FUNCTION( getWidth, NULL ),
            MAP_FUNCTION( setWidth, NULL ),
            MAP_FUNCTION( getHeight, NULL ),
            MAP_FUNCTION( setHeight, NULL ),
            
            MAP_FUNCTION( setSize, NULL ),
            MAP_FUNCTION( getCreativeWidth, NULL ),
            MAP_FUNCTION( getCreativeHeight, NULL ),
            
            MAP_FUNCTION( loadBanner, NULL ),
            MAP_FUNCTION( showBanner, NULL ),
            MAP_FUNCTION( removeBanner, NULL ),
            
            MAP_FUNCTION( setBannerKeywords, NULL ),
            
            MAP_FUNCTION( disposeBanner, NULL)
        };
        
        *numFunctionsToSet = sizeof( bannerFunctionMap ) / sizeof( FRENamedFunction );
        *functionsToSet = bannerFunctionMap;
    }
}

void MoPubContextFinalizer( FREContext ctx )
{
    id banner;
    FREGetContextNativeData( ctx, (void**)&banner );
    if( banner != nil )
    {
        if( [banner isKindOfClass:[MoPubBanner class] ] )
        {
            [banner removeFromSuperview];
            [banner release];
        }
        else if( [banner isKindOfClass:[MoPubInterstitial class] ] )
        {
            [banner release];
        }
    }
	return;
}

void MoPubExtensionInitializer( void** extDataToSet, FREContextInitializer* ctxInitializerToSet, FREContextFinalizer* ctxFinalizerToSet )
{
    extDataToSet = NULL;
    *ctxInitializerToSet = &MoPubContextInitializer;
    *ctxFinalizerToSet = &MoPubContextFinalizer;
    
    mopubConverter = [[[MoPub_TypeConversion alloc] init] retain];
}

void MoPubExtensionFinalizer()
{
    [mopubConverter release];
    return;
}