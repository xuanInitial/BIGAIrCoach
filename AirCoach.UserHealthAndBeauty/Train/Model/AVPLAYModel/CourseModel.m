//
//  CourseModel.m
//  AirCoach.acUser
//
//  Created by xuan on 15/12/3.
//  Copyright © 2015年 AirCoach2.0. All rights reserved.
//

#import "CourseModel.h"



@implementation CourseModel



+ (NSDictionary *)mj_objectClassInArray
{
    return @{
             @"warm" : @"WarmModel",
             @"main" : @"WarmModel",
             @"stretch" : @"WarmModel"
             
             };
}


+ (NSDictionary *)mj_replacedKeyFromPropertyName
{
    return @{@"hostID" : @"id",
             @"descriptionss":@"description"
             };
}



@end
