//
//  CommonUtil.m
//  myframe
//
//  Created by iMac on 16/1/8.
//  Copyright © 2016年 test. All rights reserved.
//

#import "CommonUtil.h"
#import "BusinessAirCoach.h"
#import "DownLoadManagerSingle.h"
@implementation CommonUtil

+ (void)sessionDownloadWithUrl:(NSString *)urlStr fileName:(NSInteger )aFileName success:(void (^)(NSDictionary*allHeaders, NSURL *fileURL))success fail:(void (^)(NSURLResponse *response, NSURL *filePath, NSError *error))fail{
    
     NSString *urlString = [urlStr stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSURL *url = [NSURL URLWithString:urlString];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
   
    AFURLSessionManager *manager = [DownLoadManagerSingle sharedManager];
    
    
    NSURLSessionDownloadTask *task = [manager downloadTaskWithRequest:request progress:nil destination:^NSURL *(NSURL *targetPath, NSURLResponse *response) {
        // 指定下载文件保存的路径
        NSLog(@"%@ %@", targetPath, response.suggestedFilename);
        NSString *caches = [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) lastObject];
        NSLog(@"%@",caches);
        // 将下载文件保存在缓存路径中
        NSString *archivingPath = [caches stringByAppendingPathComponent:[NSString stringWithFormat:@"%@UserVideo",[BusinessAirCoach getTel]]];
        //判断createPath路径文件夹是否已存在，此处createPath为需要新建的文件夹的绝对路径
        if ([[NSFileManager defaultManager] fileExistsAtPath:archivingPath])
        {
            
        }
        else
        {
         //创建文件夹
         [[NSFileManager defaultManager] createDirectoryAtPath:archivingPath withIntermediateDirectories:YES attributes:nil error:nil];
        }
        NSLog(@"%@",archivingPath);

        //拼接文件全路径
        NSString *fullpath = [archivingPath stringByAppendingPathComponent:[NSString stringWithFormat:@"%ld.mp4",(long)aFileName]];
        NSURL *filePathUrl = [NSURL fileURLWithPath:fullpath];
        
    
        NSDictionary *allHeaders = request.allHTTPHeaderFields;
        
        if (success) {
            success(allHeaders,filePathUrl);
        }
        
       
        return filePathUrl;
        
    } completionHandler:^(NSURLResponse *response, NSURL *filePath, NSError *error) {
        NSLog(@"%@ %@", filePath, error);
        if (fail) {
            fail(response,filePath,error);
        }
    }];
    
    [task resume];
}

+ (void)KownSessionDownloadWithUrl:(NSString *)urlStr fileName:(NSInteger )aFileName success:(void (^)(NSDictionary*allHeaders, NSURL *fileURL))success fail:(void (^)(NSURLResponse *response, NSURL *filePath, NSError *error))fail{
    
    NSString *urlString = [urlStr stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSURL *url = [NSURL URLWithString:urlString];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    
    AFURLSessionManager *manager = [DownLoadManagerSingle sharedManager];
    
    
    NSURLSessionDownloadTask *task = [manager downloadTaskWithRequest:request progress:nil destination:^NSURL *(NSURL *targetPath, NSURLResponse *response) {
        // 指定下载文件保存的路径
        NSLog(@"%@ %@", targetPath, response.suggestedFilename);
        NSString *caches = [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) lastObject];
        NSLog(@"%@",caches);
        // 将下载文件保存在缓存路径中
        NSString *archivingPath = [caches stringByAppendingPathComponent:[NSString stringWithFormat:@"%@KnowUserVideo",[BusinessAirCoach getTel]]];
        //判断createPath路径文件夹是否已存在，此处createPath为需要新建的文件夹的绝对路径
        if ([[NSFileManager defaultManager] fileExistsAtPath:archivingPath])
        {
            
        }
        else
        {
            //创建文件夹
            [[NSFileManager defaultManager] createDirectoryAtPath:archivingPath withIntermediateDirectories:YES attributes:nil error:nil];
        }
        NSLog(@"%@",archivingPath);
        
        //拼接文件全路径
        NSString *fullpath = [archivingPath stringByAppendingPathComponent:[NSString stringWithFormat:@"%ld.mp4",(long)aFileName]];
        NSURL *filePathUrl = [NSURL fileURLWithPath:fullpath];
        
        
        NSDictionary *allHeaders = request.allHTTPHeaderFields;
        
        if (success) {
            success(allHeaders,filePathUrl);
        }
        
        
        return filePathUrl;
        
    } completionHandler:^(NSURLResponse *response, NSURL *filePath, NSError *error) {
        NSLog(@"%@ %@", filePath, error);
        if (fail) {
            fail(response,filePath,error);
        }
    }];
    
    [task resume];
}



@end
