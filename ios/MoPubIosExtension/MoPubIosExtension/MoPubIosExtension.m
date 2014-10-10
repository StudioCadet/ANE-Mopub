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
#import "InMobi.h"
#if __IPHONE_OS_VERSION_MAX_ALLOWED >= MP_IOS_6_0
#import <AdSupport/AdSupport.h>
#endif

#define DEFINE_ANE_FUNCTION(fn) FREObject (fn)(FREContext context, void* functionData, uint32_t argc, FREObject argv[])

#define MAP_FUNCTION(fn, data) { (const uint8_t*)(#fn), (data), &(fn) }

MoPub_TypeConversion* mopubConverter;

<<<<<<< HEAD
DEFINE_ANE_FUNCTION( mopub_getAppleIDFA )
{
	if (NSClassFromString(@"ASIdentifierManager")) {
#if __IPHONE_OS_VERSION_MAX_ALLOWED >= MP_IOS_6_0
        NSString *idfa =[[ASIdentifierManager sharedManager].advertisingIdentifier UUIDString];
        
        FREObject returnedObject;
        if( [mopubConverter FREGetString:idfa asObject:&returnedObject] == FRE_OK )
        {
            return returnedObject;
        }
#endif
    }
	
	return NULL;
}

=======
>>>>>>> parent of 9b7b579... Revert "Added mobvious support"
DEFINE_ANE_FUNCTION( mopub_getAdScaleFactor )
{
    double scale = [UIScreen mainScreen].scale;
    FREObject asScale;
    if( [mopubConverter FREGetDouble:scale asObject:&asScale] == FRE_OK )
    {
        return asScale;
    }
    return NULL;
}

DEFINE_ANE_FUNCTION( mopub_getNativeScreenWidth )
{
    double width = [UIScreen mainScreen].bounds.size.width * [UIScreen mainScreen].scale;
    FREObject asWidth;
    if( [mopubConverter FREGetDouble:width asObject:&asWidth] == FRE_OK )
    {
        return asWidth;
    }
    return NULL;
}

DEFINE_ANE_FUNCTION( mopub_getNativeScreenHeight )
{
    double height = [UIScreen mainScreen].bounds.size.height * [UIScreen mainScreen].scale;
    FREObject asHeight;
    if( [mopubConverter FREGetDouble:height asObject:&asHeight] == FRE_OK )
    {
        return asHeight;
    }
    return NULL;
}

DEFINE_ANE_FUNCTION( mopub_initialiseBanner )
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

DEFINE_ANE_FUNCTION( mopub_setAutorefresh )
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

DEFINE_ANE_FUNCTION( mopub_setTestMode )
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

DEFINE_ANE_FUNCTION( mopub_setAdUnitId )
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

DEFINE_ANE_FUNCTION( mopub_lockNativeAdsToOrientation )
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

DEFINE_ANE_FUNCTION( mopub_getPositionX )
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

DEFINE_ANE_FUNCTION( mopub_getPositionY )
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

DEFINE_ANE_FUNCTION( mopub_getWidth )
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

DEFINE_ANE_FUNCTION( mopub_getHeight )
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

DEFINE_ANE_FUNCTION( mopub_setPositionX )
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

DEFINE_ANE_FUNCTION( mopub_setPositionY )
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

DEFINE_ANE_FUNCTION( mopub_setWidth )
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

DEFINE_ANE_FUNCTION( mopub_setHeight )
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

DEFINE_ANE_FUNCTION( mopub_setSize )
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

DEFINE_ANE_FUNCTION( mopub_getCreativeWidth )
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

DEFINE_ANE_FUNCTION( mopub_getCreativeHeight )
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

DEFINE_ANE_FUNCTION(mopub_setBannerKeywords)
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

DEFINE_ANE_FUNCTION( mopub_loadBanner )
{
    MoPubBanner* banner;
    FREGetContextNativeData( context, (void**)&banner );
    if( banner != nil )
    {
        [banner loadBanner];
    }
    return NULL;
}

DEFINE_ANE_FUNCTION( mopub_showBanner )
{
    MoPubBanner* banner;
    FREGetContextNativeData( context, (void**)&banner );
    if( banner != nil )
    {
        [banner showBanner];
    }
    return NULL;
}

DEFINE_ANE_FUNCTION( mopub_removeBanner )
{
    MoPubBanner* banner;
    FREGetContextNativeData( context, (void**)&banner );
    if( banner != nil )
    {
        [banner removeBanner];
    }
    return NULL;
}

DEFINE_ANE_FUNCTION( mopub_initialiseInterstitial )
{
    NSString* adUnitId;
    if( [mopubConverter FREGetObject:argv[0] asString:&adUnitId] != FRE_OK ) return NULL;
    
    MoPubInterstitial* interstitial = [[MoPubInterstitial alloc] initWithContext:context adUnitId:adUnitId];
    [interstitial retain];
    FRESetContextNativeData( context, interstitial );
    return NULL;
}

DEFINE_ANE_FUNCTION( mopub_setInterstitialTestMode )
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

DEFINE_ANE_FUNCTION( mopub_getInterstitialReady )
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

DEFINE_ANE_FUNCTION( mopub_setInterstitialKeywords )
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

DEFINE_ANE_FUNCTION( mopub_loadInterstitial )
{
    MoPubInterstitial* interstitial;
    FREGetContextNativeData( context, (void**)&interstitial );
    if( interstitial != nil )
    {        
        [interstitial loadInterstitial];
    }
    return NULL;
}

DEFINE_ANE_FUNCTION( mopub_showInterstitial )
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

DEFINE_ANE_FUNCTION( mopub_disposeBanner )
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

DEFINE_ANE_FUNCTION( mopub_disposeInterstitial )
{
    MoPubInterstitial* interstitial;
    FREGetContextNativeData( context, (void**)&interstitial );
    if( interstitial != nil )
    {
        [interstitial release];
    }
    
    return NULL;
}

DEFINE_ANE_FUNCTION( mopub_trackConversion )
{
    NSString *itunesAppId = [[NSBundle mainBundle] objectForInfoDictionaryKey:@"itunesAppId"];
    
    [[MPAdConversionTracker sharedConversionTracker] reportApplicationOpenForApplicationID:itunesAppId];
    
    return NULL;
}

DEFINE_ANE_FUNCTION( mopub_init )
{
    NSLog(@"Initializing MoPub extension ...");
    
    // InMobi :
    NSString *inMobiPropertyId = [[NSBundle mainBundle] objectForInfoDictionaryKey:@"IN_MOBI_PROPERTY_ID"];
    if(inMobiPropertyId == NULL) {
        NSLog(@"Your app descriptor is missing the required parameters \"IN_MOBI_PROPERTY_ID\".");
    }
    else {
        NSLog(@"Initializing InMobi SDK with property ID %@", inMobiPropertyId);
        [InMobi initialize:inMobiPropertyId];
        NSLog(@"InMobi initialized successfully.");
    }
    
    NSLog(@"MoPub extension initialized.");
    
    return NULL;
}


void MoPubContextInitializer( void* extData, const uint8_t* ctxType, FREContext ctx, uint32_t* numFunctionsToSet, const FRENamedFunction** functionsToSet )
{
    if( strcmp( ctxType, "mopub" ) == 0 )
    {
        static FRENamedFunction mopubFunctionMap[] =
        {
<<<<<<< HEAD
            MAP_FUNCTION( mopub_getAppleIDFA, NULL ),
            
=======
>>>>>>> parent of 9b7b579... Revert "Added mobvious support"
            MAP_FUNCTION( mopub_getAdScaleFactor, NULL ),
            
            MAP_FUNCTION( mopub_getNativeScreenWidth, NULL ),
            MAP_FUNCTION( mopub_getNativeScreenHeight, NULL ),
            
<<<<<<< HEAD
            MAP_FUNCTION( mopub_trackConversion, NULL ),
            MAP_FUNCTION( mopub_init, NULL )
=======
            MAP_FUNCTION( mopub_trackConversion, NULL )
>>>>>>> parent of 9b7b579... Revert "Added mobvious support"
        };
        
        *numFunctionsToSet = sizeof( mopubFunctionMap ) / sizeof( FRENamedFunction );
        *functionsToSet = mopubFunctionMap;
    }
    else if( strcmp( ctxType, "interstitial" ) == 0 )
    {
        static FRENamedFunction interstitialFunctionMap[] =
        {
            MAP_FUNCTION( mopub_initialiseInterstitial, NULL ),
            
            MAP_FUNCTION( mopub_setInterstitialTestMode, NULL ),
            MAP_FUNCTION( mopub_getInterstitialReady, NULL ),
            
            MAP_FUNCTION( mopub_loadInterstitial, NULL ),
            MAP_FUNCTION( mopub_showInterstitial, NULL ),
            
            MAP_FUNCTION( mopub_setInterstitialKeywords, NULL ),
            
            MAP_FUNCTION( mopub_disposeInterstitial, NULL)
        };
        
        *numFunctionsToSet = sizeof( interstitialFunctionMap ) / sizeof( FRENamedFunction );
        *functionsToSet = interstitialFunctionMap;
    }
    else
    {
        static FRENamedFunction bannerFunctionMap[] =
        {
            MAP_FUNCTION( mopub_initialiseBanner, NULL ),
            
            MAP_FUNCTION( mopub_setAdUnitId, NULL ),
            MAP_FUNCTION( mopub_setAutorefresh, NULL ),
            MAP_FUNCTION( mopub_setTestMode, NULL ),
            MAP_FUNCTION( mopub_lockNativeAdsToOrientation, NULL ),
            
            MAP_FUNCTION( mopub_getPositionX, NULL ),
            MAP_FUNCTION( mopub_setPositionX, NULL ),
            MAP_FUNCTION( mopub_getPositionY, NULL ),
            MAP_FUNCTION( mopub_setPositionY, NULL ),
            MAP_FUNCTION( mopub_getWidth, NULL ),
            MAP_FUNCTION( mopub_setWidth, NULL ),
            MAP_FUNCTION( mopub_getHeight, NULL ),
            MAP_FUNCTION( mopub_setHeight, NULL ),
            
            MAP_FUNCTION( mopub_setSize, NULL ),
            MAP_FUNCTION( mopub_getCreativeWidth, NULL ),
            MAP_FUNCTION( mopub_getCreativeHeight, NULL ),
            
            MAP_FUNCTION( mopub_loadBanner, NULL ),
            MAP_FUNCTION( mopub_showBanner, NULL ),
            MAP_FUNCTION( mopub_removeBanner, NULL ),
            
            MAP_FUNCTION( mopub_setBannerKeywords, NULL ),
            
            MAP_FUNCTION( mopub_disposeBanner, NULL)
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