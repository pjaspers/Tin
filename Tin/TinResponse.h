//
//  TinResponse.h
//  Tin
//
//  Created by Piet Jaspers on 13/06/11.
//  Copyright 2011 10to1. All rights reserved.
//

#import <Foundation/Foundation.h>
@class ASIHTTPRequest;

@interface TinResponse : NSObject {
    
}

@property (nonatomic, retain) ASIHTTPRequest        *request;
@property (nonatomic, retain) NSString              *response;
@property (nonatomic, retain) NSData                *responseData;
@property (nonatomic, retain) NSArray               *parsedResponse;
@property (nonatomic, retain) NSDictionary          *headers;
@property (nonatomic, readonly) NSError				*error;

+ (id)responseWithRequest:(ASIHTTPRequest *)_request response:(NSString *)_responseString parsedResponse:(NSArray *)_parsedResponse responseData:(NSData *)_responseData andHeaders:(NSDictionary *)_headers;

@end
