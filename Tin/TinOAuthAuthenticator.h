//
//  TinOAuthAuthenticator.h
//  Created by Tom Adriaenssen on 09/02/12.
//

#import <Foundation/Foundation.h>
#import "Tin.h"

typedef enum {
    TinOAuthPlaintextSignatureMethod,
    TinOAuthHMAC_SHA1SignatureMethod,
} TinOAuthSignatureMethod;


@interface TinOAuthAuthenticator : NSObject<TinAuthenticator>

+ (TinOAuthAuthenticator*)oauthAuthenticatorWithClientKey:(NSString*)key clientSecret:(NSString*)secret method:(TinOAuthSignatureMethod)method;
+ (TinOAuthAuthenticator*)oauthAuthenticatorWithClientKey:(NSString*)key clientSecret:(NSString*)secret token:(NSString*)token tokenSecret:(NSString*)tokenSecret method:(TinOAuthSignatureMethod)method;
+ (TinOAuthAuthenticator*)oauthAuthenticatorWithClientKey:(NSString*)key clientSecret:(NSString*)secret token:(NSString*)token tokenSecret:(NSString*)tokenSecret method:(TinOAuthSignatureMethod)method verifier:(NSString *)verifier;

@end

