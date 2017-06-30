//
//  KeyChainStore.h
//  AirCoach.acUser
//
//  Created by xuan on 16/3/21.
//  Copyright © 2016年 AirCoach2.0. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface KeyChainStore : NSObject


+ (void)save:(NSString *)service data:(id)data;
+ (id)load:(NSString *)service;
+ (void)deleteKeyData:(NSString *)service;

@end
