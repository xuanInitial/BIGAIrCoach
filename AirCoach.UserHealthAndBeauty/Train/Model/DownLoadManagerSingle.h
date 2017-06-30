//
//  DownLoadManagerSingle.h
//  AirCoach.UserHealthAndBeauty
//
//  Created by wei on 16/8/9.
//  Copyright © 2016年 xuan. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AFNetworking.h"
@interface DownLoadManagerSingle : NSObject
+ (AFURLSessionManager *)sharedManager;
@end
