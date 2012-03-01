//
//  TinResponse.h
//  Tin
//
//  Created by Piet Jaspers on 13/06/11.
//  Copyright 2011 10to1. All rights reserved.
//

@class AFHTTPClient;

@interface TinResponse : NSObject
@property (nonatomic, retain) AFHTTPClient *client;
@property (nonatomic, retain) NSURL *URL;
@property (nonatomic, retain) id parsedResponse;
@property (nonatomic, retain) NSError *error;

+ (id)responseWithClient:(AFHTTPClient *)_client URL:(NSURL *)_URL parsedResponse:(id)_parsedResponse error:(NSError *)_error;
@end
