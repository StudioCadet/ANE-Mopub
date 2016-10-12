//
//  MoPubIosExtension.m
//  MoPubIosExtension
//
//  Created by Richard Lord on 23/10/2012.
//  Copyright (c) 2012 Richard Lord. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FlashRuntimeExtensions.h"
#import "MoPubKeywords.h"
#import "MoPubTypeConversion.h"
#import "MoPubBanner.h"
#import "MoPubInterstitial.h"
#import "MPAdConversionTracker.h"
#import "InMobi.h"
#import "MPChartboostRouter.h"
#import "SASAdView.h"
#if __IPHONE_OS_VERSION_MAX_ALLOWED >= MP_IOS_6_0
#import <AdSupport/AdSupport.h>
#endif


MoPub_TypeConversion* mopubConverter;


/////////////////////////////////////////////////////////////
// MOPUB

FREObject mopub_init(FREContext context, void* functionData, uint32_t argc, FREObject argv[])
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
    
    // Chartboost
    NSString *chartboostAppId = [[NSBundle mainBundle] objectForInfoDictionaryKey:@"CHARTBOOST_APP_ID"];
    NSString *chartboostAppSignature = [[NSBundle mainBundle] objectForInfoDictionaryKey:@"CHARTBOOST_APP_SIGNATURE"];

    if (chartboostAppId == nil || chartboostAppSignature == nil) {
        NSLog(@"Your app descriptor is missing on of the required parameters \"CHARTBOOST_APP_ID\" or \"CHARTBOOST_APP_SIGNATURE\".");
    } else {
        NSLog(@"Initializing Chartboost SDK with app id %@ and app signature %@", chartboostAppId, chartboostAppSignature);
        [[MPChartboostRouter sharedRouter] startWithAppId:chartboostAppId appSignature:chartboostAppSignature];
    }
    
    // SmartAdServer/Mobvious
    NSString *mobviousSiteId = [[NSBundle mainBundle] objectForInfoDictionaryKey:@"MOBVIOUS_SITE_ID"];
    NSString *mobviousBaseURL = [[NSBundle mainBundle] objectForInfoDictionaryKey:@"MOBVIOUS_BASE_URL"];
    
    if (mobviousSiteId == nil || mobviousBaseURL == nil) {
        NSLog(@"Your app descriptor is missing on of the required parameters \"MOBVIOUS_SITE_ID\" or \"MOBVIOUS_BASE_URL\".");
    } else {
        NSLog(@"Initializing SmartAdServer SDK with site ID %@ and base URL %@", mobviousSiteId, mobviousBaseURL);
        [SASAdView setSiteID:mobviousSiteId.integerValue baseURL:mobviousBaseURL];
    }
    NSLog(@"MoPub extension initialized.");
    
    return NULL;
}

FREObject mopub_trackConversion(FREContext context, void* functionData, uint32_t argc, FREObject argv[])
{
    NSString *itunesAppId = [[NSBundle mainBundle] objectForInfoDictionaryKey:@"itunesAppId"];
    
    [[MPAdConversionTracker sharedConversionTracker] reportApplicationOpenForApplicationID:itunesAppId];
    
    return NULL;
}

FREObject mopub_getAppleIDFA(FREContext context, void* functionData, uint32_t argc, FREObject argv[])
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

FREObject mopub_getAdScaleFactor(FREContext context, void* functionData, uint32_t argc, FREObject argv[])
{
    double scale = [UIScreen mainScreen].scale;
    FREObject asScale;
    if( [mopubConverter FREGetDouble:scale asObject:&asScale] == FRE_OK )
    {
        return asScale;
    }
    return NULL;
}

FREObject mopub_getNativeScreenWidth(FREContext context, void* functionData, uint32_t argc, FREObject argv[])
{
    double width = [UIScreen mainScreen].bounds.size.width * [UIScreen mainScreen].scale;
    FREObject asWidth;
    if( [mopubConverter FREGetDouble:width asObject:&asWidth] == FRE_OK )
    {
        return asWidth;
    }
    return NULL;
}

FREObject mopub_getNativeScreenHeight(FREContext context, void* functionData, uint32_t argc, FREObject argv[])
{
    double height = [UIScreen mainScreen].bounds.size.height * [UIScreen mainScreen].scale;
    FREObject asHeight;
    if( [mopubConverter FREGetDouble:height asObject:&asHeight] == FRE_OK )
    {
        return asHeight;
    }
    return NULL;
}

FREObject mopub_setKeywords(FREContext context, void* functionData, uint32_t argc, FREObject argv[])
{
    int age;
    double dateOfBirthTimestamp;
    NSString *gender = nil;
    NSString *language = nil;
    NSArray *additionalKeywordsKeys = nil;
    NSArray *additionalKeywordsValues = nil;
    NSString *inMobiInterests = nil;
    
    NSLog(@"Updating MoPub keywords ...");
    
    // Age :
    if([mopubConverter FREGetObject:argv[0] asInt:&age] == FRE_OK)
        [MoPubKeywords current].age = age;
    else
        [MoPubKeywords current].age = -1;
    NSLog(@"    - Age set to %i", [MoPubKeywords current].age);
    
    // Date of birth :
    if([mopubConverter FREGetObject:argv[1] asDouble:&dateOfBirthTimestamp] == FRE_OK)
        [MoPubKeywords current].dateOfBirth = [[NSDate alloc] initWithTimeIntervalSince1970:dateOfBirthTimestamp/1000];
    else
        [MoPubKeywords current].dateOfBirth = nil;
    NSLog(@"    - DateOfBirth set to %@", [MoPubKeywords current].dateOfBirth);
    
    // Gender :
    if([mopubConverter FREGetObject:argv[2] asString:&gender] == FRE_OK)
        [MoPubKeywords current].gender = gender;
    else
        [MoPubKeywords current].gender = nil;
    NSLog(@"    - Gender set to %@", [MoPubKeywords current].gender);
    
    // Language :
    if([mopubConverter FREGetObject:argv[3] asString:&language] == FRE_OK)
        [MoPubKeywords current].language = language;
    else
        [MoPubKeywords current].language = nil;
    NSLog(@"    - Language set to %@", [MoPubKeywords current].language);
    
    // Additional keywords :
    if([mopubConverter FREGetObject:argv[4] asStringArray:&additionalKeywordsKeys] == FRE_OK &&
       [mopubConverter FREGetObject:argv[5] asStringArray:&additionalKeywordsValues] == FRE_OK)
    {
        NSMutableDictionary *additionalKeywords = [[NSMutableDictionary alloc] init];
        for(int i = 0 ; i < additionalKeywordsKeys.count ; i++)
            [additionalKeywords setObject:additionalKeywordsValues[i] forKey:additionalKeywordsKeys[i]];
        [MoPubKeywords current].additionalKeywords = additionalKeywords;
    }
    else
        [MoPubKeywords current].additionalKeywords = nil;
    NSLog(@"    - Additional keywords : %@", [MoPubKeywords current].additionalKeywords);
    
    // InMobi interests :
    if([mopubConverter FREGetObject:argv[6] asString:&inMobiInterests] == FRE_OK)
        [MoPubKeywords current].inMobiInterests = inMobiInterests;
    else
        [MoPubKeywords current].inMobiInterests = nil;
    NSLog(@"    - InMobi interests set to %@", [MoPubKeywords current].inMobiInterests);
    
    NSLog(@"Keywords succesfuly retrieved.");
    
    
    // Setting InMobi targeting data :
    NSLog(@"Setting InMobi's targeting data ...");
    if([MoPubKeywords current].age > 0) {
        @try { [InMobi setAge:[MoPubKeywords current].age]; }
        @catch(NSException *e) { NSLog(@"    -> Failed to set InMobi age"); }
    }
    
    if([MoPubKeywords current].dateOfBirth != nil) {
        @try { [InMobi setDateOfBirth:[MoPubKeywords current].dateOfBirth]; }
        @catch(NSException *e) { NSLog(@"    -> Failed to set InMobi date of birth"); }
    }
    
    if([MoPubKeywords current].gender != nil) {
        @try { [InMobi setGender:
                [[MoPubKeywords current].gender isEqualToString:@"m"] ? kIMGenderMale :
                [[MoPubKeywords current].gender isEqualToString:@"f"] ? kIMGenderFemale : kIMGenderUnknown];
        }
        @catch(NSException *e) { NSLog(@"    -> Failed to set InMobi gender"); }
    }
    
    if([MoPubKeywords current].language != nil) {
        @try { [InMobi setLanguage:[MoPubKeywords current].language]; }
        @catch(NSException *e) { NSLog(@"    -> Failed to set InMobi language"); }
    }
    
    if([MoPubKeywords current].inMobiInterests != nil) {
        @try { [InMobi setInterests:[MoPubKeywords current].inMobiInterests]; }
        @catch(NSException *e) { NSLog(@"    -> Failed to set InMobi interests"); }
    }
    
    NSLog(@"InMobi targeting data set succesfully.");
    
    return NULL;
}



/////////////////////////////////////////////////////////////
// BANNER


FREObject mopub_initialiseBanner(FREContext context, void* functionData, uint32_t argc, FREObject argv[])
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
    FRESetContextNativeData( context, (void *) CFBridgingRetain(banner) );
    
    return NULL;
}

FREObject mopub_setAutorefresh(FREContext context, void* functionData, uint32_t argc, FREObject argv[])
{
    void *nativeData;
    FREGetContextNativeData( context, &nativeData );
    MoPubBanner* banner = (__bridge MoPubBanner *)nativeData;
    if( banner != nil )
    {
        uint32_t autoRefresh;
        if( [mopubConverter FREGetObject:argv[0] asBoolean:&autoRefresh] != FRE_OK ) return NULL;
        [banner setAutorefresh:( autoRefresh == 1 )];
    }
    return NULL;
}

FREObject mopub_setTestMode(FREContext context, void* functionData, uint32_t argc, FREObject argv[])
{
    void *nativeData;
    FREGetContextNativeData( context, &nativeData );
    MoPubBanner* banner = (__bridge MoPubBanner *)nativeData;
    if( banner != nil )
    {
        uint32_t testing;
        if( [mopubConverter FREGetObject:argv[0] asBoolean:&testing] != FRE_OK ) return NULL;
        banner.testing = ( testing == 1 );
    }
    return NULL;
}

FREObject mopub_setAdUnitId(FREContext context, void* functionData, uint32_t argc, FREObject argv[])
{
    void *nativeData;
    FREGetContextNativeData( context, &nativeData );
    MoPubBanner* banner = (__bridge MoPubBanner *)nativeData;
    if( banner != nil )
    {
        NSString* adUnitId;
        if( [mopubConverter FREGetObject:argv[0] asString:&adUnitId] != FRE_OK ) return NULL;
        [banner setAdUnitId:adUnitId];
    }
    return NULL;
}

FREObject mopub_lockNativeAdsToOrientation(FREContext context, void* functionData, uint32_t argc, FREObject argv[])
{
    void *nativeData;
    FREGetContextNativeData( context, &nativeData );
    MoPubBanner* banner = (__bridge MoPubBanner *)nativeData;
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

FREObject mopub_getPositionX(FREContext context, void* functionData, uint32_t argc, FREObject argv[])
{
    void *nativeData;
    FREGetContextNativeData( context, &nativeData );
    MoPubBanner* banner = (__bridge MoPubBanner *)nativeData;
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

FREObject mopub_getPositionY(FREContext context, void* functionData, uint32_t argc, FREObject argv[])
{
    void *nativeData;
    FREGetContextNativeData( context, &nativeData );
    MoPubBanner* banner = (__bridge MoPubBanner *)nativeData;
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

FREObject mopub_getWidth(FREContext context, void* functionData, uint32_t argc, FREObject argv[])
{
    void *nativeData;
    FREGetContextNativeData( context, &nativeData );
    MoPubBanner* banner = (__bridge MoPubBanner *)nativeData;
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

FREObject mopub_getHeight(FREContext context, void* functionData, uint32_t argc, FREObject argv[])
{
    void *nativeData;
    FREGetContextNativeData( context, &nativeData );
    MoPubBanner* banner = (__bridge MoPubBanner *)nativeData;
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

FREObject mopub_setPositionX(FREContext context, void* functionData, uint32_t argc, FREObject argv[])
{
    void *nativeData;
    FREGetContextNativeData( context, &nativeData );
    MoPubBanner* banner = (__bridge MoPubBanner *)nativeData;
    if( banner != nil )
    {
        int32_t posX;
        if( [mopubConverter FREGetObject:argv[0] asInt:&posX] != FRE_OK ) return NULL;
        [banner setPositionX:posX];
    }
    return NULL;
}

FREObject mopub_setPositionY(FREContext context, void* functionData, uint32_t argc, FREObject argv[])
{
    void *nativeData;
    FREGetContextNativeData( context, &nativeData );
    MoPubBanner* banner = (__bridge MoPubBanner *)nativeData;
    if( banner != nil )
    {
        int32_t posY;
        if( [mopubConverter FREGetObject:argv[0] asInt:&posY] != FRE_OK ) return NULL;
        [banner setPositionY:posY];
    }
    return NULL;
}

FREObject mopub_setWidth(FREContext context, void* functionData, uint32_t argc, FREObject argv[])
{
    void *nativeData;
    FREGetContextNativeData( context, &nativeData );
    MoPubBanner* banner = (__bridge MoPubBanner *)nativeData;
    if( banner != nil )
    {
        int32_t width;
        if( [mopubConverter FREGetObject:argv[0] asInt:&width] != FRE_OK ) return NULL;
        [banner setFrameWidth:width];
    }
    return NULL;
}

FREObject mopub_setHeight(FREContext context, void* functionData, uint32_t argc, FREObject argv[])
{
    void *nativeData;
    FREGetContextNativeData( context, &nativeData );
    MoPubBanner* banner = (__bridge MoPubBanner *)nativeData;
    if( banner != nil )
    {
        int32_t height;
        if( [mopubConverter FREGetObject:argv[0] asInt:&height] != FRE_OK ) return NULL;
        [banner setFrameHeight:height];
    }
    return NULL;
}

FREObject mopub_setSize(FREContext context, void* functionData, uint32_t argc, FREObject argv[])
{
    void *nativeData;
    FREGetContextNativeData( context, &nativeData );
    MoPubBanner* banner = (__bridge MoPubBanner *)nativeData;
    if( banner != nil )
    {
        int32_t size;
        if( [mopubConverter FREGetObject:argv[0] asInt:&size] != FRE_OK ) return NULL;
        [banner setAdSize:size];
    }
    return NULL;
}

FREObject mopub_getCreativeWidth(FREContext context, void* functionData, uint32_t argc, FREObject argv[])
{
    void *nativeData;
    FREGetContextNativeData( context, &nativeData );
    MoPubBanner* banner = (__bridge MoPubBanner *)nativeData;
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

FREObject mopub_getCreativeHeight(FREContext context, void* functionData, uint32_t argc, FREObject argv[])
{
    void *nativeData;
    FREGetContextNativeData( context, &nativeData );
    MoPubBanner* banner = (__bridge MoPubBanner *)nativeData;
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

FREObject mopub_loadBanner(FREContext context, void* functionData, uint32_t argc, FREObject argv[])
{
    void *nativeData;
    FREGetContextNativeData( context, &nativeData );
    MoPubBanner* banner = (__bridge MoPubBanner *)nativeData;
    if( banner != nil )
    {
        [banner loadBanner];
    }
    return NULL;
}

FREObject mopub_showBanner(FREContext context, void* functionData, uint32_t argc, FREObject argv[])
{
    void *nativeData;
    FREGetContextNativeData( context, &nativeData );
    MoPubBanner* banner = (__bridge MoPubBanner *)nativeData;
    if( banner != nil )
    {
        [banner showBanner];
    }
    return NULL;
}

FREObject mopub_removeBanner(FREContext context, void* functionData, uint32_t argc, FREObject argv[])
{
    void *nativeData;
    FREGetContextNativeData( context, &nativeData );
    MoPubBanner* banner = (__bridge MoPubBanner *)nativeData;
    if( banner != nil )
    {
        [banner removeBanner];
    }
    return NULL;
}

FREObject mopub_disposeBanner(FREContext context, void* functionData, uint32_t argc, FREObject argv[])
{
    void *nativeData;
    FREGetContextNativeData( context, &nativeData );
    MoPubBanner* banner = (MoPubBanner *) CFBridgingRelease(nativeData);
    if( banner != nil )
    {
        NSLog(@"Disposing banner...");
        [banner removeFromSuperview];
    }
    
    return NULL;
}



/////////////////////////////////////////////////////////////
// INTERSTITIAL


FREObject mopub_initialiseInterstitial(FREContext context, void* functionData, uint32_t argc, FREObject argv[])
{
    NSString* adUnitId;
    if( [mopubConverter FREGetObject:argv[0] asString:&adUnitId] != FRE_OK ) return NULL;
    
    MoPubInterstitial* interstitial = [[MoPubInterstitial alloc] initWithContext:context adUnitId:adUnitId];
    FRESetContextNativeData( context, (void *) CFBridgingRetain(interstitial) );
    
    return NULL;
}

FREObject mopub_setInterstitialTestMode(FREContext context, void* functionData, uint32_t argc, FREObject argv[])
{
    void *nativeData;
    FREGetContextNativeData(context, &nativeData);
    MoPubInterstitial* interstitial = (__bridge MoPubInterstitial *) nativeData;
    if( interstitial != nil )
    {
        uint32_t testing;
        if( [mopubConverter FREGetObject:argv[0] asBoolean:&testing] != FRE_OK ) return NULL;
        interstitial.testing = ( testing == 1 );
    }
    return NULL;
}

FREObject mopub_getInterstitialReady(FREContext context, void* functionData, uint32_t argc, FREObject argv[])
{
    void *nativeData;
    FREGetContextNativeData(context, &nativeData);
    MoPubInterstitial* interstitial = (__bridge MoPubInterstitial *) nativeData;
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

FREObject mopub_loadInterstitial(FREContext context, void* functionData, uint32_t argc, FREObject argv[])
{
    void *nativeData;
    FREGetContextNativeData(context, &nativeData);
    MoPubInterstitial* interstitial = (__bridge MoPubInterstitial *) nativeData;
    if( interstitial != nil )
    {
        [interstitial loadInterstitial];
    }
    return NULL;
}

FREObject mopub_showInterstitial(FREContext context, void* functionData, uint32_t argc, FREObject argv[])
{
    void *nativeData;
    FREGetContextNativeData(context, &nativeData);
    MoPubInterstitial* interstitial = (__bridge MoPubInterstitial *) nativeData;
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

FREObject mopub_disposeInterstitial(FREContext context, void* functionData, uint32_t argc, FREObject argv[])
{
    void *nativeData;
    FREGetContextNativeData(context, &nativeData);
    CFBridgingRelease(nativeData);
    
    return NULL;
}




/////////////////////////////////////////////////////////////
// NATIVE EXTENSION


void MoPubContextInitializer( void* extData, const uint8_t* ctxType, FREContext ctx, uint32_t* numFunctionsToSet, const FRENamedFunction** functionsToSet )
{
    NSLog(@"Initializing a context with type %@ ...", [[NSString alloc] initWithUTF8String:ctxType]);
    
    if( strcmp( ctxType, "mopub" ) == 0 )
    {
        *numFunctionsToSet = 7;
        
        FRENamedFunction* func = (FRENamedFunction*) malloc(sizeof(FRENamedFunction) * (*numFunctionsToSet));
        
        func[0].name = (const uint8_t*) "mopub_init";
        func[0].functionData = NULL;
        func[0].function = &mopub_init;
        
        func[1].name = (const uint8_t*) "mopub_getAdScaleFactor";
        func[1].functionData = NULL;
        func[1].function = &mopub_getAdScaleFactor;
        
        func[2].name = (const uint8_t*) "mopub_getNativeScreenWidth";
        func[2].functionData = NULL;
        func[2].function = &mopub_getNativeScreenWidth;
        
        func[3].name = (const uint8_t*) "mopub_getNativeScreenHeight";
        func[3].functionData = NULL;
        func[3].function = &mopub_getNativeScreenHeight;
        
        func[4].name = (const uint8_t*) "mopub_trackConversion";
        func[4].functionData = NULL;
        func[4].function = &mopub_trackConversion;
        
        func[5].name = (const uint8_t*) "mopub_getAppleIDFA";
        func[5].functionData = NULL;
        func[5].function = &mopub_getAppleIDFA;
        
        func[6].name = (const uint8_t*) "mopub_setKeywords";
        func[6].functionData = NULL;
        func[6].function = &mopub_setKeywords;
        
        *functionsToSet = func;
    }
    
    else if( strcmp( ctxType, "interstitial" ) == 0 )
    {
        *numFunctionsToSet = 6;
        
        FRENamedFunction* func = (FRENamedFunction*) malloc(sizeof(FRENamedFunction) * (*numFunctionsToSet));
        
        func[0].name = (const uint8_t*) "mopub_initialiseInterstitial";
        func[0].functionData = NULL;
        func[0].function = &mopub_initialiseInterstitial;
        
        func[1].name = (const uint8_t*) "mopub_setInterstitialTestMode";
        func[1].functionData = NULL;
        func[1].function = &mopub_setInterstitialTestMode;
        
        func[2].name = (const uint8_t*) "mopub_getInterstitialReady";
        func[2].functionData = NULL;
        func[2].function = &mopub_getInterstitialReady;
        
        func[3].name = (const uint8_t*) "mopub_loadInterstitial";
        func[3].functionData = NULL;
        func[3].function = &mopub_loadInterstitial;
        
        func[4].name = (const uint8_t*) "mopub_showInterstitial";
        func[4].functionData = NULL;
        func[4].function = &mopub_showInterstitial;
        
        func[5].name = (const uint8_t*) "mopub_disposeInterstitial";
        func[5].functionData = NULL;
        func[5].function = &mopub_disposeInterstitial;
        
        *functionsToSet = func;
    }
    
    else
    {
        *numFunctionsToSet = 20;
        
        FRENamedFunction* func = (FRENamedFunction*) malloc(sizeof(FRENamedFunction) * (*numFunctionsToSet));
        
        func[0].name = (const uint8_t*) "mopub_initialiseBanner";
        func[0].functionData = NULL;
        func[0].function = &mopub_initialiseBanner;
        
        func[1].name = (const uint8_t*) "mopub_setAdUnitId";
        func[1].functionData = NULL;
        func[1].function = &mopub_setAdUnitId;
        
        func[2].name = (const uint8_t*) "mopub_setAutorefresh";
        func[2].functionData = NULL;
        func[2].function = &mopub_setAutorefresh;
        
        func[3].name = (const uint8_t*) "mopub_setTestMode";
        func[3].functionData = NULL;
        func[3].function = &mopub_setTestMode;
        
        func[4].name = (const uint8_t*) "mopub_lockNativeAdsToOrientation";
        func[4].functionData = NULL;
        func[4].function = &mopub_lockNativeAdsToOrientation;
        
        func[5].name = (const uint8_t*) "mopub_getPositionX";
        func[5].functionData = NULL;
        func[5].function = &mopub_getPositionX;
        
        func[6].name = (const uint8_t*) "mopub_setPositionX";
        func[6].functionData = NULL;
        func[6].function = &mopub_setPositionX;
        
        func[7].name = (const uint8_t*) "mopub_getPositionY";
        func[7].functionData = NULL;
        func[7].function = &mopub_getPositionY;
        
        func[8].name = (const uint8_t*) "mopub_setPositionY";
        func[8].functionData = NULL;
        func[8].function = &mopub_setPositionY;
        
        func[9].name = (const uint8_t*) "mopub_getWidth";
        func[9].functionData = NULL;
        func[9].function = &mopub_getWidth;
        
        func[10].name = (const uint8_t*) "mopub_setWidth";
        func[10].functionData = NULL;
        func[10].function = &mopub_setWidth;
        
        func[11].name = (const uint8_t*) "mopub_getHeight";
        func[11].functionData = NULL;
        func[11].function = &mopub_getHeight;
        
        func[12].name = (const uint8_t*) "mopub_setHeight";
        func[12].functionData = NULL;
        func[12].function = &mopub_setHeight;
        
        func[13].name = (const uint8_t*) "mopub_setSize";
        func[13].functionData = NULL;
        func[13].function = &mopub_setSize;
        
        func[14].name = (const uint8_t*) "mopub_getCreativeWidth";
        func[14].functionData = NULL;
        func[14].function = &mopub_getCreativeWidth;
        
        func[15].name = (const uint8_t*) "mopub_getCreativeHeight";
        func[15].functionData = NULL;
        func[15].function = &mopub_getCreativeHeight;
        
        func[16].name = (const uint8_t*) "mopub_loadBanner";
        func[16].functionData = NULL;
        func[16].function = &mopub_loadBanner;
        
        func[17].name = (const uint8_t*) "mopub_showBanner";
        func[17].functionData = NULL;
        func[17].function = &mopub_showBanner;
        
        func[18].name = (const uint8_t*) "mopub_removeBanner";
        func[18].functionData = NULL;
        func[18].function = &mopub_removeBanner;
        
        func[19].name = (const uint8_t*) "mopub_disposeBanner";
        func[19].functionData = NULL;
        func[19].function = &mopub_disposeBanner;
        
        *functionsToSet = func;
    }
}

void MoPubContextFinalizer( FREContext ctx )
{
    id banner;
    FREGetContextNativeData( ctx, (void*)&banner );
    if( banner != nil )
    {
        if( [banner isKindOfClass:[MoPubBanner class] ] )
        {
            [banner removeFromSuperview];
        }
        else if( [banner isKindOfClass:[MoPubInterstitial class] ] )
        {
        }
    }
	return;
}

void MoPubExtensionInitializer( void** extDataToSet, FREContextInitializer* ctxInitializerToSet, FREContextFinalizer* ctxFinalizerToSet )
{
    extDataToSet = NULL;
    *ctxInitializerToSet = &MoPubContextInitializer;
    *ctxFinalizerToSet = &MoPubContextFinalizer;
    
    mopubConverter = [[MoPub_TypeConversion alloc] init];
}

void MoPubExtensionFinalizer()
{
    return;
}
