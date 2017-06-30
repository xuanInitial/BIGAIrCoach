//
//  ZYKMD5.h
//  加密算法
//
//  Created by on 14-4-26.
//  Copyright (c)  . All rights reserved.
//


#import <Foundation/Foundation.h>

@interface ZYKMD5 : NSObject
//16位MD5加密方式
+ (NSString *)getMd5_16Bit_String:(NSString *)srcString isUppercase:(BOOL)isUppercase;
//32位MD5加密方式
+ (NSString *)getMd5_32Bit_String:(NSString *)srcString isUppercase:(BOOL)isUppercase;
//sha1加密方式
+ (NSString *)getSha1String:(NSString *)srcString;
//sha256加密方式
+ (NSString *)getSha256String:(NSString *)srcString;
//sha384加密方式
+ (NSString *)getSha384String:(NSString *)srcString;
//sha512加密方式
+ (NSString*) getSha512String:(NSString*)srcString;
@end
