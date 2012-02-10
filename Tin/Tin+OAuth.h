//
//  Tin+OAuth.h
//  Faering
//
//  Created by Tom Adriaenssen on 09/02/12.
//

#import "Tin.h"
#import "TinOAuthAuthenticator.h"

@interface Tin (OAuth)

- (Tin *)signedWithClientKey:(NSString *)key clientSecret:(NSString *)secret;
- (Tin*)signedWithClientKey:(NSString *)key clientSecret:(NSString *)secret method:(TinOAuthSignatureMethod)method;
- (Tin*)signedWithClientKey:(NSString *)key clientSecret:(NSString *)secret token:(NSString*)token tokenSecret:(NSString*)tokenSecret method:(TinOAuthSignatureMethod)method;

@end
