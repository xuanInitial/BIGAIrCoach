//
//  CommonUtil.h
//  myframe
//
//  Created by iMac on 16/1/8.
//  Copyright © 2016年 test. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AFNetworking.h"

@interface CommonUtil : NSObject

/**
 * 下载文件
 *
 * @param string urlStr  请求文件地址
 * @param string fileURL 保存地址
 * @param string aFileName 文件名
 * @param nsurl  filePath  文件地址（完整的）
 */

+ (void)sessionDownloadWithUrl:(NSString *)urlStr fileName:(NSInteger )aFileName success:(void (^)(NSDictionary*allHeaders, NSURL *fileURL))success fail:(void (^)(NSURLResponse *response, NSURL *filePath, NSError *error))fail;


+ (void)KownSessionDownloadWithUrl:(NSString *)urlStr fileName:(NSInteger )aFileName success:(void (^)(NSDictionary*allHeaders, NSURL *fileURL))success fail:(void (^)(NSURLResponse *response, NSURL *filePath, NSError *error))fail;

@end
