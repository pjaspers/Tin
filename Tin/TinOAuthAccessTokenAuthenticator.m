//
//  TinOAuthAccessTokenAuthenticator.m
//  Butane
//
//  Created by Tom Adriaenssen on 08/03/12.
//  Copyright (c) 2012 10to1, Interface Implementation. All rights reserved.
//

#import "TinOAuthAccessTokenAuthenticator.h"
#import "AFHTTPClient.h"

@interface TinOAuthAccessTokenAuthenticator () {
}

@property (nonatomic, retain) NSString* accessToken;

- (id)initWithAccessToken:(NSString*)token;

@end

@implementation TinOAuthAccessTokenAuthenticator

@synthesize accessToken = _accessToken;

- (id)initWithAccessToken:(NSString*)token {
    if ((self = [super init])) {
        self.accessToken = token;
    }
    return self;
}

- (void)dealloc {
    self.accessToken = nil;
    [super dealloc];
}

- (NSString *)tin:(Tin *)tin applyAuthenticationOnClient:(AFHTTPClient *)client withMethod:(NSString *)method url:(NSString *)url query:(NSString *)query 
{ 
    [client setDefaultHeader:@"Authorization" value:[@"OAuth " stringByAppendingString:_accessToken]];
    return query;
}


+ (TinOAuthAccessTokenAuthenticator*)oauthAuthenticatorWithAccessToken:(NSString*)token {
    return [[[TinOAuthAccessTokenAuthenticator alloc] initWithAccessToken:token] autorelease];
    
}


@end
