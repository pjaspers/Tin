//
//  Tin+BasicAuthentication.m
//  Faering
//
//  Created by Tom Adriaenssen on 09/02/12.
//  Copyright (c) 2012 Adriaenssen BVBA. All rights reserved.
//

#import "Tin+BasicAuthentication.h"
#import "TinBasicAuthenticator.h"

@implementation Tin (BasicAuthentication)

- (Tin*)authenticateWithUsername:(NSString*)username password:(NSString*)password {
    self.authenticator = [TinBasicAuthenticator basicAuthenticatorWithUsername:username password:password];
    return self;
}

@end
