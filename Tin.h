//
//  Tin.h
//  TouchPoint
//
//  Created by Piet Jaspers on 10/06/11.
//  Copyright 2011 10to1. All rights reserved.
//

@class Tin;
@class TinResponse;
@class AFHTTPClient;

@protocol TinDelegate <NSObject>

- (void)willBeginRequest:(NSURLRequest*)request;
- (void)didEndRequest:(NSURLRequest*)request withResponse:(TinResponse*)response;

@end


@protocol TinAuthenticator <NSObject>

@required
- (NSString *)tin:(Tin *)tin applyAuthenticationOnClient:(AFHTTPClient *)client withMethod:(NSString*)method url:(NSString *)url query:(NSString *)query;

@end


@interface Tin : NSObject

// This can be used to avoid a lot of repetitive typing.
// e.g.
//
//      [Tin get:@"http://apple.com/products/ipad" success:nil];
//
// can become
//
//      Tin *tin = [[Tin alloc] init];
//      tin.baseURI = @"apple.com";
//      [tin get:@"/products/ipad/" success:nil];
//
// Especially useful if you keep the instance somewhere handy.
@property (nonatomic, retain) NSString *baseURI;
@property (nonatomic, retain) NSString *contentType;
@property (nonatomic, retain) NSString *accept;
@property (nonatomic, retain) NSDictionary *headers;
@property (nonatomic, assign) NSTimeInterval timeoutSeconds;
@property (nonatomic, assign) BOOL debugOutput;
@property (nonatomic, retain) id<TinAuthenticator> authenticator;
@property (nonatomic, retain) id<TinDelegate> delegate;

+ (TinResponse *)get:(NSString *)url;
+ (TinResponse *)get:(NSString *)url query:(id)query;

+ (TinResponse *)post:(NSString *)url query:(id)aQuery;
+ (TinResponse *)post:(NSString *)url body:(NSDictionary *)bodyData;
+ (TinResponse *)post:(NSString *)url query:(id)aQuery body:(NSDictionary *)bodyData;
+ (TinResponse *)post:(NSString *)url query:(id)aQuery body:(NSDictionary *)bodyData files:(NSMutableDictionary *)files;

+ (TinResponse *)put:(NSString *)url query:(id)aQuery;
+ (TinResponse *)put:(NSString *)url body:(id)body;
+ (TinResponse *)put:(NSString *)url query:(id)aQuery body:(id)body;
+ (TinResponse *)put:(NSString *)url query:(id)aQuery body:(id)body files:(NSMutableDictionary *)files;

+ (TinResponse *)delete:(NSString *)url query:(id)aQuery;
+ (TinResponse *)delete:(NSString *)url body:(id)body;
+ (TinResponse *)delete:(NSString *)url query:(id)aQuery body:(id)body;

- (TinResponse *)get:(NSString *)url;
- (TinResponse *)get:(NSString *)url query:(id)query;
- (NSURLRequest*)requestGet:(NSString *)url query:(id)query;

- (TinResponse *)post:(NSString *)url query:(id)aQuery;
- (TinResponse *)post:(NSString *)url body:(NSDictionary *)bodyData;
- (TinResponse *)post:(NSString *)url query:(id)aQuery body:(NSDictionary *)bodyData;
- (TinResponse *)post:(NSString *)url query:(id)aQuery body:(NSDictionary *)bodyData files:(NSMutableDictionary *)files;
- (NSURLRequest*)requestPost:(NSString *)url query:(id)aQuery body:(NSDictionary *)bodyData files:(NSMutableDictionary *)files;

- (TinResponse *)put:(NSString *)url query:(id)aQuery;
- (TinResponse *)put:(NSString *)url body:(id)body;
- (TinResponse *)put:(NSString *)url query:(id)aQuery body:(id)body;
- (TinResponse *)put:(NSString *)url query:(id)aQuery body:(id)body files:(NSMutableDictionary *)files;
- (NSURLRequest *)requestPut:(NSString *)url query:(id)aQuery body:(id)body files:(NSMutableDictionary *)files;

- (TinResponse *)delete:(NSString *)url query:(id)aQuery;
- (TinResponse *)delete:(NSString *)url body:(id)body;
- (TinResponse *)delete:(NSString *)url query:(id)aQuery body:(id)body;
- (NSURLRequest *)requestDelete:(NSString *)url query:(id)aQuery body:(id)body;

+ (void)get:(NSString *)url success:(void(^)(TinResponse *response))callback;
+ (void)get:(NSString *)url query:(id)query success:(void(^)(TinResponse *response))callback;

+ (void)post:(NSString *)url query:(id)aQuery success:(void(^)(TinResponse *response))callback ;
+ (void)post:(NSString *)url body:(NSDictionary *)bodyData success:(void(^)(TinResponse *response))callback ;
+ (void)post:(NSString *)url query:(id)aQuery body:(NSDictionary *)bodyData success:(void(^)(TinResponse *response))callback ;
+ (void)post:(NSString *)url query:(id)aQuery body:(NSDictionary *)bodyData files:(NSMutableDictionary *)files success:(void(^)(TinResponse *response))callback;

+ (void)put:(NSString *)url query:(id)aQuery success:(void(^)(TinResponse *response))callback ;
+ (void)put:(NSString *)url body:(id)body success:(void(^)(TinResponse *response))callback ;
+ (void)put:(NSString *)url query:(id)aQuery body:(id)body success:(void(^)(TinResponse *response))callback ;
+ (void)put:(NSString *)url query:(id)aQuery body:(id)body files:(NSMutableDictionary *)files success:(void(^)(TinResponse *response))callback;

+ (void)delete:(NSString *)url query:(id)aQuery success:(void(^)(TinResponse *response))callback ;
+ (void)delete:(NSString *)url body:(id)body success:(void(^)(TinResponse *response))callback ;
+ (void)delete:(NSString *)url query:(id)aQuery body:(id)body success:(void(^)(TinResponse *response))callback ;

- (void)get:(NSString *)url success:(void(^)(TinResponse *response))callback ;
- (void)get:(NSString *)url query:(id)query success:(void(^)(TinResponse *response))callback ;

- (void)post:(NSString *)url body:(NSDictionary *)bodyData success:(void(^)(TinResponse *response))callback;
- (void)post:(NSString *)url query:(id)aQuery body:(id)bodyData success:(void(^)(TinResponse *response))callback ;
- (void)post:(NSString *)url query:(id)query body:(NSDictionary *)bodyData files:(NSMutableDictionary *)files success:(void(^)(TinResponse *response))callback;

- (void)put:(NSString *)url query:(id)aQuery success:(void(^)(TinResponse *response))callback;
- (void)put:(NSString *)url body:(id)body success:(void(^)(TinResponse *response))callback;
- (void)put:(NSString *)url query:(id)aQuery body:(id)body success:(void(^)(TinResponse *response))callback;
- (void)put:(NSString *)url query:(id)query body:(id)body files:(NSMutableDictionary *)files success:(void(^)(TinResponse *response))callback;

- (void)delete:(NSString *)url query:(id)aQuery success:(void(^)(TinResponse *response))callback;
- (void)delete:(NSString *)url body:(id)body success:(void(^)(TinResponse *response))callback;
- (void)delete:(NSString *)url query:(id)aQuery body:(id)body success:(void(^)(TinResponse *response))callback;

+ (NSDictionary*)splitQuery:(id)query;
+ (NSString *)decodeFromURL:(NSString*)source;

@end
