//
//  UserPlanModel.h
//  AirCoach.UserHealthAndBeauty
//
//  Created by wei on 16/6/15.
//  Copyright © 2016年 xuan. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "OrderModel.h"
#import "MJExtension.h"
@interface UserPlanModel : NSObject
@property(nonatomic,strong)NSString *type;
@property(nonatomic,strong)NSString *name;
@property(nonatomic,strong)NSString *backgroud;
@property(nonatomic,strong)NSString *start;
@property(nonatomic,strong)NSString *end;
@property (nonatomic,assign) NSInteger complete;
@property (nonatomic,assign) NSInteger total;
@property(nonatomic,strong)OrderModel *discription;
@property(nonatomic)BOOL is_cur;
@property(nonatomic)NSInteger planId;
@end
