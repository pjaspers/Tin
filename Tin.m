//
//  Tin.m
//  TouchPoint
//
//  Created by Piet Jaspers on 10/06/11.
//  Copyright 2011 10to1. All rights reserved.
//

#import "Tin.h"
// The always great [ASIHTTP](http://allseeing-i.com/ASIHTTPRequest/)
#import "ASIHTTPRequest.h"
// Contains additions to default objects to aid Tin
#import "Tin+Extensions.h"

@interface Tin (Utilities)
- (NSString *)normalizeQuery:(id)query;
@end
    
@implementation Tin

// This method should be use to handle all `GET` requests.
//      [TouchPointAPI get:@"http://url.com/" success:(NSDictionary *data) { NSLog(@"Response %@", data)}];
//
+ (void)get:(NSString *)url success:(void(^)(NSArray *data))callback {
    [[[[self alloc] init] autorelease] get:url success:callback];
}



// ## Instance methods

- (void)get:(NSString *)url success:(void(^)(NSArray *data))callback {
    [self performRequest:@"GET" withURL:url andQuery:nil andBody:nil andSuccessCallback:callback andErrorCallback:nil];
}

- (void)get:(NSString *)url query:(id)aQuery success:(void(^)(NSArray *data))callback {
    NSLog(@"%@",[self normalizeQuery:aQuery]);
}

- (void)performRequest:(NSString *)method withURL:(NSString *)urlString andQuery:(NSDictionary *)query andBody:(NSDictionary *)body andSuccessCallback:(void(^)(NSArray *data))returnSuccess andErrorCallback:(void(^)(NSError *error))returnError {
    
    __block ASIHTTPRequest *request = [ASIHTTPRequest requestWithURL:[NSURL URLWithString:urlString]];
    
    [request setCompletionBlock:^{
        // For now only fetching text data
        NSArray *returnArray = [NSArray arrayWithObject:[request responseString]];
        
        // Check if a parser is available, more info in [Tin+YAJL](Tin+YAJL.html)
        if ([self respondsToSelector:@selector(parseResponse:)]) {
            returnArray = [self performSelector:@selector(parseResponse:) withObject:[request responseString]];
        }
        if (returnSuccess) {
            dispatch_async(dispatch_get_main_queue(), ^{ 
                returnSuccess(returnArray);
            });
        }
    }];
    [request setFailedBlock:^{
        NSError *error = [request error];
        if(returnError) returnError(error);
    }];
    [request startAsynchronous];
}

// ## Utility methods

- (NSString *)normalizeQuery:(id)query {
    if ([query isKindOfClass:[NSString class]]) 
        return query;
    if ([query isKindOfClass:[NSDictionary class]])
        return [(NSDictionary *) query toQueryString];
    return nil;
}
@end


