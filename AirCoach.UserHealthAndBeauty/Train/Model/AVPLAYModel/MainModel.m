//
//  MainModel.m
//  AirCoach.acUser
//
//  Created by xuan on 15/12/11.
//  Copyright © 2015年 AirCoach2.0. All rights reserved.
//

#import "MainModel.h"

@implementation MainModel


+ (NSDictionary *)mj_objectClassInArray
{
    return @{
             @"medias" : @"previewModel"
            
             };
}

+ (NSDictionary *)replacedKeyFromPropertyName
{
    return @{@"hostID" : @"id",
             };
}
@end
