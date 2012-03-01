//
//  TinFile.h
//  Butane
//
//  Created by Jelle Vandebeeck on 06/12/11.
//  Copyright (c) 2011 10to1. All rights reserved.
//

@interface TinFile : NSObject
@property (nonatomic, retain) NSString *name;
@property (nonatomic, retain) NSString *mimeType;
@property (nonatomic, retain) NSData *data;

+ (id)fileWithData:(NSData *)aData;

+ (id)fileWithImage:(UIImage *)image;
+ (id)fileWithImageNamed:(NSString *)imageName;

+ (id)fileWithPNGImage:(UIImage *)image;
+ (id)fileWithPNGImageNamed:(NSString *)imageName;

+ (id)fileWithJPEGImage:(UIImage *)image;
+ (id)fileWithJPEGImageNamed:(NSString *)imageName;

+ (id)fileWithJPEGImage:(UIImage *)image compressionQuality:(CGFloat)compressionQuality;
+ (id)fileWithJPEGImageNamed:(NSString *)imageName compressionQuality:(CGFloat)compressionQuality;
@end