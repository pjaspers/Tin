//
//  Tin.m
//  TouchPoint
//
//  Created by Piet Jaspers on 10/06/11.
//  Copyright 2011 10to1. All rights reserved.
//

#import "Tin.h"

// Since ASIHTTP is no longer maintained, we switched to [AFNetworking](https://github.com/AFNetworking/AFNetworking)
#import "AFHTTPClient.h"
#import "AFHTTPRequestOperation.h"
#import "AFJSONUtilities.h"

// Each request returns a [TinResponse](TinResponse.html)
#import "TinBasicAuthenticator.h"
#import "TinResponse.h"
#import "TinFile.h"

// Contains additions to default objects to aid Tin
#import "Tin+Extensions.h"

@interface Tin (URL)
- (NSString *)normalizeURL:(NSString *)aURL withQuery:(id)query;
- (NSString *)prependHTTPtoURL:(NSString *)aUrl;
- (NSString *)normalizeQuery:(id)query;
@end

@interface Tin (Authorization)
- (void)setOptionsOnClient:(AFHTTPClient *)request;
- (void)setOptionsOnRequest:(NSMutableURLRequest *)request;
@end

@interface Tin (Blocks)
- (void)waitFor:(void(^)(void(^endCallback)(void)))block;
@end

@interface Tin (Requests)
- (NSArray*)buildRequest:(NSString *)method withURL:(NSString *)urlString andQuery:(id)query andBody:(id)body andFiles:(NSMutableDictionary *)files;
- (TinResponse *)performSynchronousRequest:(NSString *)method withURL:(NSString *)urlString andQuery:(id)query andBody:(id)body andFiles:(NSMutableDictionary *)files;
- (TinResponse *)performSynchronousRequest:(NSString *)method withURL:(NSString *)urlString andQuery:(id)query andBody:(id)body;
- (void)performRequest:(NSString *)method withURL:(NSString *)urlString andQuery:(id)query andBody:(id)body andSuccessCallback:(void(^)(TinResponse *response))returnSuccess;
- (void)performRequest:(NSString *)method withURL:(NSString *)urlString andQuery:(id)query andBody:(id)body andFiles:(NSMutableDictionary *)files andSuccessCallback:(void(^)(TinResponse *response))returnSuccess;
@end

@implementation Tin

@synthesize baseURI;
@synthesize authenticator = _authenticator;
@synthesize timeoutSeconds;
@synthesize contentType;
@synthesize accept = _accept;
@synthesize headers;
@synthesize debugOutput;
@synthesize delegate = _delegate;

#pragma mark - Class methods

#pragma mark GET ASYNCHRONOUS
// ## `GET` requests
//
// Methods for use with `GET` requests.
//
//      [Tin get:@"http://url.com/" success:(NSDictionary *data) { NSLog(@"Response %@", data)}];
//

+ (void)get:(NSString *)url success:(void(^)(TinResponse *response))callback {
    [self get:url query:nil success:callback];
}

+ (void)get:(NSString *)url query:(id)query success:(void(^)(TinResponse *response))callback {
    [[[[self alloc] init] autorelease] get:url query:query success:callback];
}

#pragma mark GET SYNCHRONOUS

+ (TinResponse *)get:(NSString *)url{ 
    return [self get:url query:nil];
}

+ (TinResponse *)get:(NSString *)url query:(id)query {
    return [[[[self alloc] init] autorelease] get:url query:query];
}

#pragma mark POST ASYNCHRONOUS
// ## `POST` requests
//
// Methods for use with `POST` requests.
// 
//      [Tin post:@"http://url.com/" 
//           query:[NSDictionary dictionaryWithObjectsAndKeys:@"string", @"key", nil]
//        success:nil
//          error:nil];
//

+ (void)post:(NSString *)url query:(id)query success:(void(^)(TinResponse *response))callback {
    [self post:url query:query body:nil success:callback];
}

+ (void)post:(NSString *)url body:(id)body success:(void(^)(TinResponse *response))callback {
    [self post:url query:nil body:body success:callback];
}

+ (void)post:(NSString *)url query:(id)query body:(id)body success:(void(^)(TinResponse *response))callback {
    [self post:url query:query body:body files:nil success:callback];
}

+ (void)post:(NSString *)url query:(id)aQuery body:(NSDictionary *)bodyData files:(NSMutableDictionary *)files success:(void(^)(TinResponse *response))callback {
    [[[[self alloc] init] autorelease] post:url query:aQuery body:bodyData files:files success:callback];
}

#pragma mark POST SYNCHRONOUS

+ (TinResponse *)post:(NSString *)url query:(id)aQuery{
    return [self post:url query:aQuery body:nil];
}

+ (TinResponse *)post:(NSString *)url body:(NSDictionary *)bodyData{
    return [self post:url query:nil body:bodyData];
}

+ (TinResponse *)post:(NSString *)url query:(id)aQuery body:(NSDictionary *)bodyData {
    return [[[[self alloc] init] autorelease] post:url query:aQuery body:bodyData files:nil];
}

+ (TinResponse *)post:(NSString *)url query:(id)aQuery body:(NSDictionary *)bodyData files:(NSMutableDictionary *)files {
    return [[[[self alloc] init] autorelease] post:url query:aQuery body:bodyData files:files];
}

#pragma mark PUT ASYNCHRONOUS
// ## `PUT` requests
//
// Methods for use with `PUT` requests.
// 
//      [Tin put:@"http://url.com/" 
//           body:[NSString stringWithFormat:@"user=%@", @"Jake"]
//        success:nil
//          error:nil];
//

+ (void)put:(NSString *)url query:(id)query success:(void(^)(TinResponse *response))callback {
    [self put:url query:query body:nil success:callback];
}

+ (void)put:(NSString *)url body:(id)body success:(void(^)(TinResponse *response))callback {
    [self put:url query:nil body:body success:callback];
}

+ (void)put:(NSString *)url query:(id)query body:(id)body success:(void(^)(TinResponse *response))callback {
    [self put:url query:query body:body files:nil success:callback];
}

+ (void)put:(NSString *)url query:(id)aQuery body:(id)body files:(NSMutableDictionary *)files success:(void(^)(TinResponse *response))callback {
    [[[[self alloc] init] autorelease] put:url query:aQuery body:body files:files success:callback];
}

#pragma mark PUT SYNCHRONOUS

+ (TinResponse *)put:(NSString *)url query:(id)aQuery{
    return [self put:url query:aQuery body:nil];
}

+ (TinResponse *)put:(NSString *)url body:(id)body {
    return [self put:url query:nil body:body];
}

+ (TinResponse *)put:(NSString *)url query:(id)aQuery body:(id)body {
    return [self put:url query:aQuery body:body files:nil];
}

+ (TinResponse *)put:(NSString *)url query:(id)aQuery body:(id)body files:(NSMutableDictionary *)files {
    return [[[[self alloc] init] autorelease] put:url query:aQuery body:body files:files];
}

#pragma mark DELETE ASYNCHRONOUS

+ (void)delete:(NSString *)url query:(id)query success:(void(^)(TinResponse *response))callback {
    [self delete:url query:query body:nil success:callback];
}

+ (void)delete:(NSString *)url body:(id)body success:(void(^)(TinResponse *response))callback {
    [self delete:url query:nil body:body success:callback];
}

+ (void)delete:(NSString *)url query:(id)query body:(id)body success:(void(^)(TinResponse *response))callback {
    [[[[self alloc] init] autorelease] delete:url query:query body:body success:callback];
}

#pragma mark DELETE SYNCHRONOUS

+ (TinResponse *)delete:(NSString *)url query:(id)aQuery{
    return [self delete:url query:aQuery body:nil];
}

+ (TinResponse *)delete:(NSString *)url body:(id)body {
    return [self delete:url query:nil body:body];
}

+ (TinResponse *)delete:(NSString *)url query:(id)aQuery body:(id)body {
    return [[[[self alloc] init] autorelease] delete:url query:aQuery body:body];
}

#pragma mark - Instance Methods

#pragma mark - initialisation & dealloc

- (id)init {
    if ((self = [super init])) {
    }
    return self;
}

- (void)dealloc {
    self.authenticator = nil;
    self.baseURI = nil;
    self.contentType = nil;
    self.headers = nil;

    [super dealloc];
}

#pragma mark GET ASYNCHRONOUS

- (void)get:(NSString *)url success:(void(^)(TinResponse *response))callback {
    [self get:url query:nil success:callback];
}

- (void)get:(NSString *)url query:(id)query success:(void(^)(TinResponse *response))callback {
    [self performRequest:@"GET" withURL:url andQuery:query andBody:nil andSuccessCallback:callback];
}

#pragma mark GET SYNCHRONOUS

- (TinResponse *)get:(NSString *)url {
    return [self get:url query:nil];
}

- (TinResponse *)get:(NSString *)url query:(id)query {
    return [self performSynchronousRequest:@"GET" withURL:url andQuery:query andBody:nil];
}

- (NSURLRequest*)requestGet:(NSString *)url query:(id)query {
    return [[self buildRequest:@"GET" withURL:url andQuery:query andBody:nil andFiles:nil] objectAtIndex:1];
}

#pragma mark POST ASYNCHRONOUS

- (void)post:(NSString *)url query:(id)query success:(void(^)(TinResponse *response))callback {
    [self post:url query:query body:nil success:callback];
}

- (void)post:(NSString *)url body:(id)bodyData success:(void(^)(TinResponse *response))callback {
    [self post:url query:nil body:bodyData success:callback];
}

- (void)post:(NSString *)url query:(id)query body:(id)bodyData success:(void(^)(TinResponse *response))callback {
    [self post:url query:query body:bodyData files:nil success:callback];
}
- (void)post:(NSString *)url query:(id)query body:(id)bodyData files:(NSMutableDictionary *)files success:(void(^)(TinResponse *response))callback {
    [self performRequest:@"POST" withURL:url andQuery:query andBody:bodyData andFiles:files andSuccessCallback:callback];
}

#pragma mark POST SYNCHRONOUS

- (TinResponse *)post:(NSString *)url body:(NSDictionary *)bodyData {
    return [self post:url query:nil body:bodyData];
}

- (TinResponse *)post:(NSString *)url query:(id)aQuery {
    return [self post:url query:aQuery body:nil];
}

- (TinResponse *)post:(NSString *)url query:(id)aQuery body:(NSDictionary *)bodyData {
    return [self post:url query:aQuery body:bodyData files:nil];
}

- (TinResponse *)post:(NSString *)url query:(id)aQuery body:(NSDictionary *)bodyData files:(NSMutableDictionary *)files {
    return [self performSynchronousRequest:@"POST" withURL:url andQuery:aQuery andBody:bodyData andFiles:files];
}

- (NSURLRequest*)requestPost:(NSString *)url query:(id)aQuery body:(NSDictionary *)bodyData files:(NSMutableDictionary *)files {
    return [[self buildRequest:@"POST" withURL:url andQuery:aQuery andBody:bodyData andFiles:files] objectAtIndex:1];
}

#pragma mark PUT ASYNCHRONOUS

- (void)put:(NSString *)url query:(id)query success:(void(^)(TinResponse *response))callback {
    [self put:url query:query body:nil success:callback];
}

- (void)put:(NSString *)url body:(id)body success:(void(^)(TinResponse *response))callback {
    [self put:url query:nil body:body success:callback];
}

- (void)put:(NSString *)url query:(id)query body:(id)body success:(void(^)(TinResponse *response))callback{
    [self put:url query:query body:body files:nil success:callback];
}

- (void)put:(NSString *)url query:(id)query body:(id)body files:(NSMutableDictionary *)files success:(void(^)(TinResponse *response))callback {
    [self performRequest:@"PUT" withURL:url andQuery:query andBody:body andFiles:files andSuccessCallback:callback];
}

#pragma mark PUT SYNCHRONOUS

- (TinResponse *)put:(NSString *)url query:(id)aQuery{
    return [self put:url query:aQuery body:nil];
}

- (TinResponse *)put:(NSString *)url body:(id)body{
    return [self put:url query:nil body:body];
}

- (TinResponse *)put:(NSString *)url query:(id)aQuery body:(id)body {
    return [self put:url query:aQuery body:body files:nil];
}

- (TinResponse *)put:(NSString *)url query:(id)aQuery body:(id)body files:(NSMutableDictionary *)files {
    return [self performSynchronousRequest:@"PUT" withURL:url andQuery:aQuery andBody:body andFiles:files];
}

- (NSURLRequest *)requestPut:(NSString *)url query:(id)aQuery body:(id)body files:(NSMutableDictionary *)files {
    return [[self buildRequest:@"PUT" withURL:url andQuery:aQuery andBody:body andFiles:files] objectAtIndex:1];
}

#pragma mark DELETE ASYNCHRONOUS

- (void)delete:(NSString *)url query:(id)query success:(void(^)(TinResponse *response))callback {
    [self delete:url query:query body:nil success:callback];
}

- (void)delete:(NSString *)url body:(id)body success:(void(^)(TinResponse *response))callback {
    [self delete:url query:nil body:body success:callback];
}

- (void)delete:(NSString *)url query:(id)query body:(id)body success:(void(^)(TinResponse *response))callback{
    [self performRequest:@"DELETE" withURL:url andQuery:query andBody:body andFiles:nil andSuccessCallback:callback];
}

#pragma mark DELETE SYNCHRONOUS

- (TinResponse *)delete:(NSString *)url query:(id)aQuery{
    return [self delete:url query:aQuery body:nil];
}

- (TinResponse *)delete:(NSString *)url body:(id)body{
    return [self delete:url query:nil body:body];
}

- (TinResponse *)delete:(NSString *)url query:(id)aQuery body:(id)body {
    return [self performSynchronousRequest:@"DELETE" withURL:url andQuery:aQuery andBody:body andFiles:nil];
}

- (NSURLRequest*)requestDelete:(NSString *)url query:(id)aQuery body:(id)body {
    return [[self buildRequest:@"DELETE" withURL:url andQuery:aQuery andBody:body andFiles:nil] objectAtIndex:1];
}

#pragma mark - Synchronous requests

- (TinResponse *)performSynchronousRequest:(NSString *)method withURL:(NSString *)urlString andQuery:(id)query andBody:(id)body {
    return [self performSynchronousRequest:method withURL:urlString andQuery:query andBody:body andFiles:nil];
}

- (TinResponse *)performSynchronousRequest:(NSString *)method withURL:(NSString *)urlString andQuery:(id)query andBody:(id)body andFiles:(NSMutableDictionary *)files {
    __block TinResponse *synchronousRequest = nil;
    
    [self waitFor:^(void(^done)(void)) {
        [self performRequest:method withURL:urlString andQuery:query andBody:body andFiles:files andSuccessCallback:^(TinResponse *response) {
            synchronousRequest = [response retain];
            done();
        }]; 
    }];
    
    return synchronousRequest;
}

#pragma mark - Asynchronous requests

- (void)performRequest:(NSString *)method withURL:(NSString *)urlString andQuery:(id)query andBody:(id)body andSuccessCallback:(void(^)(TinResponse *response))returnSuccess {
    [self performRequest:method withURL:urlString andQuery:query andBody:body andFiles:nil andSuccessCallback:returnSuccess];
}

- (NSArray*)buildRequest:(NSString *)method withURL:(NSString *)urlString andQuery:(id)query andBody:(id)body andFiles:(NSMutableDictionary *)files {
    // Initialize client
    AFHTTPClient *_client = [[AFHTTPClient alloc] initWithBaseURL:[NSURL URLWithString:self.baseURI]];
    [self setOptionsOnClient:_client];
    
    if (body && self.contentType != nil && ![self.contentType isEqualToString:@""]) {
        [_client setDefaultHeader:@"Content-Type" value:self.contentType];
    }

    if (self.accept) {
        [_client setDefaultHeader:@"Accept" value:self.accept];
    }

    query = [self normalizeQuery:query];
    if ([self.authenticator respondsToSelector:@selector(tin:applyAuthenticationOnClient:withMethod:url:query:)]) 
        query = [self.authenticator tin:self applyAuthenticationOnClient:_client withMethod:method url:urlString query:query];
    
    // Initialize request
    NSString *_url = [self normalizeURL:urlString withQuery:query];
    if (self.debugOutput) NSLog(@"Making request to: %@", _url);

    NSMutableURLRequest *_request;
    if (files) {
        _request = [_client multipartFormRequestWithMethod:method path:_url parameters:body constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
            [files enumerateKeysAndObjectsUsingBlock:^(id attribute_name, TinFile *file, BOOL *stop) {
                [formData appendPartWithFileData:file.data name:attribute_name fileName:file.name mimeType:file.mimeType];
            }];
        }];
    } else {
        _request = [_client requestWithMethod:method path:_url parameters:body];
    }
    
    [self setOptionsOnRequest:_request];
    return [NSArray arrayWithObjects:_client, _request, nil];
}

- (void)performRequest:(NSString *)method withURL:(NSString *)urlString andQuery:(id)query andBody:(id)body andFiles:(NSMutableDictionary *)files andSuccessCallback:(void(^)(TinResponse *response))returnSuccess {
    NSArray* req = [self buildRequest:method withURL:urlString andQuery:query andBody:body andFiles:files];
    __block AFHTTPClient* _client = [req objectAtIndex:0];
    NSURLRequest* _request = [req objectAtIndex:1];
    
    // Initialize operation
    AFHTTPRequestOperation *_operation = [[[AFHTTPRequestOperation alloc] initWithRequest:_request] autorelease];
    [_operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        if (self.debugOutput) NSLog(@"\t Request succesfull");
        
        NSError *_error = nil;
        TinResponse *_response = [TinResponse responseWithOperation:operation body:responseObject error:_error];
        [self.delegate didEndRequest:operation.request withResponse:_response];
        if (returnSuccess) {
            returnSuccess(_response);
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        if (self.debugOutput) NSLog(@"\t Request failed, error: %@", error);
        
        TinResponse *_response = [TinResponse responseWithOperation:operation body:nil error:error];
        [self.delegate didEndRequest:operation.request withResponse:_response];
        if (returnSuccess) {
            returnSuccess(_response);
        }
    }];
    
    [self.delegate willBeginRequest:_request];
    [_operation start];
}

#pragma mark - Utility

// Sets all specified options to the request
- (void)setOptionsOnClient:(AFHTTPClient *)client {
    if (self.headers) {
        [self.headers enumerateKeysAndObjectsUsingBlock:^(id key, id obj, BOOL *stop) {
            [client setDefaultHeader:key value:obj];
        }];
    }

    client.parameterEncoding = AFJSONParameterEncoding;
}

// Sets all specified options to the request
- (void)setOptionsOnRequest:(NSMutableURLRequest *)request {
    request.HTTPShouldHandleCookies = NO;
    if (self.timeoutSeconds) {
        [request setTimeoutInterval:self.timeoutSeconds];
    }
}

#pragma mark - URL helpers

// Creates the `URL` which will be used in the actual request.
- (NSString *)normalizeURL:(NSString *)aURL withQuery:(id) query {
    NSString *urlString = aURL;
    
    // Adds the query
    if (query) urlString = [NSString stringWithFormat:@"%@%@", urlString, [self normalizeQuery:query]];
    
    return urlString;
}

- (NSString *)normalizeQuery:(id)query {
    if ([query isKindOfClass:[NSString class]]) {
        if ([query length] > 0 && [query characterAtIndex:0] != '?')
            query = [NSString stringWithFormat:@"?%@", query];
        return query;
    }
    if ([query isKindOfClass:[NSDictionary class]])
        return [(NSDictionary *) query toQueryString];
    return nil;
}

+ (NSDictionary*)splitQuery:(id)query
{
    if (!query) return nil;
    if ([query isKindOfClass:[NSDictionary class]]) return query;
    if ([query isKindOfClass:[NSArray class]]) return query;
    if ([query isKindOfClass:[NSData class]]) 
        query = [[[NSString alloc] initWithData:query encoding:NSUTF8StringEncoding] autorelease];
    
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

+ (NSString *)decodeFromURL:(NSString*)source
{
    NSString *decoded = [NSMakeCollectable(CFURLCreateStringByReplacingPercentEscapesUsingEncoding(kCFAllocatorDefault, (CFStringRef)source, CFSTR(""), kCFStringEncodingUTF8)) autorelease];
    return [decoded stringByReplacingOccurrencesOfString:@"+" withString:@" "];
}

#pragma mark - Synchronous helper

- (void)waitFor:(void(^)(void(^endCallback)(void)))block {
    dispatch_semaphore_t waiter = dispatch_semaphore_create(0);
    
    block(^{
        dispatch_semaphore_signal(waiter);
    });
    
    dispatch_semaphore_wait(waiter, DISPATCH_TIME_FOREVER);
    dispatch_release(waiter);
}

@end


