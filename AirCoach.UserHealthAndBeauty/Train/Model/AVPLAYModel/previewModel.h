//
//  previewModel.h
//  AirCoach.UserHealthAndBeauty
//
//  Created by xuan on 16/6/16.
//  Copyright © 2016年 xuan. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MJExtension.h"
@interface previewModel : NSObject

@property (nonatomic, assign) NSInteger hostID;

@property (nonatomic) NSInteger action_id;
@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) NSString *figure;
@property (nonatomic, strong) NSString *type;
@property (nonatomic, strong) NSString *category;
@property (nonatomic, strong) NSString *url;
@property (nonatomic) NSInteger length;
@property (nonatomic) NSInteger size;
@property (nonatomic, strong) NSString *status;
@end
