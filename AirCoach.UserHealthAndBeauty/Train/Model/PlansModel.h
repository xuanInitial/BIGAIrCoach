//
//  PlansModel.h
//  AirCoach.acUser
//
//  Created by xuan on 15/12/10.
//  Copyright © 2015年 AirCoach2.0. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MJExtension.h"

@interface PlansModel : NSObject

@property (nonatomic,assign) NSInteger hostID;

@property (nonatomic,strong) NSString  *name;

@property (nonatomic,strong) NSString *figure;

@property (nonatomic,strong) NSString *type;

@property (nonatomic,assign) NSInteger coach_id;

@property (nonatomic,strong) NSString *default_count;

@property (nonatomic,strong) NSString *content;

@property (nonatomic,strong) NSString *discription;

//练一天休一天

//图片
@property (nonatomic, strong) NSString *figure_cover;
@property (nonatomic, strong) NSString *figure_plan;
@property (nonatomic, strong) NSString *figure_preview;
@property (nonatomic, strong) NSString *figure_training;


@end
