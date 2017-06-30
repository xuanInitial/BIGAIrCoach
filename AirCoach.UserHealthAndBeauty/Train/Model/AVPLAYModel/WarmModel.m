//
//  WarmModel.m
//  AirCoach.acUser
//
//  Created by xuan on 15/12/11.
//  Copyright © 2015年 AirCoach2.0. All rights reserved.
//

#import "WarmModel.h"

@implementation WarmModel

+ (NSDictionary *)mj_objectClassInArray
{
    return @{
             @"medias" : @"previewModel"
             
             };
}

+ (NSDictionary *)mj_replacedKeyFromPropertyName
{
    return @{@"hostID" : @"id",
             };
}

@end
