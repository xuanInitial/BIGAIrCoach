//
//  TrainModel.h
//  AirCoach.UserHealthAndBeauty
//
//  Created by wei on 16/6/16.
//  Copyright © 2016年 xuan. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MJExtension.h"
#import "JianyiModel.h"
@interface TrainModel : NSObject
@property (nonatomic, strong) NSString *backgroud;
@property (nonatomic) NSInteger host_id;
@property(nonatomic,strong)NSString *name;
@property(nonatomic,strong)NSString *start;
@property(nonatomic,strong)NSString *end;
@property(nonatomic)NSInteger complete;
@property(nonatomic)NSInteger total;
@property(nonatomic)NSInteger action_count;
@property(nonatomic)NSInteger length;
@property(nonatomic,strong)JianyiModel *discription;
@end