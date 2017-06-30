//
//  WYTDevicesTool.h
//  Diary
//
//  Created by lanou3g on 15/10/27.
//  Copyright © 2015年 王艺拓. All rights reserved.
//

#import <Foundation/Foundation.h>
#define kScreenWidth  [UIScreen mainScreen].bounds.size.width
#define kScreenHeight [UIScreen mainScreen].bounds.size.height

@interface WYTDevicesTool : NSObject

+ (BOOL)iPhone6Plus_iPhone6sPlus;
+ (BOOL)iPhone6_iPhone6s;
+ (BOOL)iPhone5_iPhone5s_iPhone5c;
+ (BOOL)iPhone4_iPhone4s;
+ (BOOL)iPhone320_DEVICES;
+ (BOOL)iPhoneNONE_PLUS;

@end
