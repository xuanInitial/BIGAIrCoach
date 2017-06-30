//
//  ReportCoach.h
//  AirCoach.UserHealthAndBeauty
//
//  Created by wei on 16/6/14.
//  Copyright © 2016年 xuan. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CoachDecripModel.h"
#import "MJExtension.h"
@interface ReportCoach : NSObject
@property(nonatomic,strong)NSString *figure;
@property(nonatomic,strong)NSString *name;
@property(nonatomic,strong)CoachDecripModel *discription;
@end
