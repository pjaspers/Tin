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
#import "ASIFormDataRequest.h"

// Each request returns a [TinResponse](TinResponse.html)
#import "TinResponse.h"

// Contains additions to default objects to aid Tin
#import "Tin+Extensions.h"

@interface Tin (Utilities)
- (NSString *)normalizeURL:(NSString *)aURL withQuery:(id)query;
- (NSString *)prependHTTPtoURL:(NSString *)aUrl;
- (NSString *)normalizeQuery:(id)query;
- (void)setOptionsOnRequest:(ASIHTTPRequest *)request;
+ (ASIFormDataRequest *)requestWithURL:(NSString *)url;
@end

@interface Tin (ResponseHandling)
- (TinResponse *)responseFromError:(ASIHTTPRequest *)request;
- (TinResponse *)responseFromSuccess:(ASIHTTPRequest *)request;
@end
@implementation Tin
@synthesize baseURI, password, username, timeoutSeconds, contentType, headers;
@synthesize debugOutput;

#pragma mark - Class methods

// ## Synchrnous requests
+ (TinResponse *)get:(NSString *)url{ 
    return nil;
}
+ (TinResponse *)get:(NSString *)url query:(id)query{
    return nil;
}

+ (TinResponse *)post:(NSString *)url query:(id)aQuery{
    return nil;
}

+ (TinResponse *)post:(NSString *)url body:(NSDictionary *)bodyData{
    return nil;
}
+ (TinResponse *)post:(NSString *)url query:(id)aQuery body:(NSDictionary *)bodyData{
    return nil;
}

+ (TinResponse *)put:(NSString *)url query:(id)aQuery{
    return nil;
}

+ (TinResponse *)put:(NSString *)url body:(id)body{
    return nil;
}
+ (TinResponse *)put:(NSString *)url query:(id)aQuery body:(id)body{
    return nil;
}

- (TinResponse *)get:(NSString *)url{
    return nil;
}
- (TinResponse *)get:(NSString *)url query:(id)query{
    return nil;
}

- (TinResponse *)post:(NSString *)url body:(NSDictionary *)bodyData{
    return nil;
}

- (TinResponse *)post:(NSString *)url query:(id)aQuery body:(NSDictionary *)bodyData{
    return nil;
}

- (TinResponse *)put:(NSString *)url query:(id)aQuery{
    return nil;
}

- (TinResponse *)put:(NSString *)url body:(id)body{
    return nil;
}

- (TinResponse *)put:(NSString *)url query:(id)aQuery body:(id)body{
    return nil;
}

#pragma mark GET
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

#pragma mark POST
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

#pragma mark PUT
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

+ (void)put:(NSString *)url query:(id)query body:(id)body success:(void(^)(TinResponse *response))callback{
    [self put:url query:query body:body files:nil success:callback];
}

+ (void)put:(NSString *)url query:(id)aQuery body:(id)body files:(NSMutableDictionary *)files success:(void(^)(TinResponse *response))callback {
    [[[[self alloc] init] autorelease] put:url query:aQuery body:body files:files success:callback];
}

#pragma mark - Instance Methods

// ## Instance methods

#pragma mark GET

- (void)get:(NSString *)url success:(void(^)(TinResponse *response))callback {
    [self get:url query:nil success:callback];
}

- (void)get:(NSString *)url query:(id)query success:(void(^)(TinResponse *response))callback {
    [self performRequest:@"GET" withURL:url andQuery:query andBody:nil andSuccessCallback:callback];
}

#pragma mark POST

- (void)post:(NSString *)url query:(id)query success:(void(^)(TinResponse *response))callback {

}

- (void)post:(NSString *)url body:(NSDictionary *)bodyData success:(void(^)(TinResponse *response))callback {
    [self post:url query:nil body:bodyData success:callback];
}
- (void)post:(NSString *)url query:(id)query body:(NSDictionary *)bodyData success:(void(^)(TinResponse *response))callback {
    [self post:url query:query body:bodyData files:nil success:callback];
}
- (void)post:(NSString *)url query:(id)query body:(NSDictionary *)bodyData files:(NSMutableDictionary *)files success:(void(^)(TinResponse *response))callback {
    [self performRequest:@"POST" withURL:url andQuery:query andBody:bodyData andFiles:files andSuccessCallback:callback];
}

#pragma mark PUT

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

- (TinResponse *)performSynchronousRequest:(NSString *)method withURL:(NSString *)urlString andQuery:(id)query andBody:(id)body {
    
    // Format the URL to our known format, with query appended if needed.
    NSString *url = [self normalizeURL:urlString withQuery:query];
    
    __block ASIFormDataRequest *request = [ASIFormDataRequest requestWithURL:[NSURL URLWithString:url]];
    
	[request setRequestMethod:method];
    
	// Get the defaults or options (username, password, ...)
	[self setOptionsOnRequest:request];
    
    if (body) {
        [request setPostBody:[NSMutableData dataWithData:[[body description] dataUsingEncoding:NSUTF8StringEncoding]]];
    }
    
    [request startSynchronous];
    
    // Catch requests with an error, and bail out quickly
    if ([request error]) {
        return [self responseFromError:request];
	}

    return [self responseFromSuccess:request];
}

- (TinResponse *)responseFromError:(ASIHTTPRequest *)request {
    return [TinResponse responseWithRequest:request 
                                   response:nil 
                             parsedResponse:nil 
                               responseData:nil
                                 andHeaders:nil];
}

- (TinResponse *)responseFromSuccess:(ASIHTTPRequest *)request {
    // For now only fetching text data
    NSArray *parsedArray = nil;
    
    // Check if a parser is available, more info in [Tin+YAJL](Tin+YAJL.html) or [Tin+JSON](Tin+JSON.html)
    if ([self respondsToSelector:@selector(parseResponse:)]) {
        parsedArray = [self performSelector:@selector(parseResponse:) withObject:[request responseString]];
    }
    
    return [TinResponse responseWithRequest:request 
                                   response:[request responseString] 
                             parsedResponse:parsedArray 
                               responseData:[request responseData]
                                 andHeaders:[request responseHeaders]];
}

+ (ASIFormDataRequest *)requestWithURL:(NSString *)url {
    return [ASIFormDataRequest requestWithURL:[NSURL URLWithString:url]];
}


- (void)performRequest:(NSString *)method withURL:(NSString *)urlString andQuery:(id)query andBody:(id)body andSuccessCallback:(void(^)(TinResponse *response))returnSuccess {
    [self performRequest:method withURL:urlString andQuery:query andBody:body andFiles:nil andSuccessCallback:returnSuccess];
}

- (void)performRequest:(NSString *)method withURL:(NSString *)urlString andQuery:(id)query andBody:(id)body andFiles:(NSMutableDictionary *)files andSuccessCallback:(void(^)(TinResponse *response))returnSuccess {
    
    // Format the URL to our known format, with query appended if needed.
    NSString *url = [self normalizeURL:urlString withQuery:query];
    if (self.debugOutput) NSLog(@"Making request to: %@", url);
    
    __block ASIFormDataRequest *request = [Tin requestWithURL:url];

	[request setRequestMethod:method];

	// Get the defaults or options (username, password, ...)
	[self setOptionsOnRequest:request];
    [request setCompletionBlock:^{
        if (self.debugOutput) NSLog(@"\t Request succesfull");

        // For now only fetching text data
        NSArray *parsedArray = nil;
        
        // Check if a parser is available, more info in [Tin+YAJL](Tin+YAJL.html) or [Tin+JSON](Tin+JSON.html)
        if ([self respondsToSelector:@selector(parseResponse:)]) {
            parsedArray = [self performSelector:@selector(parseResponse:) withObject:[request responseString]];
        }
        
        TinResponse *response = [TinResponse responseWithRequest:request 
                                                        response:[request responseString] 
                                                  parsedResponse:parsedArray 
                                                    responseData:[request responseData]
                                                      andHeaders:[request responseHeaders]];
        if (returnSuccess) {
            dispatch_async(dispatch_get_main_queue(), ^{ 
                returnSuccess(response);
            });
        }
    }];
    
    [request setFailedBlock:^{
        if (self.debugOutput) NSLog(@"\t Request failed, error: %@", request.error);
		TinResponse *response = [TinResponse responseWithRequest:request 
                                                        response:nil 
                                                  parsedResponse:nil 
                                                    responseData:nil
                                                      andHeaders:nil];
        if (returnSuccess) {
            dispatch_async(dispatch_get_main_queue(), ^{ 
                returnSuccess(response);
            });
        }
    }];
    
    if (files) {
        [files enumerateKeysAndObjectsUsingBlock:^(id attribute_name, id file, BOOL *stop) {
            [request setFile:file forKey:attribute_name];
        }];
    }

    if (body) {
        if (self.contentType != nil && ![self.contentType isEqualToString:@""]) {
            [request addRequestHeader:@"Content-Type" value:self.contentType];
        }
        [request setPostBody:[NSMutableData dataWithData:[[body description] dataUsingEncoding:NSUTF8StringEncoding]]];
    }
    
    [request startAsynchronous];
}

// ## Utility methods

// Sets all specified options to the request
- (void)setOptionsOnRequest:(ASIHTTPRequest *)request {
	[request setUsername:self.username];
	[request setPassword:self.password];
	if (self.timeoutSeconds) {
		[request setTimeOutSeconds:self.timeoutSeconds];
	}
    if (self.headers) {
        [self.headers enumerateKeysAndObjectsUsingBlock:^(id key, id obj, BOOL *stop) {
            [request addRequestHeader:key value:obj];
        }];
    }
}


// Creates the `URL` which will be used in the actual request.
- (NSString *)normalizeURL:(NSString *)aURL withQuery:(id) query {
    NSString *urlString = @"";
    
    // Formats the URL
    if (self.baseURI && [self.baseURI length] > 0) {
        urlString = [NSString stringWithFormat:@"%@%@",[self prependHTTPtoURL:self.baseURI], aURL];
    } else {
        urlString = [self prependHTTPtoURL:aURL];
    } 
    
    // Adds the query
    if (query) urlString = [NSString stringWithFormat:@"%@%@", urlString, [self normalizeQuery:query]];
    
    return urlString;
}

// Prepends `http` to a string if needed.
- (NSString *)prependHTTPtoURL:(NSString *)aUrl {
    if([aUrl rangeOfString:@"^http(s?)://" options:NSRegularExpressionSearch].length > 0)
        return aUrl;
    
    return [NSString stringWithFormat:@"http://%@", aUrl];
}

- (NSString *)normalizeQuery:(id)query {
    if ([query isKindOfClass:[NSString class]]) 
        return [NSString stringWithFormat:@"?%@",query];
    if ([query isKindOfClass:[NSDictionary class]])
        return [(NSDictionary *) query toQueryString];
    return nil;
}
@end


