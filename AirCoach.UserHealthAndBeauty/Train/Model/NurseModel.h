//
//  NurseModel.h
//  AirCoach.UserHealthAndBeauty
//
//  Created by xuan on 16/8/12.
//  Copyright © 2016年 xuan. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "MJExtension.h"
#import "IMModel.h"
@interface NurseModel : NSObject
@property (nonatomic, assign) NSInteger coach_id;
@property (nonatomic, assign) NSInteger hostID;
@property (nonatomic, strong) NSString *figure;//护理师头像
@property (nonatomic, strong) NSString *name;

@property (nonatomic, strong) IMModel *nim;


@end
