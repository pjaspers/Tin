//
//  TinFile.m
//  Butane
//
//  Created by Jelle Vandebeeck on 06/12/11.
//  Copyright (c) 2011 10to1. All rights reserved.
//

#import "TinFile.h"

#define kDefaultCompressionQuality 1.0

@implementation TinFile
@synthesize name;
@synthesize mimeType;
@synthesize data;

#pragma mark - Data

+ (id)fileWithData:(NSData *)aData {
    TinFile *_file = [[[TinFile alloc] init] autorelease];
    _file.data = aData;
    
    return _file;
}

#pragma mark - Images

+ (id)fileWithImage:(UIImage *)image {
    return [self fileWithJPEGImage:image];
}

+ (id)fileWithImageNamed:(NSString *)imageName {
    TinFile *_file = [self fileWithImage:[UIImage imageNamed:imageName]];
    _file.name = imageName;
    
    return _file;
}

+ (id)fileWithPNGImage:(UIImage *)image {
    TinFile *_file = [[[TinFile alloc] init] autorelease];
    
    _file.data = UIImagePNGRepresentation(image);
    _file.mimeType = @"image/png";
    
    return _file;
}

+ (id)fileWithPNGImageNamed:(NSString *)imageName {
    TinFile *_file = [self fileWithPNGImage:[UIImage imageNamed:imageName]];
    _file.name = imageName;
    
    return _file;
}

+ (id)fileWithJPEGImage:(UIImage *)image {    
    return [self fileWithJPEGImage:image compressionQuality:kDefaultCompressionQuality];
}

+ (id)fileWithJPEGImageNamed:(NSString *)imageName {
    TinFile *_file = [self fileWithJPEGImage:[UIImage imageNamed:imageName]];
    _file.name = imageName;
    
    return _file;
}

+ (id)fileWithJPEGImage:(UIImage *)image compressionQuality:(CGFloat)compressionQuality {
    TinFile *_file = [[[TinFile alloc] init] autorelease];
    
    _file.data = UIImageJPEGRepresentation(image, compressionQuality);
    _file.mimeType = @"image/jpeg";
    
    return _file;
}

+ (id)fileWithJPEGImageNamed:(NSString *)imageName compressionQuality:(CGFloat)compressionQuality {
    TinFile *_file = [self fileWithJPEGImage:[UIImage imageNamed:imageName] compressionQuality:compressionQuality];
    _file.name = imageName;
    
    return _file;
}

@end
