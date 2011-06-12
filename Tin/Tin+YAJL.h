//
//  Tin+YAJL.h
//  TouchPoint
//
//  Created by Piet Jaspers on 10/06/11.
//  Copyright 2011 10to1. All rights reserved.
//

#import "Tin.h"

/*
 * This class implements the rather excellent [yajl-objc](https://github.com/gabriel/yajl-objc)
 * which will parse all responses Tin receives and return then as an `NSArray`.
 */
@interface Tin (YAJL)

- (NSArray *)parseResponse:(NSString *)responseString;
@end
