//
//  MoPubKeywords.h
//  MoPubIosExtension
//
//  Created by Damien Dessagne on 03/12/14.
//  Copyright (c) 2014 Richard Lord. All rights reserved.
//

#import "MoPubKeywords.h"

static MoPubKeywords *current;

@implementation MoPubKeywords

+(MoPubKeywords *) current
{
    if(current == nil) {
        current = [[MoPubKeywords alloc] init];
    }
    
    return current;
}


-(NSString *) getMopubKeywords
{
    NSMutableString *s = [[NSMutableString alloc] init];
    
    if(_age > 0)
        [s appendFormat:@"m_age:%i,", _age];
    
    if(_gender != nil)
        [s appendFormat:@"m_gender:%@,", _gender];
    
    if(_additionalKeywords != nil) {
        NSArray *keywords = _additionalKeywords.allKeys;
        for(int i = 0 ; i < keywords.count ; i++) {
            [s appendFormat:@"%@:%@,", keywords[i], [_additionalKeywords objectForKey:keywords[i]]];
        }
    }
    
    if(s.length > 0)
        s = [[NSMutableString alloc] initWithString:[s substringToIndex:(s.length - 1)]];
    
    return s;
}



@end