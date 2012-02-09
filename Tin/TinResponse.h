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
@property (nonatomic, retain) NSError * error;
@property (nonatomic, retain) id body;

+ (id)responseWithClient:(AFHTTPClient *)_client URL:(NSURL *)_URL body:(id)_body error:(NSError *)_error;
@end
