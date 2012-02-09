//
//  Tin+BasicAuthentication.h
//  Faering
//
//  Created by Tom Adriaenssen on 09/02/12.
//  Copyright (c) 2012 Adriaenssen BVBA. All rights reserved.
//

#import "Tin.h"

@interface Tin (BasicAuthentication)

- (Tin*)authenticateWithUsername:(NSString*)username password:(NSString*)password;

@end
