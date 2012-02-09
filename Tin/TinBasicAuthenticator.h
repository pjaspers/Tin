//
//  TinBasicAuthenticator.h
//  Faering
//
//  Created by Tom Adriaenssen on 09/02/12.
//  Copyright (c) 2012 Adriaenssen BVBA. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Tin.h"

@interface TinBasicAuthenticator : NSObject<TinAuthenticator>

@property (nonatomic, retain) NSString *username;
@property (nonatomic, retain) NSString *password;

- (id)initWithUsername:(NSString*)username password:(NSString*)password;

+ (TinBasicAuthenticator*)basicAuthenticatorWithUsername:(NSString*)username password:(NSString*)password;

@end
