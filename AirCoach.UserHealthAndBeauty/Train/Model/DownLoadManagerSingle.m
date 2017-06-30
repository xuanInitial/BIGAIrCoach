//
//  DownLoadManagerSingle.m
//  AirCoach.UserHealthAndBeauty
//
//  Created by wei on 16/8/9.
//  Copyright © 2016年 xuan. All rights reserved.
//

#import "DownLoadManagerSingle.h"

@implementation DownLoadManagerSingle
+ (AFURLSessionManager *)sharedManager
{
    static AFURLSessionManager *sharedAccountManagerInstance = nil;
    static dispatch_once_t predicate;
    dispatch_once(&predicate, ^{
        
        NSURLSessionConfiguration *config = [NSURLSessionConfiguration defaultSessionConfiguration];
        config.timeoutIntervalForRequest = 60;
        sharedAccountManagerInstance = [[AFURLSessionManager alloc] initWithSessionConfiguration:config];
    });
    return sharedAccountManagerInstance;
}
@end
