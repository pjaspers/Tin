//
//  Tin.h
//  TouchPoint
//
//  Created by Piet Jaspers on 10/06/11.
//  Copyright 2011 10to1. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface Tin : NSObject {
    
}
+ (void)get:(NSString *)url success:(void(^)(NSArray *data))callback;

- (void)get:(NSString *)url success:(void(^)(NSArray *data))callback;
- (void)performRequest:(NSString *)method withURL:(NSString *)urlString andQuery:(NSDictionary *)query andBody:(NSDictionary *)body andSuccessCallback:(void(^)(NSArray *data))returnSuccess andErrorCallback:(void(^)(NSError *error))returnError;
@end
