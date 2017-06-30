//
//  WeekPlanModel.m
//  AirCoach.acUser
//
//  Created by xuan on 15/12/10.
//  Copyright © 2015年 AirCoach2.0. All rights reserved.
//

#import "WeekPlanModel.h"

@implementation WeekPlanModel

+ (NSDictionary *)replacedKeyFromPropertyName
{
    return @{@"hostID" : @"id",
             };
}

@end
