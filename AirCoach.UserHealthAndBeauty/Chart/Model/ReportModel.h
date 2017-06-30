//
//  ReportModel.h
//  AirCoach.UserHealthAndBeauty
//
//  Created by wei on 16/6/14.
//  Copyright © 2016年 xuan. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ReportCoach.h"
#import "MJExtension.h"
@interface ReportModel : NSObject
@property(nonatomic,strong)NSString *content;
@property(nonatomic,strong)NSString *created_at;
@property(nonatomic,strong)NSString *updated_at;
@property(nonatomic,strong)ReportCoach *coach;
@end
