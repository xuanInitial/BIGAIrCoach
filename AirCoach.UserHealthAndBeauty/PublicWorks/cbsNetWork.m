//
//  cbsNetWork.m
//  cbsNetWork
//
//  Created by 陈秉慎 on 1/15/16.
//  Copyright © 2016 cbs. All rights reserved.
//

#import "cbsNetWork.h"
#import "Header.h"
@implementation cbsNetWork
+ (instancetype)sharedManager {
    static cbsNetWork *manager = nil;
    static dispatch_once_t pred;
    dispatch_once(&pred, ^{
#warning 警告 需要修改url
        manager = [[self alloc] initWithBaseURL:[NSURL URLWithString:TEST]];
    });
    return manager;
}

-(instancetype)initWithBaseURL:(NSURL *)url
{
    self = [super initWithBaseURL:url];
    if (self) {
        // 请求超时设定
        self.requestSerializer.timeoutInterval = 5;
        self.requestSerializer.cachePolicy = NSURLRequestReloadIgnoringLocalCacheData;
        [self.requestSerializer setValue:@"application/json" forHTTPHeaderField:@"Accept"];
        [self.requestSerializer setValue:url.absoluteString forHTTPHeaderField:@"Referer"];
        
        self.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/plain", @"text/javascript", @"text/json", @"text/html", nil];
        
        self.securityPolicy.allowInvalidCertificates = YES;
    }
    return self;
}

- (void)requestWithMethod:(HTTPMethod)method
                 WithPath:(NSString *)path
               WithParams:(NSDictionary*)params
         WithSuccessBlock:(void (^)( NSDictionary *allHeaders, id responseObject,id statusCode))success
          WithFailurBlock:(void (^)( NSDictionary *allHeaders,NSError *error,id statusCode))failure
{
    switch (method) {
        case GET:{
            
            [self GET:path parameters:params progress:^(NSProgress * _Nonnull downloadProgress) {
                
            } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                if (success) {//返回加载成功的数据
                    NSHTTPURLResponse *response = (NSHTTPURLResponse *)task.response;
                    NSDictionary *allHeaders = response.allHeaderFields;
                    success(allHeaders, responseObject,[NSString stringWithFormat:@"%ld",(long)[response statusCode]]);
                }
            } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                if (failure) {//返回错误信息
                    
                    NSHTTPURLResponse *response = (NSHTTPURLResponse *)task.response;
                    NSDictionary *allHeaders = response.allHeaderFields;
                    failure(allHeaders,error,[NSString stringWithFormat:@"%ld",(long)[response statusCode]]);
                }
            }];
            
            
            break;
        }
        case POST:{
            [self POST:path parameters:params constructingBodyWithBlock:nil progress:^(NSProgress * _Nonnull uploadProgress) {
                
            } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                if (success) {//返回加载成功的数据
                    NSHTTPURLResponse *response = (NSHTTPURLResponse *)task.response;
                    NSDictionary *allHeaders = response.allHeaderFields;
                    success(allHeaders,responseObject,[NSString stringWithFormat:@"%ld",(long)[response statusCode]]);
                }
            } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                if (failure) {//返回错误信息
                    NSHTTPURLResponse *response = (NSHTTPURLResponse *)task.response;
                    NSDictionary *allHeaders = response.allHeaderFields;
                    failure(allHeaders, error,[NSString stringWithFormat:@"%ld",(long)[response statusCode]]);
                }
            }];
            break;
        }
        default:
            break;
    }    
}
@end
