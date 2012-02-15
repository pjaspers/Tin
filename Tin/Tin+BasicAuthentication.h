//
//  Tin+BasicAuthentication.h
//  Created by Tom Adriaenssen on 09/02/12.
//

#import "Tin.h"

@interface Tin (BasicAuthentication)

- (Tin*)authenticateWithUsername:(NSString*)username password:(NSString*)password;

@end
