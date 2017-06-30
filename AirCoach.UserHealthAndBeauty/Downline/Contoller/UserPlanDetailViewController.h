//
//  UserPlanDetailViewController.h
//  AirCoach.UserHealthAndBeauty
//
//  Created by wei on 16/7/25.
//  Copyright © 2016年 xuan. All rights reserved.
//

#import "BaseViewController.h"
#import "BusinessAirCoach.h"

@protocol PlanWaitingForDelegate <NSObject>

-(void)setValueB:(NSString*)string;

@end


@interface UserPlanDetailViewController :BaseViewController

@property(weak,nonatomic)id<PlanWaitingForDelegate> C_delegate;

@property(nonatomic)NSInteger planId;
//计划名称
@property(nonatomic,strong)NSString *planNameTs;
//背景图
@property(nonatomic,strong)NSString *planBackgroud;
@end
