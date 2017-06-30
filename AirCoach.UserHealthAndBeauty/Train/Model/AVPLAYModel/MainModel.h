//
//  MainModel.h
//  AirCoach.acUser
//
//  Created by xuan on 15/12/11.
//  Copyright © 2015年 AirCoach2.0. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MJExtension.h"
@interface MainModel : NSObject

@property (nonatomic, assign) NSInteger hostID;
@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) NSString *figure;
@property (nonatomic, strong) NSString *type;
@property (nonatomic, strong) NSMutableDictionary *preview;
@end
