//
//  TinBasicAuthenticator.m
//  Created by Tom Adriaenssen on 09/02/12.
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

- (NSString *)tin:(Tin *)tin applyAuthenticationOnClient:(AFHTTPClient *)client withMethod:(NSString*)method url:(NSString *)url query:(NSString *)query {
    if (self.username && self.password && ![self.username isEqualToString:@""] && ![self.password isEqualToString:@""]) {
        [client setAuthorizationHeaderWithUsername:self.username password:self.password];
    }
    return query;
}

+ (TinBasicAuthenticator*)basicAuthenticatorWithUsername:(NSString*)username password:(NSString*)password {
    return [[[TinBasicAuthenticator alloc] initWithUsername:username password:password] autorelease];
}

@end
