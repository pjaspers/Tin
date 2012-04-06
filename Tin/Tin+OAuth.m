//
//  Tin+OAuth.m
//  Created by Tom Adriaenssen on 09/02/12.
//

#import "Tin+OAuth.h"
#import "TinOAuthAuthenticator.h"
#import "TinOAuthAccessTokenAuthenticator.h"

@implementation Tin (OAuth)

- (Tin *)signedWithClientKey:(NSString *)key clientSecret:(NSString *)secret {
    return [self signedWithClientKey:key clientSecret:secret method:TinOAuthHMAC_SHA1SignatureMethod];  
}

- (Tin*)signedWithClientKey:(NSString *)key clientSecret:(NSString *)secret method:(TinOAuthSignatureMethod)method {
    self.authenticator = [TinOAuthAuthenticator oauthAuthenticatorWithClientKey:key clientSecret:secret method:method];
    return self;
}

- (Tin*)signedWithClientKey:(NSString *)key clientSecret:(NSString *)secret token:(NSString*)token tokenSecret:(NSString*)tokenSecret method:(TinOAuthSignatureMethod)method {
    self.authenticator = [TinOAuthAuthenticator oauthAuthenticatorWithClientKey:key clientSecret:secret token:token tokenSecret:tokenSecret method:method];
    return self;
}

- (Tin*)signedWithAccessToken:(NSString*)token {
    self.authenticator = [TinOAuthAccessTokenAuthenticator oauthAuthenticatorWithAccessToken:token];
    return self;
}
@end
