//
//  TokenGet.m
//  AirCoach.acUser
//
//  Created by xuan on 15/12/18.
//  Copyright © 2015年 AirCoach2.0. All rights reserved.
//

#import "TokenGet.h"
#import "BusinessAirCoach.h"



@implementation TokenGet

+ (NSString *)getTwoMinutesOfToken {
    
    
    NSDate* dat = [NSDate dateWithTimeIntervalSinceNow:0];
    NSTimeInterval a=[dat timeIntervalSince1970];
    
    NSLog(@"-----time-----%0.f",a);
    
    if (![BusinessAirCoach getTime]) {
        NSString *str = [NSString stringWithFormat:@"%0.f%@%@",round(a/120),@"KbvqxPqXWYavwrtt",@"AirCoach"];
        NSString *tokenString =  [ZYKMD5 getMd5_32Bit_String:str isUppercase:NO];
        NSLog(@"tokenString===%@",tokenString);
        return tokenString;
    } else {
        
        NSString *str = [NSString stringWithFormat:@"%0.f%@%@",round((a- [[BusinessAirCoach getTime] floatValue])/120),@"KbvqxPqXWYavwrtt",@"AirCoach"];
        NSString *tokenString =  [ZYKMD5 getMd5_32Bit_String:str isUppercase:NO];
        NSLog(@"tokenString===%@",tokenString);
        return tokenString;
    }
    
    
    
}

@end
