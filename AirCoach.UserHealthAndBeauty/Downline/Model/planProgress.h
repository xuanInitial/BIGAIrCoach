//
//  planProgress.h
//  AirCoach.UserHealthAndBeauty
//
//  Created by wei on 16/8/8.
//  Copyright © 2016年 xuan. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface planProgress : NSObject

//更新最新计划时间
@property(nonatomic,strong)NSString *updated_at;
@property(nonatomic)NSInteger times;
@property(nonatomic)NSInteger Mytotal;
@end
