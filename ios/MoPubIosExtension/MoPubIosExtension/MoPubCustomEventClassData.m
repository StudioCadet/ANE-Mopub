//
//  MoPubCustomEventClassData.m
//  MoPubIosExtension
//
//  Created by Antoine Kleinpeter on 23/03/15.
//  Copyright (c) 2015 Richard Lord. All rights reserved.
//

#import "MoPubCustomEventClassData.h"
#import "MPLogging.h"

@implementation MoPubCustomEventClassData

- (id)initWithMopubWebsiteData:(NSDictionary *) mopubWebsiteData {
    self = [super init];
    
    if (self) {
        self.mopubWebsiteData = mopubWebsiteData;
    }
    
    return self;
}


- (BOOL) hasRequiredProperties:(NSArray *)requiredProperties {
    for (NSString* requiredProperty in requiredProperties) {
        if ([self getPropertyValue:requiredProperty] == nil) {
            MPLogError(@"Missing required MoPub website property : %@", requiredProperty);
            return false;
        }
    }
    
    return true;
}

- (NSString *)getPropertyValue:(NSString *)propertyKey {
    return [self.mopubWebsiteData objectForKey:propertyKey];
}

- (void)dealloc {
    [super dealloc];
}
@end
