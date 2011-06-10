//
//  Tin+YAJL.m
//  TouchPoint
//
//  Created by Piet Jaspers on 10/06/11.
//  Copyright 2011 10to1. All rights reserved.
//

#import "Tin+YAJL.h"
#import <YAJLiOS/YAJL.h>

@implementation Tin (YAJL)

// The Tin class will check if the `parseResponse:` method is implemented,
// and use it as needed. So if you want `XML` or another `JSON`-parser.
// Create a new Category and implement this method.
- (NSArray *)parseResponse:(NSString *)responseString {
 	NSError *error = nil;
	id objectFromJSON = [responseString yajl_JSONWithOptions:YAJLParserOptionsAllowComments error:&error];
    // TODO: Make error passing a bit more sane, might even use another block.
    if (error) return nil;
    
    // Return the parsed JSON in an NSArray
    if ([objectFromJSON isKindOfClass:[NSArray class]]) return (NSArray *)objectFromJSON;
    return [NSArray arrayWithObject:objectFromJSON];
}
@end
