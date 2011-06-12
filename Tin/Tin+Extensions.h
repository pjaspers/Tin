//
//  Tin+Extensions.h
//  Tin
//
//  Created by Piet Jaspers on 12/06/11.
//  Copyright 2011 10to1. All rights reserved.
//

@interface NSDictionary (Tin)
- (NSString *)toQueryString;
- (NSString *)toQueryString:(NSString *)aNamespace;
@end