//
//  TinOAuthAccessTokenAuthenticator.h
//  Butane
//
//  Created by Tom Adriaenssen on 08/03/12.
//  Copyright (c) 2012 10to1, Interface Implementation. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Tin.h"

@interface TinOAuthAccessTokenAuthenticator : NSObject<TinAuthenticator>

+ (TinOAuthAccessTokenAuthenticator*)oauthAuthenticatorWithAccessToken:(NSString*)token;

@end
