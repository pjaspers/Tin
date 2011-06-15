//
//  Tin.h
//  TouchPoint
//
//  Created by Piet Jaspers on 10/06/11.
//  Copyright 2011 10to1. All rights reserved.
//

#import <Foundation/Foundation.h>

@class TinResponse;

@interface Tin : NSObject {
    
}
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
@property (nonatomic, retain) NSString *username;
@property (nonatomic, retain) NSString *password;

+ (void)get:(NSString *)url success:(void(^)(TinResponse *response))callback;
+ (void)get:(NSString *)url query:(id)query success:(void(^)(TinResponse *response))callback;

+ (void)post:(NSString *)url query:(id)aQuery success:(void(^)(TinResponse *response))callback ;
+ (void)post:(NSString *)url body:(NSDictionary *)bodyData success:(void(^)(TinResponse *response))callback ;
+ (void)post:(NSString *)url query:(id)aQuery body:(NSDictionary *)bodyData success:(void(^)(TinResponse *response))callback ;

+ (void)put:(NSString *)url query:(id)aQuery success:(void(^)(TinResponse *response))callback ;
+ (void)put:(NSString *)url body:(id)body success:(void(^)(TinResponse *response))callback ;
+ (void)put:(NSString *)url query:(id)aQuery body:(id)body success:(void(^)(TinResponse *response))callback ;

- (void)get:(NSString *)url success:(void(^)(TinResponse *response))callback ;
- (void)get:(NSString *)url query:(id)query success:(void(^)(TinResponse *response))callback ;

- (void)post:(NSString *)url body:(NSDictionary *)bodyData success:(void(^)(TinResponse *response))callback ;
- (void)post:(NSString *)url query:(id)aQuery body:(NSDictionary *)bodyData success:(void(^)(TinResponse *response))callback ;

- (void)put:(NSString *)url query:(id)aQuery success:(void(^)(TinResponse *response))callback ;
- (void)put:(NSString *)url body:(id)body success:(void(^)(TinResponse *response))callback ;
- (void)put:(NSString *)url query:(id)aQuery body:(id)body success:(void(^)(TinResponse *response))callback ;



- (void)performRequest:(NSString *)method withURL:(NSString *)urlString andQuery:(id)query andBody:(id)body andSuccessCallback:(void(^)(TinResponse *response))returnSuccess;
@end
