//
//  WeekPlanModel.h
//  AirCoach.acUser
//
//  Created by xuan on 15/12/10.
//  Copyright © 2015年 AirCoach2.0. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "PlansModel.h"
#import "CoachModel.h"
#import "yinshiModel.h"
#import "MJExtension.h"
#import "IMModel.h"
@interface WeekPlanModel : NSObject

@property (nonatomic,assign) NSInteger hostID;
@property (nonatomic,strong) NSString *name;
@property (nonatomic,strong) NSString *figure;
@property (nonatomic,strong) NSString *uuid;
@property (nonatomic,assign) NSInteger coach_id;
@property (nonatomic,assign) NSInteger plan_id;
@property (nonatomic,strong) NSString *plan_count;
@property (nonatomic,strong) NSString *mobile;
@property (nonatomic,strong) NSString *gender;
@property (nonatomic,strong) NSNumber *height;
@property (nonatomic,strong) NSNumber *weight;
@property (nonatomic,strong) NSString *purpose;
@property (nonatomic,strong) NSString *status;
@property (nonatomic,strong) NSString *created_at;
@property (nonatomic,strong) NSString *updated_at;
@property (nonatomic,strong) NSString *birthday;
@property (nonatomic, strong) NSString *schedule;
@property (nonatomic,strong) NSString*complete;//视频播放次数
@property(nonatomic,strong)IMModel *im_account;
@property (nonatomic,strong) PlansModel *plan;
@property (nonatomic,strong) CoachModel *coach;
@property (nonatomic,strong) yinshiModel *diet;


@end
