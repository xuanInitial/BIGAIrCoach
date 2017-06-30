//
//  CourseModel.h
//  AirCoach.acUser
//
//  Created by xuan on 15/12/3.
//  Copyright © 2015年 AirCoach2.0. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MJExtension.h"
#import "WarmModel.h"
#import "MainModel.h"


#import "MJExtension.h"



@interface CourseModel : NSObject

@property (assign, nonatomic)NSInteger hostID;
@property (copy, nonatomic)NSString *name;
@property (copy, nonatomic)NSString *backgroud;
@property (assign, nonatomic)NSInteger stage_id;
@property (assign, nonatomic)NSInteger coach_id;
@property (assign, nonatomic)NSInteger parent_id;
@property (copy, nonatomic)NSDictionary *descriptionss;

@property (strong, nonatomic) NSString *type;
@property (strong, nonatomic) NSString *created_at;
@property (strong, nonatomic) NSString *updated_at;

@property (strong, nonatomic) NSString *start;
@property (strong, nonatomic) NSString *end;
@property (nonatomic) NSInteger complete;
@property (nonatomic) NSInteger total;
@property (nonatomic) NSInteger length;
@property (nonatomic) NSInteger action_count;


@property (strong,nonatomic)NSMutableDictionary *content;

@property (strong, nonatomic) NSMutableArray *warm;

@property (strong, nonatomic) NSMutableArray *main;
@property (strong, nonatomic) NSMutableArray *stretch;


@property (strong, nonatomic) NSMutableDictionary *coach;//塑性师

@end

