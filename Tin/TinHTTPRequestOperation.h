//
//  TinHTTPRequestOperation.h
//  Luan
//
//  Created by Jelle Vandebeeck on 18/06/12.
//  Copyright (c) 2012 10to1. All rights reserved.
//

#import "AFHTTPRequestOperation.h"

@interface TinHTTPRequestOperation : AFHTTPRequestOperation
@property (nonatomic, assign) BOOL disableAutoRedirect; // When receiving an redirect from the server, don't use it.
@end
