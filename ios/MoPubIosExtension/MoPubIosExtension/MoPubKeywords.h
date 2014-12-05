//
//  MoPubKeywords.h
//  MoPubIosExtension
//
//  Created by Damien Dessagne on 03/12/14.
//  Copyright (c) 2014 Richard Lord. All rights reserved.
//

#import <Foundation/Foundation.h>

/**
 An object containing all keywords registered through AS method Mopub.setKeywords().
 Use current
 */
@interface MoPubKeywords : NSObject

@property (nonatomic)           int age;
@property (nonatomic, strong)   NSDate *dateOfBirth;
@property (nonatomic, strong)   NSString *gender;
@property (nonatomic, strong)   NSString *language;
@property (nonatomic, strong)   NSDictionary *additionalKeywords;
@property (nonatomic, strong)   NSString *inMobiInterests;


/** The current keywords. */
+(MoPubKeywords *) current;

/** Returns the keywords to pass to MoPub. */
-(NSString *) getMopubKeywords;

@end
