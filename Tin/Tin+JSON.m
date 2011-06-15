//
//  Tin+JSON.m
//  TouchPoint
//
//  Created by Jelle Vandebeeck on 15/06/11.
//  Copyright 2011 10to1. All rights reserved.
//

#import "Tin+JSON.h"
#import "JSON.h"

@implementation Tin (JSON)

// The Tin class will check if the `parseResponse:` method is implemented,
// and use it as needed. So if you want `XML` or another `JSON`-parser.
// Create a new Category and implement this method.
- (NSArray *)parseResponse:(NSString *)responseString {
	id objectFromJSON = [responseString JSONValue];
    if (!objectFromJSON) return nil;
	
    // Return the parsed JSON in an NSArray
    if ([objectFromJSON isKindOfClass:[NSArray class]]) return (NSArray *)objectFromJSON;
    return [NSArray arrayWithObject:objectFromJSON];
}
@end
