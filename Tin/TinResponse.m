//
//  TinResponse.m
//  Tin
//
//  Created by Piet Jaspers on 13/06/11.
//  Copyright 2011 10to1. All rights reserved.
//

#import "TinResponse.h"
#import "ASIHTTPRequest.h"

@interface TinResponse (Private)
- (id)initWithRequest:(ASIHTTPRequest *)_request response:(NSString *)_responseString parsedResponse:(NSArray *)_parsedResponse responseData:(NSData *)_responseData andHeaders:(NSDictionary *)_headers;
@end

@implementation TinResponse
@synthesize request;
@synthesize response;
@synthesize responseData;
@synthesize parsedResponse;
@synthesize headers;

+ (id)responseWithRequest:(ASIHTTPRequest *)_request response:(NSString *)_responseString parsedResponse:(NSArray *)_parsedResponse responseData:(NSData *)_responseData andHeaders:(NSDictionary *)_headers {
    return [[[self alloc] initWithRequest:_request response:_responseString parsedResponse:_parsedResponse responseData:_responseData andHeaders:_headers] autorelease];
}

- (id)initWithRequest:(ASIHTTPRequest *)_request response:(NSString *)_responseString parsedResponse:(NSArray *)_parsedResponse responseData:(NSData *)_responseData andHeaders:(NSDictionary *)_headers {
    if(!(self = [super init])) return nil;
    
    self.request = _request;
    self.response = _responseString;
    self.parsedResponse = _parsedResponse;
    self.responseData = _responseData;
    self.headers = _headers;
    return self;
}
- (NSString *)description {
    return [NSString stringWithFormat:@"Response (%p) parsedResponse: %@ response: %@ headers: %@", self, self.parsedResponse, self.response, self.headers];
}

- (NSError *)error {
	return self.request.error;
}

- (void)dealloc {
	[request release];
	[reponse release];
	[reponseData release];
	[parsedResponse release];
	[header release];
}
@end
