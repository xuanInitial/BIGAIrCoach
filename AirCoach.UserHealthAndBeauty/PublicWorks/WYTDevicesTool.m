//
//  WYTDevicesTool.m
//  Diary
//
//  Created by lanou3g on 15/10/27.
//  Copyright © 2015年 王艺拓. All rights reserved.
//

#import "WYTDevicesTool.h"
#import <UIKit/UIKit.h>

@interface WYTDevicesTool ()

@property (nonatomic, assign)CGFloat screenWidth;
@property (nonatomic, assign)CGFloat screenHeight;

@end

@implementation WYTDevicesTool

+ (BOOL)iPhone6Plus_iPhone6sPlus
{
    if ((NSInteger)kScreenWidth == 414 && (NSInteger)kScreenHeight == 736) {
        return YES;
    }
    return NO;
}

+ (BOOL)iPhone6_iPhone6s
{
    if ((NSInteger)kScreenWidth == 375 && (NSInteger)kScreenHeight == 667) {
        return YES;
    }
    return NO;
}

+ (BOOL)iPhone5_iPhone5s_iPhone5c
{
    if ((NSInteger)kScreenWidth == 320 && (NSInteger)kScreenHeight == 568) {
        return YES;
    }
    return NO;
}

+ (BOOL)iPhone4_iPhone4s
{
    if ((NSInteger)kScreenWidth == 320 && (NSInteger)kScreenHeight == 480) {
        return YES;
    }
    return NO;
}

+ (BOOL)iPhone320_DEVICES
{
    if ((NSInteger)kScreenWidth == 320) {
        return YES;
    }
    return NO;
}

+ (BOOL)iPhoneNONE_PLUS
{
    if ((NSInteger)kScreenWidth == 414) {
        return NO;
    }
    return YES;
}

@end
