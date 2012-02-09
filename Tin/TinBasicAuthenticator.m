//
//  TinBasicAuthenticator.m
//  Faering
//
//  Created by Tom Adriaenssen on 09/02/12.
//  Copyright (c) 2012 Adriaenssen BVBA. All rights reserved.
//

#import "TinBasicAuthenticator.h"
#import "AFHTTPClient.h"

@implementation TinBasicAuthenticator

@synthesize password = _password;
@synthesize username = _username;

- (id)initWithUsername:(NSString*)username password:(NSString*)password {
    if ((self = [self init])) {
        self.username = username;
        self.password = password;
    }
    return self;
}

- (void)dealloc {
    self.password = nil;
    self.username = nil;
    
    [super dealloc];
}

- (void)tin:(Tin *)tin setOptionsOnClient:(AFHTTPClient *)client {
    if (self.username && self.password && ![self.username isEqualToString:@""] && ![self.password isEqualToString:@""]) {
        [client setAuthorizationHeaderWithUsername:self.username password:self.password];
    }
}

+ (TinBasicAuthenticator*)basicAuthenticatorWithUsername:(NSString*)username password:(NSString*)password {
    return [[[TinBasicAuthenticator alloc] initWithUsername:username password:password] autorelease];
}

@end
