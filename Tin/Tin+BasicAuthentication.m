//
//  Tin+BasicAuthentication.m
//  Created by Tom Adriaenssen on 09/02/12.
//

#import "Tin+BasicAuthentication.h"
#import "TinBasicAuthenticator.h"

@implementation Tin (BasicAuthentication)

- (Tin*)authenticateWithUsername:(NSString*)username password:(NSString*)password {
    self.authenticator = [TinBasicAuthenticator basicAuthenticatorWithUsername:username password:password];
    return self;
}

@end
