//
//  DietPlanTableViewCell.h
//  AirCoach.UserHealthAndBeauty
//
//  Created by wei on 16/6/15.
//  Copyright © 2016年 xuan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UserPlanModel.h"
#import "MainTableViewCell.h"
//饮食的cell
@interface DietPlanTableViewCell : MainTableViewCell
@property(nonatomic,strong)UILabel *dietTime;
@property(nonatomic,strong)UIImageView *dietBackground;
@property(nonatomic,strong)UserPlanModel *planModel;
@end
