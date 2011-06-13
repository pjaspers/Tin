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

// Contains additions to default objects to aid Tin
#import "Tin+Extensions.h"

@interface Tin (Utilities)
- (NSString *)normalizeURL:(NSString *)aURL withQuery:(NSString *)query;
- (NSString *)prependHTTPtoURL:(NSString *)aUrl;
- (NSString *)normalizeQuery:(id)query;
@end
    
@implementation Tin
@synthesize baseURI;

#pragma mark - Class methods

#pragma mark GET
// ## `GET` requests
//
// Methods for use with `GET` requests.
//
//      [Tin get:@"http://url.com/" success:(NSDictionary *data) { NSLog(@"Response %@", data)}];
//

+ (void)get:(NSString *)url success:(void(^)(NSArray *data))callback error:(void(^)(NSError *error))errorCallback {
    [self get:url query:nil success:callback error:errorCallback];
}

+ (void)get:(NSString *)url query:(id)query success:(void(^)(NSArray *data))callback error:(void(^)(NSError *error))errorCallback {
    [[[[self alloc] init] autorelease] get:url query:query success:callback error:errorCallback];
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

+ (void)post:(NSString *)url query:(id)query success:(void(^)(NSArray *data))callback error:(void(^)(NSError *error))errorCallback {
    [self post:url query:query body:nil success:callback error:errorCallback];
}

+ (void)post:(NSString *)url body:(id)body success:(void(^)(NSArray *data))callback error:(void(^)(NSError *error))errorCallback {
    [self post:url query:nil body:body success:callback error:errorCallback];
}

+ (void)post:(NSString *)url query:(id)query body:(id)body success:(void(^)(NSArray *data))callback error:(void(^)(NSError *error))errorCallback{
    [[[[self alloc] init] autorelease] post:url query:query body:body success:callback error:errorCallback];
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

+ (void)put:(NSString *)url query:(id)query success:(void(^)(NSArray *data))callback error:(void(^)(NSError *error))errorCallback {
    [self put:url query:query body:nil success:callback error:errorCallback];
}

+ (void)put:(NSString *)url body:(id)body success:(void(^)(NSArray *data))callback error:(void(^)(NSError *error))errorCallback {
    [self put:url query:nil body:body success:callback error:errorCallback];
}

+ (void)put:(NSString *)url query:(id)query body:(id)body success:(void(^)(NSArray *data))callback error:(void(^)(NSError *error))errorCallback{
    [[[[self alloc] init] autorelease] put:url query:query body:body success:callback error:errorCallback];
}

#pragma mark - Instance Methods

// ## Instance methods

#pragma mark GET

- (void)get:(NSString *)url success:(void(^)(NSArray *data))callback error:(void(^)(NSError *error))errorCallback {
    [self get:url query:nil success:callback error:errorCallback];
}

- (void)get:(NSString *)url query:(id)query success:(void(^)(NSArray *data))callback error:(void(^)(NSError *error))errorCallback {
    [self performRequest:@"GET" withURL:url andQuery:query andBody:nil andSuccessCallback:callback andErrorCallback:errorCallback];
}

#pragma mark POST

- (void)post:(NSString *)url query:(id)query success:(void(^)(NSArray *data))callback error:(void(^)(NSError *error))errorCallback {

}

- (void)post:(NSString *)url body:(NSDictionary *)bodyData success:(void(^)(NSArray *data))callback error:(void(^)(NSError *error))errorCallback {
    [self post:url query:nil body:bodyData success:callback error:errorCallback];
}
- (void)post:(NSString *)url query:(id)query body:(NSDictionary *)bodyData success:(void(^)(NSArray *data))callback error:(void(^)(NSError *error))errorCallback {
    [self performRequest:@"POST" withURL:url andQuery:query andBody:bodyData andSuccessCallback:callback andErrorCallback:errorCallback];
}

#pragma mark PUT

- (void)put:(NSString *)url query:(id)query success:(void(^)(NSArray *data))callback error:(void(^)(NSError *error))errorCallback {
    [self put:url query:query body:nil success:callback error:errorCallback];
}

- (void)put:(NSString *)url body:(id)body success:(void(^)(NSArray *data))callback error:(void(^)(NSError *error))errorCallback {
    [self put:url query:nil body:body success:callback error:errorCallback];
}

- (void)put:(NSString *)url query:(id)query body:(id)body success:(void(^)(NSArray *data))callback error:(void(^)(NSError *error))errorCallback{
    [self performRequest:@"PUT" withURL:url andQuery:query andBody:body andSuccessCallback:callback andErrorCallback:errorCallback];
}

- (void)performRequest:(NSString *)method withURL:(NSString *)urlString andQuery:(id)query andBody:(id)body andSuccessCallback:(void(^)(NSArray *data))returnSuccess andErrorCallback:(void(^)(NSError *error))returnError {
    
    // Format the URL to our known format, with query appended if needed.
    NSString *url = [self normalizeURL:urlString withQuery:query];
    
    __block ASIFormDataRequest *request = [ASIFormDataRequest requestWithURL:[NSURL URLWithString:url]];
    [request setRequestMethod:method];
   
    if (body) {
        [request setPostBody:[NSMutableData dataWithData:[[body description] dataUsingEncoding:NSUTF8StringEncoding]]];
    }
    
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
        NSLog(@"Error %@", error);
        if(returnError) returnError(error);
    }];
    [request startAsynchronous];
}

// ## Utility methods

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


