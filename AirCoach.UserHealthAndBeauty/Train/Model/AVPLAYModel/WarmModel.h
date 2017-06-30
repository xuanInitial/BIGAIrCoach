//
//  WarmModel.h
//  AirCoach.acUser
//
//  Created by xuan on 15/12/11.
//  Copyright © 2015年 AirCoach2.0. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "MJExtension.h"

#import "previewModel.h"
@interface WarmModel : NSObject

@property (nonatomic, assign) NSInteger hostID;
@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) NSString *figure;
@property (nonatomic, strong) NSString *type;

@property (nonatomic, strong) NSString *url;
@property (nonatomic, strong) NSString *category;

@property (nonatomic, strong) NSMutableDictionary *preview;

@property (nonatomic) NSInteger count;


@end
