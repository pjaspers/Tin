//
//  TinHTTPRequestOperation.m
//  Luan
//
//  Created by Jelle Vandebeeck on 18/06/12.
//  Copyright (c) 2012 10to1. All rights reserved.
//

#import "TinHTTPRequestOperation.h"

@implementation TinHTTPRequestOperation
@synthesize disableAutoRedirect=_disableAutoRedirect;

- (NSURLRequest *)connection: (NSURLConnection *)inConnection willSendRequest: (NSURLRequest *)inRequest redirectResponse:(NSURLResponse *)inRedirectResponse {
    if (!inRedirectResponse && !_disableAutoRedirect) return inRequest;
    
    NSMutableURLRequest *request = [self.request mutableCopy];
    request.URL = inRequest.URL; 
    return request;
}
    
@end