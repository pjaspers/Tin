//
//  TinResponse.m
//  Tin
//
//  Created by Piet Jaspers on 13/06/11.
//  Copyright 2011 10to1. All rights reserved.
//

#import "TinResponse.h"
#import "AFJSONUtilities.h"

#import "AFHTTPClient.h"

@interface TinResponse (Private)
- (id)initWithClient:(AFHTTPClient *)_client URL:(NSURL *)_URL body:(id)_response error:(NSError *)_error;
@end

@implementation TinResponse
@synthesize client;
@synthesize URL;
@synthesize body;
@synthesize parsedResponse;
@synthesize error;

#pragma mark - Initialization

+ (id)responseWithClient:(AFHTTPClient *)_client URL:(NSURL *)_URL body:(id)_body error:(NSError *)_error {
  return [[[self alloc] initWithClient:_client URL:_URL body:_body error:_error] autorelease];
}

- (id)initWithClient:(AFHTTPClient *)_client URL:(NSURL *)_URL body:(id)_body error:(NSError *)_error {
    if(!(self = [super init])) return nil;

    self.client = _client;
    self.URL = _URL;
    self.body = _body;
    if(self.body != nil){
        self.parsedResponse = AFJSONDecode(_body, &_error);   
    }
    self.error = _error;
    
    return self;
}

#pragma mark - Utility

- (NSString *)description {
    return [NSString stringWithFormat:@"Client (%p) parsedResponse: %@ URL: %@", self, self.parsedResponse, self.URL];
}

#pragma mark - Memory

- (void)dealloc {
	self.client = nil;
    self.URL = nil;
    self.parsedResponse = nil;
    self.error = nil;
    self.body = nil;
    
    [super dealloc];
}

@end
