//
//  MoPubCustomEventClassData.h
//  MoPubIosExtension
//
//  Created by Antoine Kleinpeter on 23/03/15.
//  Copyright (c) 2015 Richard Lord. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MoPubCustomEventClassData : NSObject

@property (nonatomic, strong) NSDictionary* mopubWebsiteData;

-(id)initWithMopubWebsiteData:(NSDictionary*) mopubWebsiteData;
- (BOOL)hasRequiredProperties:(NSArray*) requiredProperties;
- (NSString*)getPropertyValue:(NSString*) propertyKey;
@end
