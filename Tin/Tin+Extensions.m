//
//  Tin+Extensions.m
//  Tin
//
//  Created by Piet Jaspers on 12/06/11.
//  Copyright 2011 10to1. All rights reserved.
//

#import "Tin+Extensions.h"

@implementation NSDictionary (Tin)

// Convert a `NSDictionary` to a string resembling a http
// query.
//
//      NSDictionary *aDict = [NSDictionary dictionaryWithObjectsAndKeys:
//        @"something", @"keyOne",
//        [NSNumber numberWithInt:2], @"keyTwo", nil];
//      [aDict toQueryString];
//        => @"?keyOne=something&keyTwo=2
//
- (NSString *)toQueryString {
    return [self toQueryString:nil];
}

- (NSString *)toQueryString:(NSString *)aNamespace {
    NSMutableArray *paramsArray = [NSMutableArray arrayWithCapacity:[[self allKeys] count]];
    for (NSString *key in self) {
        if (!aNamespace) {
            [paramsArray addObject:[NSString stringWithFormat:@"%@=%@", [key stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding], [[[self objectForKey:key] description] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]]];
        } else {
            [paramsArray addObject:[NSString stringWithFormat:@"%@[%@]=%@", 
                                    aNamespace, 
                                    [key stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding], 
                                    [[[self objectForKey:key] description]stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]]];
        }
    }
    return [NSString stringWithFormat:@"?%@",[paramsArray componentsJoinedByString:@"&"]];
}
@end