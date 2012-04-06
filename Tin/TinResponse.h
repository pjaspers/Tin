//
//  TinResponse.h
//  Tin
//
//  Created by Piet Jaspers on 13/06/11.
//  Copyright 2011 10to1. All rights reserved.
//

@class AFHTTPRequestOperation;

typedef enum {
    TinFormURLParseMethod,
    TinJSONParseMethod,
} TinResponseParseMethod;

@interface TinResponse : NSObject

//@property (nonatomic, retain) AFHTTPClient *client;
@property (nonatomic, retain, readonly) NSURL *URL;
@property (nonatomic, retain, readonly) id parsedResponse;
@property (nonatomic, retain, readonly) NSString* bodyString;
@property (nonatomic, retain, readonly) NSURLRequest *httpRequest;
@property (nonatomic, retain, readonly) NSHTTPURLResponse *httpResponse;
@property (nonatomic, retain) NSError * error;
@property (nonatomic, retain) id body;
@property (nonatomic, assign) TinResponseParseMethod parseMethod;


+ (id)responseWithOperation:(AFHTTPRequestOperation *)operation body:(id)body error:(NSError *)error;
@end
