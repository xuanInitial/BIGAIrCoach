//
//  Cur_planModel.h
//  AirCoach.UserHealthAndBeauty
//
//  Created by wei on 16/8/8.
//  Copyright © 2016年 xuan. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "planProgress.h"
#import "OrderModel.h"
#import "MJExtension.h"
@interface Cur_planModel : NSObject

@property(nonatomic,strong)OrderModel *discription;
@property(nonatomic,strong)NSArray *progresses;
@property(nonatomic)NSInteger complete;
@property(nonatomic)NSInteger total;
@end
