//
//  CheckModel.h
//  AirCoach.UserHealthAndBeauty
//
//  Created by wei on 16/6/16.
//  Copyright © 2016年 xuan. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FirtCheckData.h"
#import "lastcheckingData.h"
//进度条的类
@interface CheckModel : NSObject
@property(nonatomic)NSInteger total;
@property(nonatomic)NSInteger week_task;
@property(nonatomic,strong)FirtCheckData *first_checking;
@property(nonatomic,strong)lastcheckingData *last_checking;
@end
