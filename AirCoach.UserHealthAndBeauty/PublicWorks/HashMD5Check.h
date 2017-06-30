//
//  HashMD5Check.h
//  AirCoach.acUser
//
//  Created by xuan on 16/3/8.
//  Copyright © 2016年 AirCoach2.0. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface HashMD5Check : NSObject

+(NSString*)getFileMD5WithPath:(NSString*)path;

@end
