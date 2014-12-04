//
//  MoPubTypeConversion.m
//  MoPubIosExtension
//
//  Created by Richard Lord on 23/10/2012.
//  Copyright (c) 2012 Stick Sports Ltd. All rights reserved.
//

#import "MoPubTypeConversion.h"

@implementation MoPub_TypeConversion


// FREObject to values :

- (FREResult) FREGetObject:(FREObject)object asInt:(int32_t*)value
{
    return FREGetObjectAsInt32( object, value );
}

- (FREResult) FREGetObject:(FREObject)object asDouble:(double*)value
{
    return FREGetObjectAsDouble( object, value );
}

- (FREResult) FREGetObject:(FREObject)object asBoolean:(uint32_t*)value
{
    return FREGetObjectAsBool( object, value );
}

- (FREResult) FREGetObject:(FREObject)object asString:(NSString**)value
{
    FREResult result;
    uint32_t length = 0;
    const uint8_t* tempValue = NULL;
    
    result = FREGetObjectAsUTF8( object, &length, &tempValue );
    if( result != FRE_OK ) return result;
    
    *value = [NSString stringWithUTF8String: (char*) tempValue];
    return FRE_OK;
}

- (FREResult) FREGetObject:(FREObject)object asStringArray:(NSArray **)value
{
    // Get array length :
    FREResult result;
    uint32_t length;
    result = FREGetArrayLength(object, &length);
    if( result != FRE_OK )
        return result;
    
    // Convert to array of string :
    FREObject item;
    int32_t i;
    NSString *itemAsString;
    NSMutableArray* array = [[NSMutableArray  alloc] init];
    for(i = 0 ; i < length ; i++) {
        result = FREGetArrayElementAt(object, i, &item);
        if(result != FRE_OK)
            return result;
        
        result = [self FREGetObject:item asString:&itemAsString];
        if(result != FRE_OK)
            return result;
        
        [array addObject:itemAsString];
    }
    
    *value = array;
    
    return FRE_OK;
}



// Values to FREObject :


- (FREResult) FREGetString:(NSString*)string asObject:(FREObject*)asObject
{
    if( string == nil )
    {
        return FRE_INVALID_ARGUMENT;
    }
    const char* utf8String = string.UTF8String;
    unsigned long length = strlen( utf8String );
    return FRENewObjectFromUTF8( length + 1, (uint8_t*) utf8String, asObject );
}

- (FREResult) FREGetInt:(int32_t)value asObject:(FREObject*)asObject
{
    return FRENewObjectFromInt32( value, asObject );
}

- (FREResult) FREGetDouble:(double)value asObject:(FREObject*)asObject
{
    return FRENewObjectFromDouble( value, asObject );
}

- (FREResult) FREGetBool:(BOOL)value asObject:(FREObject*)asObject
{
    return FRENewObjectFromBool( value, asObject );
}

@end
