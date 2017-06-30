//
//  PlanList.m
//  AirCoach.acUser
//
//  Created by xuan on 15/12/11.
//  Copyright © 2015年 AirCoach2.0. All rights reserved.
//

#import "PlanList.h"

@implementation PlanList


+ (NSDictionary *)replacedKeyFromPropertyName
{
    return @{@"hostID" : @"id",
             };
}

+ (NSDictionary *)mj_objectClassInArray
{
    return @{
             @"preview" : @"previewModel"
             
             };
}

@end
