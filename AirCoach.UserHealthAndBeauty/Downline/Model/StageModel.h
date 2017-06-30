//
//  StageModel.h
//  AirCoach.UserHealthAndBeauty
//
//  Created by wei on 16/6/15.
//  Copyright © 2016年 xuan. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "OrderModel.h"
#import "UserTestModel.h"
#import "MJExtension.h"
@interface StageModel : NSObject
@property(nonatomic,strong)NSString *name;
@property(nonatomic,strong)NSString *start;
@property(nonatomic,strong)NSString *end;
@property(nonatomic,strong)OrderModel *discription;
@property(nonatomic,strong)NSArray *plans;
@property(nonatomic,strong)UserTestModel *examination;
@property(nonatomic)BOOL isopen;
@property(nonatomic,strong)NSString *status;
@end
