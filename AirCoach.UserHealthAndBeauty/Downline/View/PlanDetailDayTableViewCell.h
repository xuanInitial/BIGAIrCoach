//
//  PlanDetailDayTableViewCell.h
//  AirCoach.UserHealthAndBeauty
//
//  Created by wei on 16/7/26.
//  Copyright © 2016年 xuan. All rights reserved.
//

#import "MainTableViewCell.h"
#import "planProgress.h"
@interface PlanDetailDayTableViewCell : MainTableViewCell

@property(nonatomic,strong)UILabel *Donday;
@property(nonatomic,strong)UILabel *PlanTime;
@property(nonatomic,strong)UIView *LineView;
@property(nonatomic,strong)UIView *TopLineView;
@property(nonatomic,strong)planProgress *PlanProgress;
@end
