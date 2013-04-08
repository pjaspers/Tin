//
//  TinResponse.m
//  Tin
//
//  Created by Piet Jaspers on 13/06/11.
//  Copyright 2011 10to1. All rights reserved.
//

#import "TinResponse.h"
#import "Tin.h"
#import "AFHTTPRequestOperation.h"

@interface TinResponse () {
    BOOL _didParse;
}

@property (nonatomic, retain) NSURLRequest *httpRequest;
@property (nonatomic, retain) NSHTTPURLResponse *httpResponse;

- (id)initWithOperation:(AFHTTPRequestOperation *)operation body:(id)body error:(NSError *)error;
- (NSString *)decodeFromURL:(NSString*)source;
- (NSDictionary*)splitQuery:(NSString*)query;

@end

@implementation TinResponse

@synthesize httpRequest = _httpRequest;
@synthesize httpResponse = _httpResponse;
@synthesize body = _body;
@synthesize parsedResponse = _parsedResponse;
@synthesize parseMethod = _parseMethod;
@synthesize error = _error;

#pragma mark - Initialization

+ (id)responseWithOperation:(AFHTTPRequestOperation *)operation body:(id)body error:(NSError *)error {
    return [[self alloc] initWithOperation:operation body:body error:error];
}

- (id)initWithOperation:(AFHTTPRequestOperation *)operation body:(id)body error:(NSError *)error {
    if(!(self = [super init])) return nil;
    
    self.httpRequest = operation.request;
    self.httpResponse = operation.response;
    self.body = body;
    self.error = error;
    self.parseMethod = TinJSONParseMethod;
    _didParse = NO;
    
    return self;
}

- (NSURL *)URL {
    return self.httpRequest.URL;
}

- (NSString*)bodyString {
    return self.body ? [[NSString alloc] initWithData:self.body encoding:NSUTF8StringEncoding]  : nil;
}

- (id)parsedResponse {
    if (!_didParse) {
        _didParse = YES;
        NSError* error = nil;
        id parsedResponse = nil;
        switch (self.parseMethod) {
            case TinFormURLParseMethod:
                parsedResponse = [self splitQuery:self.body];
                break;
                
            case TinJSONParseMethod:
                if (self.body) {
                    parsedResponse = [NSJSONSerialization JSONObjectWithData:self.body options:0 error:&error];
                }
                break;
                
            default:
                parsedResponse = self.body;
                break;
        }
        
        if ([self respondsToSelector:@selector(transformParsedResponse:)]) 
            parsedResponse = [self performSelector:@selector(transformParsedResponse:) withObject:parsedResponse];
        _parsedResponse = parsedResponse;
        if (error) self.error = error;
    }
    
    return _parsedResponse;
}


#pragma mark - Utility


- (NSDictionary*)splitQuery:(id)query
{
    return [Tin splitQuery:query];
}

- (NSString *)decodeFromURL:(NSString*)source
{
    return [Tin decodeFromURL:source];
}

- (NSString *)description {
    return [NSString stringWithFormat:@"Client (%p) parsedResponse: %@ URL: %@", self, self.parsedResponse, self.URL];
}

#pragma mark - Memory

- (void)dealloc {
//	self.client = nil;
    self.httpRequest = nil;
    self.httpResponse = nil;
    _parsedResponse = nil;
    self.error = nil;
    self.body = nil;
}

@end
