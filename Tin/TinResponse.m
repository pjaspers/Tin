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

@interface TinResponse () {
    BOOL _didParse;
}

- (id)initWithClient:(AFHTTPClient *)_client URL:(NSURL *)_URL body:(id)_response error:(NSError *)_error;
- (NSString *)decodeFromURL:(NSString*)source;
- (NSDictionary*)splitQuery:(NSString*)query;

@end

@implementation TinResponse

@synthesize client = _client;
@synthesize URL = _url;
@synthesize body = _body;
@synthesize parsedResponse = _parsedResponse;
@synthesize parseMethod = _parseMethod;
@synthesize error = _error;

#pragma mark - Initialization

+ (id)responseWithClient:(AFHTTPClient *)client URL:(NSURL *)URL body:(id)body error:(NSError *)error {
  return [[[self alloc] initWithClient:client URL:URL body:body error:error] autorelease];
}

- (id)initWithClient:(AFHTTPClient *)client URL:(NSURL *)URL body:(id)body error:(NSError *)error {
    if(!(self = [super init])) return nil;

    self.client = client;
    self.URL = URL;
    self.body = body;
    self.error = error;
    self.parseMethod = TinJSONParseMethod;
    _didParse = NO;
    
    return self;
}

- (NSString*)bodyString {
    return self.body ? [[[NSString alloc] initWithData:self.body encoding:NSUTF8StringEncoding] autorelease] : nil;
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
                    parsedResponse = AFJSONDecode(self.body, &error);   
                }
                break;
                
            default:
                parsedResponse = self.body;
                break;
        }
        
        if ([self respondsToSelector:@selector(transformParsedResponse:)]) 
            parsedResponse = [self performSelector:@selector(transformParsedResponse:) withObject:parsedResponse];
        [_parsedResponse release]; // should be nil but can't hurt
        _parsedResponse = [parsedResponse retain];
        if (error) self.error = error;
    }
    
    return _parsedResponse;
}


#pragma mark - Utility


- (NSDictionary*)splitQuery:(id)query
{
    if (!query) return nil;
    if ([query isKindOfClass:[NSDictionary class]]) return query;
    if ([query isKindOfClass:[NSArray class]]) return query;
    if ([query isKindOfClass:[NSData class]]) 
        query = [[NSString alloc] initWithData:query encoding:NSUTF8StringEncoding];

    // make sure we have a string
    query = [query description];

    // Decode the parameters given in the query string, and add their encoded counterparts
    if ([query length] > 0 && [query characterAtIndex:0] == '?')
        query = [query substringFromIndex:1];
    
    NSMutableDictionary *result = [NSMutableDictionary dictionary];
    NSArray *pairs = [query componentsSeparatedByString:@"&"];
    for (NSString *pair in pairs) {
        NSString *key, *value;
        NSRange separator = [pair rangeOfCharacterFromSet:[NSCharacterSet characterSetWithCharactersInString:@"="]];
        if (separator.location != NSNotFound) {
            key = [self decodeFromURL:[pair substringToIndex:separator.location]];
            value = [self decodeFromURL:[pair substringFromIndex:separator.location + 1]];
        } else {
            key = [self decodeFromURL:pair];
            value = @"";
        }
        
        if (key && key.length > 0) {
            [result setObject:value forKey:key];
        }
    }
    
    return result;
}

- (NSString *)decodeFromURL:(NSString*)source
{
    NSString *decoded = [NSMakeCollectable(CFURLCreateStringByReplacingPercentEscapesUsingEncoding(kCFAllocatorDefault, (CFStringRef)source, CFSTR(""), kCFStringEncodingUTF8)) autorelease];
    return [decoded stringByReplacingOccurrencesOfString:@"+" withString:@" "];
}

- (NSString *)description {
    return [NSString stringWithFormat:@"Client (%p) parsedResponse: %@ URL: %@", self, self.parsedResponse, self.URL];
}

#pragma mark - Memory

- (void)dealloc {
	self.client = nil;
    self.URL = nil;
    [_parsedResponse release];
    self.error = nil;
    self.body = nil;
    
    [super dealloc];
}

@end
