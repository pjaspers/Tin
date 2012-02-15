//
//  TinResponse.h
//  Tin
//
//  Created by Piet Jaspers on 13/06/11.
//  Copyright 2011 10to1. All rights reserved.
//

@class AFHTTPClient;

typedef enum {
    TinFormURLParseMethod,
    TinJSONParseMethod,
} TinResponseParseMethod;

@interface TinResponse : NSObject

@property (nonatomic, retain) AFHTTPClient *client;
@property (nonatomic, retain) NSURL *URL;
@property (nonatomic, retain, readonly) id parsedResponse;
@property (nonatomic, retain, readonly) NSString* bodyString;
@property (nonatomic, retain) NSError * error;
@property (nonatomic, retain) id body;
@property (nonatomic, assign) TinResponseParseMethod parseMethod;


+ (id)responseWithClient:(AFHTTPClient *)_client URL:(NSURL *)_URL body:(id)_body error:(NSError *)_error;
@end
