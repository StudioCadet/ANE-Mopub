//
//  MoPubTypeConversion.m
//  MoPubIosExtension
//
//  Created by Richard Lord on 18/06/2012.
//  Copyright (c) 2012 Stick Sports Ltd. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FlashRuntimeExtensions.h"

@interface MoPub_TypeConversion : NSObject

- (FREResult) FREGetObject:(FREObject)object asInt:(int32_t*)value;
- (FREResult) FREGetObject:(FREObject)object asDouble:(double*)value;
- (FREResult) FREGetObject:(FREObject)object asBoolean:(uint32_t*)value;
- (FREResult) FREGetObject:(FREObject)object asString:(NSString**)value;
- (FREResult) FREGetObject:(FREObject)object asStringArray:(NSArray**)value;

- (FREResult) FREGetString:(NSString*)string asObject:(FREObject*)asObject;
- (FREResult) FREGetInt:(int32_t)value asObject:(FREObject*)asObject;
- (FREResult) FREGetDouble:(double)value asObject:(FREObject*)asObject;
- (FREResult) FREGetBool:(BOOL)value asObject:(FREObject*)asObject;

@end
