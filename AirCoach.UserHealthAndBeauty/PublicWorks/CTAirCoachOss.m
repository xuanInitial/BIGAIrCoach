//
//  CTAirCoachOss.m
//  AirCoach2.0
//
//  Created by wei on 16/1/26.
//  Copyright © 2016年 高静. All rights reserved.
//

#import "CTAirCoachOss.h"
#import "SVProgressHUD.h"
@implementation CTAirCoachOss

+(void)addPic:(UIImage *)pic PicName:(NSString *)picName
{
    
    NSString *endpoint = @"oss-cn-beijing.aliyuncs.com";
    NSString *token = [TokenGet getTwoMinutesOfToken];
#pragma mark---动态获取ak和sk
    id<OSSCredentialProvider> credential2 = [[OSSFederationCredentialProvider alloc] initWithFederationTokenGetter:^OSSFederationToken * {
        // 构造请求访问您的业务server
        NSURL * url = [NSURL URLWithString:[NSString stringWithFormat:Get_aliyun_oss_token,token]];
        NSURLRequest * request = [NSURLRequest requestWithURL:url];
        OSSTaskCompletionSource * tcs = [OSSTaskCompletionSource taskCompletionSource];
        NSURLSession * session = [NSURLSession sharedSession];
        
        // 发送请求
        NSURLSessionTask * sessionTask = [session dataTaskWithRequest:request
                                                    completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
                                                        if (error) {
                                                            [tcs setError:error];
                                                            return;
                                                        }
                                                        LRLog(@"%@",data);
                                                        [tcs setResult:data];
                                                    }];
        [sessionTask resume];
        
        // 需要阻塞等待请求返回
        [tcs.task waitUntilFinished];
        
        // 解析结果
        if (tcs.task.error) {
            NSLog(@"get token error: %@", tcs.task.error);
            return nil;
        } else {
            // 返回数据是json格式，需要解析得到token的各个字段
            NSDictionary * object = [NSJSONSerialization JSONObjectWithData:tcs.task.result
                                                                    options:kNilOptions
                                                                      error:nil];
            OSSFederationToken * token = [OSSFederationToken new];
            token.tAccessKey = [object objectForKey:@"AccessKeyId"];
            token.tSecretKey = [object objectForKey:@"AccessKeySecret"];
            token.tToken = [object objectForKey:@"SecurityToken"];
            token.expirationTimeInGMTFormat = [object objectForKey:@"Expiration"];
            NSLog(@"get token: %@", token.tAccessKey);
            NSLog(@"get token: %@", token.tSecretKey);
            NSLog(@"get token: %@", token.tToken);
            NSLog(@"get token: %@", token.expirationTimeInGMTFormat);
            return token;
        }
    }];
    
//    //固定的 ak和sk
//    id<OSSCredentialProvider> credential = [[OSSPlainTextAKSKPairCredentialProvider alloc] initWithPlainTextAccessKey:@"3a9avejujdNyufOO" secretKey:@"eXLRloB8XVeHxpGUphoBSjCW5xs7xK"];
    
    OSSClientConfiguration * conf = [OSSClientConfiguration new];
    conf.maxRetryCount = 2;
    conf.timeoutIntervalForRequest = 60;
    conf.timeoutIntervalForResource = 24 * 60 * 60;
    OSSClient *client = [OSSClient new];
    client = [[OSSClient alloc] initWithEndpoint:endpoint credentialProvider:credential2 clientConfiguration:conf];
    
    
    
    
   
    NSData *data = UIImageJPEGRepresentation(pic, 1.0);
    
    OSSPutObjectRequest * put = [OSSPutObjectRequest new];
    
    // required fields
    put.bucketName = @"aircoach-test";
    put.objectKey = [NSString stringWithFormat:@"image/UserHead%@.jpg",picName];
    NSString *str = [NSString stringWithFormat:@"http://image-test.aircoach.cn/%@",put.objectKey];
    NSLog(@"%@",str);
    put.uploadingData = data;
    put.uploadProgress = ^(int64_t bytesSent, int64_t totalByteSent, int64_t totalBytesExpectedToSend) {
        NSLog(@"%lld, %lld, %lld", bytesSent, totalByteSent, totalBytesExpectedToSend);
    };
    OSSTask * putTask = [client putObject:put];
    //[SVProgressHUD showWithMaskType:SVProgressHUDMaskTypeBlack];
    [putTask waitUntilFinished]; // 阻塞直到上传完成
    
    if (!putTask.error) {
        NSLog(@"upload object success!");
        //[SVProgressHUD dismiss];
        
    } else {
        NSLog(@"upload object failed, error: %@" , putTask.error);
        [SVProgressHUD dismiss];
        [SVProgressHUD showErrorWithStatus:@"上传失败请检查网络"];
    }
   
}





@end
