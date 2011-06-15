//
//  Tin+JSON.h
//  TouchPoint
//
//  Created by Jelle Vandebeeck on 15/06/11.
//  Copyright 2011 10to1. All rights reserved.
//

#import "Tin.h"

/*
 * This class implements the JSON-framework (http://stig.github.com/json-framework)
 * which will parse all responses Tin receives and return then as an `NSArray`.
 */
@interface Tin (JSON)

- (NSArray *)parseResponse:(NSString *)responseString;
@end
