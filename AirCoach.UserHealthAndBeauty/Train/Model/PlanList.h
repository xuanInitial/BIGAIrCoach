//
//  PlanList.h
//  AirCoach.acUser
//
//  Created by xuan on 15/12/11.
//  Copyright © 2015年 AirCoach2.0. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "MJExtension.h"

#import "previewModel.h"
@interface PlanList : NSObject

@property (nonatomic, assign) NSInteger hostID;
@property (nonatomic, strong) NSString *type;
@property (nonatomic, strong) NSNumber *count;
@property (nonatomic, strong) NSString *figure;
@property (nonatomic, strong) NSString *category;
@property (nonatomic, strong) NSString *url;
@property (nonatomic) NSInteger length;
@property (nonatomic) NSInteger size;
@property (nonatomic, strong) NSString *status;

@property (nonatomic, strong) previewModel *preview;

@end
